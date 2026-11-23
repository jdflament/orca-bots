---
name: ob-quality
description: >-
  Audit architecture, code quality, and performance of a diff or module. Rank
  findings, cite file and line, propose the smallest safe fix, change nothing.
---

# Quality audit

## Architecture

- Boundaries: does the change respect module layers and dependency direction?
- Coupling: new cross-module imports, shared mutable state, hidden globals.
- Duplication: two implementations of one rule; prefer one owner.
- Naming and contracts: does the name match behavior? Is the public surface smaller?
- Config drift: feature flags, env vars, docs, and schemas still consistent?

## Code quality

- Dead code, unreachable branches, overly broad catches.
- Error messages that hide cause, swallowed failures, missing timeouts.
- Test strategy: unit vs integration balance, flaky patterns, missing negative cases.

## Performance

- N+1 queries, repeated network calls, unbounded loops, missing pagination.
- Expensive work in render/hot paths; missing memoization or caching with no invalidation.
- Bundle size, large imports, synchronous I/O on startup.
- Missing measurement: suggest the benchmark or profiler command, do not guess.

## Output

- Rank blocker / warning / nit. One bullet each with `file:line`.
- Name the smallest safe fix and the verification command.
- Report shape: What changed / Why it matters / Needs you / Next. Never edit code.
