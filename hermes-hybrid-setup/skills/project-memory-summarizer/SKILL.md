# Project memory summarizer

Summarize session progress into the **active profile** memory folder only.

## When to use

- End of session, before context window resets
- User asks to "remember this for next time"

## Steps

1. Resolve profile → `memories/<profile>/summaries/`.
2. Write a dated markdown summary: decisions, open questions, next steps.
3. Do **not** read or write other profiles' `memories/` trees (forbidden cross-project memory).
4. Optional: call `scripts/save-learning-example.sh` for reusable patterns.

## Output path

`memories/<profile>/summaries/YYYY-MM-DD-session.md`

## Safety

Tier T1–T2. No secrets, API keys, or production credentials in summaries.
