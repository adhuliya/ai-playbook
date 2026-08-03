#!/usr/bin/env python3
"""Serve skillup knowledge as browsable HTML. Stdlib only, no dependencies.

Usage:
    python3 serve.py [ROOT] [--port N]

ROOT defaults to the current directory. Two modes, auto-detected:

- **Learning root** (contains one or more <slug>/learning.md): the home page is
  a generated global index linking every learning activity — title, status, and
  level parsed from each learning.md — with quick links to its knowledge index,
  essentials, and cheatsheets. Per-activity notes render under <slug>/knowledge/.
- **Single knowledge folder** (has index.md, no activity children): serves that
  folder with index.md as the home page (legacy behavior).

Renders .md to HTML on the fly: headings, fenced code, inline code, bold/italic,
relative links (kept inside the server), lists, blockquotes, tables, and
```mermaid blocks (Mermaid 11 ESM via CDN). Non-.md files served as-is. Ctrl-C to stop.

Deliberately small: a convenient local reader for revision and quick reference,
not a full markdown engine.
"""

import argparse
import html
import http.server
import os
import re
import socketserver
import sys
import urllib.parse

PAGE = """<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title}</title>
<style>
 body{{max-width:820px;margin:2rem auto;padding:0 1rem;
   font:16px/1.6 -apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;color:#1a1a1a}}
 a{{color:#0645ad;text-decoration:none}} a:hover{{text-decoration:underline}}
 h1,h2,h3{{line-height:1.25;margin-top:1.6em}}
 h1{{border-bottom:1px solid #eaecef;padding-bottom:.3em}}
 code{{background:#f3f4f6;padding:.15em .35em;border-radius:4px;font-size:.9em}}
 pre{{background:#f6f8fa;padding:1rem;border-radius:6px;overflow:auto}}
 pre code{{background:none;padding:0}}
 pre.mermaid{{background:none;padding:0}}
 blockquote{{color:#57606a;border-left:.25em solid #d0d7de;margin:0;padding:0 1em}}
 table{{border-collapse:collapse}} td,th{{border:1px solid #d0d7de;padding:.4em .7em}}
 nav{{font-size:.85em;color:#57606a;margin-bottom:1.5rem}}
 hr{{border:none;border-top:1px solid #eaecef}}
</style>
<script type="module">
 import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
 mermaid.initialize({{startOnLoad:false,securityLevel:"loose"}});
 await mermaid.run({{querySelector:".mermaid"}});
</script>
</head><body>
<nav><a href="/">index</a> &middot; {crumb}</nav>
{body}
</body></html>"""


def _inline(text: str) -> str:
    """Escape then apply inline markdown (code, bold, italic, links)."""
    # Protect inline code spans first.
    spans: list[str] = []

    def stash(m: re.Match) -> str:
        spans.append(m.group(1))
        return f"\x00{len(spans) - 1}\x00"

    text = re.sub(r"`([^`]+)`", stash, text)
    text = html.escape(text)
    text = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", _link, text)
    text = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", text)
    text = re.sub(r"(?<!\*)\*([^*]+)\*(?!\*)", r"<em>\1</em>", text)
    text = re.sub(r"\x00(\d+)\x00",
                  lambda m: f"<code>{html.escape(spans[int(m.group(1))])}</code>",
                  text)
    return text


_FENCE_OPEN = re.compile(r"^(\s*)```(\w*)\s*$")
_FENCE_CLOSE = re.compile(r"^\s*```\s*$")


def _link(m: re.Match) -> str:
    label, href = m.group(1), m.group(2)
    # Keep relative .md links inside the server; leave external/anchor links.
    if not re.match(r"^[a-z]+://|^#|^/", href) and href.endswith(".md"):
        href = href  # relative .md served by our handler as HTML
    return f'<a href="{html.escape(href)}">{html.escape(label)}</a>'


