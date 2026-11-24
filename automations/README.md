# Automations

Create disabled, inspect, run once, then enable. All commands talk to the running Orca runtime. Captain creates these per project after `ob-onboard`, with the owner's go. Every automation wakes **Captain**; Captain hands off to specialists, so the owner keeps one chat.

```bash
ORCA=/Applications/Orca.app/Contents/Resources/bin/orca
REPO=owner/repo   # one set per repo Captain onboarded; scope with in=owner/repo
```

## 1. Events — the default

```bash
$ORCA automations create --name "Captain: PR opened or updated" --bot Captain \
  --on "github.pull_request_opened in=$REPO" --runs-in chat --results-to none \
  --prompt "Load ob-captain. A PR changed. Hand it to @Reviewer (and @Experience if UI changed). Act per the autonomy ladder. Report only if something needs the owner." \
  --disabled --json

$ORCA automations create --name "Captain: new issue" --bot Captain \
  --on "github.issue_opened in=$REPO" --runs-in chat --results-to none \
  --prompt "Load ob-captain. A new issue arrived. Hand it to @Issues for triage and a brief. Dispatch a worker only if the brief is low-risk and the issue has a priority label." \
  --disabled --json

$ORCA automations create --name "Captain: review requested" --bot Captain \
  --on "github.review_requested in=$REPO" --runs-in chat --results-to chat \
  --prompt "Load ob-captain. The owner's review was requested. Get @Reviewer's verdict and summarize it for the owner." \
  --disabled --json
```

Check `orca automations create --help` for the exact event names your Orca build supports.

## 2. Sweep — catches what events miss

Runs only when there is something to move; the precheck exits non-zero (skip, no tokens) otherwise.

```bash
$ORCA automations create --name "Captain: queue sweep" --bot Captain \
  --trigger "0 */2 * * *" --runs-in chat --results-to none \
  --precheck "test \"\$(gh pr list --repo $REPO --json number --jq length)\" -gt 0" \
  --prompt "Load ob-captain. Sweep: red CI, conflicts, green PRs to merge, stalled workers. Act; stay silent if nothing changed." \
  --disabled --json
```

## 3. Daily report

```bash
$ORCA automations create --name "Captain: morning report" --bot Captain \
  --trigger weekdays --time 08:00 --runs-in chat --results-to chat \
  --prompt "Load ob-captain. Report per project: merged, in flight, blocked, open gates. ≤5 bullets each." \
  --disabled --json
```

## 4. Monthly hygiene (optional)

```bash
$ORCA automations create --name "Issues: monthly hygiene" --bot Issues \
  --trigger "0 9 1 * *" --runs-in chat --results-to none \
  --prompt "Load ob-issues and ob-docs. Stale/unowned issues and docs drift since last month. Report to Captain, ≤5 items. Change nothing on GitHub." \
  --disabled --json
```

## Manage

```bash
$ORCA automations list --json
$ORCA automations show <id> --json
$ORCA automations run <id> --json      # manual test, bypasses precheck
$ORCA automations edit <id> --enabled --json
$ORCA automations runs --id <id> --json
$ORCA automations remove <id> --json
```

Never enable before a manual `run` produces a report you approve. Prefer events over schedules; every schedule gets a `--precheck`.
