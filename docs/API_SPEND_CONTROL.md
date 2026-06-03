# API spend control

Manual governance for paid models — **$20/month**, **$2/day**, local-first default.

---

## Prevent overspending

| Rule | Mechanism |
|------|-----------|
| Local first | `choose-model-for-task.sh` + `model-selector` skill |
| Pre-paid gate | `budget-gatekeeper` skill before every API call |
| Approval above $0.25 | `require_approval_above_usd` in budget policy |
| Max 3 paid calls/session | Stop and ask human |
| No secrets online | Block in budget-gatekeeper |
| Manual logging | `scripts/spend-log.sh` → `logs/api-spend/YYYY-MM.csv` |

---

## Daily budget review (2 min)

1. Open `logs/api-spend/` current month CSV.
2. Sum `estimated_cost_usd` column.
3. If **> $2 today** → stop paid calls until tomorrow.
4. If approaching **$20/month** → local only except approved final review.

```bash
# Example: view current month (Git Bash)
cat logs/api-spend/$(date +%Y-%m).csv
```

---

## Monthly budget review (15 min)

1. Total spend vs $20 cap.
2. Count calls by model — any premium overuse?
3. Sessions with >3 paid calls without approval?
4. Move one golden paid answer to `rag-ready/` to reduce future spend.
5. Update personal notes in `memories/<profile>/learning-log/`.

---

## When to use each tier

| Model | Use when | Do not use when |
|-------|----------|-----------------|
| **local_qwen_coder / local_gemma_helper** | Default; coding; private notes | Final security/accounting sign-off |
| **deepseek_flash** | Local failed 2×; cheap plan/SOP draft | Secrets, prod DB snippets |
| **qwen_coder_api** | Harder coding, test diagnosis | Secrets, final governance alone |
| **gpt_5_mini** | Architecture, complex debug, governance **draft** | Daily summaries, loops without approval |
| **claude_sonnet** | Final review, SOP/security quality | Default work, repeated cheap tasks |

Always run:

```bash
bash scripts/choose-model-for-task.sh <task-type>
bash scripts/spend-log.sh <provider> <model> <task> <usd> "<notes>"
```

---

## Stop rules for paid loops

1. **Same task, 3 paid attempts** → stop; save to `failed-local-cases/`; ask human.
2. **Estimated cost > $0.25** → explicit approval before call.
3. **Premium model** (`gpt_5_mini`, `claude_sonnet`) → approval every session.
4. **Full repo context** → confirm with human; prefer local excerpt.
5. **Retry after failure** → try cheaper tier or local before repeating same premium call.

---

## Manual spend logging SOP

After each **paid** API call:

```bash
bash scripts/spend-log.sh deepseek deepseek_flash test-task 0.01 "manual test"
```

Fields:

| Column | Meaning |
|--------|---------|
| date | UTC date |
| provider | e.g. deepseek, openrouter, openai, anthropic |
| model | catalog id e.g. deepseek_flash |
| task_name | short slug |
| estimated_cost_usd | your estimate (numeric) |
| notes | no secrets — reason only |

**Never log:** API keys, `.env` contents, prod DB rows, PII.

CSV path: `logs/api-spend/YYYY-MM.csv` (gitignored).

---

## Escalation flow (summary)

```
local (free) → deepseek_flash (cheap) → qwen_coder_api (coding) → gpt_5_mini (risk) → claude_sonnet (final)
     ↑                    ↑                      ↑                      ↑
  default            budget-gatekeeper        budget-gatekeeper      approval required
```

See [MODEL_FLOATING_NOTES.md](MODEL_FLOATING_NOTES.md) and [RUNTIME_OPERATIONALIZATION.md](RUNTIME_OPERATIONALIZATION.md).
