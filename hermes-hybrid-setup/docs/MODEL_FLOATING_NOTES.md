# Model floating notes (beginner scan)

Use with `bash scripts/show-model-notes.sh` and skill `model-cheatsheet`.  
**Default:** try **local** first. **Paid** needs a reason. **Premium** needs approval.

---

## Local Qwen Coder (`local_qwen_coder`)

**Use for:** code explanation, small bug fixes, terminal logs, Cursor prompt drafts, local skill drafts.

**Why:** free on your GPU; strong coding helper; keeps daily cost at $0.

**Do not use for:** final security sign-off, accounting/audit approval, production deploy decisions, whole-repo architecture alone.

**Cost warning:** free after hardware/electricity — still costs your time if wrong.

**Privacy warning:** safest — runs on your machine; keep secrets out of prompts anyway.

**Escalate to:** Qwen Coder API (harder code) → DeepSeek Flash (cheap plan) → GPT-5 mini (risky arch) → Claude Sonnet (final review).

**Memory note:** *Local Qwen = first coding helper.*

---

## Local Gemma Helper (`local_gemma_helper`)

**Use for:** private notes, summarization, local RAG answers, offline reasoning, personal memory cleanup.

**Why:** cheapest private path; good enough for bullets and recall.

**Do not use for:** complex coding finals, high-risk architecture, production decisions.

**Cost warning:** free local.

**Privacy warning:** best for **private** profile work — never mix LifeOS notes into commerceos-dev memory.

**Escalate to:** Local Qwen Coder (light code) → DeepSeek Flash (only if non-secret).

**Memory note:** *Gemma = private summarizer.*

---

## DeepSeek Flash (`deepseek_flash`)

**Use for:** cheap online reasoning, planning, SOP drafts, first paid escalation when local is weak.

**Why:** low $/token; good for longer thinking on a **$20/mo** budget.

**Do not use for:** secrets, production DB snippets, final CommerceOS governance, sensitive business data.

**Cost warning:** cheap but adds up — max ~3 paid calls/session without approval.

**Privacy warning:** **online** — redact tenant IDs, credentials, PII.

**Escalate to:** Qwen Coder API → GPT-5 mini → Claude Sonnet.

**Memory note:** *DeepSeek = first cheap cloud step.*

---

## Qwen Coder API (`qwen_coder_api`)

**Use for:** harder coding, refactor plans, test failure diagnosis, agentic skill/tool design.

**Why:** coding-specialist online tier before GPT/Claude price.

**Do not use for:** secrets, prod DB, final security approval alone.

**Cost warning:** cheap_medium — confirm with `budget-gatekeeper` skill.

**Privacy warning:** online — workspace-only context; no `.env` contents.

**Escalate to:** GPT-5 mini → Claude Sonnet.

**Memory note:** *Qwen API = online coding step-up.*

---

## GPT-5 Mini (`gpt_5_mini`)

**Use for:** serious architecture, complex debugging, CommerceOS governance **draft**, agentic system planning.

**Why:** stronger reasoning than cheap tiers; still below Claude for final polish.

**Do not use for:** simple summaries, loops without approval, daily default.

**Cost warning:** **medium_high** — approval if estimated > $0.25 or premium rules hit.

**Privacy warning:** online — minimal context; never full repo without confirmation.

**Escalate to:** Claude Sonnet for final review.

**Memory note:** *GPT-5 mini = important paid reasoning.*

---

## Claude Sonnet (`claude_sonnet`)

**Use for:** final review, SOP quality, security review, doc quality, second-opinion architecture.

**Why:** highest quality in this catalog — use sparingly.

**Do not use for:** daily work, log triage, repeated cheap tasks.

**Cost warning:** **high** — explicit human approval every session.

**Privacy warning:** online — send only redacted, necessary excerpts.

**Escalate to:** none (top tier).

**Memory note:** *Claude = expensive final reviewer only.*

---

## Quick decision tree

1. **Secret/private?** → `local_gemma_helper` only unless you approve online + redaction.
2. **Coding/debug?** → `local_qwen_coder` → escalate per script.
3. **CommerceOS governance?** → local draft → `gpt_5_mini` / `claude_sonnet` with **approval**.
4. **Unsure?** → `bash scripts/choose-model-for-task.sh <type>`
