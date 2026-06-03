# Safety rules

Safety is enforced in three layers: **YAML policy**, **`.env` gates**, and **agent skills**.

## Tiers T0–T8

Defined in `configs/safety-policy.example.yaml`:

| Tier | Name | Typical use |
|------|------|-------------|
| T0 | observation | Read-only inspection |
| T1 | local_draft | Scratch drafts |
| T2 | workspace_edit | Edit inside profile workspace |
| T3 | tooling | Tests, dev docker compose |
| T4 | dependency_change | npm/pip installs (approval) |
| T5 | git_local | Local commits, **no push** |
| T6 | destructive | Deletes/migrations (approval + gate) |
| T7 | production_touch | **Blocked by default** |
| T8 | escalation | Cross-profile / autonomous loops |

## Always forbidden

- Production database read/write
- **Auto git push** (`ALLOW_GIT_PUSH` must stay `false` unless reviewed)
- Destructive commands without explicit approval
- **Cross-project memory** (one profile cannot read another's `memories/` tree)
- Symlinks or scripts linking to external CommerceOS repos

## Environment gates

```env
ALLOW_GIT_PUSH=false
ALLOW_PRODUCTION_DB=false
ALLOW_DESTRUCTIVE_COMMANDS=false
```

`scripts/check-environment.sh` warns if these are enabled.

## Profiles

Each profile in `configs/project-profiles.example.yaml` binds:

- `workspaces/<name>/`
- `memories/<name>/`

Agents must not swap memory paths mid-session without user consent.

## Escalation

For T7–T8 or `final_review` tasks, use models `claude_sonnet` with skill `escalation-reviewer` and human approval.

## CommerceOS guardrail

Skill `commerceos-guardrail-reviewer` applies extra checks in the **commerceos-dev** sandbox — still **no** live CommerceOS repo link.
