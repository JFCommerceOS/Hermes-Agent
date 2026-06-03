# RAG index prototype (design + SOP)

Lightweight **local-only** retrieval plan — no heavy framework in Phase 3. Design first, implement when you have verified `rag-ready/` content.

---

## Principles

1. **Profile isolation** — one index per profile; never mix LifeOS and commerceos-dev.
2. **Local-only default** — embeddings run on your machine; no content sent to cloud embed APIs unless you explicitly approve.
3. **Verify before ingest** — only `rag-ready/` and approved golden examples.
4. **No secrets in index** — redact before ingest.

---

## Folders to index (per profile)

| Folder | Content |
|--------|---------|
| `memories/<profile>/rag-ready/` | Cleaned, approved chunks |
| `memories/<profile>/golden-examples/` | Verified best answers |
| `memories/<profile>/cursor-prompts/` | Reusable Cursor blocks |
| `memories/<profile>/sop-patterns/` | Procedural wins |

**Shared (read-only reference, tag by profile when retrieved):**

| Folder | Content |
|--------|---------|
| `docs/` | Model notes, safety, RAG strategy |
| `skills/` | Skill definitions (metadata only) |

Replace `<profile>` with: `lifeos`, `commerceos-dev`, `homeos`, `research`.

---

## Never index

- `.env`, `.env.*`, API keys, credentials
- `logs/` (may contain secrets in error output)
- `memories/**/do-not-ingest/`
- Production DB exports or connection strings
- Raw unedited chat logs
- Cross-profile private notes
- Unverified model outputs
- `workspaces/**/node_modules/`, scratch caches

---

## Suggested embedding options (local)

| Option | Pros | Cons |
|--------|------|------|
| **Ollama embed** (`nomic-embed-text`, `mxbai-embed-large`) | Same stack as chat; simple | GPU/RAM for batch |
| **sentence-transformers** (Python) | Mature, offline | Extra venv |
| **llama.cpp embed** | Lightweight | Manual wiring |

Start with **Ollama** if you already run Qwen/Gemma locally.

---

## Suggested vector store options (local)

| Option | Pros | Cons |
|--------|------|------|
| **Chroma** (local persist dir) | Simple Python API | Another dependency |
| **FAISS** (file on disk) | Fast, no server | Manual index management |
| **SQLite + vec** (sqlite-vec) | Single file per profile | Newer tooling |
| **Plain markdown + ripgrep** | Zero deps; good for Phase 3 | No semantic search |

**Phase 3 recommendation:** start with **markdown + ripgrep** for recall tests; add Chroma/FAISS when `rag-ready/` has 20+ verified chunks per profile.

---

## Index layout (proposed)

```
memories/<profile>/.rag-index/     # gitignored — local only
  embeddings/
  manifest.json                    # file list, dates, tags
  version.txt                      # index build id
```

Add to local `.gitignore` pattern: `memories/**/.rag-index/`

---

## Refresh index SOP

1. Run skill **`local-rag-ingester`** on new content → approve → move to `rag-ready/`.
2. Quarantine bad files in `do-not-ingest/`.
3. Rebuild index for **one profile only**:
   - Scan `rag-ready/`, `golden-examples/`, `cursor-prompts/`, `sop-patterns/`
   - Skip files without `verified: true` front-matter (when you adopt front-matter)
4. Update `manifest.json` with build date.
5. Log in `memories/<profile>/learning-log/YYYY-MM-DD/rag-refresh.md`.

---

## Clean bad memory

1. Move suspect file to `do-not-ingest/`.
2. Remove from index manifest (or full rebuild).
3. Document in `failed-local-cases/` if local model repeated the bad answer.
4. Never copy quarantined content across profiles.

---

## Test whether RAG improved quality

Use tasks **E19** and **E20** in [LOCAL_MODEL_EVALUATION.md](LOCAL_MODEL_EVALUATION.md):

1. **Baseline:** answer without retrieval.
2. **With RAG:** same prompt + top-k chunks from profile index.
3. Compare against **expected good answer checklist**.
4. Record pass/fail in `evaluations/YYYY-MM-DD/results.md`.

**Pass signal:** correct recall of locked rule or golden pattern that was only in `rag-ready/`.

---

## CommerceOS isolation

- Index only `memories/commerceos-dev/` and `workspaces/commerceos-dev/` content.
- **Do not** link or read `D:\CommerceOS`.
- Clone app code inside workspace only if you choose.

---

## Phase 4+ (not in scope now)

- Automated nightly index refresh
- Cross-encoder reranking
- Paid-model answer distillation pipeline
- Fine-tuning on golden-examples

See [LOCAL_LLM_IMPROVEMENT_ROADMAP.md](LOCAL_LLM_IMPROVEMENT_ROADMAP.md).
