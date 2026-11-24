# Orca bots

Canonical, project-agnostic setup for a small fleet of Orca bots that take over any app project — one repo, many, or a local folder — with the owner talking to a single bot. Public by design: **no secrets, tokens, private paths, or project-specific config**.

## Fleet

| Bot | Job | Writes |
| --- | --- | --- |
| **Captain** | Owner's only contact. Splits messages into parallel topics, dispatches, verifies, runs the merge queue, reports. | Per the autonomy ladder |
| **Reviewer** | Merge gate: correctness, tests, security, architecture, performance. Verdict per PR. | Nothing |
| **Experience** | Runs the app: UI/UX, accessibility, perceived performance, smoke test of changed flows. | Nothing |
| **Issues** | Triage, worker-ready briefs, stale issues, docs drift. | Nothing without a go |
| *Workers* | Short-lived agents Captain starts per task, each in its own worktree (`ob-work`). | Own branch + PR |

Workers are not bots: they cost nothing when idle and run in parallel up to the project's cap.

## Principles

1. This repo is the only source of truth for roles, skills and automations. It knows no project: Captain onboards each one itself (`ob-onboard`) and keeps a private profile in its own memory.
2. The owner talks to Captain only. Captain fans work out in parallel and brings back one report per topic.
3. Bots act on their own inside the **autonomy ladder** (`skills/ob-conventions`): *Act*, *Act + tell*, *Ask*. Only *Ask* items interrupt the owner, batched, one word to answer.
4. Never overwrite text or code; additive edits and marker blocks only.
5. Answers are short: 2–4 sentences, ≤5 bullets, `file:line` citations, fixed report shape, one-line verdict from specialists.
6. `opencode2` is the default agent for every bot and worker; Claude only while its tokens last. Behavior lives in skills, not the agent.

## Layout

| Path | Purpose |
| --- | --- |
| `roles/<role>/SOUL.md` | Canonical SOUL per bot |
| `skills/` | Agent-agnostic `ob-*` skills, installable from this repo |
| `templates/` | Optional `AGENTS.md` marker block for a project |
| `automations/` | Event and schedule automations, all waking Captain |
| `setup/` | Sync, bot proposals, agent switch, bootstrap checklist, validator |

## Skills

| Skill | Loaded by |
| --- | --- |
| `ob-conventions`, `ob-context` | Everyone |
| `ob-captain`, `ob-onboard` | Captain |
| `ob-work` | Workers |
| `ob-review`, `ob-quality` | Reviewer |
| `ob-experience` | Experience |
| `ob-issues`, `ob-docs` | Issues (and workers for docs edits) |

## Quick start

1. Create Captain manually in the Bots sidebar.
2. From Captain's chat, `bash setup/create-bots.sh` → run each printed command → **Create bot** for the three specialists.
3. Install skills:
   `npx skills add https://github.com/jdflament/orca-bots --skill ob-conventions --skill ob-context --skill ob-captain --skill ob-onboard --skill ob-work --skill ob-review --skill ob-quality --skill ob-experience --skill ob-issues --skill ob-docs --global`
4. Hand Captain a project: "take over owner/repo" (or several repos, or a folder). It discovers stack, commands, CI, merge rules and labels, then asks a few one-word policy questions.
5. Finish `setup/bootstrap.md`.

## Ownership

| Target | Rule |
| --- | --- |
| Bot `SOUL.md`, skills, automation recipes | Managed from this repo |
| Project profiles | Captain's private `memory/projects/`, never in this repo |
| Project `AGENTS.md` / `CLAUDE.md` | Only the marked block is managed; all other text untouched |
| Bot `bot.json`, `AGENTS.md`, `CLAUDE.md`, chats, `MEMORY.md` | Never written by sync |
| Application code | Worker worktree → PR → Reviewer verdict → merge under the owner's per-project authorization |

`sync.sh` uses a three-way hash guard: it updates a file only when the local copy still matches the last applied version. Diverged files are skipped, backed up as `*.orca-bots.conflict`, and reported.

## Token policy

- `opencode2` everywhere; `setup/set-agent.mjs` switches the fleet. Model tier per job: small for triage, rebases, CI re-runs, docs; strong for risky review and hard bugs.
- Idle specialists cost nothing: no Look around on specialists; Captain at most daily. Memory upkeep weekly or off.
- Events over schedules; every schedule has a `--precheck` so it skips when nothing changed.
- Handoffs carry a brief and paths, never pasted files. One combined reply per bot, even when it fanned out to subagents.
- Worker cap per project (default 3); stalled workers are stopped, not left burning.
- Install `brodesigns.skill-usage`; prune unused skills monthly.

## Coordinator

Captain alone carries this rule:

> If the orca-coordinator plugin is present, keep its board current; if absent, ignore it — it is optional.

## Maintenance

- **Weekly:** `sync.sh check`, skill usage, automation run history.
- **Monthly:** verify Orca templates and CLI flags after updates.
- **Never:** changes to this repo without a PR the owner approves.

## License

MIT. See [LICENSE](LICENSE).
