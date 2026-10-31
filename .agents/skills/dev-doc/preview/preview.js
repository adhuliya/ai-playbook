/* Client-side Markdown → HTML probe (markdown-it). Not the formal Typst PDF. */

const SOURCES = {
  "report-browser": {
    label: "report-browser.md (PNG figures)",
    path: "./report-browser.md",
    bib: "../templates/refs.bib",
    numbers: true,
  },
  "report-raw": {
    label: "report.md (raw Pandoc; Typst blocks show as code)",
    path: "../templates/report.md",
    bib: "../templates/refs.bib",
    numbers: true,
  },
};

const PDFS = {
  report: { label: "sample/report.pdf", path: "../sample/report.pdf" },
  deck: { label: "sample/deck.pdf", path: "../sample/deck.pdf" },
};

const statusEl = document.getElementById("status");
const articleEl = document.getElementById("article");
const pdfFrame = document.getElementById("pdf-frame");
const sourceSelect = document.getElementById("source");
const pdfSelect = document.getElementById("pdf");
const paneMode = document.getElementById("pane-mode");
const panes = document.getElementById("panes");
const reloadBtn = document.getElementById("reload");

const md = window.markdownit({
  html: false,
  linkify: true,
  typographer: true,
  highlight(str, lang) {
    let html;
    let langClass = "";
    if (window.hljs) {
      try {
        if (lang && window.hljs.getLanguage(lang)) {
          html = window.hljs.highlight(str, { language: lang, ignoreIllegals: true }).value;
          langClass = ` language-${md.utils.escapeHtml(lang)}`;
        } else {
          html = window.hljs.highlightAuto(str).value;
        }
      } catch (_) {
        html = md.utils.escapeHtml(str);
      }
    } else {
      html = md.utils.escapeHtml(str);
    }
    const lines = html.replace(/\n$/, "").split("\n");
    const body = lines.map((line) => `<span class="line">${line || " "}</span>`).join("");
    return `<pre class="code-lines hljs${langClass}"><code>${body}</code></pre>`;
  },
});

function setStatus(text, isError) {
  statusEl.textContent = text;
  statusEl.classList.toggle("error", Boolean(isError));
}

function stripYamlFrontMatter(text) {
  if (!text.startsWith("---\n")) return { body: text, meta: {} };
  const end = text.indexOf("\n---\n", 4);
  if (end === -1) return { body: text, meta: {} };
  const yaml = text.slice(4, end);
  const body = text.slice(end + 5);
  const meta = {};
  yaml.split("\n").forEach((line) => {
    const m = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (m) meta[m[1]] = m[2].replace(/^["']|["']$/g, "").trim();
  });
  return { body, meta };
}

function promoteItalicCaptions(root) {
  root.querySelectorAll("p > em:only-child").forEach((em) => {
    const p = em.parentElement;
    if (!p || p.children.length !== 1) return;
    p.classList.add("caption");
    p.textContent = em.textContent;
  });
}

function wrapImagesAsFigures(root) {
  root.querySelectorAll("p > img:only-child").forEach((img) => {
    const p = img.parentElement;
    if (!p) return;
    const fig = document.createElement("figure");
    const caption = document.createElement("figcaption");
    caption.textContent = img.getAttribute("alt") || "";
    fig.appendChild(img);
    if (caption.textContent) fig.appendChild(caption);
    p.replaceWith(fig);
  });
}

/** Minimal BibTeX parse for @online / @article / @misc style entries. */
function parseBibTeX(text) {
  const entries = {};
  const re = /@(\w+)\s*\{\s*([^,]+)\s*,([\s\S]*?)\n\s*\}/g;
  let m;
  while ((m = re.exec(text))) {
    const key = m[2].trim();
    const fields = {};
    const fieldRe = /(\w+)\s*=\s*(\{([^{}]*)\}|"([^"]*)"|(\S+))/g;
    let f;
    while ((f = fieldRe.exec(m[3]))) {
      fields[f[1].toLowerCase()] = (f[3] ?? f[4] ?? f[5] ?? "").trim();
    }
    entries[key] = { type: m[1].toLowerCase(), fields };
  }
  return entries;
}

function formatBibAuthor(raw) {
  if (!raw) return "";
  return raw.replace(/^\{\{|\}\}$/g, "").replace(/\s+/g, " ").trim();
}

function formatBibEntry(entry) {
  const f = entry.fields;
  const author = formatBibAuthor(f.author);
  const title = f.title || "(untitled)";
  const year = f.year || "";
  const url = f.url || "";
  const parts = [];
  if (author) parts.push(`${author}.`);
  parts.push(`“${title}.”`);
  if (year) parts.push(`${year}.`);
  if (url) {
    const a = document.createElement("a");
    a.href = url;
    a.target = "_blank";
    a.rel = "noopener";
    a.textContent = url;
    return { textParts: parts, link: a };
  }
  return { textParts: parts, link: null };
}

function collectCiteKeys(text) {
  const keys = [];
  const seen = new Set();
  const re = /\[@([^\]]+)\]/g;
  let m;
  while ((m = re.exec(text))) {
    m[1].split(";").forEach((part) => {
      const key = part.trim().replace(/^@/, "");
      if (!key || seen.has(key)) return;
      seen.add(key);
      keys.push(key);
    });
  }
  return keys;
}

