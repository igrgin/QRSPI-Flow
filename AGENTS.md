# QRSPI Workflow Instructions

This repository uses a HumanLayer-style **Research → Plan → Implement** flow adapted for Codex.

## Global Rules

1. Do not start implementation before research and plan artifacts exist.
2. Keep artifacts in `thoughts/shared/`:
   - research: `thoughts/shared/research/`
   - plans: `thoughts/shared/plans/`
   - PR notes: `thoughts/shared/prs/`
3. Every plan must contain:
   - scope and out-of-scope
   - phased execution steps
   - automated checks and manual verification gates
4. Implement one phase at a time and pause for manual verification unless explicitly asked to batch phases.
5. Prefer concise, source-backed documentation with concrete file references.

## Command/Prompt Locations

- Primary prompts: `.agent/commands/`
- Specialist agents: `.agent/agents/`
- Templates: `.agent/templates/`

Use these files as reusable harness instructions for Codex sessions.
