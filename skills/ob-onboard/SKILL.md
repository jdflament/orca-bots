---
name: ob-onboard
description: >-
  Take over a project the owner hands you (one repo, several repos, or a local
  folder): discover its stack, commands, CI, merge rules, labels and risky
  areas yourself, ask the owner only for policy, and keep a private profile.
  Load when the owner names a new project, or a known profile looks wrong.
---

# Onboard a project

Nothing project-specific belongs in `jdflament/orca-bots`. The profile is Captain's private cache: `memory/projects/<project>.md` in Captain's bot folder, plus one `MEMORY.md` line pointing to it. Live repo state always wins over the profile.

## 1. Discover — read, don't ask

For each repo or folder the owner named (stop as soon as each answer is found):

- **Identity:** `gh repo view --json nameWithOwner,description,defaultBranchRef,primaryLanguage,visibility`; README first screen.
- **Rules:** `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `ARCHITECTURE.md` — headings and rules only.
- **Commands:** manifest scripts (`package.json`, `Makefile`, `pyproject.toml`, `Cargo.toml`, `justfile`…). Pick install, fast check, full check, run/preview.
- **CI:** `.github/workflows/*` job names; required checks and merge queue via `gh api repos/<r>/rules/branches/<default>` and `.../branches/<default>/protection`; allowed merge methods via `gh api repos/<r>`.
- **Backlog:** `gh label list` → which labels mean priority, blocked, needs-design, human-only.
- **Risky areas:** paths for auth, payments, secrets, migrations, infra, CI config, AI prompts/models, privacy/data egress; `SECURITY.md`.
- **UI:** does it have one? How to run it locally or where previews deploy (Experience needs this).
- **Multi-repo:** how repos depend on each other (packages, API contracts, deploy order).

Validate the fast-check command once in a throwaway worktree if it is cheap; otherwise mark it "unverified".

## 2. Ask — policy only, one message

Propose a default for each; the owner answers in one word each:

1. Standing merge authorization (CI green + Reviewer `merge`)? default: yes if a merge queue or required checks exist, else no.
2. Worker cap? default 3.
3. May bots apply triage labels? default no.
4. Extra **Ask** areas beyond what you found? default: the risky areas listed.
5. Priority order of labels, if not obvious.

Until answered, treat merges as **Ask** and keep working on everything else.

## 3. Write the profile

```md
# <project> — onboarded <date>, verified <date>
Repos: <owner/repo> (role, default branch, worktree prefix) …
Commands: install / fast check / full check / run or preview URL
CI: required checks; merge queue yes/no; merge command
Policy (owner, <date>): merge auth; worker cap; labels; extra Ask areas
Priorities: <labels high→low>; skip: <labels>
Risky paths: …
Rules: <file:line of local rules that matter>
```

≤25 lines. No secrets, tokens or private URLs with credentials.

## 4. Keep it true

- A command, check name or merge rule fails → re-discover that one fact, update the profile, note `verified <date>`.
- Owner changes a policy → update the Policy line with the date.
- Pass workers and bots only the lines they need, inside the brief.