def md_to_html(md: str) -> str:
    out: list[str] = []
    lines = md.splitlines()
    i, n = 0, len(lines)
    in_list = False

    def close_list() -> None:
        nonlocal in_list
        if in_list:
            out.append("</ul>")
            in_list = False

    while i < n:
        line = lines[i]
        # Fenced code / mermaid (opening fence may be indented, e.g. under a list).
        fence = _FENCE_OPEN.match(line)
        if fence:
            close_list()
            base_indent = fence.group(1)
            lang = fence.group(2)
            i += 1
            buf: list[str] = []
            while i < n and not _FENCE_CLOSE.match(lines[i]):
                raw = lines[i]
                if base_indent and raw.startswith(base_indent):
                    raw = raw[len(base_indent):]
                buf.append(raw)
                i += 1
            i += 1  # skip closing fence
            code = "\n".join(buf)
            if lang == "mermaid":
                # Mermaid parses the element's text as diagram source, so it must
                # stay raw — escaping arrows (--> to --&gt;) breaks parsing. Dedent
                # each line (leading indentation confuses the v11 parser) and drop
                # blank lines so statements are cleanly newline-separated.
                diagram = "\n".join(
                    ln.strip() for ln in buf if ln.strip())
                out.append(f'<pre class="mermaid">\n{diagram}\n</pre>')
            else:
                out.append(f"<pre><code>{html.escape(code)}</code></pre>")
            continue
        # Tables (simple pipe tables).
        if "|" in line and i + 1 < n and re.match(r"^\s*\|?[\s:|-]+\|?\s*$", lines[i + 1]):
            close_list()
            header = [c.strip() for c in line.strip().strip("|").split("|")]
            out.append("<table><thead><tr>"
                       + "".join(f"<th>{_inline(c)}</th>" for c in header)
                       + "</tr></thead><tbody>")
            i += 2
            while i < n and "|" in lines[i]:
                cells = [c.strip() for c in lines[i].strip().strip("|").split("|")]
                out.append("<tr>" + "".join(f"<td>{_inline(c)}</td>" for c in cells) + "</tr>")
                i += 1
            out.append("</tbody></table>")
            continue
        # Headings.
        h = re.match(r"^(#{1,6})\s+(.*)$", line)
        if h:
            close_list()
            lvl = len(h.group(1))
            out.append(f"<h{lvl}>{_inline(h.group(2))}</h{lvl}>")
            i += 1
            continue
        # List items.
        li = re.match(r"^\s*[-*+]\s+(.*)$", line)
        oli = re.match(r"^\s*\d+\.\s+(.*)$", line)
        if li or oli:
            if not in_list:
                out.append("<ul>")
                in_list = True
            out.append(f"<li>{_inline((li or oli).group(1))}</li>")
            i += 1
            continue
        # Blockquote.
        if line.startswith(">"):
            close_list()
            out.append(f"<blockquote>{_inline(line.lstrip('> '))}</blockquote>")
            i += 1
            continue
        # Horizontal rule.
        if re.match(r"^\s*---+\s*$", line):
            close_list()
            out.append("<hr>")
            i += 1
            continue
        # Blank line.
        if not line.strip():
            close_list()
            i += 1
            continue
        # Paragraph.
        close_list()
        out.append(f"<p>{_inline(line)}</p>")
        i += 1

    close_list()
    return "\n".join(out)


def _meta(learning_md: str) -> dict:
    """Parse title + first metadata table from a learning.md (first ~15 lines)."""
    meta = {"title": "", "status": "", "level": "", "slug": ""}
    with open(learning_md, encoding="utf-8") as f:
        for line in f.read().splitlines()[:15]:
            if not meta["title"]:
                h = re.match(r"^#\s+(.*)$", line)
                if h:
                    meta["title"] = h.group(1).strip()
                    continue
            row = re.match(r"^\|\s*(\w+)\s*\|\s*(.*?)\s*\|\s*$", line)
            if row and row.group(1).lower() in meta:
                meta[row.group(1).lower()] = row.group(2).strip()
    return meta


