---
name: model-cheatsheet
description: Short reminder of what each catalog model is for, cost, privacy, and escalation.
---

# Model Cheatsheet

## Purpose

When you forget which model to use, print a **scannable** cheat sheet (no API keys).

## When to use

- Start of session
- After budget warning
- Training new habits (local-first)

## Input

```text
optional_filter: all | local | paid | premium
```

## Output format

For each model (short table or bullets):

| Model | Use for | Do not use for | Cost | Privacy | Escalate |
|-------|---------|----------------|------|---------|----------|

Plus one line: **Today default:** `local_qwen_coder` (coding) / `local_gemma_helper` (private).

## Source of truth

- `configs/model-catalog.example.yaml`
- `docs/MODEL_FLOATING_NOTES.md`
- `bash scripts/show-model-notes.sh`

## Rules

- Keep under ~40 lines unless filter=one model.
- Remind: daily budget $2, monthly $20.
- Premium needs approval.

## Example one-liners

- **local_qwen_coder** — first for code/logs/prompts; free; local.
- **local_gemma_helper** — notes/summary/RAG; free; most private.
- **deepseek_flash** — cheap cloud plan; no secrets.
- **qwen_coder_api** — harder code online.
- **gpt_5_mini** — risky arch/governance; ask first.
- **claude_sonnet** — final review only; expensive.

## Verification checklist

- [ ] All six catalog models mentioned when filter=all
- [ ] Cost + privacy on each
- [ ] Beginner-readable
