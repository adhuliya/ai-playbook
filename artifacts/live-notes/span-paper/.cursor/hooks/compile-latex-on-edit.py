#!/usr/bin/env python3
"""Compile the paper after LaTeX source edits and summarize failures."""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Any


LATEX_EXTENSIONS = {".tex", ".cls", ".sty"}
MAX_AGENT_OUTPUT_CHARS = 12000


def collect_strings(value: Any) -> list[str]:
    if isinstance(value, str):
        return [value]
    if isinstance(value, list):
        result: list[str] = []
        for item in value:
            result.extend(collect_strings(item))
        return result
    if isinstance(value, dict):
        result = []
        for item in value.values():
            result.extend(collect_strings(item))
        return result
    return []


def edited_latex_files(payload: dict[str, Any]) -> list[str]:
    files = []
    for text in collect_strings(payload):
        path = text.strip()
        suffix = Path(path).suffix.lower()
        if suffix in LATEX_EXTENSIONS:
            files.append(path)
    return sorted(set(files))


def local_commands(style_path: Path) -> set[str]:
    if not style_path.exists():
        return set()

    text = style_path.read_text(errors="replace")
    commands: set[str] = set()
    patterns = [
        r"\\(?:re)?newcommand\*?\s*\{\\([A-Za-z@]+)\}",
        r"\\DeclareMathOperator\*?\s*\{\\([A-Za-z@]+)\}",
        r"\\(?:New|Renew|Declare)DocumentCommand\s*\{\\([A-Za-z@]+)\}",
        r"\\def\\([A-Za-z@]+)",
    ]
    for pattern in patterns:
        commands.update(re.findall(pattern, text))
    return commands


def undefined_c_capital_suggestions(output: str, project_root: Path) -> list[str]:
    unknown = sorted(set(re.findall(r"\\(c[A-Z][A-Za-z@]*)", output)))
    if not unknown:
        return []

    commands = local_commands(project_root / "resources" / "myarticle.sty")
    suggestions = []
    for command in unknown:
        expected = "c" + command[1:2].lower() + command[2:]
        if expected in commands:
            suggestions.append(
                f"`\\{command}` looks like a capitalization typo. "
                f"`resources/myarticle.sty` defines `\\{expected}`; locally defined commands start with lowercase `c`."
            )
        else:
            similar = sorted(name for name in commands if name.lower() == command.lower())
            if similar:
                suggestions.append(
                    f"`\\{command}` is undefined. Did you mean `\\{similar[0]}` from `resources/myarticle.sty`?"
                )
            else:
                suggestions.append(
                    f"`\\{command}` is undefined and no matching local command was found in `resources/myarticle.sty`."
                )
    return suggestions


def undefined_command_near_error(output: str) -> str | None:
    line_match = re.search(r"^l\.\d+\s+(.+?)(?:\n\s*(\{[^}\n]*\}.*))?$", output, re.MULTILINE)
    if not line_match:
        return None

    context = "".join(part or "" for part in line_match.groups())
    commands = re.findall(r"\\[A-Za-z@]+", context)
    return commands[-1] if commands else None


def explain_failure(output: str, project_root: Path) -> str:
    lines: list[str] = []

    latex_error = re.search(r"^! LaTeX Error: (.+)$", output, re.MULTILINE)
    if latex_error:
        lines.append(f"Cause: LaTeX reported `{latex_error.group(1).strip()}`.")
    elif "! Undefined control sequence." in output:
        lines.append("Cause: LaTeX hit an undefined control sequence.")
    elif "Emergency stop" in output:
        lines.append("Cause: LaTeX stopped early, usually after a missing file, unclosed environment, or malformed command.")
    else:
        lines.append("Cause: `make` failed while compiling the LaTeX project.")

    line_match = re.search(r"^l\.(\d+)\s+(.+)$", output, re.MULTILINE)
    if line_match:
        lines.append(f"Location: LaTeX points near line {line_match.group(1)}: `{line_match.group(2).strip()}`.")

    suggestions = undefined_c_capital_suggestions(output, project_root)
    if suggestions:
        lines.append("Suggested fix: " + " ".join(suggestions))
    elif "! Undefined control sequence." in output:
        command = undefined_command_near_error(output)
        if command:
            lines.append(f"Suggested fix: check whether `{command}` is misspelled or missing a package/macro definition.")
        else:
            lines.append("Suggested fix: inspect the command immediately before the reported line and add or correct its definition.")
    elif latex_error:
        lines.append("Suggested fix: address the reported LaTeX error, then rerun `make` from the project root.")
    else:
        lines.append("Suggested fix: inspect the `make` output above for the first LaTeX error, then rerun `make`.")

    return "\n".join(lines)


