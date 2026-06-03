# Hermes Hybrid Setup

A **standalone** local + online agent workstation for Windows (Git Bash), with optional WSL2/Docker.

**Repository:** [github.com/JFCommerceOS/Hermes-Agent](https://github.com/JFCommerceOS/Hermes-Agent)

This project does **not** symlink or link to `D:\CommerceOS` or any external CommerceOS repository — see [docs/PROJECT_ISOLATION.md](docs/PROJECT_ISOLATION.md).

## What you get

- **Local models** (Ollama / LM Studio) for everyday coding and private tasks
- **Online models** (OpenRouter, etc.) for long planning and final review — budget-gated
- **Four isolated profiles**: LifeOS, CommerceOS-dev sandbox, HomeOS, Research
- **Safety tiers T0–T8**, `.env` gates, and skills that enforce boundaries
- **11 bundled skills** under `skills/` for prompts, routing, RAG, and guardrails

## Quick start (Git Bash)

```bash
cd /d/hermes-agent-project/hermes-hybrid-setup

# If you have no .env yet:
cp .env.example .env
# Edit .env — set HERMES_WORKSPACE_ROOT and API keys as needed

bash scripts/bootstrap-offline.sh
bash scripts/setup-learning-memory.sh
```

Optional: copy `ACTIVE_PROFILE.example` to `ACTIVE_PROFILE` to switch profiles.

---

## Local-first model strategy

| Asset | Purpose |
|-------|---------|
| `configs/model-catalog.example.yaml` | Six models with cost, privacy, escalation, floating notes |
| `configs/budget-policy.example.yaml` | $20/mo cap, local-first routing, approval gates |
| `docs/MODEL_FLOATING_NOTES.md` | Beginner scan — what/when/not/cost/privacy |
| `scripts/show-model-notes.sh` | Print catalog notes in terminal |
| `scripts/choose-model-for-task.sh` | Pick model for `coding`, `commerceos`, `final-review`, etc. |
| `scripts/save-learning-example.sh` | Save verified outcomes to `memories/<profile>/` |

**Skills:** `model-selector`, `budget-gatekeeper`, `local-learning-loop`, `local-rag-ingester`, `escalation-reviewer`, `model-cheatsheet`

### How floating notes help

Each model has a one-line **floating note** (and a full section in `MODEL_FLOATING_NOTES.md`) so you know *why* Hermes picked it — without memorizing the catalog.

### Budget protection

- Default: **local first** (`local_qwen_coder`, `local_gemma_helper`)
- Paid tiers need **reason** + often **approval** (premium, CommerceOS governance, >$0.25, >3 paid calls)
- Skill **`budget-gatekeeper`** runs before any online call

### Local learning loop

1. Complete task locally when possible.
2. If weak → `escalation-reviewer` → cheap paid → premium with approval.
3. Save verified output: `bash scripts/save-learning-example.sh commerceos-dev my-task`
4. Ingest clean chunks: skill **`local-rag-ingester`** → see `docs/LOCAL_RAG_STRATEGY.md`

### First models to pull (local)

```powershell
ollama pull qwen2.5-coder:14b
ollama pull gemma2:9b
```

Set in `.env`: `LOCAL_MODEL_NAME`, `LOCAL_GEMMA_MODEL_NAME`.

### First online model to configure (later — no keys in repo)

1. Add `DEEPSEEK_API_KEY` or `OPENROUTER_API_KEY` in your private `.env` only
2. Set `ONLINE_MODEL_SKIP=false`
3. `bash scripts/test-online-model.sh`

### When to escalate to paid API

| Signal | Action |
|--------|--------|
| Local failed twice | `deepseek_flash` or `qwen_coder_api` + budget gatekeeper |
| Large refactor / arch | `gpt_5_mini` with approval |
| Final security / CommerceOS governance | `claude_sonnet` or `gpt_5_mini` + `commerceos-guardrail-reviewer` |
| Private/secret content | **Stay local** unless you approve redacted online |

### Daily SOP

1. Start **local** model (Ollama).
2. Run **model selector** (`choose-model-for-task.sh` or `model-selector` skill).
3. Use **local first**.
4. Escalate to **cheap API** only if needed (budget-gatekeeper).
5. Use **premium** only for high-risk final review (with approval).
6. Save useful result → `save-learning-example.sh` + learning memory.
7. Log paid API spend → `spend-log.sh`.
8. Review budget weekly.

---

## Phase 3 — Runtime, RAG, evaluation, spend control

| Doc | Purpose |
|-----|---------|
| [RUNTIME_OPERATIONALIZATION.md](docs/RUNTIME_OPERATIONALIZATION.md) | Daily Hermes ops (Windows / Git Bash / WSL2) |
| [RAG_INDEX_PROTOTYPE.md](docs/RAG_INDEX_PROTOTYPE.md) | Local RAG design + refresh SOP |
| [LOCAL_MODEL_EVALUATION.md](docs/LOCAL_MODEL_EVALUATION.md) | 20 benchmark tasks + pass/fail criteria |
| [API_SPEND_CONTROL.md](docs/API_SPEND_CONTROL.md) | Budget rules + manual spend logging |

**Scripts:**

```bash
bash scripts/run-local-eval.sh
bash scripts/spend-log.sh deepseek deepseek_flash test-task 0.01 "manual test"
```

**Daily workflow:**

1. Start local model.
2. Run model selector.
3. Use local first.
4. Escalate to cheap API only if needed.
5. Use premium model only for high-risk final review.
6. Save useful result to learning memory.
7. Log paid API spend manually.
8. Review budget weekly.

---

## Daily commands

| Task | Command |
|------|---------|
| Check machine + gates | `bash scripts/check-environment.sh` |
| Pick model for task | `bash scripts/choose-model-for-task.sh coding` |
| Model cheat sheet | `bash scripts/show-model-notes.sh` |
| Test routing rules | `bash scripts/test-hybrid-routing.sh` |
| Test Ollama | `bash scripts/test-local-model.sh` |
| Test API key | `bash scripts/test-online-model.sh` |
| Save a learning note | `bash scripts/save-learning-example.sh commerceos-dev my-task` |

## Profiles and workspaces

Each profile uses its own folder under `workspaces/` and `memories/`:

- `lifeos-agent` → `workspaces/lifeos`
- `commerceos-dev-agent` → `workspaces/commerceos-dev` (sandbox only)
- `homeos-agent` → `workspaces/homeos`
- `research-agent` → `workspaces/research`

## Safety defaults (keep these unless you know why)

```env
ALLOW_GIT_PUSH=false
ALLOW_PRODUCTION_DB=false
ALLOW_DESTRUCTIVE_COMMANDS=false
```

## Documentation map

| Doc | Topic |
|-----|--------|
| [BEGINNER_USAGE.md](docs/BEGINNER_USAGE.md) | First week walkthrough |
| [MODEL_SETUP.md](docs/MODEL_SETUP.md) | Ollama, OpenRouter, Hermes env |
| [INSTALL_WSL2_DOCKER.md](docs/INSTALL_WSL2_DOCKER.md) | Optional WSL2 + Docker |
| [SAFETY_RULES.md](docs/SAFETY_RULES.md) | Tiers and forbidden actions |
| [PROJECT_ISOLATION.md](docs/PROJECT_ISOLATION.md) | Standalone project rules |
| [OFFLINE_FIRST.md](docs/OFFLINE_FIRST.md) | Local-first workflow |
| [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | Common fixes |
| [MODEL_FLOATING_NOTES.md](docs/MODEL_FLOATING_NOTES.md) | Model cheat sheet (beginner) |
| [LOCAL_RAG_STRATEGY.md](docs/LOCAL_RAG_STRATEGY.md) | Safe RAG ingest rules |
| [LOCAL_LLM_IMPROVEMENT_ROADMAP.md](docs/LOCAL_LLM_IMPROVEMENT_ROADMAP.md) | Phased local improvement |
| [COMPLETION_STATUS.md](docs/COMPLETION_STATUS.md) | Checklist of what's included |
| [RUNTIME_OPERATIONALIZATION.md](docs/RUNTIME_OPERATIONALIZATION.md) | Phase 3 daily ops |
| [RAG_INDEX_PROTOTYPE.md](docs/RAG_INDEX_PROTOTYPE.md) | Local RAG prototype |
| [LOCAL_MODEL_EVALUATION.md](docs/LOCAL_MODEL_EVALUATION.md) | 20 eval benchmarks |
| [API_SPEND_CONTROL.md](docs/API_SPEND_CONTROL.md) | Spend control SOP |

## Model selection skills

| Skill | Role |
|-------|------|
| `model-selector` | Task → cheapest safe model |
| `budget-gatekeeper` | Pre-paid spend gate |
| `local-learning-loop` | Save verified patterns |
| `local-rag-ingester` | Classify RAG content |
| `escalation-reviewer` | Local vs online decision |
| `model-cheatsheet` | Quick reminder card |

## Config files

Copy or apply examples from `configs/*.example.yaml` via `scripts/apply-hermes-hybrid-config.sh`.

## Logs

Runtime logs go to `logs/` (gitignored except `.gitkeep`).

## License / scope

Personal Hermes workstation template. Extend skills and configs in-repo; do not add CommerceOS repo link scripts.
