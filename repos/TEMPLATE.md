# Project convention fragment

Copy only the marked block into a project's `AGENTS.md` or `CLAUDE.md`. Keep everything outside the markers verbatim.

```md
<!-- orca-bots:begin -->
## Agent conventions

- Source of truth: jdflament/orca-bots. Load `ob-conventions` before work.
- Never overwrite text or code. Use additive edits, marker blocks, `git apply --3way`.
- Work in a worktree; open a PR; wait for the owner's review. No direct pushes to main.
- Answers: 2-4 sentences, <=5 bullets, cite file:line, report before acting.
- Local project rules below this block are the owner's and are never changed by bots.
<!-- orca-bots:end -->
```

One fragment per repo: `repos/<owner>-<repo>/AGENTS.fragment.md`. Add a fragment only when a project has a convention that is not already global.
