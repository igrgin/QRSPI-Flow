# /implement_plan

Execute an approved plan from `thoughts/shared/plans/`.

## Goal
Implement phase-by-phase with verification and status updates.

## Steps
1. Read the plan fully.
2. Start with first incomplete phase.
3. Implement requested file changes.
4. Run automated checks listed in the plan.
5. Update plan checkboxes for completed items.
6. Pause for manual verification unless instructed to continue.

## Constraints
- If plan and code reality differ, stop and report mismatch before proceeding.
- Keep changes scoped to the active phase.
