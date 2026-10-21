#!/usr/bin/env python3
"""Extract mermaid diagrams from a markdown file for use outside the doc.

Usage:
  extract_diagrams.py FILE.md [--out-dir DIR] [--formats mmd,svg,png] [--no-install]

Always writes raw .mmd source per diagram. Also renders .svg/.png via mmdc
(mermaid-cli) when available (auto-installed via npm unless --no-install).
"""
import argparse
import os
import sys

from mermaid_common import ensure_mmdc, extract_mermaid_blocks, render_mermaid_to_file


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("md_file")
    ap.add_argument("--out-dir", help="default: <md_basename>_diagrams/ next to the md file")
    ap.add_argument("--formats", default="mmd,svg,png", help="comma list: mmd,svg,png")
    ap.add_argument("--no-install", action="store_true", help="don't auto-install mmdc if missing")
    args = ap.parse_args()

    md_path = os.path.abspath(args.md_file)
    if not os.path.isfile(md_path):
        sys.exit(f"Not a file: {md_path}")

    base = os.path.splitext(os.path.basename(md_path))[0]
    out_dir = args.out_dir or os.path.join(os.path.dirname(md_path), f"{base}_diagrams")
    os.makedirs(out_dir, exist_ok=True)

    formats = [f.strip().lower() for f in args.formats.split(",") if f.strip()]
    want_render = "svg" in formats or "png" in formats

    with open(md_path, "r", encoding="utf-8") as f:
        text = f.read()

    blocks = extract_mermaid_blocks(text)
    if not blocks:
        print("No ```mermaid blocks found.")
        return

    mmdc_cmd = ensure_mmdc(auto_install=want_render and not args.no_install) if want_render else None
    if want_render and not mmdc_cmd:
        print("Proceeding without rendering (mmdc unavailable) -- .mmd source only.")

    for b in blocks:
        name = f"{base}_diagram{b['index']+1}"
        if "mmd" in formats:
            mmd_path = os.path.join(out_dir, f"{name}.mmd")
            with open(mmd_path, "w", encoding="utf-8") as f:
                f.write(b["code"].rstrip() + "\n")
            print(f"wrote {mmd_path}")
        for fmt in ("svg", "png"):
            if fmt in formats and mmdc_cmd:
                out_path = os.path.join(out_dir, f"{name}.{fmt}")
                ok = render_mermaid_to_file(mmdc_cmd, b["code"], out_path, fmt)
                print(f"{'wrote' if ok else 'FAILED'} {out_path}")

    print(f"\nDone. Output dir: {out_dir}")


if __name__ == "__main__":
    main()
