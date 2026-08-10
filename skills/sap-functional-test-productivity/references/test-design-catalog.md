# SAP Functional Test Design Catalog

Use this reference to expand test coverage systematically. Apply only relevant categories; do not
create meaningless cases simply to fill a checklist. Formats are in `templates.md`.

---

## 0. Before writing cases

### 0.1 Strategy first

Summarize before producing a matrix: scope and out-of-scope; the top risks; test levels required;
environments; data needs; dependencies; exit criteria. A matrix written without this covers the
document instead of the risk.

### 0.2 Coverage dimensions

For each business rule, decide whether each dimension applies. Skipping a dimension is a decision —
say so; silently omitting it is a gap.

**Core functional** — standard happy path; alternate valid path; negative path; invalid input;
missing mandatory input; null/empty; boundary min and max; over and under limit; duplicate;
already-processed object; canceled or reversed object; ineligible status; stale or changed data;
repeated action.

**State and lifecycle** — initial, intermediate and final state; invalid transition; re-open or
reprocess; cancellation; reversal; retry after failure; retry after partial success.

**Authorization** — authorized user; unauthorized user; display-only user; different organizational
scope; role removed after prior access; segregation-of-duties scenario.

**Data** — valid master data; missing master data; blocked master data; deletion-flagged master data;
cross-plant and cross-company behavior; special and accented characters; leading zeros; locale, date
and currency differences; high volume where relevant.

**Integration** — valid payload; missing field; invalid field; mapping mismatch; target unavailable;
timeout; retry; duplicate message; out-of-order message; partial response; authentication failure;
downstream business rejection; asynchronous delay; reprocessing.

**Regression** — original behavior preserved; adjacent rules preserved; old status transitions
preserved; historical and open documents handled correctly; unaffected organizational units
unchanged; existing integrations still compatible.

### 0.3 Priority

`P0` release is impossible without it passing · `P1` high business or financial risk ·
`P2` meaningful, not release-blocking by default · `P3` edge or usability coverage.

Priority follows risk, not document order. A negative case on a financial posting outranks a happy
path on a display field.

### 0.4 Traceability

Build `Requirement → BR → AC → TC → Evidence → Defect` and flag:

- a requirement with no test;
- a test with no requirement or risk behind it;
- an acceptance criterion covered only by a happy path;
- a critical business rule with no negative test;
- a fixed defect with no permanent regression case.

### 0.5 Reject weak cases

Improve or reject a case that: says only "check if it works"; has no expected result; uses ambiguous
test data; bundles several independent behaviors; cannot be reproduced; depends on undocumented
environment state; verifies a UI message when the business document is what matters; omits the
condition that makes the case unique; **or would still pass if the wrong behavior occurred**.

That last one is the strongest filter. Before accepting a case, ask: *if the bug were present, would
this test fail?*

> ❌ `TC-014 — Create a purchase order for a blocked vendor and check the result.`
> Passes whether the PO is blocked or created — "the result" is whatever happens.
>
> ✅ `TC-014 — Given vendor <VENDOR_1> with purchasing block on plant 1000, saving a PO must be
> rejected with message ZMM 042 and no PO number generated. Verify in the vendor's document list that
> no new PO exists.`
> Fails if the block is not enforced, and the backend check catches a UI-only rejection.

---

### 0.6 How to use the catalog below

Sections 1–24 are prompts, not a coverage requirement. Walking all of them for every rule produces
noise; ignoring them produces happy-path suites. The workflow is:

1. Pick the sections the rule actually touches. A validation rule needs §1, §2, §6 and §16. A status
   change needs §4 and §23. A posting needs §11.
2. For each item in that section, ask **"could this behave differently, and would anyone notice?"**
   If no to either, skip it and do not write a case.
3. Turn the surviving items into cases with a concrete expected result — the list gives you the
   *condition*, you supply the *expectation*.

An item you skipped deliberately is a decision. An item you never considered is a gap. Say which is
which when the coverage is questioned.

---

## 1. Functional Equivalence Partitions

Identify meaningful valid and invalid classes rather than testing random values.

Examples:

- valid document type / invalid document type;
- active material / blocked material;
- eligible status / ineligible status;
- authorized plant / unauthorized plant;
- supported currency / unsupported currency;
- active vendor / blocked vendor.

For each partition, choose a representative value and state why it matters.

## 2. Boundary Value Analysis

For numeric, date, quantity, amount, length, count, or threshold rules, consider:

