# HumanLayer QRSPI (RPI) Flow: Complete Implementation Guide for Codex

## What this guide is

This guide summarizes how HumanLayer’s **Research → Plan → Implement** workflow operates (sometimes referred to as QRSPI/RPI in community usage), based on:

- The HumanLayer open-source repo (`humanlayer/humanlayer`)
- HumanLayer workshop docs
- HumanLayer blog posts about Advanced Context Engineering and harness engineering

It also translates the workflow to **Codex-style agent usage** (where Claude slash commands/hooks may not exist 1:1).

---

## 1) Core mental model of the workflow

HumanLayer’s workflow is built around three explicit phases:

1. **Research**: Build an accurate map of the current system (files, architecture, flow, constraints).
2. **Plan**: Convert research into a phased, testable implementation specification.
3. **Implement**: Execute the plan in phases with verification gates.

The key HumanLayer idea is **Frequent Intentional Compaction**:

- Keep agent context focused.
- Use sub-agents for discovery/summarization.
- Put human review at high-leverage checkpoints (research and plan quality, not only code diff quality).

---

## 2) Canonical HumanLayer command stack (from `.claude/commands`)

The HumanLayer repo ships prompts/commands that embody this flow:

- `research_codebase.md`
- `create_plan.md`
- `implement_plan.md`

Related helper commands commonly used around the flow:

- `iterate_plan.md`, `validate_plan.md`
- `commit.md`, `describe_pr.md`
- variants such as `*_generic.md`, `*_nt.md`

### Research command intent

`research_codebase.md` heavily enforces:

- Document current behavior only.
- Avoid proposing fixes unless asked.
- Use specialized sub-agents in parallel (locator/analyzer/pattern-finder).
- Produce a research artifact with file:line references.

### Plan command intent

`create_plan.md` enforces:

- Read ticket/research files fully before planning.
- Ask focused clarifying questions.
- Produce phased plan with explicit verification criteria.
- Include “what we are not doing” scope guardrails.

### Implement command intent

`implement_plan.md` enforces:

- Read plan fully, then execute phase-by-phase.
- Run verification after each phase.
- Pause for human/manual verification before moving on (unless instructed otherwise).
- Update plan checkboxes as progress tracking.

---

## 3) HumanLayer’s specialized sub-agents (“skills” in practice)

In the HumanLayer repo, reusable specialist agents are under `.claude/agents/`:

- `codebase-locator.md`: Finds where components live.
- `codebase-analyzer.md`: Explains how code currently works.
- `codebase-pattern-finder.md`: Finds existing patterns to mirror.
- `thoughts-locator.md`: Finds prior research/notes in thoughts dirs.
- `thoughts-analyzer.md`: Synthesizes relevant notes.
- `web-search-researcher.md`: Web-source lookup when needed.

This is effectively a skill layer: small role-specific prompts that the main agent delegates to.

---

## 4) Thoughts system (artifact management)

HumanLayer’s prompts assume persistent artifacts are stored outside active code changes, often in a `thoughts/` structure. Typical conventions in prompts:

- Research docs under `thoughts/shared/research/`
- Plans under `thoughts/shared/plans/`
- Filename format includes date and ticket slug.
- Frontmatter metadata includes commit, branch, researcher, timestamps.

Why it matters:

- Keeps planning/research reusable across sessions.
- Supports async collaboration.
- Preserves engineering intent beyond a single chat context.

---

## 5) Hooks and harness engineering (what’s necessary vs optional)

From HumanLayer’s harness-engineering guidance:

- Hooks are used for control flow automation (approval logic, notifications, auto-checking).
- A common pattern: run formatter/typecheck/build hooks at stop points; only emit details on failure to save context.

### For Codex specifically

Codex may not expose the same Claude hook lifecycle primitives in all environments. So treat hooks as:

- **Optional optimization**, not required to run QRSPI.
- Replaceable with explicit scripted checks in your task loop.

Equivalent Codex pattern:

- At end of each phase, run scripted checks manually (or via a standard command list).
- Keep successful output terse; print full logs only on failures.

---

## 6) Minimal file structure to implement this in your own repo

If you want a HumanLayer-like flow in a Codex-driven repo, use this structure:

