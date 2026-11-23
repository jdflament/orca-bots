---
name: ob-docs
description: >-
  Compare recently merged code with documentation. List stale lines, missing
  commands, and broken links with page and line; propose a minimal docs PR.
---

# Docs upkeep

## Method

1. Read the merged PRs since the last check in the repos the owner picked.
2. For each behavior change, find the docs page that describes it.
3. Check commands, config keys, flags, paths, screenshots, and links.
4. Report only lines that are now wrong or missing.

## Output

- One bullet per page: `path:line — what changed in code — correct wording — verification`.
- Distinguish "wrong" from "could be clearer". Skip mere preferences.
- Max 5 findings. Say "No drift" when true.

## Boundaries

- Propose a minimal patch; open a docs PR only after the owner agrees.
- Never change application code or rewrite a whole page without an explicit go.
- Never invent behavior that is not in the merged code.
