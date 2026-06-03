# Beginner usage

This guide assumes **Git Bash** on Windows and zero prior Hermes experience.

## Day 0 — folder sanity

1. Open Git Bash.
2. `cd /d/hermes-agent-project/hermes-hybrid-setup`
3. If you need a fresh env file: `cp .env.example .env` (skip if `.env` already exists).
4. Edit `.env` — at minimum set:
   ```env
   HERMES_WORKSPACE_ROOT=D:/hermes-agent-project/hermes-hybrid-setup
   SKIP_LOCAL_MODEL_TEST=1
   ONLINE_MODEL_SKIP=true
   ```
5. Run:
   ```bash
   bash scripts/bootstrap-offline.sh
   ```

You should see workspace folders and a passing routing test.

## Day 1 — pick a profile

```bash
cp ACTIVE_PROFILE.example ACTIVE_PROFILE
# edit ACTIVE_PROFILE — e.g. commerceos-dev-agent
bash scripts/setup-workspaces.sh
```

Work only inside the matching `workspaces/<name>/` directory.

## Day 2 — local model

1. Install Ollama, pull `qwen2.5-coder:14b`.
2. Set `SKIP_LOCAL_MODEL_TEST=0` in `.env`.
3. `bash scripts/test-local-model.sh`

## Day 3 — ask the agent with routing

Before a big task, check the model:

```bash
bash scripts/choose-model-for-task.sh coding
bash scripts/show-model-notes.sh local_qwen_coder
```

## Day 4 — online model (optional)

1. Add OpenRouter key to `.env`.
2. Set `ONLINE_MODEL_SKIP=false`.
3. `bash scripts/test-online-model.sh`

## Day 5 — save what you learned

```bash
bash scripts/save-learning-example.sh refactor good-patterns notes.txt
```

## Habits that keep you safe

- Do not set `ALLOW_*` gates to `true` casually.
- Run `final-review` tasks only when you mean it — they route to Claude Sonnet (cost).
- Read [SAFETY_RULES.md](SAFETY_RULES.md) once.

## Help

- Stuck? [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Isolation rules: [PROJECT_ISOLATION.md](PROJECT_ISOLATION.md)
