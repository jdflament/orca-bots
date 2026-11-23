#!/usr/bin/env node
// Point every Orca bot at opencode2 (the default), using Orca's local runtime.
// Claude is a fallback only while Claude tokens are available.
//
// Usage: node setup/set-agent.mjs [agent]     (default: opencode2)
// Env:   ORCA_CLI, ORCA_APP
//
// Orca stores a bot's live agent in its runtime, not in bot.json, and the CLI
// has no verb for it. This calls the same `bots.update` method the settings
// screen uses. If the app changes that method, set each bot by hand instead.
import { execFileSync } from 'node:child_process'
import { existsSync } from 'node:fs'
import { createRequire } from 'node:module'

const ORCA = process.env.ORCA_CLI || '/Applications/Orca.app/Contents/Resources/bin/orca'
const APP = process.env.ORCA_APP || '/Applications/Orca.app'
const OUT = `${APP}/Contents/Resources/app.asar.unpacked/out`
const AGENT = process.argv[2] || 'opencode2'

if (!existsSync(`${OUT}/cli/runtime/client.js`)) {
  console.error(`Orca's runtime client was not found under ${OUT}. Set ORCA_APP.`)
  process.exit(1)
}

const require = createRequire(import.meta.url)
const { RuntimeClient } = require(`${OUT}/cli/runtime/client.js`)
const listed = JSON.parse(execFileSync(ORCA, ['bot', 'list', '--json'], { encoding: 'utf8' }))
const client = new RuntimeClient(undefined, undefined, null, null)

let changed = 0
for (const bot of listed.result.bots) {
  if (bot.agent === AGENT) {
    console.log(`ok       ${bot.name}`)
    continue
  }
  try {
    const res = await client.call('bots.update', { botId: bot.id, updates: { agent: AGENT } })
    const next = res?.result?.bot?.agent
    console.log(`${next === AGENT ? 'updated' : 'failed '} ${bot.name}`)
    if (next === AGENT) changed += 1
  } catch (err) {
    console.log(`failed   ${bot.name}: ${err?.message ?? err}`)
  }
}

console.log(`\n${changed} bot(s) switched to ${AGENT}.`)
console.log('If Orca does not reflect it, set each bot under Settings -> Agent and model.')
