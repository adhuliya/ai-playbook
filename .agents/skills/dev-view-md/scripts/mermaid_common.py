#!/usr/bin/env python3
"""Shared helpers for dev-view-md scripts: find/extract/render mermaid blocks.

Used by: extract_diagrams.py, build_html.py
"""
import html
import os
import re
import shutil
import subprocess
import sys
import tempfile

MERMAID_FENCE_RE = re.compile(
    r"^([ \t]*)```[ \t]*(?:mermaid\b[ \t]*|\{\.mermaid([^}]*)\}[ \t]*)\r?\n(.*?)\r?\n[ \t]*```[ \t]*$",
    re.DOTALL | re.MULTILINE,
)

CAPTION_ATTR_RE = re.compile(r'(?:caption|title)\s*=\s*"([^"]*)"')


def extract_mermaid_blocks(text):
    """Return list of dicts: {index, code, caption, match} for each mermaid
    fence in text. Supports plain ```mermaid and ```{.mermaid caption="..."}
    (pandoc attribute syntax) for an optional figure caption."""
    blocks = []
    for i, m in enumerate(MERMAID_FENCE_RE.finditer(text)):
        attrs = m.group(2) or ""
        cap_match = CAPTION_ATTR_RE.search(attrs)
        blocks.append({
            "index": i,
            "code": m.group(3),
            "caption": cap_match.group(1) if cap_match else None,
            "match": m,
        })
    return blocks


def replace_blocks(text, blocks, replacer):
    """Replace each matched mermaid fence with replacer(block) -> str, right to left."""
    out = text
    for b in sorted(blocks, key=lambda b: b["match"].start(), reverse=True):
        m = b["match"]
        out = out[: m.start()] + replacer(b) + out[m.end() :]
    return out


def to_placeholder(index):
    return f"MERMAIDPLACEHOLDER{index}MERMAIDPLACEHOLDER"


def substitute_with_placeholders(text, blocks):
    """Replace mermaid fences with unique plain-text placeholder lines.
    Returns (new_text, {placeholder: {"code": ..., "caption": ...}})."""
    mapping = {}

    def replacer(b):
        ph = to_placeholder(b["index"])
        mapping[ph] = {"code": b["code"], "caption": b.get("caption")}
        return ph

    return replace_blocks(text, blocks, replacer), mapping


def _which(cmd):
    return shutil.which(cmd)


INSTALL_TIMEOUT_S = 180
RENDER_TIMEOUT_S = 60


def find_mmdc():
    """Return a command list to invoke an already-installed mermaid-cli, or
    None. Deliberately does NOT fall back to 'npx ...' here: running via npx
    without a local/global install can silently try to fetch the package
    over the network, which belongs under the auto_install opt-in below."""
    path = _which("mmdc")
    return [path] if path else None


def ensure_mmdc(auto_install=True, log=print):
    """Find mmdc, optionally auto-installing via npm. Returns command list or
    None. When auto_install is False, only an already-installed mmdc is used
    -- no network calls are made."""
    cmd = find_mmdc()
    if cmd:
        return cmd
    if not auto_install:
        return None
    npm = _which("npm")
    if not npm:
        log(
            "mmdc (mermaid-cli) not found and npm is unavailable, so it cannot be "
            "auto-installed.\n"
            "  Install Node.js first, then either:\n"
            "    npm install -g @mermaid-js/mermaid-cli\n"
            "  macOS:  brew install node\n"
            "  Linux:  sudo apt install nodejs npm   (or use nvm)\n"
        )
        return None
    log(
        f"mmdc (mermaid-cli) not found; installing with "
        f"'npm install -g @mermaid-js/mermaid-cli' (up to {INSTALL_TIMEOUT_S}s, needs network) ..."
    )
    try:
        subprocess.run(
            [npm, "install", "-g", "@mermaid-js/mermaid-cli"],
            check=True,
            timeout=INSTALL_TIMEOUT_S,
        )
    except subprocess.TimeoutExpired:
        log(f"Auto-install of mermaid-cli timed out after {INSTALL_TIMEOUT_S}s; skipping diagram rendering.")
        return None
    except Exception as exc:  # noqa: BLE001
        log(f"Auto-install of mermaid-cli failed: {exc}")
        return None
    return find_mmdc()


def render_mermaid_to_file(mmdc_cmd, mermaid_code, out_path, fmt="svg", scale=None, log=print):
    """Render one mermaid snippet to out_path (svg/png) using mmdc. Returns True/False.

    scale applies to PNG only (puppeteer device scale).
    """
    if not mmdc_cmd:
        return False
    fd, mmd_path = tempfile.mkstemp(suffix=".mmd")
    try:
        with os.fdopen(fd, "w") as f:
            f.write(mermaid_code)
        puppeteer_cfg = None
        # Headless chromium under mmdc commonly needs --no-sandbox in CI/containers.
        fd2, puppeteer_cfg = tempfile.mkstemp(suffix=".json")
        with os.fdopen(fd2, "w") as f:
            f.write('{"args": ["--no-sandbox", "--disable-setuid-sandbox"]}')
        cmd = mmdc_cmd + [
            "-i", mmd_path,
            "-o", out_path,
            "-e", fmt,
            "-b", "white",
            "-p", puppeteer_cfg,
        ]
        if scale and fmt == "png":
            cmd += ["-s", str(scale)]
        try:
            result = subprocess.run(
                cmd, capture_output=True, text=True, timeout=RENDER_TIMEOUT_S
            )
        except subprocess.TimeoutExpired:
            log(f"mmdc timed out after {RENDER_TIMEOUT_S}s for a diagram.")
            return False
        if result.returncode != 0:
            log(f"mmdc failed for a diagram: {result.stderr.strip()[-500:]}")
            return False
        return os.path.exists(out_path)
    finally:
        os.unlink(mmd_path)
        if puppeteer_cfg and os.path.exists(puppeteer_cfg):
            os.unlink(puppeteer_cfg)


def escape_for_pre(code):
    return html.escape(code, quote=False)
