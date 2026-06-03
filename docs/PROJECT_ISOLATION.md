# Project isolation

## Standalone by design

`hermes-hybrid-setup` is a **self-contained** project under `D:\hermes-agent-project\`. It must not:

- Symlink to `D:\CommerceOS` or any CommerceOS git checkout
- Run "link repo" or "mount CommerceOS" bootstrap scripts
- Read secrets or production config from external CommerceOS paths

The `commerceos-dev-agent` profile is a **sandbox theme** only — its workspace is `workspaces/commerceos-dev/`, not the CommerceOS monorepo.

## Profile boundaries

| Profile | Workspace | Memory |
|---------|-----------|--------|
| lifeos-agent | workspaces/lifeos | memories/lifeos |
| commerceos-dev-agent | workspaces/commerceos-dev | memories/commerceos-dev |
| homeos-agent | workspaces/homeos | memories/homeos |
| research-agent | workspaces/research | memories/research |

`sandbox` workspace exists for throwaway experiments without a dedicated memory profile.

## Cross-project memory — forbidden

Agents must not:

- Copy learnings from `memories/lifeos` into `memories/commerceos-dev` without explicit export + user review
- Load another profile's `examples/` during a session

Skill `project-memory-summarizer` writes only to the active profile path.

## Git push — forbidden by default

`ALLOW_GIT_PUSH=false` blocks tier T5 push actions. Any push requires a deliberate `.env` change **and** user approval in session.

## Moving this folder

1. Copy the entire `hermes-hybrid-setup` directory.
2. Update `HERMES_WORKSPACE_ROOT` in `.env`.
3. Re-run `bash scripts/bootstrap-offline.sh`.

No CommerceOS path updates required — there is no link.
