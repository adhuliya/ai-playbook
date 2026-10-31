# Pandoc excerpt

Source: https://pandoc.org/MANUAL.html (user guide fetched 2026-10-31)

Kept: the Typst bridge, the DOCX style reference, and the LaTeX default. This is the converter. It is not the revision format.

- Markdown to Typst source: `pandoc report.md --from markdown+raw_attribute --to typst -o report.typ`, then `typst compile report.typ`.
- Markdown straight to PDF through Typst: `pandoc report.md --pdf-engine=typst -o report.pdf`.
- A fenced block `{=typst}` passes Typst through. That needs the `raw_attribute` extension. Use it for a figure or a template call that Markdown cannot say.
- Pipe form: `pandoc report.md --from markdown+raw_attribute --to typst --output - | typst compile - report.pdf`.
- Typst template variables include `papersize`, `margin`, `mainfont`, `fontsize`, `section-numbering`, `page-numbering`, `columns`, `linestretch`, and `linkcolor` (a hex color). Pass them with `-V`, or put the same keys in YAML.
- Pitfall: section numbers stay off unless you set `section-numbering` (e.g. `"1.1"`). The Typst template default is `none`.
- Pitfall: the guide says the `thanks` variable does not work properly as of Typst 0.15 (pandoc issue 11807).
- If the output is PDF and `--pdf-engine` is omitted, pandoc uses `pdflatex`, not Typst.
- DOCX styles: `pandoc report.md --reference-doc custom-reference.docx -o report.docx`. The reference file's styles, margins, page size, header, and footer are used. Its body text is ignored.
- Seed a reference file with `pandoc -o custom-reference.docx --print-default-data-file reference.docx`, then change styles only.
- A Div or Span with `custom-style="Name"` applies a DOCX style. If that style is missing from the reference file, pandoc defines it from normal text.
- Markdown to LaTeX: `pandoc -f markdown -t latex report.md`. That path is an explicit conversion, not the core PDF path.
