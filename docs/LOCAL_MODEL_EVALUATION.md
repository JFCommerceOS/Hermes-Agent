# Local model evaluation (20 benchmark tasks)

Use to score **local_qwen_coder** and **local_gemma_helper** before escalating to paid APIs. Human marks pass/fail in `evaluations/YYYY-MM-DD/results.md` (created by `run-local-eval.sh`).

**Rules:** no secrets in prompts; no paid API in eval script; profile-scoped where noted.

---

## How to run

```bash
bash scripts/run-local-eval.sh
# Optional: run one task against local Ollama if LOCAL_MODEL_BASE_URL is set
```

---

## Coding tasks (5)

### E01 — Explain a function

**Prompt:**  
Explain what this Python function does in 3 bullet points. Do not rewrite it.

```python
def clamp(value, low, high):
    return max(low, min(value, high))
```

**Expected checklist:**
- Mentions bounding/limiting value between low and high
- Correct min/max order
- No hallucinated side effects

**Pass:** 2+ checklist items correct. **Fail:** wrong logic or invented behavior.

**Escalation:** if fail twice → `qwen_coder_api`.

---

### E02 — Small bug fix suggestion

**Prompt:**  
This loop should sum a list of integers but returns 0. What's wrong?

```python
total = 0
for n in numbers:
    total = n
```

**Expected checklist:**
- Identifies missing `total += n` or equivalent
- Suggests correct fix

**Pass:** identifies accumulation bug. **Fail:** unrelated advice.

**Escalation:** fail twice → `qwen_coder_api`.

---

### E03 — Cursor prompt draft

**Prompt:**  
Draft a Cursor prompt to add a hello-world script in `workspaces/sandbox/` only. Include: no git push, no prod DB, run tests if any.

**Expected checklist:**
- Scoped to sandbox
- Safety constraints present
- Clear objective

**Pass:** 2+ items. **Fail:** missing safety or wrong path.

**Escalation:** fail twice → `deepseek_flash` (if non-secret).

---

### E04 — Refactor plan (local draft)

**Prompt:**  
Outline 3 steps to split a 200-line `utils.py` into `utils/` package without changing behavior. No code yet.

**Expected checklist:**
- Incremental steps
- Mentions tests or verification
- No destructive rewrite

**Pass:** reasonable plan. **Fail:** "rewrite everything" with no tests.

**Escalation:** large repo → `gpt_5_mini` with approval.

---

### E05 — Type hint addition

**Prompt:**  
Add type hints to: `def merge(a, b): return {**a, **b}`

**Expected checklist:**
- Uses `dict` or `Mapping` types
- Return type mentioned

**Pass:** syntactically valid hints. **Fail:** wrong types or syntax errors.

**Escalation:** fail twice → `qwen_coder_api`.

---

## Debug / log tasks (5)

### E06 — Parse error line

**Prompt:**  
What failed?  
`ModuleNotFoundError: No module named 'yaml'`

**Expected checklist:**
- Missing Python package PyYAML
- Suggest pip install pyyaml or fix import

**Pass:** correct module/package. **Fail:** blames wrong layer.

**Escalation:** fail twice → `qwen_coder_api`.

---

### E07 — Test failure summary

**Prompt:**  
Summarize: `AssertionError: expected 200 got 404` on `GET /api/health`

**Expected checklist:**
- Endpoint returned 404 not 200
- Suggests route/server/downstream check

**Pass:** correct status interpretation. **Fail:** ignores 404.

**Escalation:** fail twice → `qwen_coder_api`.

---

### E08 — Log triage priority

**Prompt:**  
Order by urgency (1=highest): (A) disk 95% full (B) debug log line (C) auth 401 spike on login

**Expected checklist:**
- C or A before B
- Brief reason per item

**Pass:** sensible ordering with reasons. **Fail:** debug over auth spike.

**Escalation:** high-risk prod → human + optional `gpt_5_mini`.

---

### E09 — Stack trace root cause

**Prompt:**  
Root cause?  
`KeyError: 'tenant_id'` at `get_settings()` line 42

**Expected checklist:**
- Missing config key tenant_id
- Suggest env/config validation

**Pass:** KeyError explained. **Fail:** unrelated database theory.

**Escalation:** fail twice → `qwen_coder_api`.

---

### E10 — Safe rerun command

**Prompt:**  
Suggest a safe rerun for failed unit tests in `./workspaces/sandbox/` only. No deploy, no prod.

**Expected checklist:**
- Scoped test command (pytest/npm test etc.)
- No production references

**Pass:** sandbox-scoped command. **Fail:** prod deploy commands.

**Escalation:** n/a for local.

---

## Project planning tasks (5)

### E11 — Daily plan bullets

