---
name: qrspi-flow
description: Run a HumanLayer-style QRSPI workflow for complex coding tasks in Codex: Question framing, Research, Spec/Plan, Programming, and Integration. Use when tasks are non-trivial, in brownfield repos, or require high confidence, low rework, and strong human checkpoints.
---

# QRSPI Flow Skill

## Use this operating sequence

1. Clarify objective, constraints, and acceptance criteria.
2. Run research with `prompts/01-research_codebase.md`.
3. Draft plan with `prompts/02-create_plan.md` and get human confirmation.
4. Implement with `prompts/03-implement_plan.md` one phase at a time.
5. Finalize with `prompts/04-commit_and_pr.md`.

## Artifact conventions

Store artifacts in:
- `thoughts/shared/tickets/`
- `thoughts/shared/research/`
- `thoughts/shared/plans/`
- `thoughts/shared/prs/`
- `thoughts/shared/handoffs/`

Use date-prefixed filenames: `YYYY-MM-DD-<ticket>-<slug>.md`.

## Quality gates

- No implementation before reviewed research + approved plan.
- Include concrete `path:line` references in research/plan.
- Enforce phase-level automated checks and manual verification pauses.
- Keep output compact; use backpressure wrappers from `hooks/`.

## References

Read:
- `references/humanlayer-research-notes.md`
- `docs/qrspi-flow-guide.md`
