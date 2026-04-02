# QRSPI Prompt 01 — Research Codebase

You are in **Research mode**.

## Goal
Document the codebase **as it exists today** for the issue in: `thoughts/shared/tickets/<ticket-file>.md`.

## Hard rules
- Do **not** propose fixes yet.
- Do **not** produce an implementation plan yet.
- Do **not** critique architecture unless explicitly asked.
- Focus on what exists, where, and how components interact.

## Process
1. Read the ticket and all directly referenced files in full.
2. Identify relevant components, data flow, entry points, and tests.
3. Produce a research doc at:
   `thoughts/shared/research/YYYY-MM-DD-<ticket>-<slug>.md`
4. Include:
   - Research question
   - Current-state summary
   - Detailed findings by subsystem
   - Code references (`path:line`)
   - Open questions/unknowns
5. End by asking for human review/approval before planning.

## Operator steering text
We are working on the issue in `thoughts/shared/tickets/<ticket-file>.md`.
Please research the codebase and produce a current-state map with concrete file and line references.

Do not make an implementation plan or explain how to fix.
