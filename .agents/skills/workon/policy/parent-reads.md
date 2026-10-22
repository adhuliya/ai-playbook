# Parent reads

For status, read metadata only (`test -f`, size, mtime); when the file is
missing, say so. Never read a body to judge status.

Read a body only to consume a result: the final file the pipeline step
names, explore reports while you draft, `env.md` only when it says
`blocked`, `bg/M<n>/slice.md` before splitting that milestone's jobs, and
both critic files on the milestone evaluate step (then
reconcile them per **Reconcile** in `briefs/synthesizer.md`). Do not read
job reports, test reports, critic files, comment job reports, snapshots, or
slice directories otherwise.
