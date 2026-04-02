# AGENTS.md

Use this repository's QRSPI workflow by default for non-trivial coding tasks.

## Default execution model

For feature work, bug fixes, or refactors larger than a tiny edit, run the phases in order:
1. **Question framing**: restate the goal, constraints, and acceptance criteria.
2. **Research**: produce a research doc that maps current behavior with concrete file:line references.
3. **Spec/Plan**: produce a phased implementation plan with explicit automated + manual verification.
4. **Programming**: implement one phase at a time, run checks, and update plan progress.
5. **Integration**: prepare commit + PR summary and handoff notes.

## Workflow constraints

- Do not skip research for medium/high complexity tasks.
- Do not implement before a reviewed plan exists (unless user explicitly asks for a one-shot).
- Keep context compact by summarizing verbose command outputs.
- Prefer deterministic scripts/hooks from `hooks/` and `scripts/` over retyping logic.
- Always include specific file references in reports and summaries.

## Artifacts and paths

Store planning artifacts in the repository (or mirrored external notes repo) using:
- `thoughts/shared/tickets/`
- `thoughts/shared/research/`
- `thoughts/shared/plans/`
- `thoughts/shared/prs/`
- `thoughts/shared/handoffs/`

## Prompt library

Use prompt files in `prompts/` as base prompts for each phase.

## Hooks and backpressure

When running lint/test/build commands, prefer wrappers in `hooks/run_with_backpressure.sh` to keep success output minimal and preserve context for failures.
