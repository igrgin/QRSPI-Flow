# /validate_plan

Review a plan for completeness before implementation.

## Validation checklist
- Problem statement and end state are clear.
- Scope and non-scope are explicit.
- Phases are ordered and independently testable.
- Each phase has automated checks.
- Manual verification gates are present.
- Risks and rollback considerations are documented.

Return:
1. Ready / Not Ready verdict
2. Missing items
3. Exact edits required
