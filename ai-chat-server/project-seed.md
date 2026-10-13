# Seed prompt — cursor-agent-chat

---

Build a local **Cursor Agent chat** (npm name `cursor-agent-chat`): ChatGPT-style browser UI over `@cursor/sdk`, one Node process, one port (default **3456**).

## Stack

- **Runtime:** Node 22+, TypeScript ESM (`"type": "module"`)
- **Server:** Express, `ws`, `multer`, `dotenv`, `uuid`, `@cursor/sdk`
- **Web:** React 19, `react-router-dom`, Vite 6 + `@vitejs/plugin-react`, Tailwind 4 (`@tailwindcss/vite`)
- **Markdown UI:** `react-markdown`, `remark-gfm`, `rehype-raw`, `mermaid`, `@monaco-editor/react`, `lucide-react`, `diff`
- **PDF:** `markdown-it` + `puppeteer` (server-side)
- **Dev:** `tsx`, `typescript`; scripts: `dev` (tsx watch server), `build` (vite → `dist/`), `start` (prod Express serves `dist/`), `typecheck`

## Layout

```
server/src/     Express + WS + agent host (index, agent-manager, session-store,
                paths, skills-rules, file-tracker, pdf-renderer, env-tokens)
web/src/        React UI (App, api, components/*); index.html under web/
scripts/        hello-sdk.mjs, run-prompt.mjs; optional jira/gitlab sync (Python)
workspace/      sessions/<id>/{meta,messages,files/}, uploads/  (gitignored sessions)
.cursor/        skills/ + rules/ (project; UI-editable; session files/.cursor → here)
tokens/         secrets (gitignored); prefer tokens/cursor-api-key.txt
dist/           production UI build
```

Optional later: `jira_tickets/`, `gitlab_repos/` caches; `sub-projects/` read-only checkouts.

## Architecture invariants

- **One process:** Express hosts API + WebSocket; **dev** = Vite middleware mode (no second port); **prod** = static `dist/`.
- Agent cwd = `workspace/sessions/<id>/files/`; path ops stay inside session root.
- Skills/rules live at repo `.cursor/`; CRUD parks prior versions (`.bak.<ISO>`).
- Sessions: shareable `/s/<id>`; ownership via `X-Tab-Id` / `cac.tabId`; unnamed guest writes may auto-clone.
- Chat stream: `WS /ws/sessions/:id` (fallback `POST .../chat-sync`).
- Key resolution: env → `.env` → `CURSOR_API_KEY_FILE` → `tokens/cursor-api-key.txt`.
- Markdown: shared `.prose-chat` / `.prose-light` CSS for chat + file preview; PDF uses separate `PAGE_STYLE`.

## Minimal MVP to implement first

1. `package.json` + Vite root=`web`, outDir=`dist`; `server`/`web` tsconfigs.
2. Express: `POST/GET /api/sessions`, WS chat stub with `@cursor/sdk` Agent create/resume + stream events.
3. React: session URL, chat list/input, live deltas; file preview with markdown.
4. `.env.example`, gitignore for `node_modules/`, `dist/`, `.env`, `tokens/`, `workspace/sessions/`.

Do not invent multi-tenant auth or cloud Cursor product work. Prefer smallest working vertical slice.

