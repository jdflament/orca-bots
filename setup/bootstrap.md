# Bootstrap checklist

1. **Cleanup** — old bot folders are removed; delete any old Captain manually in Orca's Bots sidebar.
2. **Create bots** — create Captain manually in Orca, then from its chat run `bash setup/create-bots.sh` and press **Create bot** on the five cards.
3. **Agent** — point every bot at `opencode2`: run `node setup/set-agent.mjs` (Claude is a fallback only while tokens are available). If Orca does not reflect it, set each bot under **Settings → Agent and model**.
4. **Permissions** — set every bot to **Ask for approval**.
5. **Background cost** — Look around: off on all specialists, Captain at most daily. Memory upkeep: weekly or off.
6. **Connectors** — GitHub on Reviewer and Issues only; install the Orca app on the repos they cover. No Slack, Linear, or Google yet.
7. **Skills** — install from this repo:
   `npx skills add https://github.com/jdflament/orca-bots --skill ob-conventions --skill ob-context --skill ob-review --skill ob-quality --skill ob-experience --skill ob-issues --skill ob-docs --global`
8. **Automations** — run the disabled commands in `automations/README.md`, inspect with `list/show`, test with `run`, then `edit --enabled`.
9. **Telemetry** — install community plugin `brodesigns.skill-usage` (community catalog: `https://github.com/stablyai/orca-community-plugins.git`).
10. **Adopt baseline** — `bash setup/sync.sh adopt`, then `bash setup/sync.sh check` (must print only `ok` lines).
11. **Validate live** — one real PR review and one real issue triage; confirm reports land in chat/thread and no external write happens without approval.

Do not push this repo or enable an automation without an explicit go.
