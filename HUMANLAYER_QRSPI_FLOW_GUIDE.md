# QRSPI for Codex: Reworking HumanLayer’s `.claude` Structure into a Codex-Native Flow

## What changed in this version

This revision is a **Codex implementation guide**, not a Claude-only summary.
It takes the HumanLayer `.claude` shape (commands, agents, settings, thoughts hooks) and translates it into a practical Codex harness you can use immediately.

> HumanLayer source material describes the core loop as **Research → Plan → Implement**. In this guide we implement your requested **QRSPI** as:
> **Question → Research → Spec → Plan → Implement**.

---

## 1) Mapping: `.claude` → Codex equivalents

HumanLayer’s Claude setup uses:

- `.claude/commands/*.md` (slash-command prompt specs)
- `.claude/agents/*.md` (specialized sub-agents)
- `.claude/settings.json` (tool permissions / defaults)
- `thoughts/` + git hooks (artifact hygiene and sync)

For Codex, use this mapping:

| HumanLayer / Claude | Codex Equivalent | Purpose |
|---|---|---|
| `.claude/commands/*.md` | `.codex/prompts/*.md` | Stage prompts (`question`, `research`, `spec`, `plan`, `implement`) |
| `.claude/agents/*.md` | `.codex/skills/*/SKILL.md` | Reusable specialist skills |
| `.claude/settings.json` | `AGENTS.md` + wrapper scripts | Execution policy, workflow constraints, quality gates |
| `/cl:research_codebase` style invocation | `./scripts/qrspi research <issue-file>` | Deterministic CLI entry point |
| `thoughts/` docs | `thoughts/` docs (same) | Durable context artifacts |
| pre/post commit hook logic | `.githooks/*` + `core.hooksPath` | Prevent accidental commits + auto-sync |

---

## 2) Codex file structure to create

Use this structure in your repo:

```text
.
├── AGENTS.md
├── thoughts/
│   ├── shared/
│   │   ├── research/
│   │   ├── specs/
│   │   ├── plans/
│   │   └── prs/
│   └── <your_user>/
├── .codex/
│   ├── prompts/
│   │   ├── question.md
│   │   ├── research.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── implement.md
│   │   ├── commit.md
│   │   └── describe_pr.md
│   └── skills/
│       ├── codebase-locator/SKILL.md
│       ├── codebase-analyzer/SKILL.md
│       ├── codebase-pattern-finder/SKILL.md
│       ├── thoughts-locator/SKILL.md
│       ├── thoughts-analyzer/SKILL.md
│       └── web-researcher/SKILL.md
├── scripts/
│   ├── qrspi
│   ├── thoughts-sync
│   └── verify-phase
└── .githooks/
    ├── pre-commit
    └── post-commit
```

Why this works:

- `.codex/prompts/` keeps your stage behavior explicit and versioned.
- `.codex/skills/` gives you reusable “specialist behavior” analogous to `.claude/agents`.
- `scripts/qrspi` gives team-wide deterministic entry points (instead of ad-hoc freeform prompting).
- `thoughts/` remains the artifact backbone.

---

## 3) AGENTS.md (Codex control plane)

In Codex, `AGENTS.md` is the best place to enforce workflow behavior.
Use it to force QRSPI stage discipline.

Recommended `AGENTS.md` policy blocks:

1. **Stage discipline**
   - In `research`: document current state only (no implementation recommendations).
   - In `spec/plan`: propose phased design and checks.
   - In `implement`: execute only approved plan file.

2. **Artifact requirements**
   - Research must write `thoughts/shared/research/YYYY-MM-DD-*.md`.
   - Spec must write `thoughts/shared/specs/YYYY-MM-DD-*.md`.
   - Plan must write `thoughts/shared/plans/YYYY-MM-DD-*.md`.

3. **Verification requirements**
   - Every implementation phase must run automated checks.
   - Manual checks must be explicitly listed and confirmed.

4. **Path/reference requirements**
   - Use exact file paths and line references for claims.
   - Never commit `thoughts/` to product code history.

---

## 4) Prompt pack for Codex (`.codex/prompts/*.md`)

The key rework is converting Claude command prompts into Codex stage prompts.
Below are concise, production-ready prompt intents.

## `question.md`

Goal: normalize issue intake.

- Read `issue.txt` or provided ticket file.
- Extract goals, constraints, acceptance criteria, unknowns.
- Output a short “Question Brief” and list missing info.

## `research.md`

Goal: equivalent to HumanLayer `research_codebase`.

Hard rules:

- Documentarian mode only.
- Read referenced files fully first.
- Use specialist skills in parallel where useful.
- Produce research artifact with evidence.

Output file:

- `thoughts/shared/research/YYYY-MM-DD-<slug>.md`

Required sections:

- Research Question
- System Overview
- Detailed Findings (with file references)
- Data/Control Flows
- Related Historical Context
- Open Questions

## `spec.md`

Goal: bridge between research and implementation plan.

- Define desired end-state behavior.
- Define non-goals.
- Define invariants and constraints.
- Define acceptance criteria and test strategy.

Output file:

- `thoughts/shared/specs/YYYY-MM-DD-<slug>.md`

## `plan.md`

Goal: phase-based, executable plan.

- Derive phases from spec.
- For each phase: files to change, operations, automated checks, manual checks, rollback notes.
- Require human review before implement stage.

Output file:

- `thoughts/shared/plans/YYYY-MM-DD-<slug>.md`

## `implement.md`

