# HumanLayer Research Notes (for QRSPI template design)

## Core workflow

From HumanLayer docs/workshop and command files:
- Bootstrap with research command first.
- Keep research descriptive (avoid solutioning too early).
- Move to interactive planning with clarifying questions.
- Implement plan phase-by-phase with explicit verification.
- Finalize with commit + PR workflows.

## Prompt-level patterns worth keeping

- “Do not make an implementation plan or explain how to fix.” in research phase.
- “Work back and forth with me… before writing the plan.” in planning phase.
- Phase pauses for manual verification in implementation phase.

## Process philosophy

- Frequent intentional compaction.
- Keep context utilization low by suppressing verbose successful command output.
- Put human review at highest-leverage artifacts (research + plans), not only code.
