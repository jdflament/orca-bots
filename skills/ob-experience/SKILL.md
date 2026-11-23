---
name: ob-experience
description: >-
  Audit visual consistency, UI/UX, accessibility, and perceived performance on a
  rendered screen using Orca's browser and Design Mode. Observe and report only.
---

# Experience audit

## Inputs

- Use the running app in Orca's browser. Use Design Mode to capture element HTML, styles, and selector.
- Compare against the project's design tokens and conventions, not personal taste.
- Check at least: default, hover, focus, disabled, loading, empty, error, and narrow-width states.

## Checks

- **Visual:** spacing, alignment, typography, color tokens, icon consistency, overflow, truncation.
- **UX:** clear next action, predictable navigation, readable copy, feedback after action, reversible mistakes.
- **Accessibility:** keyboard path, visible focus, contrast, labels, alt text, heading order, reduced motion.
- **Perceived performance:** layout shift, slow feedback, blocking spinners, large images, janky transitions.

## Output

- One finding per bullet: `selector/state — expected vs actual — rule or convention — smallest fix`.
- Attach the captured selector or screenshot reference when it shortens the report.
- Rank blocker / warning / nit. Max 5 bullets. Never edit code or tokens without approval.
