#!/usr/bin/env bash
# Print the three specialist proposals. Run from Captain's chat after Captain exists.
# Nothing is created until the owner presses "Create bot".
# After the cards are accepted, run `node setup/set-agent.mjs` to put every bot on opencode2,
# then `bash setup/sync.sh adopt && bash setup/sync.sh apply` to install the canonical SOULs.
set -euo pipefail

cat <<'CMDS'
/Applications/Orca.app/Contents/Resources/bin/orca bot create --offer \
  --name Reviewer \
  --purpose "Merge gate: review PRs for correctness, tests, security, architecture and performance." \
  --watches "PRs Captain hands off and PRs where the owner's review is requested" \
  --does "Rank findings with file:line, smallest fix, and a merge / fix first / needs owner verdict" \
  --reports "Back to Captain" --json

/Applications/Orca.app/Contents/Resources/bin/orca bot create --offer \
  --name Experience \
  --purpose "Check what users see: UI/UX, accessibility, perceived performance, and a smoke test of changed flows." \
  --watches "User-facing PRs Captain flags and screens the owner names, in Orca's browser" \
  --does "List issues with selector, state, expected vs actual, smallest fix, and a ship / fix first verdict" \
  --reports "Back to Captain" --json

/Applications/Orca.app/Contents/Resources/bin/orca bot create --offer \
  --name Issues \
  --purpose "Keep the backlog workable: triage issues, write worker-ready briefs, flag docs drift." \
  --watches "New issues in the project's repos; stale issues and docs monthly" \
  --does "Propose labels, duplicates, missing details; write goal, acceptance criteria, files, test, risk" \
  --reports "Back to Captain" --json
CMDS
