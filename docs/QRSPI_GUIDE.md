# HumanLayer-Style QRSPI Flow in Codex

This guide implements a **HumanLayer CodeLayer-inspired** operating model in Codex.

## What was researched

This template is based on public HumanLayer sources as of **April 2, 2026**:

- HumanLayer Workshop docs (research → plan → implement workflow and “magic words”).
- HumanLayer `humanlayer` repository `.claude/commands` structure and command naming.
- HumanLayer harness-engineering article (skills, hooks, progressive disclosure).

It is adapted for **Codex** (not a 1:1 clone of CodeLayer internals).

---

## 1) Core mental model

Use strict phased execution to reduce context drift and avoid premature coding:

1. **Q — Qualify**
   - Restate the issue, scope, constraints, and acceptance criteria.
   - Decide whether to proceed, split, or ask for clarification.
2. **R — Research**
   - Map relevant files, call-graphs, data flow, and invariants.
   - Explicitly avoid solution design in this phase.
3. **S — Specify**
   - Produce a concise technical spec from research.
   - Include risks, tradeoffs, and non-goals.
4. **P — Plan**
   - Produce an execution plan with phases, verification, and rollback strategy.
5. **I — Implement**
   - Execute the plan phase-by-phase.
   - Run checks after each phase and update plan progress.

---

## 2) Repository conventions in this template

- Put ticket text into `issue.md`.
- Write phase outputs into:
  - `artifacts/research.md`
  - `artifacts/spec.md`
  - `artifacts/plan.md`
  - `artifacts/implementation-log.md`
- Keep prompts in `prompts/qrspi/` and copy/paste them into Codex.
- Optional skills live in `skills/` and can be adapted to your Codex harness.

Create the artifact folder for each project run:

```bash
mkdir -p artifacts
```

---

## 3) End-to-end operating procedure

### Phase Q: Qualify

1. Load `issue.md`.
2. Run prompt: `prompts/qrspi/01_qualify.md`.
3. Ensure model output includes:
   - assumptions
   - missing information
   - crisp acceptance tests

### Phase R: Research

1. Run prompt: `prompts/qrspi/02_research.md`.
2. Output to `artifacts/research.md`.
3. Enforce “no fix proposal” rule.

### Phase S: Specify

1. Run prompt: `prompts/qrspi/03_specify.md`.
2. Output to `artifacts/spec.md`.
3. Confirm explicit non-goals and risk register.

### Phase P: Plan

1. Run prompt: `prompts/qrspi/04_plan.md`.
2. Output to `artifacts/plan.md`.
3. Require manual checkpoints and test commands per phase.

### Phase I: Implement

1. Run prompt: `prompts/qrspi/05_implement.md`.
2. Execute only one phase at a time unless task is trivial.
3. After each phase:
   - run checks
   - update `artifacts/plan.md` with status and deltas
   - append notable decisions to `artifacts/implementation-log.md`

---

## 4) Prompts and “magic words”

HumanLayer’s workshop emphasizes phase-separating language, especially:

- Research prompt: _“Do not make an implementation plan or explain how to fix.”_
- Plan prompt: _“Work back and forth with me, sharing your open questions and phases outline before writing the plan.”_

Those ideas are embedded in this repo’s prompt files under `prompts/qrspi/`.

---

## 5) Hooks and guardrails

This template includes lightweight guardrails in `hooks/`:

- `hooks/pre-commit-check.sh`:
  - verifies `artifacts/plan.md` exists
  - checks tests/lint were run (from implementation log)
- `hooks/phase-gate.sh`:
  - blocks implementation when research/spec/plan artifacts are missing

You can wire these into your own tooling (git hooks, task runner, CI, or Codex wrapper).

Install as git hooks locally:

```bash
mkdir -p .git/hooks
ln -sf ../../hooks/pre-commit-check.sh .git/hooks/pre-commit
chmod +x hooks/pre-commit-check.sh hooks/phase-gate.sh
```

---

## 6) Skill strategy (progressive disclosure)

HumanLayer’s harness guidance stresses context efficiency:

- keep global instructions small
- activate detailed instructions only when needed
- avoid giant always-on prompts

This repo mirrors that pattern with separate skills:

- `skills/qrspi-orchestrator` — controls phase transitions
- `skills/qrspi-research` — codebase mapping behavior
- `skills/qrspi-spec` — spec writing behavior
- `skills/qrspi-plan` — phased execution planning
- `skills/qrspi-implement` — controlled implementation + verification

---

## 7) Recommended collaboration loop

For harder tickets, run this loop:

1. Human confirms Q output (scope and acceptance criteria).
2. Human reviews R output for coverage gaps.
3. Human reviews S output for architecture correctness.
4. Human approves P output before any code is changed.
5. I runs one phase, reports diffs/checks, waits for go-ahead.

---

## 8) Practical usage tips

- Keep each artifact concise but concrete.
- Prefer line-level citations in research outputs.
- If implementation diverges from plan, update `artifacts/plan.md` immediately.
- If a phase gets noisy, start a fresh Codex session with only:
  - issue
  - previous phase artifacts
  - current phase prompt

---

## 9) Source links

- HumanLayer workshop documentation:
  - https://www.humanlayer.dev/docs/workshop
- HumanLayer harness engineering article:
  - https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents
- HumanLayer commands directory:
  - https://github.com/humanlayer/humanlayer/tree/main/.claude/commands

