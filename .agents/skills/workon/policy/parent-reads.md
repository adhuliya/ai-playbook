# Parent reads

For readiness, read metadata only (`test -f`, size, mtime); when the file
is missing, say so. Never read a result body to judge readiness.

Read a body only to consume a result: the final file the pipeline step
names, explore reports while you draft, `env.md` only when it says
`blocked`, and `bg/M<n>/slice.md` before splitting that milestone's jobs.
Do not read `sub-agents-log.txt`, job reports, test reports, critic
files, comment job reports, snapshots, or slice directories otherwise.