function applyCitationsAndBibliography(root, sourceText, bibEntries) {
  const order = collectCiteKeys(sourceText);
  if (!order.length) return;

  const numByKey = new Map(order.map((k, i) => [k, i + 1]));

  const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null);
  const textNodes = [];
  while (walker.nextNode()) textNodes.push(walker.currentNode);

  const citeBlock = /\[@([^\]]+)\]/g;
  textNodes.forEach((node) => {
    const text = node.nodeValue;
    if (!text || !text.includes("[@")) return;
    const frag = document.createDocumentFragment();
    let last = 0;
    let m;
    citeBlock.lastIndex = 0;
    while ((m = citeBlock.exec(text))) {
      if (m.index > last) frag.appendChild(document.createTextNode(text.slice(last, m.index)));
      const keys = m[1].split(";").map((p) => p.trim().replace(/^@/, "")).filter(Boolean);
      keys.forEach((key, i) => {
        if (i) frag.appendChild(document.createTextNode(", "));
        const n = numByKey.get(key);
        const a = document.createElement("a");
        a.className = "cite-ref";
        a.href = `#ref-${key}`;
        a.textContent = n != null ? `[${n}]` : `[@${key}]`;
        if (n == null) a.title = `Missing bibliography key: ${key}`;
        frag.appendChild(a);
      });
      last = m.index + m[0].length;
    }
    if (last < text.length) frag.appendChild(document.createTextNode(text.slice(last)));
    node.parentNode.replaceChild(frag, node);
  });

  const section = document.createElement("section");
  section.className = "bibliography";
  section.id = "references";
  const h2 = document.createElement("h2");
  h2.className = "unnumbered";
  h2.textContent = "References";
  section.appendChild(h2);
  const ol = document.createElement("ol");
  order.forEach((key) => {
    const li = document.createElement("li");
    li.id = `ref-${key}`;
    const num = document.createElement("span");
    num.className = "ref-num";
    num.textContent = `[${numByKey.get(key)}]`;
    const body = document.createElement("span");
    body.className = "ref-body";
    const entry = bibEntries[key];
    if (!entry) {
      body.textContent = `${key} (missing from refs.bib)`;
    } else {
      const { textParts, link } = formatBibEntry(entry);
      body.textContent = textParts.join(" ");
      if (link) {
        body.appendChild(document.createTextNode(" "));
        body.appendChild(link);
      }
    }
    li.appendChild(num);
    li.appendChild(body);
    ol.appendChild(li);
  });
  section.appendChild(ol);
  root.appendChild(section);
}

async function loadMarkdown(key) {
  const src = SOURCES[key];
  if (!src) return;
  setStatus(`Loading ${src.path}…`);
  articleEl.classList.toggle("no-numbers", !src.numbers);
  try {
    const res = await fetch(src.path);
    if (!res.ok) throw new Error(`${res.status} ${res.statusText}`);
    const raw = await res.text();
    const { body, meta } = stripYamlFrontMatter(raw);
    articleEl.innerHTML =
      `<div class="running-head"><span>Doc pipeline · browser MD probe</span><span>${src.label}</span></div>` +
      md.render(body);
    promoteItalicCaptions(articleEl);
    wrapImagesAsFigures(articleEl);

    const bibPath = src.bib || (meta.bibliography ? `../${meta.bibliography}` : null);
    if (bibPath && /\[@/.test(body)) {
      const bibRes = await fetch(bibPath);
      if (!bibRes.ok) throw new Error(`Bibliography ${bibPath}: ${bibRes.status}`);
      const bibEntries = parseBibTeX(await bibRes.text());
      applyCitationsAndBibliography(articleEl, body, bibEntries);
    }

    setStatus(
      `Rendered ${src.path} with markdown-it` +
        (bibPath && /\[@/.test(body) ? " + refs.bib" : "") +
        ". Formal look remains the Typst PDF.",
    );
  } catch (err) {
    articleEl.innerHTML = "";
    setStatus(`Failed to load ${src.path}: ${err.message}. Serve from scratch/ over HTTP (file:// blocks fetch).`, true);
  }
}

function loadPdf(key) {
  const pdf = PDFS[key];
  if (!pdf) return;
  pdfFrame.src = pdf.path;
}

function applyPaneMode() {
  const mode = paneMode.value;
  panes.classList.toggle("single", mode !== "split");
  document.getElementById("md-pane").hidden = mode === "pdf";
  document.getElementById("pdf-pane").hidden = mode === "md";
}

sourceSelect.innerHTML = Object.entries(SOURCES)
  .map(([k, v]) => `<option value="${k}">${v.label}</option>`)
  .join("");
pdfSelect.innerHTML = Object.entries(PDFS)
  .map(([k, v]) => `<option value="${k}">${v.label}</option>`)
  .join("");

sourceSelect.addEventListener("change", () => loadMarkdown(sourceSelect.value));
pdfSelect.addEventListener("change", () => loadPdf(pdfSelect.value));
paneMode.addEventListener("change", applyPaneMode);
reloadBtn.addEventListener("click", () => {
  loadMarkdown(sourceSelect.value);
  loadPdf(pdfSelect.value);
});

applyPaneMode();
loadMarkdown(sourceSelect.value);
loadPdf(pdfSelect.value);
