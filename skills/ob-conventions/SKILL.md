---
name: ob-conventions
description: >-
  Canonical working rules for the Orca bot fleet: source of truth, autonomy
  ladder (act / act + tell / ask), parallel work, no-overwrite edits, reports,
  and token discipline. Load before planning.
---

# Conventions

## Truth

- `https://github.com/jdflament/orca-bots` is canonical for roles, skills, and standards.
- This repo is project-agnostic. Per-project facts and owner policy live in Captain's private profile (`ob-onboard`); Captain passes the needed lines in each brief.
- The project's own `AGENTS.md` / `CONTRIBUTING.md` win for code style and layering.
- `MEMORY.md` holds learned facts, never rules. Promote rules into the repo by PR.

## Autonomy ladder

The owner's per-project policy can make an item stricter, or grant a standing authorization; nothing else moves items up a tier.

- **Act** — read anything; create worktrees; start, nudge, stop workers; push to bot-owned branches; open draft PRs; fix CI on bot PRs; re-run CI; hand off to bots.
- **Act + tell** — mark a bot PR ready; rebase bot branches; merge under the project's standing authorization (CI green, Reviewer `merge`, no open gate); triage labels if the profile allows.
- **Ask** — anything destructive or irreversible; closing or commenting on human issues and PRs; touching a human's branch; auth, payments, secrets, data migrations, infra, CI config, major dependency bumps; public posts; scope or product decisions; a task that failed twice; changes to this repo.

Ask with one batched message (or `orca orchestration gate-create`), each question answerable in one word, with your default. Keep working on everything the gate does not block.

## Parallel

- One topic = one task. Independent tasks run at the same time; never serialize them.
- Hand off to several bots at once; inside a bot, split independent pieces across subagents and reply once.
- Respect the project's worker cap (default 3). Queue the rest by priority.

## No overwrite

- Never replace existing text or code with `>` or a blind write. Prefer additive edits, `git apply --3way`, or a new file.
- In human-owned files touch only the `<!-- orca-bots:begin -->` … `<!-- orca-bots:end -->` block; ask before inserting markers.
- Never write `bot.json`, bot `AGENTS.md`, bot `CLAUDE.md`, chats, or another bot's `MEMORY.md`.

## Reports

- Shape: What changed / Why it matters / Needs you / Next. Specialists end with a one-line `Verdict:`.
- 2–4 sentences, ≤5 bullets, cite `file:line` or `#number`. No restating the task.

## Tokens

- `opencode2` is the default agent; Claude only while its tokens last. Rules never change with the agent.
- Model tier by job: small for triage, CI re-runs, rebases, docs; strong for risky review and hard bugs.
- Read only what the job needs. Pass handoffs a brief and paths, not pasted files.
- Events over schedules; schedules get a `--precheck` so they skip when nothing changed.
- Stop when the answer is enough. Don't re-check what has not changed.