Goal: controlled execution.

- Implement only from approved plan.
- Complete one phase at a time.
- Run checks after each phase.
- Update phase checkboxes in plan.
- Pause for manual verification unless user explicitly asks batching.

## `commit.md` and `describe_pr.md`

Goal: consistent handoff quality.

- `commit.md`: produce conventional, scoped commit messages from actual changes.
- `describe_pr.md`: summarize scope, tests, risks, and validation evidence.

---

## 5) Skill pack for Codex (`.codex/skills/*/SKILL.md`)

Recreate HumanLayer sub-agents as Codex skills.

Each skill should include:

- **When to use**
- **Inputs**
- **Process**
- **Output format**
- **Strict do/don’t list**

Recommended skills:

1. `codebase-locator`
   - Finds where components live.
2. `codebase-analyzer`
   - Explains how code paths currently work.
3. `codebase-pattern-finder`
   - Finds comparable implementations and test patterns.
4. `thoughts-locator`
   - Finds relevant prior docs.
5. `thoughts-analyzer`
   - Extracts high-value, still-relevant decisions.
6. `web-researcher`
   - External docs lookup when local code/artifacts are insufficient.

This preserves HumanLayer’s key design: **parallel specialization + synthesized artifact output**.

---

## 6) Hooks for Codex QRSPI

You need two hook classes:

## A) Git safety hooks (required)

`pre-commit`:

- Block staging any `thoughts/` content in app repo.
- Optional: block if `plan.md` references unchecked required checks for implemented phases.

`post-commit`:

- Run `scripts/thoughts-sync` to sync thoughts repo (or enqueue background sync).

Example `pre-commit` behavior:

- If `git diff --cached --name-only | grep '^thoughts/'` => reject commit.

## B) Verification hooks (recommended)

Use `scripts/verify-phase` as a standard post-implementation gate.

- For backend repos: lint + unit + integration subset.
- For frontend repos: typecheck + test + build/lint.
- Fail fast and report exact command failures.

---

## 7) Codex CLI wrapper (`scripts/qrspi`)

Create a small wrapper to reduce freeform drift:

```bash
./scripts/qrspi question issue.txt
./scripts/qrspi research issue.txt
./scripts/qrspi spec thoughts/shared/research/2026-04-02-foo.md
./scripts/qrspi plan thoughts/shared/specs/2026-04-02-foo.md
./scripts/qrspi implement thoughts/shared/plans/2026-04-02-foo.md
```

Wrapper responsibilities:

1. Validate required input file exists.
2. Print the stage prompt template path being used.
3. Enforce output target path convention.
4. Call Codex with the stage prompt + provided context.

This creates predictable ergonomics analogous to Claude slash commands.

---

## 8) Stage-by-stage Codex operating guide

## Q — Question

Input:

- `issue.txt` (or ticket markdown)

Output:

- `thoughts/shared/research/<date>-<slug>-question-brief.md` (optional) or inline brief

Checklist:

- Problem statement normalized
- Constraints listed
- Acceptance criteria captured
- Unknowns explicitly listed

## R — Research

Input:

- Question brief + issue

Output:

- `thoughts/shared/research/YYYY-MM-DD-<slug>.md`

Checklist:

- Concrete file paths + relevant references
- Data flow and control flow documented
- No implementation proposal leakage

## S — Spec

Input:

- Research doc

Output:

- `thoughts/shared/specs/YYYY-MM-DD-<slug>.md`

Checklist:

- End-state behavior precise
- Non-goals explicit
- Acceptance tests explicit

## P — Plan

Input:

- Spec doc

Output:

- `thoughts/shared/plans/YYYY-MM-DD-<slug>.md`

Checklist:

- Phases are independently verifiable
- Automated/manual checks per phase
- Sequencing and dependencies clear

## I — Implement

Input:

- Approved plan

Output:

- Code changes + updated plan checkboxes + commit + PR notes

Checklist:

- One phase at a time
- Verification executed and recorded
- Manual verification requested at planned pause points

---

## 9) Practical migration sequence from existing `.claude` repos

1. Keep existing `.claude/` as reference source.
2. Create `.codex/prompts/` by porting command intent (`research`, `plan`, `implement`, etc.).
3. Create `.codex/skills/` by porting each agent’s operating contract.
4. Move policy constraints into `AGENTS.md`.
5. Add `scripts/qrspi`, `scripts/verify-phase`, and git hooks.
6. Run first ticket fully via QRSPI and refine prompts based on friction.

---

## 10) Minimal “done-right” criteria for Codex QRSPI

You are “correctly implemented” when:

- Team can run all five stages with deterministic paths.
- Each stage produces its artifact in `thoughts/shared/*`.
- Research stays descriptive; implementation stays plan-driven.
- Git hooks prevent `thoughts/` pollution.
- PRs consistently include phase verification evidence.

---

## 11) Primary sources used for the rework

- HumanLayer repository (`.claude/commands`, `.claude/agents`, thoughts tooling):
  - https://github.com/humanlayer/humanlayer
- Workshop flow and operator prompts:
  - https://www.humanlayer.dev/docs/workshop
- Advanced Context Engineering (Research → Plan → Implement):
  - https://www.humanlayer.dev/blog/advanced-context-engineering
- Harness engineering concepts (skills/sub-agents/hooks):
  - https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents
- CLAUDE.md prompt-control pattern:
  - https://www.humanlayer.dev/blog/stop-claude-from-ignoring-your-claude-md