def output_tail(output: str, max_chars: int = MAX_AGENT_OUTPUT_CHARS) -> str:
    if len(output) <= max_chars:
        return output.rstrip()
    return "[Earlier make output omitted]\n" + output[-max_chars:].lstrip().rstrip()


def agent_fix_request(
    edited_files: list[str],
    explanation: str,
    make_output: str,
) -> str:
    return (
        "Agent fix request: analyze this LaTeX build failure and suggest concrete fixes.\n"
        "Focus on the first real LaTeX error, cite the likely file/line when possible, "
        "and propose the smallest correction. If the unknown command starts with `\\c` "
        "followed by a capital letter, inspect `resources/myarticle.sty`; locally defined "
        "commands start with lowercase `c`.\n\n"
        f"Edited files: {', '.join(edited_files)}\n\n"
        "Initial hook diagnosis:\n"
        f"{explanation}\n\n"
        "Relevant `make` output:\n"
        "```text\n"
        f"{output_tail(make_output)}\n"
        "```"
    )


def write_log(
    project_root: Path,
    edited_files: list[str],
    status: str,
    message: str,
    make_output: str = "",
    returncode: int | None = None,
) -> None:
    log_path = project_root / "hooks.output.txt"
    timestamp = datetime.now().isoformat(timespec="seconds")
    lines = [
        "=" * 80,
        f"Timestamp: {timestamp}",
        f"Edited files: {', '.join(edited_files)}",
        f"Status: {status}",
    ]
    if returncode is not None:
        lines.append(f"make exit code: {returncode}")
    lines.extend(["", message])
    if status in {"failure", "timeout"}:
        lines.extend(["", "--- agent fix request ---", agent_fix_request(edited_files, message, make_output)])
    if make_output:
        lines.extend(["", "--- make output ---", make_output.rstrip()])
    lines.append("")
    log_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError:
        payload = {}

    edited_files = edited_latex_files(payload)
    if not edited_files:
        print(json.dumps({}))
        return 0

    project_root = Path(os.getcwd())
    try:
        result = subprocess.run(
            ["make"],
            cwd=project_root,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=110,
            check=False,
        )
    except subprocess.TimeoutExpired as error:
        make_output = error.stdout or ""
        if isinstance(make_output, bytes):
            make_output = make_output.decode(errors="replace")
        message = (
            "LaTeX build timed out after editing "
            + ", ".join(edited_files)
            + ".\nCause: `make` did not finish within the hook timeout.\n"
            + "Suggested fix: run `make` manually from the project root and inspect where compilation stalls."
        )
        write_log(project_root, edited_files, "timeout", message, make_output)
        print(json.dumps({"additional_context": message + "\n\n" + agent_fix_request(edited_files, message, make_output)}))
        return 0
    except OSError as error:
        message = (
            "LaTeX build could not start after editing "
            + ", ".join(edited_files)
            + f".\nCause: `{error}`.\n"
            + "Suggested fix: verify `make` is installed and runnable from the project root."
        )
        write_log(project_root, edited_files, "error", message)
        print(json.dumps({"additional_context": message}))
        return 0

    if result.returncode == 0:
        message = "LaTeX build succeeded after editing " + ", ".join(edited_files) + "."
        write_log(project_root, edited_files, "success", message, result.stdout, result.returncode)
        print(json.dumps({"additional_context": message}))
        return 0

    explanation = explain_failure(result.stdout, project_root)
    message = (
        "LaTeX build failed after editing "
        + ", ".join(edited_files)
        + ".\n"
        + explanation
    )
    write_log(project_root, edited_files, "failure", message, result.stdout, result.returncode)
    print(
        json.dumps(
            {
                "additional_context": message + "\n\n" + agent_fix_request(edited_files, explanation, result.stdout)
            }
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
