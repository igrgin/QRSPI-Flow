# QRSPI Flow Template for Codex

This repository is a **ready-to-copy template** for running a HumanLayer-style flow in Codex:

1. **Q**uestion framing
2. **R**esearch
3. **S**pec/plan
4. **P**rogramming (implementation)
5. **I**ntegration (commit, PR, verification, handoff)

It includes:
- reusable prompts (`prompts/`)
- a Codex skill (`skills/qrspi-flow/`)
- low-noise test/build wrappers and sample git hooks (`hooks/`)
- templates for research/plans/PR/handoffs (`templates/`)
- a complete operating guide (`docs/qrspi-flow-guide.md`)

## Quick Start

1. Copy these files into a project repo.
2. Read `docs/qrspi-flow-guide.md`.
3. Place your issue in `thoughts/shared/tickets/`.
4. Run phases in order with prompt files:
   - `prompts/01-research_codebase.md`
   - `prompts/02-create_plan.md`
   - `prompts/03-implement_plan.md`
   - `prompts/04-commit_and_pr.md`
5. (Recommended) Install sample hooks from `hooks/`.

## Why this works

This process emphasizes:
- **frequent intentional compaction**
- **human review at high-leverage artifacts** (research + plans)
- **context-efficient execution** (especially test output backpressure)

Inspired by HumanLayer's CodeLayer workflow and documentation:
- https://github.com/humanlayer/humanlayer
- https://www.humanlayer.dev/blog/advanced-context-engineering
- https://www.humanlayer.dev/docs/workshop
