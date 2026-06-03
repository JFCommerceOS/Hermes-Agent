---
name: local-learning-loop
description: Capture verified task outcomes into profile-scoped learning memory for local improvement.
---

# Local Learning Loop

## Purpose

After a **verified** task, save patterns so local models + RAG improve without cross-profile leakage.

## When to use

- Task succeeded (tests pass or human confirmed)
- Paid model produced a golden answer worth distilling locally
- New Cursor prompt or SOP pattern worth keeping

## Memory layout (per profile)

`memories/<profile>/`

- `learning-log/YYYY-MM-DD/` — session entries
- `golden-examples/` — verified best answers
- `failed-local-cases/` — local misses (for escalation tuning)
- `cursor-prompts/` — reusable Cursor blocks
- `sop-patterns/` — procedural wins
- `rag-ready/` — cleaned chunks for ingest
- `do-not-ingest/` — raw/dirty holds

Profiles: `lifeos`, `commerceos-dev`, `homeos`, `research` only.

## Input format

```text
profile: <profile>
task_summary: ...
model_used: local_qwen_coder | ...
local_succeeded: yes | no
paid_escalation: yes | no
final_solution: ...
failed_attempts: ...
files_touched: [...]
test_commands: ...
```

## Output format

Fill this template, then save via script:

```markdown
## Learning capture
- **Task summary:**
- **Project profile:**
- **Model used:**
- **Local model succeeded:** yes/no
- **Paid escalation used:** yes/no
- **Final solution:**
- **Failed attempts:**
- **Reusable pattern:**
- **Files touched:**
- **Test commands:**
- **Future skill idea:**
- **RAG tag:**
- **Do-not-break rules:**

## Next steps
- Run: bash scripts/save-learning-example.sh <profile> <task-slug>
- If RAG-ready: skill local-rag-ingester
```

## Rules

- **Never** copy memory across profiles.
- **Never** save unverified hallucinations as golden.
- CommerceOS entries stay under `commerceos-dev` only; workspace-relative paths only.
- T4 max to write files unless `APPROVE-T6`.

## Verification checklist

- [ ] Profile matches active session
- [ ] Solution was verified
- [ ] No secrets in saved content
