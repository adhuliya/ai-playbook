# Google Docs export

Load only when the user asks for Google Docs. Do not call a Drive plugin from the skill core.

## Path (no plugin required)

1. Produce a DOCX (`references/docx.md`).
2. Upload to Google Drive.
3. Either:
   - **Edit in place:** open the DOCX with Google Docs (keeps a Word file that Docs can edit), or
   - **Save as Google Docs:** File → Save as Google Docs for a native Docs copy.

Tracked changes / suggestions behave per Google Docs help; they are not Typst features.

## Skill boundary

Drive steps live only in this file. `SKILL.md` must not inline them. Machines without a Google/Microsoft plugin still use the Pandoc DOCX path above.
