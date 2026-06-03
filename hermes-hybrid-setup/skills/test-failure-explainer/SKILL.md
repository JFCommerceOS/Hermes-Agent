# Test failure explainer

Explain test failures clearly and propose minimal fixes — prefer **local** models for iteration.

## When to use

- CI or local test output is noisy
- User pastes a failing test log

## Steps

1. Identify failure type: assertion, timeout, env, flake, dependency.
2. Map task to `test_fix` → model `local_qwen_coder` via router.
3. Propose the smallest code change; cite file paths under active workspace only.
4. Suggest one verification command — do not run destructive fixes without approval (T6).
5. If failure touches production or shared DB, stop and cite `ALLOW_PRODUCTION_DB=false`.

## Output

- **What failed** (one paragraph)
- **Likely cause** (ranked bullets)
- **Minimal fix** (diff-sized scope)
- **How to verify**

## Safety

Tier T3 unless edits are required (T2). No git push.
