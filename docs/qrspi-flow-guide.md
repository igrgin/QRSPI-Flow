# Full Guide: Running HumanLayer-Style QRSPI in Codex

## What this template is copying

This template mirrors the operating ideas from HumanLayer's public workflow:
- research → plan → implement progression
- explicit “magic words” to constrain each phase
- human checkpoints before high-leverage transitions
- context-efficient command output patterns

## QRSPI definition used here

- **Q — Question framing**: lock scope, constraints, acceptance criteria.
- **R — Research**: map current system behavior and relevant files.
- **S — Spec/Plan**: write phased, verifiable implementation plan.
- **P — Programming**: execute phases, verify, update plan state.
- **I — Integration**: commit, PR description, handoff continuity.

## Directory layout

- `prompts/`: phase prompts to paste/use directly
- `skills/qrspi-flow/`: reusable skill metadata and execution guidance
- `hooks/`: context-backpressure utilities and sample git hooks
- `scripts/`: helper automation (hook install)
- `templates/`: reusable docs for research/plan/pr/handoff
- `thoughts/shared/*`: canonical artifact locations

## End-to-end runbook

### 0) Prepare the issue

Create: `thoughts/shared/tickets/YYYY-MM-DD-<ticket>.md`
Include problem statement, constraints, acceptance criteria, and links.

### 1) Research phase

Use `prompts/01-research_codebase.md`.

**Key behavior to enforce:**
- document only current state
- no solutioning yet
- include concrete `path:line` references

Deliverable: research markdown in `thoughts/shared/research/`.

### 2) Plan phase

Use `prompts/02-create_plan.md`.

**Key behavior to enforce:**
- ask clarifying questions first
- share phase outline before full plan
- include scope boundaries and verification per phase

Deliverable: plan markdown in `thoughts/shared/plans/`.

### 3) Programming phase

Use `prompts/03-implement_plan.md`.

**Key behavior to enforce:**
- implement one phase at a time
- run automated checks after each phase
- pause for manual verification at phase boundaries
- update plan checkboxes as work completes

### 4) Integration phase

Use `prompts/04-commit_and_pr.md` and `templates/pr-description-template.md`.

Output:
- focused commit(s)
- reviewer-friendly PR description
- optional handoff doc for session continuity

## Hooks and context backpressure

Install:
```bash
./scripts/install-hooks.sh
```

The provided hook runner prints a single line for successful commands and only dumps full output on failure. This helps preserve context quality for coding agents.

## Team operating guidance

- Require reviewed research before plan approval.
- Require approved plan before implementation.
- Keep plans short and verifiable.
- Optimize for reducing rework, not maximizing raw code output.
- Treat research and plans as first-class review artifacts.

## Optional enhancements for future projects

- Add project-specific sub-prompts in `prompts/project/`.
- Add a `scripts/new-task.sh` scaffolder for ticket/research/plan files.
- Add CI checks to enforce plan/reference links in PR body.
- Add domain-specific sub-skills under `skills/` for backend/frontend/data.
