# Troubleshooting

## `.env` not loading / variables empty

- Ensure file is `hermes-hybrid-setup/.env` (not only `.env.example`).
- Windows CRLF is supported — `scripts/lib/load-env.sh` strips `\r`.
- In Git Bash, source via scripts; do not hand-edit export syntax with spaces around `=`.

## `test-local-model.sh` fails

- Start Ollama: `ollama serve` (or Ollama tray app).
- Pull model: `ollama pull qwen2.5-coder:14b`
- Temporary bypass: `SKIP_LOCAL_MODEL_TEST=1` in `.env`.

## `test-online-model.sh` fails

- Placeholder key → test should **SKIP**; if not, check key does not contain `your-online-api-key`.
- Or set `ONLINE_MODEL_SKIP=true`.
- Verify outbound HTTPS from Git Bash (`curl https://openrouter.ai`).

## `test-hybrid-routing.sh` fails

- Confirm `configs/model-router.example.yaml` has `long_planning.model: claude_sonnet`.
- Run `bash scripts/choose-model-for-task.sh final-review` — must print `claude_sonnet`.
- If `load-yaml-key.sh` errors, check file path and indentation (2 spaces).

## Permission denied on `.sh` scripts

```bash
chmod +x scripts/*.sh scripts/lib/*.sh
```

## Docker warning in check-environment

Set `ENABLE_DOCKER_SANDBOX=false` if you do not use containers.

## Wrong workspace path

Set Git Bash style paths in `.env`:

```env
HERMES_WORKSPACE_ROOT=D:/hermes-agent-project/hermes-hybrid-setup
```

## Skills not visible in Cursor

```bash
bash scripts/install-skills.sh
```

Point to your Cursor skills folder if non-default.
