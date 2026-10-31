# Browser preview excerpt

Kept: how to open a deck or a Typst document in a browser, and the mistakes that produce a blank page, source text, or the wrong layout. Sources are named on each point.

## Marp slides

Source: https://github.com/marp-team/marp-cli/blob/main/README.md and https://github.com/marp-team/marp-cli/issues/280

- Start a site with `npx @marp-team/marp-cli@latest -s ./slides`. Open `http://localhost:8080/`. Set `PORT` to change the port.
- The server converts on request and does not write the HTML to disk. `http://localhost:8080/deck.md?pdf` returns a PDF.
- Put `index.md` or `PITCHME.md` in the served directory to make `/` open a deck.
- Images must live in the served directory or below it. A path outside that tree does not appear.
- `--allow-local-files` lets a browser conversion read local files. Use it only for Markdown you trust, on your own machine. Do not use it for a server that renders Markdown from someone else. With HTML enabled, a document can read files on the machine.
- `-w` watches files and can refresh an HTML file already open in the browser. It does not host the deck. The watch connection speaks WebSocket. Opening that port in a browser returns `426 Upgrade Required`. Use `-s` when you want a page.
- A plain static server does not run Marp. It will show the Markdown source.

## Typst documents

Source: https://typst.app/docs/reference/html/ and https://github.com/typst/typst/issues/7016 and https://github.com/typst/typst/pull/5524

- The formal look is the PDF. `typst compile file.typ` writes it. `typst watch file.typ` recompiles that PDF and does not serve a page. Pair it with a PDF viewer that reloads.
- HTML export is experimental. The command is `typst watch file.typ --format html --features html`. The docs say not to use it for production. It emits semantic HTML and does not emit the CSS of the PDF, so the browser page will not match the formal document.
- That HTML watch starts a live-reload server on the first free port from 3000 to 3005. `--port` sets the port. `--no-reload` keeps the server and skips the reload script. `--no-serve` writes the HTML and starts no server. The file on disk does not contain the reload script.
- The server exists for HTML and bundle output only. Watching a PDF does not open a port.
- `typst watch` runs until you stop it. It is a writing aid, not a one-shot build.
- A plain static server serves the PDF or HTML you already compiled. It does not compile a `.typ` file. Opening the source in the browser shows Typst markup.

## What to tell an agent

- For a slide preview, use Marp `-s`. Do not browse the watch port.
- For the formal report, poster, or cheat sheet, compile the PDF and open that. Do not treat Typst HTML as the same picture.
- Say which command is running, and which URL, before calling a preview broken.
