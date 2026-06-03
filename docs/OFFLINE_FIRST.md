# Offline-first workflow

Default strategy: **local models first**, API only when routing or budget policy allows.

## Bootstrap without network

```bash
bash scripts/bootstrap-offline.sh
```

This runs workspace + memory setup, environment check, and routing test. Online API test is skipped or soft-fails.

## When local is enough

- Coding, refactors, unit test fixes → `local_qwen_coder`
- Summaries, checklists, quick Q&A → `local_gemma_helper`

```bash
bash scripts/choose-model-for-task.sh coding
```

## When to go online

Router sends these to `claude_sonnet`:

- `long_planning`
- `architecture`
- `final_review` (approval required)

Medium planning may escalate to `qwen_coder_api` when context is large — see `configs/model-router.example.yaml`.

## Defer paid API setup

```env
ONLINE_MODEL_SKIP=true
ONLINE_MODEL_API_KEY=your-online-api-key-here
```

`test-online-model.sh` prints **SKIP** — not a failure.

## Local RAG offline

Queue documents in `memories/<profile>/rag-inbox/`, then use skill `local-rag-ingester` (see [LOCAL_RAG_STRATEGY.md](LOCAL_RAG_STRATEGY.md)).

## Improvement path

See [LOCAL_LLM_IMPROVEMENT_ROADMAP.md](LOCAL_LLM_IMPROVEMENT_ROADMAP.md) for tuning local quality over time.
