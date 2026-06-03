# Local RAG strategy

Profile-scoped retrieval so **LifeOS**, **commerceos-dev**, **homeos**, and **research** never share an index.

## What to ingest

| Content | Profile tag | Notes |
|---------|-------------|-------|
| Verified Cursor prompts | same profile | `memories/<p>/cursor-prompts/` |
| Solved bugs + test proof | commerceos-dev, etc. | `golden-examples/` |
| SOP patterns | any | `sop-patterns/` |
| CommerceOS locked rules | commerceos-dev only | rules only — no prod rows |
| Model floating notes | all (copy summaries) | from `docs/MODEL_FLOATING_NOTES.md` |
| Distilled paid answers | same profile | strip vendor fluff |

## What not to ingest

- API keys, passwords, tokens
- Production DB dumps or connection strings
- Raw unedited chat logs
- Wrong/outdated answers
- Cross-profile private notes
- Unverified model hallucinations

## Avoid bad memory

1. **Verify before ingest** — test command or human OK.
2. **One profile per index** — separate folders under `memories/<profile>/rag-ready/`.
3. **Version filenames** — `YYYY-MM-DD-topic.md`.
4. **do-not-ingest/** for quarantine until cleaned.
5. **Monthly prune** — archive stale chunks.

## Tagging

Front-matter per file:

```yaml
profile: commerceos-dev
rag_tag: commerceos-rbac
verified: true
source: local_qwen_coder
```

## Refresh indexes

1. Add files to `rag-ready/` after `local-rag-ingester` approves.
2. Rebuild local index (Ollama embed, LlamaIndex, etc. — your choice).
3. Log refresh date in `memories/<profile>/learning-log/`.
4. Never point commerceos-dev index at LifeOS paths.

## Paid → local knowledge

1. Paid model produces answer.
2. Human verifies.
3. `local-learning-loop` distills pattern (no secrets).
4. `local-rag-ingester` → `rag-ready/`.
5. Re-index — local model answers faster next time.

## CommerceOS isolation

- RAG only from `workspaces/commerceos-dev/` and `memories/commerceos-dev/`.
- **Never** link or read `D:\CommerceOS` — clone inside workspace only if you choose.
- Use skill `commerceos-guardrail-reviewer` before treating RAG rules as law.