**Prompt:**  
Turn into 5 actionable bullets: "Fix login bug, document API, review budget, pull Ollama model, save learning example."

**Expected checklist:**
- 5 distinct bullets
- Action verbs
- No invented tasks

**Pass:** 5 clear bullets. **Fail:** vague or wrong count.

**Escalation:** fail twice → `deepseek_flash`.

---

### E12 — SOP outline

**Prompt:**  
Outline SOP: "Start Hermes session with profile commerceos-dev-agent, local first."

**Expected checklist:**
- Steps: profile, model check, safety
- Local-first mentioned

**Pass:** ordered steps. **Fail:** skips profile isolation.

**Escalation:** n/a local.

---

### E13 — Risk list

**Prompt:**  
List 3 risks of sending `.env` contents to an online model.

**Expected checklist:**
- Secret leakage
- Credential exposure
- Compliance/privacy

**Pass:** 2+ real risks. **Fail:** says it's fine.

**Escalation:** n/a — should pass locally.

---

### E14 — Task breakdown

**Prompt:**  
Break down "add spend logging script" into 4 subtasks for a beginner.

**Expected checklist:**
- CSV format, validation, folder create, docs
- Ordered sensibly

**Pass:** 4 concrete subtasks. **Fail:** one vague step.

**Escalation:** fail twice → `deepseek_flash`.

---

### E15 — Weekly review checklist

**Prompt:**  
Give 6-item weekly review checklist for Hermes hybrid budget + learning memory.

**Expected checklist:**
- Budget/spend review
- Learning memory / RAG
- Local vs paid ratio

**Pass:** 6 relevant items. **Fail:** generic unrelated list.

**Escalation:** n/a local.

---

## CommerceOS guardrail tasks (3)

*Profile: commerceos-dev only. No real prod data in prompts.*

### E16 — Tenant isolation rule

**Prompt:**  
State one rule: why tenant A must not read tenant B data in a multi-tenant app. 2 sentences max.

**Expected checklist:**
- Isolation / data leak prevention
- No fabricated tenant names with secrets

**Pass:** correct isolation principle. **Fail:** allows cross-tenant access.

**Escalation:** final governance → `commerceos-guardrail-reviewer` + premium with approval.

---

### E17 — RBAC change review

**Prompt:**  
A PR adds `admin` role to all users by default. What is wrong? One paragraph.

**Expected checklist:**
- Privilege escalation / least privilege
- Suggests deny-by-default or review

**Pass:** identifies RBAC flaw. **Fail:** approves blanket admin.

**Escalation:** high risk → `gpt_5_mini` + approval.

---

### E18 — Audit trail requirement

**Prompt:**  
Why must accounting adjustments keep an audit trail? 3 bullets for commerceos-dev context.

**Expected checklist:**
- Traceability
- Compliance or reconciliation
- No prod DB access suggested

**Pass:** 2+ valid bullets. **Fail:** suggests deleting logs.

**Escalation:** accounting final → human + `claude_sonnet` with approval.

---

## RAG recall tasks (2)

*Requires content in `memories/<profile>/rag-ready/` or docs — baseline vs RAG comparison.*

### E19 — Model floating note recall

**Prompt:**  
Without guessing: what is `local_qwen_coder` **not** for? Cite project docs concept (final security, accounting approval, etc.).

**Expected checklist:**
- Matches MODEL_FLOATING_NOTES / catalog weak_for
- Does not invent new weaknesses

**Pass:** 1+ correct weak_for. **Fail:** says it's fine for final security sign-off.

**Escalation:** n/a — doc recall task.

**RAG test:** index includes `docs/MODEL_FLOATING_NOTES.md`; compare answer with/without retrieval.

---

### E20 — Profile isolation recall

**Prompt:**  
Can LifeOS memory be used in a commerceos-dev-agent session? Why not? 2 sentences.

**Expected checklist:**
- No cross-profile memory
- References isolation / PROJECT_ISOLATION or LOCAL_RAG_STRATEGY

**Pass:** clear no + reason. **Fail:** allows mixing profiles.

**Escalation:** n/a.

**RAG test:** index includes `docs/PROJECT_ISOLATION.md` or `LOCAL_RAG_STRATEGY.md`.

---

## Scoring summary

| ID | Category | Default model |
|----|----------|---------------|
| E01–E05 | Coding | local_qwen_coder |
| E06–E10 | Debug/log | local_qwen_coder |
| E11–E15 | Planning | local_gemma_helper |
| E16–E18 | CommerceOS guardrail | local_qwen_coder → review |
| E19–E20 | RAG recall | local_gemma_helper |

**Monthly:** re-run full set; track pass rate in `evaluations/YYYY-MM-DD/summary.md`.
