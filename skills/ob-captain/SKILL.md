---
name: ob-captain
description: >-
  Captain's operating loop: split owner messages into parallel topics, pick
  work by priority, dispatch workers and specialist bots, verify, run the merge
  queue, open gates only when needed, and report. Load when coordinating.
---

# Captain loop

## 1. Intake — every owner message

- Split it into independent topics (a bug, a question, a feature, a config change…).
- Reply at once with one line per topic: `topic — owner (worker / bot / me) — next step`.
- Create one task per topic (`orca orchestration task-create`); add `--deps` only for real dependencies.
- Answer pure questions inline if cheap; otherwise hand them off too.

## 2. Pick — when idle or woken

Unknown project or stale profile → `ob-onboard` first. Then read state once (`ob-context`, the profile, `orca worktree ps --json`, open PRs and issues) and order:

1. Red CI or merge conflict on a bot PR.
2. Green PR waiting for review or merge.
3. Owner's explicit asks.
4. Briefed issues by the profile's priority labels.
5. Hygiene: stale PRs, triage, docs drift.

## 3. Dispatch

| Work | Goes to |
| --- | --- |
| Code, CI fix, rebase, docs edit | worker: `orca orchestration worker-start --spec-file <brief> --worktree new-top-level --repo <repo> --agent opencode2 [--model <tier>]` |
| PR review / merge verdict | `@Reviewer` |
| UI change, flow check | `@Experience` (in parallel with Reviewer) |
| New issues, unclear issue, docs drift | `@Issues` |

- Brief = goal, acceptance criteria, repo + base branch, files to start from, the profile's commands, risk, "load ob-work". No pasted files.
- Multi-repo change → one worker per repo, linked with `--deps`; merge in dependency order.
- Up to the worker cap at once; the rest queue by priority.
- An unclear issue goes to `@Issues` for a brief first, not to a worker.

## 4. Verify

- Read the worker's report, the diff stat, and CI yourself. Re-run flaky CI once.
- Blockers from Reviewer or Experience → back to a worker with the findings, same branch.
- Stalled worker: `worker-read` → nudge once → `worker-stop` → retry with `--retry-of`. Two failures → **Ask**.

## 5. Merge queue

- Only under the project's standing authorization: CI green, mergeable, Reviewer `merge`, Experience `ship` when UI changed, no open gate.
- One at a time with the profile's merge command; then re-check the next PR (it may need a rebase).

## 6. Report

- Per topic: What changed / Why it matters / Needs you / Next.
- Batch: send when a topic finishes or a gate opens, not on every step.
- Scheduled runs with nothing new: stay silent.
