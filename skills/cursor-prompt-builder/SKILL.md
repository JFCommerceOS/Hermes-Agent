# Cursor prompt builder

Build high-quality Cursor agent prompts for tasks in the **active profile workspace only**.

## When to use

- Starting a multi-step feature in `workspaces/<profile>/`
- User asks for a "prompt template" or "agent brief"

## Steps

1. Read `ACTIVE_PROFILE` or `DEFAULT_PROJECT_PROFILE` from `.env`.
2. Confirm target paths stay inside `workspaces/<profile>/` per `docs/PROJECT_ISOLATION.md`.
3. Include: goal, constraints, safety tier (T0–T8), suggested model from `scripts/choose-model-for-task.sh`.
4. Add verification commands (tests, lint) appropriate to the stack.
5. Never instruct auto `git push` or production DB access.

## Output format

```markdown
## Goal
## Context (files)
## Constraints (safety tier, model)
## Steps
## Verification
## Out of scope
```

## Model hint

Run `bash scripts/choose-model-for-task.sh <task_type>` and paste the catalog id into the prompt.
