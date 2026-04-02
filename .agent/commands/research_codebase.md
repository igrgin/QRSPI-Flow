# /research_codebase

Document the codebase **as-is** for a given issue/task.

## Goal
Produce a research artifact that explains current behavior, architecture, and relevant files without proposing changes unless asked.

## Steps
1. Read the issue/task file fully.
2. Break question into sub-questions.
3. Delegate focused discovery to specialist agents in `.agent/agents/`.
4. Synthesize findings with file references.
5. Save output to `thoughts/shared/research/YYYY-MM-DD-<slug>.md` using `.agent/templates/research_template.md`.

## Constraints
- No prescriptions unless requested.
- Prefer concrete paths and line references.
- Include open questions and unknowns clearly.