- minimum - 1;
- exact minimum;
- minimum + 1;
- normal value;
- maximum - 1;
- exact maximum;
- maximum + 1;
- zero;
- negative;
- very large value;
- decimal precision edge;
- rounding edge.

For dates:

- day before rule starts;
- exact start date;
- day after start;
- month-end;
- year-end;
- leap day when relevant;
- fiscal period close;
- timezone boundary in integrations.

> **Applied.** Rule: "purchase orders above R$ 50.000,00 require approval."
> The list collapses to four cases that matter: `49.999,99` (no approval), `50.000,00` (the ambiguity
> — is the rule `>` or `>=`? if the spec does not say, this is a `Q-###` before it is a test),
> `50.000,01` (approval), and `0,00`. Add a fifth if the amount can be in a foreign currency: the
> threshold applies to the document currency or the company code currency, and the exchange rate date
> decides which side of the boundary a document lands on. That fifth case is where the real defect
> usually is.
>
> Not worth a case: `999.999.999,00`. It exercises nothing the `50.000,01` case does not, unless a
> field length or a rounding rule is in scope.

## 3. Decision Table Testing

Use when outcome depends on multiple conditions.

Example structure:

| Condition | Rule 1 | Rule 2 | Rule 3 | Rule 4 |
|---|---:|---:|---:|---:|
| Document eligible | Y | Y | N | N |
| User authorized | Y | N | Y | N |
| Required master data exists | Y | Y | Y | N |
| Expected outcome | Process | Deny | Block | Block |

Detect combinations not described by the requirement.

## 4. State Transition Testing

Create a state model when behavior changes by status.

For every transition validate:

- valid source state;
- valid target state;
- invalid transition;
- repeated action;
- cancellation/reversal;
- retry after error;
- system recovery after interruption;
- final state cannot be modified if required;
- old/open objects created before the change.

## 5. CRUD/Data Lifecycle

If the feature creates or maintains data:

- create valid;
- create duplicate;
- create missing mandatory;
- display;
- update editable field;
- update protected field;
- update after status change;
- delete/cancel/reverse;
- recreate after cancellation;
- audit/history if required.

## 6. Field Validation Matrix

For each field consider:

- blank;
- spaces only;
- valid value;
- invalid value;
- maximum length;
- over maximum;
- special characters;
- accented characters;
- leading zeros;
- lowercase/uppercase;
- copied/pasted value;
- value help selection;
- manual entry;
- defaulting;
- dependent field changed after selection;
- field read-only when expected.

## 7. Document Flow Testing

For processes creating follow-on SAP documents, verify the chain, not just the first screen.

Potential checkpoints:

- source document;
- follow-on document number;
- document status;
- quantities/amounts;
- accounting impact;
- stock impact;
- workflow status;
- output/message;
- integration event;
- reconciliation report.

## 8. Authorization Testing

Test the business action with role variants:

- full authorization;
- display only;
- no authorization;
- different organizational level;
- approver vs requester;
- background/interface user if relevant.

Expected result includes not only “denied,” but whether sensitive data remains hidden and whether the error is understandable.

## 9. Organizational-Level Testing

SAP behavior often differs by:

- company code;
- plant;
- storage location;
- purchasing organization/group;
- sales organization/distribution channel/division;
- controlling area;
- personnel area/subarea;
- profit center;
- business area;
- warehouse number;
- maintenance plant/planning plant.

Test at least one representative of each materially different configuration branch.

## 10. Master Data State Testing

For relevant master data:

- active;
- blocked;
- deletion flag;
- missing organizational view;
- missing required attribute;
- valid in different org unit only;
- expired validity;
- future-dated validity;
- duplicated/external mapping inconsistency.

## 11. Financial/Quantity Integrity

For processes affecting amounts or quantities:

- correct sign;
- correct currency;
- exchange rate/date;
- rounding;
- tax effect where in scope;
- debit/credit direction;
- account assignment;
- quantity unit conversion;
- partial quantity;
- over-delivery/under-delivery;
- reversal restores or compensates correctly;
- reconciliation with source document.

> **Applied.** A goods receipt is posted for 100 units at R$ 12,50. The tester screenshots the
> material document and marks the case `PASSED`.
>
> That is `L2` evidence for a `P0` case. What it does not prove: that the accounting document was
> created, that the debit and credit landed on the intended accounts, that the value is
> `100 × 12,50 = 1.250,00` and not the PO price times a different quantity, and that the stock
> quantity moved by 100 rather than by a converted unit. Four of the five ways this can be wrong are
> invisible in the material document.
>
> The case needs the FI document number, its line items, and the stock before/after — `L3`. This is
> why `templates.md` §9 asks for "business/backend verification" as a separate field from "expected
> result": on a financial posting they are never the same thing.

