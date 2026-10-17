# `query-work` / `no-query-work`

Status: any. Status unchanged. `query-work` sets a session flag that lasts
until `no-query-work` or session end (**Stops** query mode).

Under the flag, every mutation is blocked: files, git writes, sub-agent
output files, and mutating keywords. Allowed: `help`, `no-query-work`,
list, details, reads, and `resume-work` on `Planning` / `Approved` /
`Active` (reload only). Skip **Session start**; report pending repairs
instead. Do not record review points the user states; after
`no-query-work`, ask whether to record them. On a blocked request, say
query mode is on and ask for `no-query-work`.
