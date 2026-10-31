# Typst excerpt

Source: https://github.com/typst/typst/blob/main/README.md and https://typst.app/docs/tutorial/making-a-template/ and https://typst.app/docs/reference/scripting/

Kept: local compile, how a reusable style is applied, and the fact that the official language is Typst markup. The reference does not document a Markdown reader.

- Install on macOS: `brew install typst`. A binary from the GitHub release is the other local path. `cargo install --locked typst-cli` needs a Rust toolchain.
- Compile: `typst compile file.typ` writes `file.pdf`. `typst compile input.typ output.pdf` sets the output path. `typst watch file.typ` recompiles on change.
- Fonts: `typst compile --font-path path/to/fonts file.typ`. `typst fonts` lists discovered fonts. `TYPST_FONT_PATHS` is the environment form.
- A template is a function. The document applies it with `#show: template` or `#show: template.with(...)`.
- Put the template in another file and import it: `#import "conf.typ": conf`. `#include` inserts content and does not carry `set` rules back to the caller. Use import for the style.
- Style knobs inside the template are `set` rules, for example `set text(font: "Libertinus Serif", size: 11pt)` and `set page(...)`.
- Color and other per-document choices belong in the template arguments, so each document can pass its own values.
