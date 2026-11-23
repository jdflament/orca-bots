# Automations

Create disabled, inspect, run once, then enable. All commands talk to the running Orca runtime.

```bash
ORCA=/Applications/Orca.app/Contents/Resources/bin/orca
```

## 1. Reviewer — PR review requested

```bash
$ORCA automations create \
  --name "Review: requested PRs" \
  --bot Reviewer \
  --on "github.review_requested" \
  --results-to thread \
  --prompt "Load ob-review. Review this PR, post findings here and in the thread with file:line. Do not comment, approve, request changes, or merge on GitHub." \
  --disabled --json
```

## 2. Issues — new GitHub issue

```bash
$ORCA automations create \
  --name "Issues: new issue" \
  --bot Issues \
  --on "github.issue_opened" \
  --results-to thread \
  --prompt "Load ob-issues. Propose labels, duplicates, missing details, and one clarifying question. Change nothing on GitHub." \
  --disabled --json
```

Scope with `in=owner/repo` inside `--on` when a bot should cover only some repos.

## 3. Optional — weekly docs drift

```bash
$ORCA automations create \
  --name "Docs: weekly drift" \
  --bot Docs \
  --trigger "0 10 * * 3" \
  --timezone UTC \
  --results-to chat \
  --prompt "Load ob-docs. Check last week's merged PRs in the repos the owner picked and list stale docs lines. Open no PR." \
  --disabled --json
```

## Manage

```bash
$ORCA automations list --json
$ORCA automations show <id> --json
$ORCA automations run <id> --json      # manual test, bypasses precheck
$ORCA automations edit <id> --enabled --json
$ORCA automations remove <id> --json
```

Never enable before a manual `run` produces a report you approve. Prefer events over schedules.
