# `build`

Status: `Active` (an engineering turn with no keyword: "continue", a
milestone, a fix).

Reads: policy/activity-kind.md, policy/comments.md

When `kind` is `thin`, do the work inline. Do not read the launch kit
or `pipelines/milestone.md`. Checkpoint per **Update cadence**
(`policy/update-cadence.md`).

When `kind` is `full`, follow **Engineering while focused** and **Test
evidence**. Run each milestone through the **Milestone** pipeline;
checkpoint per **Update cadence**. Before the first sub-agent launch of
the session, read the launch kit and `pipelines/milestone.md`
(**Background sub-agents**).

When work remains, ask for `continue`. When the milestones and the
end-to-end check are done, prompt `mark-completed`.
