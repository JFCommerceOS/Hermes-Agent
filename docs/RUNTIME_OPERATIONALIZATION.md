# Runtime operationalization

How to run Hermes hybrid **daily** on Windows — local-first, budget-safe, profile-isolated.

---

## Runtime options

| Environment | Best for | Notes |
|-------------|----------|-------|
| **Git Bash** | Scripts, model routing, eval | Use for all `bash scripts/*.sh` |
| **PowerShell** | Ollama, Hermes CLI, file edits | Native Windows paths (`D:\...`) |
| **WSL2** | Full Hermes + Docker sandbox | Recommended long-term runtime per Nous docs |

**Recommended path:** develop scripts in Git Bash today; move Hermes runtime to WSL2 when you need full terminal tooling — see [INSTALL_WSL2_DOCKER.md](INSTALL_WSL2_DOCKER.md).

---

## Daily startup flow

### 1. Open terminal in hybrid setup

```powershell
cd D:\hermes-agent-project\hermes-hybrid-setup
```

Or Git Bash:

```bash
cd /d/hermes-agent-project/hermes-hybrid-setup
```

### 2. Start local model (Ollama)

```powershell
# Ensure Ollama is running (Windows tray or service)
ollama serve   # if not already running

# Pull models once (if not done)
ollama pull qwen2.5-coder:14b
ollama pull gemma2:9b
```

Verify:

```bash
bash scripts/test-local-model.sh
# Or skip if not ready: SKIP_LOCAL_MODEL_TEST=1 in .env
```

### 3. Check environment

```bash
bash scripts/check-environment.sh
```

### 4. Model notes and routing

```bash
bash scripts/show-model-notes.sh
bash scripts/choose-model-for-task.sh coding
```

For CommerceOS sandbox work:

```bash
bash scripts/choose-model-for-task.sh commerceos
```

### 5. Start Hermes

```powershell
$env:HERMES_HOME = "D:\hermes-agent-project"
hermes
```

Session opener (paste in Hermes):

```text
Active profile: commerceos-dev-agent
Load skill model-selector.
Task: <your task> — local first, no git push, no prod DB.
```

### 6. Use skills during work

| Skill | When |
|-------|------|
| `model-selector` | Start of any task — pick cheapest safe model |
| `budget-gatekeeper` | Before any paid API call |
| `escalation-reviewer` | Local answer weak after 2 attempts |
| `local-learning-loop` | After verified success |
| `local-rag-ingester` | Before adding content to RAG |
| `model-cheatsheet` | Forgot which model to use |

### 7. Save learning example

```bash
bash scripts/save-learning-example.sh commerceos-dev first-test
# Edit the created file under memories/commerceos-dev/learning-log/YYYY-MM-DD/
```

### 8. Log paid spend (manual)

If you used a paid API:

```bash
bash scripts/spend-log.sh deepseek deepseek_flash my-task 0.01 "reason for paid call"
```

---

## Beginner command flow (copy-paste)

```powershell
cd D:\hermes-agent-project\hermes-hybrid-setup
```

```bash
bash scripts/show-model-notes.sh
bash scripts/choose-model-for-task.sh coding
bash scripts/save-learning-example.sh commerceos-dev first-test
```

```powershell
$env:HERMES_HOME = "D:\hermes-agent-project"
hermes
```

---

## Windows vs Git Bash path notes

| Context | Path style |
|---------|------------|
| PowerShell | `D:\hermes-agent-project\hermes-hybrid-setup` |
| Git Bash | `/d/hermes-agent-project/hermes-hybrid-setup` |
| `.env` | `HERMES_WORKSPACE_ROOT=D:/hermes-agent-project/hermes-hybrid-setup` |

---

## What remains manual

| Item | Why |
|------|-----|
| API keys in `.env` | Never committed — you add privately |
| Ollama start / model pull | OS-level service |
| Hermes `hermes setup` | One-time provider config |
| Paid API calls | You approve; scripts never auto-call paid APIs |
| Spend logging | `spend-log.sh` — manual append to CSV |
| RAG index build | Prototype design only — see [RAG_INDEX_PROTOTYPE.md](RAG_INDEX_PROTOTYPE.md) |
| Evaluation scoring | Human marks pass/fail in eval template |
| Weekly budget review | Spreadsheet or `logs/api-spend/*.csv` |
| WSL2 Hermes install | Optional migration path |

---

## Related docs

- [API_SPEND_CONTROL.md](API_SPEND_CONTROL.md) — budget and stop rules
- [LOCAL_MODEL_EVALUATION.md](LOCAL_MODEL_EVALUATION.md) — 20 benchmark tasks
- [RAG_INDEX_PROTOTYPE.md](RAG_INDEX_PROTOTYPE.md) — local RAG SOP
- [BEGINNER_USAGE.md](BEGINNER_USAGE.md) — first week walkthrough
