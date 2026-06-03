---
name: escalation-reviewer
description: Decide if local Hermes output needs online/premium review with cost and context boundaries.
---

# Escalation Reviewer

## Purpose

Prevent **premature paid spend** and **unsafe local-only** decisions on high-risk work.

## When to use

- Local model gave weak/uncertain answer
- CommerceOS governance, security, or accounting touched
- Major refactor or production-like decision

## Input format

```text
profile: ...
task_summary: ...
local_model: local_qwen_coder | local_gemma_helper
local_attempts: 1-5
local_output_quality: ok | weak | failed
risk: low | medium | high | critical
task_type: ...
```

## Output format

```markdown
## Escalation review
- **Escalate:** yes | no
- **Model to use:** <id>
- **Reason:** ...
- **Cost warning:** ...
- **Approval needed:** yes | no
- **Send context:** bullet list (safe excerpts only)
- **Do NOT send:** secrets, prod DB, full .env, cross-profile memory
```

## Escalate when

- Local failed **twice** on same subtask
- High-risk architecture
- CommerceOS RBAC/tenant/module/accounting/audit/MCP/A2A
- Security/privacy issue
- Production-like decision
- Hallucination risk unclear
- Major refactor
- Legal/compliance/accounting content

## Rules

- First escalation online: prefer `deepseek_flash` unless coding-heavy → `qwen_coder_api`.
- Final governance: `gpt_5_mini` draft + `claude_sonnet` review with approval.
- Pair with `budget-gatekeeper` before paid call.

## Verification checklist

- [ ] Escalate decision justified by attempts/risk
- [ ] Context boundaries listed
- [ ] Approval flag set for premium
