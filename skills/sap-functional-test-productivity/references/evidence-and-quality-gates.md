# Evidence and Quality Gates

Formats are in `templates.md`.

## 0. Evidence levels

Grade evidence before judging a result. High-risk tests require `L3` or `L4`; anything at `L0`–`L1`
cannot support a `PASSED`.

| Level | What it shows |
|---|---|
| `L0` | Narrative only — "I tested it and it worked" |
| `L1` | A single screenshot with no input or context |
| `L2` | Input plus visible result |
| `L3` | Input, result, **and** the created or changed business document / backend consequence |
| `L4` | `L3` plus traceability to the test case, environment, timestamp, and reproducibility |

When evidence is insufficient, name exactly what is missing and how to capture it. Never write
"please add more evidence".

> ✅ "The screenshot proves the save returned success, but not that the accounting document was
> created. Open the material document's document flow, capture the FI document number and its
> debit/credit lines, and attach both before marking `AC-004` as `PASSED`."

## 1. Evidence Principles

A test result is only as strong as its evidence.

Evidence should answer:

- What was tested?
- With which data?
- Where?
- By whom/which role when relevant?
- What was expected?
- What actually happened?
- Which business object/document proves it?
- Can another person reproduce or verify it?

## 2. Evidence Types

### Screenshot

Good for:

- field values;
- message;
- status;
- visible document number.

Weak when:

- no context;
- cropped too aggressively;
- input data hidden;
- wrong environment not identifiable;
- no timestamp and integration timing matters.

### SAP document record

Strong for:

- generated document;
- status;
- amounts/quantities;
- document flow.

### Log

Strong for:

- processing path;
- message result;
- error timing;
- integration correlation.

### Payload

Strong for:

- mapping;
- source/target field values;
- API behavior.

Redact secrets/tokens/passwords.

### Spreadsheet/test management record

Useful for traceability, but it should reference real evidence for high-risk cases.

## 3. Evidence Checklist by Test Type

### Validation test

Capture:

- input;
- action;
- validation message;
- proof that invalid transaction was not committed if important.

### Document creation

Capture:

- source/input;
- generated document number;
- key fields in generated document;
- status;
- downstream consequence if relevant.

### Financial posting

Capture:

- source document;
- FI document number;
- debit/credit lines or validated accounting result;
- amount/currency;
- reversal when tested.

### Integration

Capture:

- business key;
- source payload;
- middleware/transport status;
- target response/created object;
- final SAP status;
- timestamps/correlation ID.

### Authorization

Capture:

- user/role context;
- attempted action;
- denial/allowed result;
- SU53 or equivalent evidence when available and appropriate.

## 4. Definition of Ready

A demand is `READY` when:

- purpose is clear;
- scope is bounded;
- AS-IS is known enough;
- TO-BE is explicit;
- critical rules are written;
- exception behavior is defined;
- acceptance criteria are testable;
- dependencies are identified;
- major authorization/integration/data impacts are known;
- critical open questions are resolved;
- test data can be obtained.

The full readiness checklist and the exact verdict rules are in `requirement-analysis.md` §9.

### `READY_WITH_RISKS`

Use when work can start but known non-blocking uncertainty remains. List for each: risk, owner,
decision date, effect if unresolved.

### `NOT_READY`

Use when ambiguity can cause incompatible implementations or impossible testing.

## 5. Definition of Done

| # | Check | Met? |
|---|---|---|
| 1 | All critical acceptance criteria passed | |
| 2 | Planned `P0`/`P1` tests passed or explicitly accepted | |
| 3 | Critical negative tests executed, not just happy paths | |
| 4 | Regression executed at the scope the change warrants | |
| 5 | Defects resolved or formally accepted | |
| 6 | Evidence sufficient (`L3`+ on high-risk cases) | |
| 7 | Business outcome verified, not only the UI action | |
| 8 | Documentation and status updated | |
| 9 | No hidden blocking dependency remains | |

- `DONE` — all met.
- `DONE_WITH_RESIDUAL_RISK` — met except for risks that are explicit, impact-assessed and **owned**.
- `NOT_DONE` — any of 1, 3, 6 or 7 unmet.

Transport completion is never proof. Neither is "the developer said it was fixed".

## 6. Go/No-Go Gate

### `GO`

- no open release-blocking defect;
- critical business flows passed;
- regression sufficient for the change;
- integration and authorization critical paths passed;
- evidence sufficient;
- operational dependencies ready.

### `GO_WITH_ACCEPTED_RISK`

Use only when the risk is explicit, its impact is understood, a workaround or contingency is known
where appropriate, it does not violate a mandatory control, and **a named person accepts it**.

A risk with no owner is not accepted — it is ignored. Drop the verdict to `NO_GO`.

### `NO_GO`

Examples:

- critical rule failed;
- financial/data integrity uncertain;
- major regression failed;
- interface reconciliation incomplete;
- defect cannot be reproduced but evidence indicates severe unresolved risk;
- required transport/config dependency missing;
- acceptance evidence absent for critical scope.

## 7. Residual Risk Record

For each accepted risk capture:

- risk;
- affected process;
- probability qualitative;
- impact;
- workaround;
- owner;
- expiry/review date;
- post-go-live monitoring if needed.

## 8. UAT Sign-off Pack

Recommended contents:

- scope;
- business owners;
- acceptance criteria;
- executed tests summary;
- passed/failed/not-run counts;
- critical evidence links/IDs;
- defects and disposition;
- regression summary;
- residual risks;
- sign-off decision.
