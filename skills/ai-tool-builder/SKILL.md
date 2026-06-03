# AI tool builder

Design small scripts, MCP helpers, or CLI tools inside the hybrid setup — standalone, no external repo links.

## When to use

- User wants automation around Hermes hybrid scripts
- Building a helper under `workspaces/sandbox/` or active profile

## Steps

1. Prefer bash in `scripts/` or profile `scratch/` — match existing conventions.
2. Source `scripts/lib/load-env.sh` for `.env` access.
3. Document usage in README or `docs/` only when user asks.
4. Gate network and git push per safety policy.
5. Never add CommerceOS symlink or link scripts.

## Checklist

- [ ] Works in Git Bash on Windows
- [ ] CRLF-safe if reading `.env`
- [ ] Idempotent / safe to re-run
- [ ] Clear SKIP behavior when deps missing

## Model

`coding` → `local_qwen_coder`; escalate only if user approves API budget.
