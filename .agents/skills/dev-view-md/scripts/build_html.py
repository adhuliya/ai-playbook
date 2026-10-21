#!/usr/bin/env python3
"""Convert a markdown file (with ```mermaid fences) to a single self-contained,
browsable HTML file. Diagrams render client-side via a vendored mermaid.js
(no CDN/network needed). Prefers pandoc for full CommonMark + syntax
highlighting; falls back to a minimal built-in converter if pandoc is absent.

Usage: build_html.py FILE.md [-o OUTPUT.html] [--title TITLE]
"""
import argparse
import html
import os
import re
import shutil
import subprocess
import sys

from mermaid_common import extract_mermaid_blocks, substitute_with_placeholders

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
VENDOR_JS = os.path.join(SCRIPT_DIR, "vendor", "mermaid.min.js")

EXTRA_CSS = """
:root {
  --accent: #4f46e5;
  --accent-soft: #eef0ff;
  --text: #1f2328;
  --text-muted: #57606a;
  --border: #e2e5ea;
  --code-bg: #f2f3f7;
  --code-fg: #24292f;
  --code-border: #6366f1;
}
* { box-sizing: border-box; }
body {
  max-width: 880px; margin: 0 auto; padding: 3rem 1.75rem 5rem;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
  font-size: 16.5px; line-height: 1.7; color: var(--text);
  background: #fbfbfd;
}
h1, h2, h3, h4, h5 { font-weight: 650; line-height: 1.3; scroll-margin-top: 1rem; }
h1 {
  font-size: 2.3em; margin: 0 0 .3em; padding-bottom: .4em;
  border-bottom: 3px solid var(--accent);
}
h2 {
  font-size: 1.55em; margin-top: 2.2em; padding-bottom: .35em;
  border-bottom: 1px solid var(--border);
}
h3 { font-size: 1.22em; margin-top: 1.8em; color: #334155; }
h3::before { content: "▍"; color: var(--accent); margin-right: .35em; font-size: .85em; }
h4 { font-size: 1.05em; margin-top: 1.5em; color: #475569; }
p { margin: 0.9em 0; }
a { color: var(--accent); text-decoration: none; border-bottom: 1px solid transparent; }
a:hover { border-bottom-color: var(--accent); }
hr { border: none; border-top: 2px dashed var(--border); margin: 2.5em 0; }

/* Heading index (pandoc --toc, or the fallback converter) */
nav#TOC {
  background: #fff; border: 1px solid var(--border); border-radius: 10px;
  padding: 0.85em 1.25em 1em; margin: 0 0 2.2em;
}
nav#TOC h2 {
  border: none; margin: 0 0 0.35em; padding: 0;
  font-size: 0.78em; letter-spacing: 0.08em; text-transform: uppercase;
  color: var(--text-muted);
}
nav#TOC ul { list-style: none; margin: 0.2em 0; padding-left: 0; }
nav#TOC ul ul { padding-left: 1.15em; }
nav#TOC li { margin: 0.12em 0; }
nav#TOC li.toc-sub { margin-left: 1.15em; }
nav#TOC li.toc-deep { margin-left: 2.3em; }
nav#TOC a { color: var(--text); }
nav#TOC a:hover { color: var(--accent); }

/* Code blocks: dark, rounded "terminal" card with a colored accent edge */
div.sourceCode, pre {
  background: var(--code-bg); color: var(--code-fg);
  border-left: 4px solid var(--code-border);
  border-radius: 10px;
  padding: 1em 1.2em; margin: 1.2em 0;
  overflow-x: auto;
  box-shadow: 0 1px 4px rgba(15, 23, 42, 0.08);
  font-size: 0.92em;
}
@media print {
  div.sourceCode, pre { box-shadow: none; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
}

/* Line numbers: pandoc already wraps each highlighted line in its own
   <span>; number them with CSS counters (no numberLines attribute needed
   on individual fences). */
div.sourceCode code {
  counter-reset: line;
  display: block;
}
div.sourceCode code > span {
  counter-increment: line;
  position: relative;
  padding-left: 2.8em;
}
div.sourceCode code > span::before {
  content: counter(line);
  position: absolute;
  left: 0; top: 0;
  width: 2.1em;
  text-align: right;
  color: #9aa3af;
  user-select: none;
}
div.sourceCode pre { background: none; box-shadow: none; border: none; margin: 0; padding: 0; }
pre code, code {
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, "Liberation Mono", monospace;
}
pre code { background: none; padding: 0; color: inherit; }
/* Inline code (outside pre) */
p code, li code, td code, th code {
  background: var(--accent-soft); color: #3730a3;
  padding: .15em .45em; border-radius: 5px; font-size: 0.9em;
}

/* Tables */
table { border-collapse: collapse; width: 100%; margin: 1.3em 0; overflow: hidden;
  border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.06); }
th, td { border: 1px solid var(--border); padding: 8px 14px; text-align: left; }
th { background: var(--accent); color: #fff; font-weight: 600; }
tr:nth-child(even) td { background: #f6f7fb; }

/* Blockquotes */
blockquote {
  background: var(--accent-soft); color: var(--text-muted);
  border-left: 4px solid var(--accent);
  padding: .8em 1.2em; margin: 1.3em 0; border-radius: 0 8px 8px 0;
}
blockquote p { margin: .3em 0; }

/* Task lists */
li:has(> input[type="checkbox"]) { list-style: none; margin-left: -1.4em; }
input[type="checkbox"] { margin-right: .5em; accent-color: var(--accent); }

/* Mermaid diagram cards */
.mermaid {
  background: #fff; text-align: center; margin: 1.8em 0; padding: 1.2em;
  border: 1px solid var(--border); border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
  overflow-x: auto;
}

/* Figures (mermaid diagrams with a caption, and pandoc's own image figures) */
figure {
  margin: 1.8em 0; text-align: center;
}
figure img {
  max-width: 100%; border-radius: 10px; border: 1px solid var(--border);
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}
figure.mermaid-figure .mermaid { margin: 0 0 .6em; }
figcaption {
  margin-top: .6em; font-size: 0.9em; color: var(--text-muted);
  font-style: italic;
}
figcaption b.fig-label { color: var(--accent); font-style: normal; font-weight: 600; }
"""

