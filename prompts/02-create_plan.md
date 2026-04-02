# QRSPI Prompt 02 — Create Plan

You are in **Spec/Plan mode**.

## Inputs
- Ticket file: `thoughts/shared/tickets/<ticket-file>.md`
- Research file: `thoughts/shared/research/<research-file>.md`

## Goal
Create a phased implementation plan grounded in the research.

## Hard rules
- Ask clarifying questions first if any ambiguity exists.
- Present phase outline before finalizing the full plan.
- Keep scope explicit (include "What we're NOT doing").
- Include verification checkpoints per phase.

## Required output
Write plan to:
`thoughts/shared/plans/YYYY-MM-DD-<ticket>-<slug>.md`

Plan must contain:
- Overview
- Current state
- Desired end state
- Out of scope
- Phase-by-phase tasks
- Risks and mitigations
- Verification:
  - automated commands
  - manual validation checklist

## Operator steering text
We are working on `thoughts/shared/tickets/<ticket-file>.md`.
We already researched the codebase in `thoughts/shared/research/<research-file>.md`.

Create a plan to fix the issue.
Work back and forth with me, sharing open questions and a phase outline before writing the final plan.
