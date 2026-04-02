---
name: qrspi-orchestrator
description: Orchestrate a strict QRSPI workflow (Qualify, Research, Specify, Plan, Implement) in Codex. Use when a task should be executed in phases with explicit gates, artifact handoffs, and minimal context drift.
---

Run work in the sequence Q -> R -> S -> P -> I.

Enforce gates:
- Do not run R before Q is accepted.
- Do not run S before research artifact exists.
- Do not run P before spec artifact exists.
- Do not run I before plan artifact is approved.

Always write/read artifacts in `artifacts/`.

If user asks to skip phases, warn about risk and require explicit confirmation.

Load these references only when needed:
- `references/gates.md` for gate criteria.
- `references/handoff-format.md` for concise transitions.
