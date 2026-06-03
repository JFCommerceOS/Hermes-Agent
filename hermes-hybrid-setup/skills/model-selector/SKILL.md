---
name: model-selector
description: Recommend local-first Hermes model for a task with cost, privacy, and approval guidance.
---

# Model Selector

## Purpose

Pick the **cheapest safe** model using `configs/model-catalog.example.yaml` and `configs/budget-policy.example.yaml`.

## When to use

- Starting any Hermes task
- Unsure whether to stay local or pay
- Switching profiles (LifeOS / commerceos-dev / homeos / research)

## Input format

```text
task: <one-line description>
profile: lifeos-agent | commerceos-dev-agent | homeos-agent | research-agent
privacy: public | internal | private | secret
risk: low | medium | high | critical
task_type: summary | coding | debug | architecture | commerceos | private | long-context | final-review
context_size: small | medium | large
local_attempts: 0-2 (optional)
```

## Output format

```markdown
## Recommendation
- **First model:** <id>
- **Reason:** ...
- **Cheaper alternative:** ...
- **Fallback:** ...
- **Premium escalation:** ...
- **Cost risk:** low | medium | high
- **Privacy risk:** low | medium | high
- **Approval needed:** yes | no
- **User instruction:** <exact next step>
```

## Rules

1. **Default local** — `local_qwen_coder` or `local_gemma_helper` per task_type.
2. **secret/private** → local only unless user explicitly approves online + redaction.
3. **high/critical risk** → local draft allowed; **premium review required** before final (`gpt_5_mini` / `claude_sonnet`).
4. **commerceos** + accounting/RBAC/MCP/A2A → strong review; use `commerceos-guardrail-reviewer` before merge-ready.
5. **large context** → warn before paid long-context; never full repo online without confirmation.
6. Run `bash scripts/choose-model-for-task.sh <task_type>` and cite result.
7. Run `bash scripts/show-model-notes.sh <model_id>` for floating note.
8. No real API keys in output.

## Example

```text
task: Summarize test failure in commerceos-dev workspace only
profile: commerceos-dev-agent
privacy: internal
risk: medium
task_type: debug
context_size: small
```

## Verification checklist

- [ ] First model is local when privacy is private/secret
- [ ] Approval flagged for premium/commerceos/final-review
- [ ] Cheaper alternative named
- [ ] No secrets in response
