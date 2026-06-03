# Model setup

Hermes Hybrid uses **six catalog models** (see `configs/model-catalog.example.yaml`):

| ID | Role |
|----|------|
| `local_qwen_coder` | Primary offline coding |
| `local_gemma_helper` | Fast private helper |
| `deepseek_flash` | Low-cost API fallback |
| `qwen_coder_api` | API coding when local context is tight |
| `gpt_5_mini` | General API reasoning |
| `claude_sonnet` | Long planning & final review |

## Local (Ollama)

1. Install [Ollama](https://ollama.com/) on Windows or WSL.
2. Pull models:
   ```bash
   ollama pull qwen2.5-coder:14b
   ollama pull gemma2:9b
   ```
3. Set `.env`:
   ```env
   LOCAL_MODEL_BASE_URL=http://127.0.0.1:11434/v1
   LOCAL_MODEL_NAME=qwen2.5-coder:14b
   LOCAL_GEMMA_BASE_URL=http://127.0.0.1:11434/v1
   LOCAL_GEMMA_MODEL_NAME=gemma2:9b
   SKIP_LOCAL_MODEL_TEST=0
   ```
4. Test: `bash scripts/test-local-model.sh`

## LM Studio alternative

Point `LOCAL_MODEL_BASE_URL` at `http://127.0.0.1:1234/v1` and match `LOCAL_MODEL_NAME` to the loaded model id.

## Online (OpenRouter)

1. Create an API key at [openrouter.ai](https://openrouter.ai/).
2. Set `.env`:
   ```env
   ONLINE_MODEL_SKIP=false
   ONLINE_MODEL_PROVIDER=openrouter
   ONLINE_MODEL_API_KEY=sk-or-...
   ONLINE_MODEL_NAME=anthropic/claude-sonnet-4
   ```
3. Test: `bash scripts/test-online-model.sh`

Defer online setup with `ONLINE_MODEL_SKIP=true` or leave the placeholder key — tests **SKIP** instead of failing.

## Routing

- `bash scripts/choose-model-for-task.sh coding` → `local_qwen_coder`
- `bash scripts/choose-model-for-task.sh long_planning` → `claude_sonnet`
- `bash scripts/choose-model-for-task.sh final-review` → `claude_sonnet` (maps `final-review` → `final_review`)

## Apply configs to Hermes home

```bash
bash scripts/apply-hermes-hybrid-config.sh ~/.hermes-hybrid
```

Merge `hybrid.env.snippet` into your Hermes `.env` manually.

## Budget

See `configs/budget-policy.example.yaml` — $20/month, $2/day, local-first. Use skill `budget-gatekeeper` before expensive API runs.
