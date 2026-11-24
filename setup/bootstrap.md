# Bootstrap checklist

1. **Cleanup** — old bot folders are removed; delete any old Captain manually in Orca's Bots sidebar.
2. **Create bots** — create Captain manually in Orca, then from its chat run `bash setup/create-bots.sh` and press **Create bot** on the three cards (Reviewer, Experience, Issues).
3. **Agent** — point every bot at `opencode2`: run `node setup/set-agent.mjs` (Claude is a fallback only while tokens are available). If Orca does not reflect it, set each bot under **Settings → Agent and model**.
4. **Permissions** — Captain: allow `gh`, `git` and `orca` so it can act on the autonomy ladder; specialists: **Ask for approval** (they are read-only).
5. **Background cost** — Look around: off on all specialists, Captain at most daily. Memory upkeep: weekly or off.
6. **Connectors** — GitHub on Captain, Reviewer and Issues; install the Orca app on the repos they cover. No Slack, Linear, or Google yet.
7. **Skills** — install from this repo:
   `npx skills add https://github.com/jdflament/orca-bots --skill ob-conventions --skill ob-context --skill ob-captain --skill ob-onboard --skill ob-work --skill ob-review --skill ob-quality --skill ob-experience --skill ob-issues --skill ob-docs --global`
8. **Automations** — run the disabled commands in `automations/README.md`, inspect with `list/show`, test with `run`, then `edit --enabled`.
9. **Telemetry** — install community plugin `brodesigns.skill-usage` (community catalog: `https://github.com/stablyai/orca-community-plugins.git`).
10. **Project** — tell Captain "take over <owner/repo> [and <owner/repo2>…]". It runs `ob-onboard` and asks you a few one-word policy questions. Nothing project-specific goes into this repo.
11. **Install SOULs** — `bash setup/sync.sh adopt && bash setup/sync.sh apply`, then `bash setup/sync.sh check` (must print only `ok` lines).
12. **Validate live** — send Captain one message with two topics; confirm both run in parallel, one PR gets a Reviewer verdict, and nothing on the **Ask** tier happens without a gate.

Do not push this repo or enable an automation without an explicit go.

Retiring bots from v1 (Craft, Docs): their jobs moved to Reviewer (`ob-quality`) and Issues (`ob-docs`). Delete them in the Bots sidebar when ready.
