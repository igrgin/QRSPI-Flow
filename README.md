# QRSPI Flow Template for Codex

This repository is a reusable template for running a HumanLayer-inspired multi-phase agent workflow in Codex:

1. **Q**ualify
2. **R**esearch
3. **S**pecify
4. **P**lan
5. **I**mplement

Start with: [`docs/QRSPI_GUIDE.md`](docs/QRSPI_GUIDE.md).

## Quick start

```bash
cp docs/templates/issue-template.md issue.md
# fill issue.md

# start a Codex session and use prompts from:
# prompts/qrspi/*.md
```

## Repo layout

- `docs/QRSPI_GUIDE.md` - full operating guide
- `prompts/qrspi/` - copy/paste prompts for each phase
- `skills/` - Codex skill templates for phase-specific behavior
- `hooks/` - optional guardrail hooks and scripts
- `docs/templates/` - reusable issue/research/spec/plan templates
