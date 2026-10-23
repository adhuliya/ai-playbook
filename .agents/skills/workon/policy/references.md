# References

`references.md` holds every `REF<n>` of the activity; `agent-activity.md` has no
References section. Shape: `shapes/references.md`. Cite a reference by its
ID. Numbering: **IDs**.

## Cited context

Runs when the user points at files or links as initial context or definition
updates (create, derive, `replan-work`, RD changes), not for every source
file touched while building.

1. Use every cited file this session, saved or not.
2. Ask once with a list. For each item: tracked or not, a hint of whole
   copy vs excerpt, and whether an MCP tool fits (**MCP sources**). Do not
   copy until the user chooses; a subset is fine.
3. **Whole copy:** `artifacts/<basename>` at the artifacts root (create the
   dir if needed), never under a reserved name (`shapes/layout.md`). On a
   name clash, ask. No secrets. For huge trees, excerpt or skip.
4. **Excerpt:** a new `artifacts/<stem>-excerpt.md` whose header names the
   source and what was kept. For a binary, write markdown of what mattered,
   or a whole copy if the user asked for the file.
5. Every cited item gets a `REF<n>` entry in `references.md`: `source`,
   `kept` (`copied` / `excerpt` / `context-only`), and 1–3 sentences
   learned. On `replan-work`, refresh it if the same items return.

## MCP sources

When a cited link or ID fits a tool of the user's configured MCP servers
(ticket, wiki, document, pull request, design file), use that tool to get
the details. Fetch read-only; never write through an MCP tool. Save what
later phases need under `artifacts/` as in steps 3–4 (excerpt by default; no
secrets), and record `fetched: <date>` in the entry. With no fitting tool,
record `context-only` and the link; ask the user to paste the details when
they matter.

## Refresh

A fetched remote reference goes stale on a long activity. Re-fetch it
at `resume-work`, at `replan-work`, and before a milestone that cites it,
when `fetched:` is about a week old or older, or the source is volatile
(open ticket, pull request, draft document). Update the artifact, `fetched:`,
and the learned lines. When the new content changes a requirement, follow
**Material-change**. A refresh writes no journal event. `references.md` MAY
carry dates; the no-dates rule covers only `agent-activity.md` and `agent-journal.md`.