MERMAID_INIT = """
<script>
  mermaid.initialize({ startOnLoad: true, securityLevel: "loose" });
</script>
"""


def pandoc_html(text, title):
    if not shutil.which("pandoc"):
        return None
    result = subprocess.run(
        [
            "pandoc", "-s", "-f", "markdown", "-t", "html5",
            "--highlight-style=pygments",
            "--toc", "--toc-depth=3",
            "--metadata", f"title={title}",
            "--metadata", "toc-title=Index",
        ],
        input=text, capture_output=True, text=True,
    )
    if result.returncode != 0:
        print(f"pandoc failed, falling back: {result.stderr}", file=sys.stderr)
        return None
    return result.stdout


def _slug(text, used):
    s = re.sub(r"[^\w\s-]", "", text, flags=re.UNICODE).strip().lower()
    s = re.sub(r"\s+", "-", s) or "section"
    base, n = s, 2
    while s in used:
        s = f"{base}-{n}"
        n += 1
    used.add(s)
    return s


def _index_nav(headings):
    """headings: list of (level, slug, text), levels 1–3."""
    shown = [(lvl, slug, text) for lvl, slug, text in headings if lvl <= 3]
    if not shown:
        return ""
    base = min(lvl for lvl, _, _ in shown)
    items = []
    for lvl, slug, text in shown:
        cls = {0: "", 1: "toc-sub", 2: "toc-deep"}.get(lvl - base, "toc-deep")
        attr = f' class="{cls}"' if cls else ""
        items.append(f'<li{attr}><a href="#{slug}">{html.escape(text)}</a></li>')
    return (
        '<nav id="TOC" role="doc-toc"><h2 id="toc-title">Index</h2><ul>'
        + "\n".join(items)
        + "</ul></nav>"
    )


