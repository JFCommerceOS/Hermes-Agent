---
name: budget-gatekeeper
description: Gate paid/premium Hermes model use against budget policy before any API spend.
---

# Budget Gatekeeper

## Purpose

**Block silent overspend** — every paid call needs visibility and approval when policy says so.

## When to use

- Before **any** online model call
- Before retrying a failed paid call
- Before long-context or full-repo prompts
- Weekly budget check-in

## Input format

```text
proposed_model: deepseek_flash | qwen_coder_api | gpt_5_mini | claude_sonnet
task_summary: <short>
profile: <profile>
estimated_calls: 1-10
estimated_cost_usd: optional
local_alternatives_tried: [local_qwen_coder, local_gemma_helper]
context: small | medium | large | full_repo
contains_secrets: yes | no
contains_prod_db: yes | no
```

## Output format

```markdown
## Budget gate
- **Selected paid model:** ...
- **Estimated call count:** ...
- **Why local insufficient:** ...
- **Cheaper option considered:** ...
- **Estimated cost risk:** low | medium | high
- **Approval needed:** yes | no
- **Stop condition:** e.g. stop after 1 response / no retry >3 / switch to local
```

## Rules

- **Never** silently use premium (`gpt_5_mini`, `claude_sonnet`).
- **Never** >3 paid calls/session without approval (`budget-policy.example.yaml`).
- **Never** send secrets or production DB data online.
- **Ask** before full repo context to paid models.
- Respect `monthly_budget_usd: 20`, `daily_budget_usd: 2`, `require_approval_above_usd: 0.25`.
- If `contains_secrets=yes` or `contains_prod_db=yes` → **BLOCK** paid, use local only.
- Reference `forbidden_without_approval` in budget policy.

## Verification checklist

- [ ] Approval explicit when required
- [ ] Stop condition stated
- [ ] Cheaper path mentioned
- [ ] No API keys printed