## 12. Batch/Serial/Valuation Special Cases

When relevant:

- batch-managed vs non-batch;
- serial-managed vs non-serial;
- split valuation;
- valuation type missing;
- expired/restricted batch;
- batch determination difference;
- serial count mismatch.

## 13. Workflow/Approval Testing

Cover:

- initiator;
- expected approver;
- no approver found;
- substitute/delegate;
- rejection;
- resubmission;
- multiple approval levels;
- threshold boundary;
- amount changed after submission;
- requester cannot self-approve if prohibited;
- notification/output;
- stuck workflow/restart.

## 14. Background Job Testing

When background processing exists:

- job scheduled;
- job runs with expected variant;
- no-data run;
- partial-data run;
- error row handling;
- rerun/idempotency;
- overlapping execution;
- job failure notification;
- output/spool/log;
- downstream job dependency.

## 15. Integration Functional Testing

At minimum separate:

- source trigger test;
- payload content test;
- mapping test;
- target acceptance test;
- business reconciliation test;
- retry/reprocessing test;
- duplicate test;
- unavailable target test.

## 16. Error Message Testing

Validate:

- correct condition triggers error;
- message identifies the problem;
- message does not expose sensitive technical detail unnecessarily;
- action is blocked or allowed as intended;
- partial data is not incorrectly committed;
- user understands next step;
- message language/localization if required.

## 17. Reprocessing and Idempotency

For any retry/reprocess action, test:

- first attempt succeeds;
- first attempt fails then retry succeeds;
- retry while root problem still exists;
- repeated retry after success;
- duplicate protection;
- partial success before retry;
- retry count limit if any;
- audit/log history;
- final status.

## 18. Cancellation/Reversal

Test:

- eligible cancellation;
- ineligible cancellation;
- already canceled;
- downstream document exists;
- partial processing exists;
- reversal accounting/stock effect;
- integration notification after reversal;
- audit trail;
- recreated/reprocessed transaction.

## 19. Concurrency

When two users/processes can act on the same object:

- two users open same object;
- both attempt update;
- one changes status before the other saves;
- background job processes while user edits;
- duplicate interface event arrives;
- lock behavior;
- stale-data message;
- final data integrity.

## 20. Performance/Volume from Functional View

The functional team need not profile code, but should identify business-volume risks:

- one record;
- normal daily batch;
- peak batch;
- maximum expected file size;
- large selection range;
- high item count document;
- response time expectation;
- timeout behavior;
- partial progress visibility.

## 21. Localization

When applicable:

- decimal separator;
- thousands separator;
- date format;
- language text;
- currency;
- timezone;
- daylight saving behavior;
- country-specific tax/formatting;
- Unicode/special characters.

## 22. Fiori/UI Functional Testing

Check:

- field visibility;
- mandatory indicator;
- value help;
- table filtering/sorting;
- personalization if in scope;
- responsive behavior only when relevant;
- backend error presentation;
- navigation target;
- deep link;
- refresh after update;
- stale cache behavior;
- draft behavior where applicable;
- browser/session differences if observed.

## 23. Regression Heuristic by Change Type

### Validation rule changed

Retest:

- valid case;
- invalid case;
- boundary;
- old valid case;
- old invalid case;
- dependent fields;
- error message.

### Status logic changed

Retest:

- every source state;
- every allowed transition;
- invalid transition;
- final state;
- reprocessing;
- downstream workflow.

### Mapping changed

Retest:

- changed field;
- empty field;
- long/edge value;
- all conditional branches;
- downstream reconciliation;
- backward compatibility.

### Authorization changed

Retest:

- intended allowed role;
- intended denied role;
- adjacent org values;
- display/change separation;
- Fiori/backend consistency.

### Shared custom logic changed

Retest:

- all business processes using the shared rule;
- major organizational branches;
- major document types;
- historical/open documents.

## 24. Test Design Exit Criteria

Test design is strong when:

- every critical rule has at least one proving case;
- every critical validation has a failing case;
- important boundaries are covered;
- important status transitions are covered;
- authorization is covered where applicable;
- integration failure/retry is covered where applicable;
- known defects have regression tests;
- evidence expectations are explicit;
- data is feasible to obtain;
- execution order is practical.
