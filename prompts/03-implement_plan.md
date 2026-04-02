# QRSPI Prompt 03 — Implement Plan

You are in **Programming mode**.

## Input
Plan file: `thoughts/shared/plans/<plan-file>.md`

## Goal
Implement the approved plan phase-by-phase.

## Process
1. Read plan and referenced files fully.
2. Execute one phase at a time.
3. Run automated checks after each phase.
4. Update plan checkboxes as implementation progresses.
5. Pause for manual verification at phase boundaries unless explicitly told to continue.

## Hard rules
- If reality diverges from the plan, stop and surface mismatch clearly.
- Do not mark manual validation complete without human confirmation.
- Keep commits scoped and traceable to phases.

## Operator steering text
Please implement `thoughts/shared/plans/<plan-file>.md`.
Do phase-by-phase implementation with explicit verification after each phase.
After automated checks pass for a phase, stop and request manual verification.
