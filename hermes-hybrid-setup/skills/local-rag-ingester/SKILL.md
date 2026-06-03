---
name: local-rag-ingester
description: Classify and prepare content for profile-scoped local RAG ingestion with redaction rules.
---

# Local RAG Ingester

## Purpose

Grow **local** retrieval quality safely — ingest only clean, verified, profile-tagged content.

## When to use

- After `local-learning-loop` marks content `rag-ready`
- Curating docs/skills/SOPs for Ollama+RAG stack
- Promoting paid-model golden answers to local knowledge

## Input format

```text
profile: lifeos | commerceos-dev | homeos | research
source_path: workspaces/... or memories/...
content_type: cursor_prompt | bug_fix | sop | commerceos_rule | model_note | summary | other
raw_text: |
  ...
verified: yes | no
```

## Output format

```markdown
## Classification
- **Decision:** ingest | do_not_ingest | needs_cleanup | needs_redaction
- **Profile:** ...
- **RAG tags:** ...
- **Redaction applied:** ...
- **Target path:** memories/<profile>/rag-ready/<suggested-file>
- **Ingest blockers:** ...
```

## Good RAG content

- Successful Cursor prompts
- Solved bug reports (with test proof)
- Verified test fixes
- CommerceOS **locked rules** (no prod data)
- Hermes model notes, SOP patterns
- Project summaries, golden paid answers (distilled)

## Do not ingest

- API keys, passwords
- Production DB rows/connection strings
- Messy raw chats
- Outdated/wrong answers
- Cross-project private notes
- Unverified hallucinations

## Rules

- Default **needs_cleanup** for raw chat.
- **secret** privacy → do_not_ingest unless fully redacted.
- See `docs/LOCAL_RAG_STRATEGY.md`.
- Never ingest from outside active profile folder.

## Verification checklist

- [ ] Classification explicit
- [ ] No secrets in proposed ingest
- [ ] Profile tag correct