def minimal_markdown_html(text, title):
    """Very small regex-based fallback used only when pandoc is unavailable.
    Handles headings, fenced code, bold/italic, links, paragraphs, and an index."""
    lines = text.split("\n")
    out, in_code, headings, used = [], False, [], set()
    for line in lines:
        if line.strip().startswith("```"):
            if in_code:
                out.append("</code></pre>")
            else:
                out.append("<pre><code>")
            in_code = not in_code
            continue
        if in_code:
            out.append(html.escape(line))
            continue
        m = re.match(r"^(#{1,6})\s+(.*)", line)
        if m:
            n = len(m.group(1))
            label = m.group(2).strip()
            sid = _slug(label, used)
            if n <= 3:
                headings.append((n, sid, label))
            out.append(f'<h{n} id="{sid}">{html.escape(label)}</h{n}>')
            continue
        if not line.strip():
            out.append("<p></p>")
            continue
        esc = html.escape(line)
        esc = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", esc)
        esc = re.sub(r"\*(.+?)\*", r"<i>\1</i>", esc)
        esc = re.sub(r"\[(.+?)\]\((.+?)\)", r'<a href="\2">\1</a>', esc)
        out.append(f"<p>{esc}</p>")
    body = _index_nav(headings) + "\n" + "\n".join(out)
    return (
        f"<!DOCTYPE html><html><head><meta charset='utf-8'>"
        f"<title>{html.escape(title)}</title></head><body>{body}</body></html>"
    )


def inject(html_doc, extra_css, mermaid_script, init_script):
    if "</head>" in html_doc:
        html_doc = html_doc.replace("</head>", f"<style>{extra_css}</style></head>", 1)
    else:
        html_doc = f"<style>{extra_css}</style>" + html_doc
    tail = f"{mermaid_script}{init_script}"
    if "</body>" in html_doc:
        html_doc = html_doc.replace("</body>", f"{tail}</body>", 1)
    else:
        html_doc += tail
    return html_doc


def restore_placeholders(html_doc, mapping):
    for ph, info in mapping.items():
        pre = f'<pre class="mermaid">{html.escape(info["code"])}</pre>'
        if info.get("caption"):
            pre = (
                '<figure class="mermaid-figure">'
                f"{pre}"
                f'<figcaption>{html.escape(info["caption"])}</figcaption>'
                "</figure>"
            )
        # pandoc / fallback both tend to wrap bare text in <p>...</p>
        html_doc = re.sub(
            rf"<p>\s*{re.escape(ph)}\s*</p>", pre, html_doc
        )
        html_doc = html_doc.replace(ph, pre)
    return html_doc


def number_figure_captions(html_doc):
    """Prefix every <figcaption> (mermaid figures and pandoc's own image
    figures) with 'Figure N: ' in document order."""
    counter = {"n": 0}

    def repl(m):
        counter["n"] += 1
        return f'{m.group(1)}<b class="fig-label">Figure {counter["n"]}:</b> {m.group(2)}'

    return re.sub(r"(<figcaption[^>]*>)(.*?)(?=</figcaption>)", repl, html_doc, flags=re.DOTALL)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("md_file")
    ap.add_argument("-o", "--output", help="default: <md_basename>.html next to the md file")
    ap.add_argument("--title")
    args = ap.parse_args()

    md_path = os.path.abspath(args.md_file)
    if not os.path.isfile(md_path):
        sys.exit(f"Not a file: {md_path}")

    base = os.path.splitext(os.path.basename(md_path))[0]
    out_path = os.path.abspath(args.output) if args.output else os.path.join(
        os.path.dirname(md_path), f"{base}.html"
    )
    title = args.title or base

    with open(md_path, "r", encoding="utf-8") as f:
        text = f.read()

    blocks = extract_mermaid_blocks(text)
    sub_text, mapping = substitute_with_placeholders(text, blocks)

    doc = pandoc_html(sub_text, title)
    degraded = doc is None
    if degraded:
        print("pandoc not found; using minimal built-in markdown converter (degraded mode).",
              file=sys.stderr)
        doc = minimal_markdown_html(sub_text, title)

    out_dir = os.path.dirname(out_path)
    os.makedirs(out_dir, exist_ok=True)

    if os.path.isfile(VENDOR_JS):
        dest_js = os.path.join(out_dir, "mermaid.min.js")
        if os.path.abspath(dest_js) != os.path.abspath(VENDOR_JS):
            shutil.copyfile(VENDOR_JS, dest_js)
        mermaid_script = '<script src="mermaid.min.js"></script>'
    else:
        print("vendored mermaid.min.js missing; diagrams loaded from CDN instead.",
              file=sys.stderr)
        mermaid_script = '<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>'

    doc = inject(doc, EXTRA_CSS, mermaid_script, MERMAID_INIT)
    doc = restore_placeholders(doc, mapping)
    doc = number_figure_captions(doc)

    with open(out_path, "w", encoding="utf-8") as f:
        f.write(doc)

    print(out_path)


if __name__ == "__main__":
    main()
