---
name: ob-conventions
description: >-
  Canonical working rules for the Orca bot fleet: source of truth, no-overwrite
  edits, marker blocks, concise reports, and token discipline. Load before planning.
---

# Conventions

## Truth

- `https://github.com/jdflament/orca-bots` is canonical for roles, skills, and standards.
- Project conventions live in `repos/<name>/` fragments. Read the relevant one before judging code.
- `MEMORY.md` holds learned facts, never rules. Promote rules into the repo by PR.

## No overwrite

- Never replace existing text or code with `>` or a blind write.
- Prefer additive edits, `git apply --3way`, or a new file.
- To manage text in a human-owned file, touch only the marked block:

  ```md
  <!-- orca-bots:begin -->
  Managed lines only.
  <!-- orca-bots:end -->
  ```

- If the markers are absent, ask before inserting them. Preserve everything outside verbatim.
- Never write `bot.json`, bot `AGENTS.md`, bot `CLAUDE.md`, chats, or `MEMORY.md`.

## Reports

- Shape: What changed / Why it matters / Needs you / Next.
- 2–4 sentences, ≤5 bullets, cite `file:line`. No restating the task.
- Report first; ask before commits, pushes, PRs, comments, tickets, or config changes.

## Tokens

- Read only what the job needs. No whole-repo sweeps for a single file question.
- Prefer `opencode2` for every role. Use Claude only while Claude tokens are available, then fall back to `opencode2`.
- Use the cheapest model that can do the job.
- On-demand beats a schedule. Stop a job when the answer is enough.

## Agents

- `opencode2` is the default agent for every bot; Claude is a fallback only while tokens are available.
- These rules are agent-neutral. Switching the agent never changes the conventions.