```text
<repo-root>/
  AGENTS.md
  .agent/
    commands/
      research_codebase.md
      create_plan.md
      implement_plan.md
      validate_plan.md
      commit.md
      describe_pr.md
    agents/
      codebase-locator.md
      codebase-analyzer.md
      codebase-pattern-finder.md
      notes-locator.md
      notes-analyzer.md
      web-researcher.md
    templates/
      research_template.md
      plan_template.md
  thoughts/
    shared/
      research/
      plans/
      prs/
```

You can mirror HumanLayer naming exactly (`.claude/...`) if your harness supports it.

---

## 7) Prompt set you actually need (minimum viable)

## A) `research_codebase` prompt

Must enforce:

- “Document what exists; do not prescribe changes.”
- Read issue/ticket first.
- Decompose into sub-questions.
- Use specialized sub-agents for search and synthesis.
- Produce artifact with file paths and line references.

## B) `create_plan` prompt

Must enforce:

- Read research artifact(s) first.
- Ask clarifying questions before finalizing plan.
- Return phased plan with:
  - objective
  - scope/non-scope
  - file-level change map
  - automated checks
  - manual verification checklist

## C) `implement_plan` prompt

Must enforce:

- Execute phases sequentially.
- Run tests/checks for each phase.
- Update plan status checkboxes.
- Stop after each phase for human confirmation (default).

---

## 8) Operating procedure in Codex (practical loop)

1. **Prepare ticket context**
   - Save issue/ticket as `issue.md`.
   - Ensure branch/worktree ready.

2. **Run research session**
   - Ask agent to produce research artifact in `thoughts/shared/research/`.
   - Require concrete code references.

3. **Human review gate #1**
   - Confirm research is accurate and complete.
   - Correct misunderstandings before planning.

4. **Run planning session**
   - Generate `thoughts/shared/plans/<date>-<ticket>-<slug>.md`.
   - Ensure phased rollout + verification criteria.

5. **Human review gate #2**
   - Approve design and risk handling.
   - Adjust phase boundaries if needed.

6. **Run implementation session**
   - Execute one phase at a time.
   - Run checks after each phase.
   - Pause for manual verification.

7. **Finalize**
   - Commit.
   - Generate PR description from plan/research deltas.

---

## 9) “Necessary” vs “nice-to-have” components

### Strictly necessary to adopt QRSPI

- 3 top-level prompts: research, plan, implement
- Persistent artifacts (research + plan markdown files)
- Phase gates with verification
- Human checkpoints

### Very helpful but optional

- Specialized sub-agent prompts (locator/analyzer/pattern)
- Hook automation for checks and notifications
- Ticket-system integrations (Linear/GitHub MCP)
- Thoughts sync tooling

---

## 10) Common failure modes and how to avoid them

1. **Skipping research depth**
   - Symptom: wrong plan target files.
   - Fix: require file:line-backed research output.

2. **Planning without clarifications**
   - Symptom: phase churn and rework.
   - Fix: force unresolved-questions section before final plan.

3. **No verification discipline**
   - Symptom: green diff, broken runtime behavior.
   - Fix: automated + manual checks per phase.

4. **Overloading root instructions**
   - Symptom: agent ignores key constraints.
   - Fix: keep AGENTS/CLAUDE concise; push detail into command prompts.

---

## 11) Quick-start checklist for a Codex repo

- [ ] Add root `AGENTS.md` with concise global rules.
- [ ] Add `.agent/commands/{research_codebase,create_plan,implement_plan}.md`.
- [ ] Add `.agent/agents/{locator,analyzer,pattern}.md`.
- [ ] Add `thoughts/shared/{research,plans,prs}` directories.
- [ ] Add plan/research markdown templates.
- [ ] Define a standard verification command list (`lint`, `typecheck`, `test`, build).
- [ ] Enforce human approval between phases.

---

## 12) Source links used for this research

- HumanLayer repo: https://github.com/humanlayer/humanlayer
- Workshop docs: https://www.humanlayer.dev/docs/workshop
- Advanced Context Engineering blog: https://www.humanlayer.dev/blog/advanced-context-engineering
- Writing a good CLAUDE.md: https://www.humanlayer.dev/blog/writing-a-good-claude-md
- Skill Issue / harness engineering: https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents
