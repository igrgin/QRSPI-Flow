# /create_plan

Create an implementation plan from approved research.

## Goal
Produce a phase-based, testable plan with explicit scope and verification.

## Inputs
- Issue/task description
- Research artifact(s) from `thoughts/shared/research/`

## Steps
1. Read research artifacts fully.
2. Ask clarifying questions before finalizing.
3. Draft phased plan with objective, non-goals, file-level changes, risks.
4. Add automated and manual verification checklists.
5. Save to `thoughts/shared/plans/YYYY-MM-DD-<slug>.md` via `.agent/templates/plan_template.md`.

## Constraints
- Do not skip unresolved questions.
- Keep phases independently verifiable.
