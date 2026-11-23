#!/usr/bin/env bash
# Print the five specialist proposals. Run from Captain's chat after Captain exists.
# Nothing is created until the owner presses "Create bot".
# After the cards are accepted, run `node setup/set-agent.mjs` to put every bot on opencode2.
set -euo pipefail

cat <<'CMDS'
/Applications/Orca.app/Contents/Resources/bin/orca bot create --offer \
  --name Reviewer --template pr-review --json

/Applications/Orca.app/Contents/Resources/bin/orca bot create --offer \
  --name Craft \
  --purpose "Audit architecture, code quality, and performance of diffs and modules." \
  --watches "Diffs, boundaries, hot paths, dependency direction" \
  --does "Rank findings with file:line and name the smallest safe fix" \
  --reports "Here, on demand; a weekly scan only if the owner asks" --json

/Applications/Orca.app/Contents/Resources/bin/orca bot create --offer \
  --name Experience \
  --purpose "Audit visual consistency, UI/UX, accessibility, and perceived performance." \
  --watches "Rendered screens in Orca's browser and Design Mode selections" \
  --does "List concrete issues with selector, state, expected vs actual, and the smallest fix" \
  --reports "Here, on demand" --json

/Applications/Orca.app/Contents/Resources/bin/orca bot create --offer \
  --name Issues --template issue-triage --json

/Applications/Orca.app/Contents/Resources/bin/orca bot create --offer \
  --name Docs --template docs-upkeep --json
CMDS
