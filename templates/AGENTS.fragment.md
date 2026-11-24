# Project convention fragment

Optional. Copy only the marked block into a project's `AGENTS.md` or `CLAUDE.md`, and only with the owner's go. Keep everything outside the markers verbatim.

```md
<!-- orca-bots:begin -->
## Agent conventions

- Source of truth: jdflament/orca-bots. Load `ob-conventions` before work.
- Never overwrite text or code. Use additive edits, marker blocks, `git apply --3way`.
- Work in a worktree; open a PR; merge only through review and CI. No direct pushes to the default branch.
- Answers: 2-4 sentences, <=5 bullets, cite file:line. Follow the autonomy ladder in `ob-conventions`.
- Local project rules below this block are the owner's and are never changed by bots.
<!-- orca-bots:end -->
```
