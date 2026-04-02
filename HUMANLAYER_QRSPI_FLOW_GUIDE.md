# HumanLayer QRSPI Flow (Research/Plan/Implement) — Complete Practical Guide

## Scope of this guide

This guide consolidates how HumanLayer’s workflow operates across:

- the `humanlayer/humanlayer` repository (commands, agents, settings, thoughts tooling)
- HumanLayer workshop docs
- HumanLayer blog posts that explain the rationale behind prompts, skills, sub-agents, and hooks

> **Note on naming:** HumanLayer docs consistently describe the core loop as **Research → Plan → Implement (RPI)**. In this guide I map your requested “QRSPI” framing as **Question → Research → Spec/Plan → Implement** (an inferred extension for practical usage).

---

## 1) Conceptual model: what the flow is actually doing

At a high level, the flow intentionally splits work into compact artifacts:

1. **Question / ticket ingestion**
   - Put the issue in a local file (`issue.txt`/`issue.md`) so agent instructions can consistently reference it.
2. **Research**
   - Generate a documentation-style artifact of how the codebase currently works (file/line grounded), without jumping to implementation.
3. **Spec / Plan**
   - Convert findings into a phase-based implementation plan with clear verification criteria.
4. **Implement**
   - Execute phase by phase, running checks and pausing for manual verification where needed.

This is context-management by design: each stage compacts context into reusable markdown, rather than carrying long chat history forward.

---

## 2) Minimal starter workflow (operator actions)

From HumanLayer Workshop, the core operator loop is:

1. Clone target repo and add issue text file.
2. Run `/cl:research_codebase` and provide research prompt.
3. Run `/cl:create_plan` and provide planning prompt.
4. Run `/cl:implement_plan - PATH_TO_PLAN.md` and execute the plan.
5. Finish with commit + PR flow.

Recommended “magic words” in workshop examples:

- **Research prompt ending:**
  - `Do not make an implementation plan or explain how to fix.`
- **Planning prompt ending:**
  - `Work back and forth with me, sharing your open questions and phases outline before writing the plan.`

These instructions reinforce the intended stage boundaries.

---

## 3) Files to bootstrap into each working repo

HumanLayer’s `claude init` command copies a `.claude/` bundle into your repo. In practice, these are the key files:

```text
.claude/
├── commands/
│   ├── research_codebase.md
│   ├── create_plan.md
│   ├── implement_plan.md
│   ├── commit.md
│   ├── describe_pr.md
│   └── ... (additional workflow commands)
├── agents/
│   ├── codebase-locator.md
│   ├── codebase-analyzer.md
│   ├── codebase-pattern-finder.md
│   ├── thoughts-locator.md
│   ├── thoughts-analyzer.md
│   └── web-search-researcher.md
└── settings.json
```

### What each layer does

- **`commands/`** = top-level slash-command prompts (workflow orchestration).
- **`agents/`** = specialized sub-agent instructions (parallel/context-isolated investigation).
- **`settings.json`** = harness defaults (allowed commands, thinking budget env vars, model defaults).

---

## 4) Prompt anatomy by stage

### A) Research prompt (`.claude/commands/research_codebase.md`)

Purpose: document current state with evidence.

Core behavior encoded in prompt:

- Explicit “documentarian mode” (no unsolicited fixing recommendations).
- Read user-mentioned files fully before sub-task fanout.
- Spawn parallel specialist sub-agents (locator/analyzer/pattern/thoughts/web if requested).
- Synthesize with concrete `file:line` references.
- Write a research artifact in `thoughts/shared/research/YYYY-MM-DD-...md` with metadata.

**Practical operator input template:**

```text
We are working on the issue in issue.txt.
Please read the issue and research the codebase to understand how the system works
and what files and line numbers are relevant to the issue.

Do not make an implementation plan or explain how to fix.
```

### B) Plan prompt (`.claude/commands/create_plan.md`)

Purpose: transform research into a testable implementation spec.

Core behavior encoded in prompt:

- Read all referenced artifacts first.
- Perform additional targeted research before asking clarifying questions.
- Present understanding + open questions.
- Propose phases first; ask for feedback.
- Write final plan to `thoughts/shared/plans/YYYY-MM-DD-...md`.
- Include both automated and manual verification criteria per phase.

**Practical operator input template:**

```text
We are working on the issue in issue.txt.
We've done the following research: thoughts/shared/research/2026-04-02-...md

Create a plan to fix the issue.
Work back and forth with me, sharing your open questions and phases outline before writing the plan.
```

### C) Implement prompt (`.claude/commands/implement_plan.md`)

Purpose: execute approved plan with disciplined verification.

Core behavior encoded in prompt:

- Read the plan and referenced files fully.
- Implement phase-by-phase.
- Run automated checks after each phase.
- Pause for human manual verification (unless explicitly told to batch phases).
- Update plan checkboxes to reflect completion.

**Practical operator input template:**

```text
/cl:implement_plan - thoughts/shared/plans/2026-04-02-...md

Please implement the plan.
```

---

## 5) Sub-agents (“skills” in practice) and when to use each

In HumanLayer’s shipped config, the reusable specialization units are `.claude/agents/*.md` sub-agents:

