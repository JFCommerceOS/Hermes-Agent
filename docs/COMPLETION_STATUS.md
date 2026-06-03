# Completion status

Rebuild checklist for `hermes-hybrid-setup` (standalone, no CommerceOS links).

## Core

- [x] README.md, .env.example, .gitignore, ACTIVE_PROFILE.example
- [x] configs/*.example.yaml (6 files)
- [x] scripts/*.sh and PowerShell wrappers
- [x] scripts/lib/load-env.sh (CRLF-safe)
- [x] scripts/lib/load-yaml-key.sh
- [x] workspaces: lifeos, commerceos-dev, homeos, research, sandbox
- [x] memories/ via setup-learning-memory.sh
- [x] logs/.gitkeep

## Safety

- [x] T0–T8 in safety-policy.example.yaml
- [x] Forbidden: prod DB, auto push, unapproved destructive, cross-memory
- [x] .env gates documented and checked

## Models (local-first selectable system)

- [x] model-catalog.example.yaml — 6 profiles with floating_note, escalation
- [x] budget-policy.example.yaml — $20/mo, routing_order, approval gates
- [x] MODEL_FLOATING_NOTES.md — beginner scan for all models
- [x] show-model-notes.sh / choose-model-for-task.sh / save-learning-example.sh
- [x] setup-learning-memory.sh — 7 subfolders per profile + .gitkeep
- [x] Skills: model-selector, budget-gatekeeper, local-learning-loop, local-rag-ingester, escalation-reviewer, model-cheatsheet
- [x] LOCAL_RAG_STRATEGY.md + LOCAL_LLM_IMPROVEMENT_ROADMAP.md
- [x] README local-first strategy + daily SOP

## Skills (11)

- [x] cursor-prompt-builder
- [x] test-failure-explainer
- [x] project-memory-summarizer
- [x] ai-tool-builder
- [x] commerceos-guardrail-reviewer
- [x] model-selector
- [x] budget-gatekeeper
- [x] local-learning-loop
- [x] local-rag-ingester
- [x] escalation-reviewer
- [x] model-cheatsheet

## Docs (10)

- [x] INSTALL_WSL2_DOCKER.md
- [x] MODEL_SETUP.md
- [x] SAFETY_RULES.md
- [x] BEGINNER_USAGE.md
- [x] TROUBLESHOOTING.md
- [x] PROJECT_ISOLATION.md
- [x] OFFLINE_FIRST.md
- [x] COMPLETION_STATUS.md
- [x] MODEL_FLOATING_NOTES.md
- [x] LOCAL_RAG_STRATEGY.md
- [x] LOCAL_LLM_IMPROVEMENT_ROADMAP.md

## Verify locally

```bash
bash scripts/setup-workspaces.sh
bash scripts/setup-learning-memory.sh
bash scripts/test-hybrid-routing.sh
```

Existing `.env` is preserved — not overwritten by rebuild.
