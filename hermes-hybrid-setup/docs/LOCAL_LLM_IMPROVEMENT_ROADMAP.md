# Local LLM improvement roadmap

Goal: **local handles more over time**; paid models only for escalation; budget stays predictable.

## Phase 1 — Prompt and Modelfile (now)

- [ ] Pull `qwen2.5-coder:14b` for `local_qwen_coder`
- [ ] Pull `gemma2:9b` (or your pick) for `local_gemma_helper`
- [ ] Custom system prompts in Ollama Modelfiles:
  - **coding-assistant** — workspace jail, T0–T6
  - **private-notes** — LifeOS/homeos summarization only
  - **commerceos-local-reviewer** — draft only; never final audit sign-off
- [ ] Pin prompts in `memories/<profile>/sop-patterns/`

## Phase 2 — RAG

- [ ] Run `bash scripts/setup-learning-memory.sh`
- [ ] Ingest per `docs/LOCAL_RAG_STRATEGY.md`
- [ ] Sources: project docs, skill docs, logs (redacted), SOPs, golden examples
- [ ] Separate indexes per profile
- [ ] Weekly: add verified fixes only

## Phase 3 — Evaluation

- [ ] Benchmark set in `memories/<profile>/golden-examples/benchmarks/`
- [ ] Tasks: summary, coding snippet, debug log, commerceos rule recall
- [ ] Score local vs `deepseek_flash` / `qwen_coder_api`
- [ ] Track pass/fail in `failed-local-cases/`
- [ ] Monthly review — update `model-catalog.example.yaml` notes

## Phase 4 — Fine-tuning (later)

- [ ] Collect **clean** pairs only from golden-examples
- [ ] LoRA/QLoRA after 500+ verified examples per task type
- [ ] **Do not** train on messy chats
- [ ] Version datasets (`v1`, `v2`) with changelog
- [ ] Evaluate on held-out benchmark before deploy

## Phase 5 — Local-first autonomy

- [ ] Default routing: `budget-policy.example.yaml` local_first
- [ ] Paid only via `budget-gatekeeper` + `escalation-reviewer`
- [ ] Weekly budget report (manual spreadsheet or script — track calls)
- [ ] Adjust catalog escalation chains from evaluation data
- [ ] Target: **80%** of daily tasks local by month 6 (adjust to your reality)

## Weekly operator ritual

1. Review spend vs `$20/mo` cap.
2. Count paid calls — any session >3 without approval?
3. Move one golden paid answer into `rag-ready/`.
4. Delete or quarantine one bad memory from `do-not-ingest/`.