- **`codebase-locator`**: where things live.
- **`codebase-analyzer`**: how a specific component works.
- **`codebase-pattern-finder`**: find comparable implementations.
- **`thoughts-locator`**: discover prior research/plans/notes.
- **`thoughts-analyzer`**: extract high-value decisions from prior docs.
- **`web-search-researcher`**: external lookup when needed.

The pattern is:

1. parent command decomposes task,
2. dispatches sub-agents in parallel,
3. receives compacted results (not full noisy tool traces),
4. synthesizes into durable markdown artifact.

This is the context-firewall concept discussed by HumanLayer: parent thread stays focused, subtasks absorb exploration noise.

---

## 6) Hooks you need (two categories)

## A) Git hooks from the Thoughts tool (`humanlayer thoughts init`)

The thoughts setup writes repository hooks to enforce artifact hygiene:

- **pre-commit**: blocks committing `thoughts/` into the code repo.
- **post-commit**: auto-runs `humanlayer thoughts sync` to sync thought artifacts.

This makes markdown workflow durable without polluting product repo history.

## B) Harness hooks (Claude Code hook concept)

HumanLayer’s harness-engineering guidance treats hooks as deterministic control-flow points for:

- pre/post tool lifecycle automation,
- surfacing compile/type failures before task completion,
- notifications and integration glue.

Even when exact hook implementation differs by harness, the design goal is the same: convert implicit behavior into deterministic, reusable guardrails.

---

## 7) Thoughts tool structure and file architecture

When `humanlayer thoughts init` is configured, you get:

### In your working code repo

```text
thoughts/
├── <user>/      -> symlink to global thoughts repo (repo-specific personal notes)
├── shared/      -> symlink to global thoughts repo (repo-specific shared notes)
├── global/      -> symlink to global thoughts repo (cross-repo notes)
├── searchable/  (hardlink index built by sync)
└── CLAUDE.md    (usage instructions generated by tool)
```

### In your separate thoughts git repo

```text
<thoughts_repo>/
├── repos/
│   └── <mapped-repo-name>/
│       ├── <user>/
│       └── shared/
└── global/
    ├── <user>/
    └── shared/
```

### Recommended artifact locations

- Research docs: `thoughts/shared/research/YYYY-MM-DD-...md`
- Plans/specs: `thoughts/shared/plans/YYYY-MM-DD-...md`
- PR narratives: `thoughts/shared/prs/...md`
- Local private notes: `thoughts/<user>/...`

---

## 8) Suggested “QRSPI” execution playbook (operational)

## Q — Question framing

- Save canonical issue text to `issue.txt`.
- Add acceptance criteria and constraints directly in that file.
- If ticket has screenshots/logs, include paths or copied essentials.

## R — Research

- Run `/cl:research_codebase`.
- Keep output descriptive (what exists + where).
- Require line-grounded references and system-level flow mapping.
- Publish research artifact in `thoughts/shared/research/`.

## S/P — Spec/Plan

- Run `/cl:create_plan` with reference to research doc.
- Force phase draft review before final write.
- Ensure each phase has:
  - file-level change scope,
  - automated checks,
  - manual checks,
  - explicit stop points for human signoff.

## I — Implement

- Run `/cl:implement_plan - <plan path>`.
- Execute one phase at a time for complex changes.
- After each phase: run checks, update plan checkboxes, pause for manual verification.
- End with commit + PR prompt helpers (`/commit`, `/describe_pr`) as needed.

---

## 9) Common failure modes and fixes

- **Agent jumps to coding during research**
  - Reassert stage boundary language (“do not propose fixes”).
- **Plan appears without clarifying questions**
  - Re-run with explicit collaboration instruction (work back and forth first).
- **Context gets noisy/slow**
  - Increase use of sub-agent decomposition and artifact compaction.
- **Thought artifacts accidentally staged**
  - Ensure thoughts pre-commit hook is installed and active.
- **Too many tools degrade performance**
  - Favor minimal tool surface and progressive disclosure.

---

## 10) Implementation checklist for a new team rollout

1. Install HumanLayer tooling in developer environments.
2. Bootstrap `.claude/commands`, `.claude/agents`, `.claude/settings.json` in each active repo.
3. Add concise root `CLAUDE.md` / `AGENTS.md` with universally applicable rules.
4. Initialize `humanlayer thoughts` and verify hooks installed.
5. Standardize naming conventions for `thoughts/shared/research` and `thoughts/shared/plans` docs.
6. Train team on explicit stage prompts (Research vs Plan vs Implement).
7. Define mandatory verification commands per repo and include in plan templates.
8. Use `/commit` + `/describe_pr` prompts to standardize handoff quality.

---

## 11) Primary references

- HumanLayer repo: https://github.com/humanlayer/humanlayer
- Workshop doc: https://www.humanlayer.dev/docs/workshop
- ACE post (Research/Plan/Implement with prompt links): https://www.humanlayer.dev/blog/advanced-context-engineering
- Harness engineering (skills/sub-agents/hooks): https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents
- CLAUDE.md conditional instructions post: https://www.humanlayer.dev/blog/stop-claude-from-ignoring-your-claude-md