def discover_activities(root: str) -> list[dict]:
    """Find <slug>/learning.md under root; return sorted metadata dicts."""
    acts = []
    for entry in sorted(os.listdir(root)):
        lm = os.path.join(root, entry, "learning.md")
        if os.path.isfile(lm):
            m = _meta(lm)
            m["dir"] = entry
            m["slug"] = m["slug"] or entry
            acts.append(m)
    return acts


def global_index_html(root: str) -> str:
    """Home page listing every learning activity with quick links."""
    acts = discover_activities(root)
    rows = []
    for a in acts:
        d = a["dir"]
        links = []
        for label, rel in (("knowledge", f"{d}/knowledge/index.md"),
                            ("essentials", f"{d}/knowledge/essentials.md"),
                            ("cheatsheets", f"{d}/knowledge/cheatsheets/")):
            if os.path.exists(os.path.join(root, rel.rstrip("/"))):
                links.append(f'<a href="/{html.escape(rel)}">{label}</a>')
        rows.append(
            "<tr>"
            f"<td>{html.escape(a['title'] or a['slug'])}</td>"
            f"<td><code>{html.escape(a['slug'])}</code></td>"
            f"<td>{html.escape(a['status'])}</td>"
            f"<td>{html.escape(a['level'])}</td>"
            f"<td>{' &middot; '.join(links)}</td>"
            "</tr>")
    body = ["<h1>Learning activities</h1>"]
    if rows:
        body.append("<table><thead><tr><th>Title</th><th>Slug</th>"
                     "<th>Status</th><th>Level</th><th>Links</th></tr></thead>"
                     "<tbody>" + "".join(rows) + "</tbody></table>")
    else:
        body.append("<p>No learning activities found under this folder.</p>")
    return "\n".join(body)


class Handler(http.server.SimpleHTTPRequestHandler):
    is_learning_root = False  # set on the class in main()

    def do_GET(self) -> None:  # noqa: N802
        path = urllib.parse.unquote(self.path.split("?", 1)[0])
        if path in ("/", "") and self.is_learning_root:
            self._send_html(global_index_html(self.directory), "Learning", "home")
            return
        if path in ("/", ""):
            path = "/index.md"
        rel = path.lstrip("/")
        fs = os.path.normpath(os.path.join(self.directory, rel))
        if not fs.startswith(os.path.abspath(self.directory)):
            self.send_error(403)
            return
        if os.path.isdir(fs):
            idx = os.path.join(fs, "index.md")
            if os.path.exists(idx):
                fs = idx
                rel = os.path.join(rel, "index.md")
        if fs.endswith(".md") and os.path.exists(fs):
            with open(fs, encoding="utf-8") as f:
                md = f.read()
            self._send_html(md_to_html(md), os.path.basename(fs), rel)
            return
        super().do_GET()

    def _send_html(self, body: str, title: str, crumb: str) -> None:
        page = PAGE.format(title=html.escape(title), crumb=html.escape(crumb),
                           body=body)
        data = page.encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)


def main() -> int:
    ap = argparse.ArgumentParser(
        description="Serve skillup knowledge (a learning root or one knowledge/ folder).")
    ap.add_argument("root", nargs="?", default=".",
                    help="learning root (.dev-notes/learning) or a knowledge/ folder")
    ap.add_argument("--port", type=int, default=8800)
    args = ap.parse_args()
    root = os.path.abspath(args.root)
    if not os.path.isdir(root):
        print(f"error: not a directory: {root}", file=sys.stderr)
        return 1

    is_root = bool(discover_activities(root))
    Handler.is_learning_root = is_root
    handler = lambda *a, **k: Handler(*a, directory=root, **k)  # noqa: E731
    with socketserver.TCPServer(("127.0.0.1", args.port), handler) as httpd:
        url = f"http://127.0.0.1:{args.port}/"
        mode = "learning root (global index)" if is_root else "knowledge folder"
        print(f"serving {root}\n  mode: {mode}\n  {url}\nCtrl-C to stop.")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nstopped.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
