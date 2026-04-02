#!/usr/bin/env bash
set -euo pipefail

mkdir -p artifacts

cat <<'MSG'
QRSPI workflow bootstrap complete.

Next steps:
1) Add ticket details to issue.md (or copy docs/templates/issue-template.md)
2) Run phase prompts in order from prompts/qrspi/
3) Save outputs into artifacts/

Recommended order:
- 01_qualify.md
- 02_research.md
- 03_specify.md
- 04_plan.md
- 05_implement.md
MSG
