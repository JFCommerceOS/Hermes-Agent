# CommerceOS guardrail reviewer

Extra review for **commerceos-dev-agent** sandbox work — **not** a link to the CommerceOS monorepo.

## When to use

- Profile is `commerceos-dev-agent`
- Changes resemble e-commerce, inventory, or POS patterns

## Guardrails

1. Confirm edits stay in `workspaces/commerceos-dev/` only.
2. Reject requests to symlink `D:\CommerceOS` or import production secrets.
3. Block `ALLOW_PRODUCTION_DB` scenarios — sandbox data only.
4. Flag PII in logs or memory writes.
5. Recommend `commerceos-dev-agent` tier T2 max unless user escalates with approval.

## Review output

- **Isolation**: pass/fail
- **Safety tier**: recommended T0–T8
- **Risks**: data, payments, auth
- **Go / no-go** for implementation

## Model

Use `local_qwen_coder` for review drafts; `final_review` → `claude_sonnet` only with approval.
