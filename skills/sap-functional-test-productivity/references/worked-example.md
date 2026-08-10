# Worked Example — One Demand, End to End

A single realistic demand carried from an ambiguous specification through to a developer handoff and
regression scope. Read it when you are unsure how much detail an artifact needs or how the pieces
connect.

The example is fictional. It is here to show **shape and reasoning**, not to be reused as content —
never copy its business rules into a real analysis.

---

## The input

The analyst receives this by email:

> **CR-4821 — Block purchase orders for blocked vendors**
>
> Today users can create purchase orders for vendors that are blocked. The problem is only detected
> at invoice verification, which generates rework for Finance. We need the system to prevent creation
> of purchase orders for blocked vendors. Returns should continue working normally. Please implement
> for go-live on 30/09.

Four sentences. This is typical, and it is not enough to test against.

---

## Stage 1 — `REQUIREMENT_ANALYSIS`

### Executive summary

Purchase orders can currently be created for vendors that carry a purchasing block, and the
inconsistency surfaces only during invoice verification, creating rework in Finance. The request is
to reject the purchase order earlier, at creation. Returns are stated as an exception. Target
go-live 30/09.

The request does not specify **which** block, at which organizational level, at which point in the
transaction, or what happens to purchase orders that already exist.

### AS-IS

`AS-IS not confirmed.`

The email asserts that POs can be created for blocked vendors, but no evidence was supplied showing
the current behavior, the block type in use, or whether a warning is already raised. Minimum
information needed:

- one existing purchase order created for a blocked vendor (document number and vendor);
- the vendor master screenshot showing which block field is set;
- whether any message is currently issued at save.

**Do not** write an AS-IS reconstructed from the TO-BE. If the current behavior is not confirmed,
a regression cannot be detected later.

### TO-BE

`Trigger` user saves a purchase order →
`Validation` system checks the vendor's purchasing block for the relevant organizational level →
`Decision` blocked and document type is not an exception →
`Action` reject the save →
`Result` no purchase order number is generated →
`Error path` an error message identifies the vendor and the block.

### Business rules

| ID | Trigger / condition | Expected behavior | Error / alternative | Data | Source | Confidence |
|---|---|---|---|---|---|---|
| `BR-001` | Vendor carries a purchasing block for the purchasing organization of the PO | Save is rejected | Error message, no document number generated | Vendor master, purchasing org | CR-4821 | `LIKELY` |
| `BR-002` | Document type is a returns type | Save proceeds despite the block | — | Document type | CR-4821 ("returns should continue working") | `LIKELY` |
| `BR-003` | Purchase order already exists and was created before the change | Behavior unchanged; the block is not applied retroactively | — | Existing POs | *not stated* | `UNKNOWN` |
| `BR-004` | Vendor is blocked but the block is set at a different purchasing organization than the PO | *undefined* | — | Vendor master org views | *not stated* | `UNKNOWN` |

`BR-001` is `LIKELY`, not `CONFIRMED`: "blocked" was never defined, and the vendor master carries
more than one kind of block. `BR-003` and `BR-004` exist only because the analysis produced them —
neither appears in the email, and both are behaviors someone will assume differently.

### Open questions

| ID | Question | Classification | Blocks | Owner |
|---|---|---|---|---|
| `Q-001` | Which block should trigger the rejection — the central purchasing block, the block for a specific purchasing organization, or the deletion flag? They can be set independently. | `BLOCKER` | `BR-001` | Process owner — Procurement |
| `Q-002` | "Returns should continue working" — which document types exactly? Please list them, since the exception must be coded against a list. | `BLOCKER` | `BR-002` | Process owner — Procurement |
| `Q-003` | Should the rejection also apply to purchase orders created by the interface user through the integration, or only to manual creation? | `BLOCKER` | `BR-001` | Architect + Procurement |
| `Q-004` | If a vendor is blocked *after* a purchase order exists, should follow-on documents (goods receipt, invoice) still be allowed against that PO? | `IMPORTANT` | `BR-003` | Process owner — Finance |
| `Q-005` | Should the block be evaluated at header save or when the vendor is entered, so the user finds out before keying twenty items? | `ENHANCEMENT` | — | Key user |

`Q-003` is the one that matters most and the one nobody asked. It is also the question this example
later shows being answered by a production defect instead of by the meeting.

### Acceptance criteria

```
AC-001 — Given a vendor blocked for purchasing organization 1000, when a user saves a purchase
         order for purchasing organization 1000 with a non-returns document type, then the save is
         rejected, an error message naming the vendor is displayed, and no purchase order number
         is generated.

AC-002 — Given the same blocked vendor, when a user saves a purchase order with a returns document
         type, then the purchase order is created normally.

AC-003 — Given a purchase order created before the change for a vendor that is now blocked, when a
         user displays or posts a goods receipt against it, then the existing behavior is unchanged.

AC-004 — Given a vendor blocked for purchasing organization 1000 only, when a user saves a purchase
         order for purchasing organization 2000, then the purchase order is created normally.
```

`AC-004` exists only because `BR-004` was flagged `UNKNOWN`. It is the criterion that turns an
unstated assumption into something the business must confirm.

### Readiness

`NOT_READY` — three `BLOCKER` questions are open (`Q-001`, `Q-002`, `Q-003`), and check 5 of the
readiness list (critical rules with their error paths) is unmet because `BR-004` has no defined
behavior.

Exact action to reach `READY_WITH_RISKS`: get Procurement to answer `Q-001` and `Q-002` in the
refinement on Thursday, and get the architect to answer `Q-003` before the technical specification is
written. `Q-004` can be resolved in parallel without blocking development.

---

## Stage 2 — `TEST_DESIGN`

Assume `Q-001` was answered ("the purchasing-organization-level block"), `Q-002` was answered
("document types ZRET and ZRE2"), and `Q-003` was answered ("manual creation only, the interface is
out of scope"). Note that last answer — the example returns to it.

| TC | BR/AC | Scenario | Type | Priority | Test data | Expected result | Evidence | Status |
|---|---|---|---|---|---|---|---|---|
| `TC-001` | `AC-001` | Blocked vendor, standard doc type, same purch. org | `NEGATIVE` | `P0` | `<VENDOR_1>` blocked purch org 1000, doc type NB | Save rejected, error names vendor, no PO number | `L3`: error screenshot + vendor PO list showing no new document | `NOT_RUN` |
| `TC-002` | `AC-002` | Blocked vendor, returns doc type ZRET | `HAPPY` | `P1` | `<VENDOR_1>`, doc type ZRET | PO created normally | `L3`: PO number + header | `NOT_RUN` |
| `TC-003` | `AC-004` | Vendor blocked for org 1000, PO for org 2000 | `BOUNDARY` | `P1` | `<VENDOR_1>` blocked org 1000 only | PO created normally | `L3`: PO number + purch org | `NOT_RUN` |
| `TC-004` | `AC-001` | Unblocked vendor, standard doc type | `HAPPY` | `P0` | `<VENDOR_2>` not blocked | PO created normally | `L2` | `NOT_RUN` |
| `TC-005` | `AC-003` | Pre-existing PO, vendor blocked afterwards, post GR | `REGRESSION` | `P0` | PO created before transport | GR posts, material document created | `L3`: material doc + FI doc | `NOT_RUN` |
| `TC-006` | `AC-001` | Vendor blocked while PO is open in the user's session | `STATE` | `P2` | Block set mid-session | Save rejected on the re-read | `L2` | `NOT_RUN` |
| `TC-007` | `AC-001` | Change an existing PO for a now-blocked vendor | `STATE` | `P1` | Existing PO + block | Per `Q-004` answer | `L3` | `NOT_RUN` |
| `TC-008` | `BR-001` | Deletion-flagged vendor, not purchasing-blocked | `DATA` | `P2` | `<VENDOR_3>` deletion flag only | Per `Q-001` answer — must not be blocked by this rule | `L2` | `NOT_RUN` |

`TC-004` looks trivial and is `P0` on purpose. A validation that rejects *everything* passes every
negative test in this matrix. Without `TC-004` the suite cannot detect the most likely
over-implementation.

`TC-008` is the case that catches a developer who read "blocked" and checked the wrong field.

### Traceability gaps flagged

- `AC-002` is covered by `TC-002` only — a single happy path on an exception rule. Add a negative:
  a returns document type for a vendor blocked for a *different* purchasing organization.
- No test covers PO creation through the integration, because `Q-003` scoped it out. **Recorded as an
  explicit coverage limitation, not silently omitted.**

That last line is what makes the next stage a managed risk instead of a surprise.

---

## Stage 3 — Execution and a failure

`TC-001` through `TC-008` run in UAT. `TC-001` passes. Then Finance reports that a purchase order was
created for a blocked vendor after the transport, in QAS.

### `DEFECT_TRIAGE`

```
Summary:            A purchase order was created for a vendor with a purchasing block, after
                    CR-4821 was transported to QAS.
Environment:        QAS, client 200
User / role:        <INTERFACE_USER> (background)
Date / time:        2026-09-18 03:14
Transaction:        created via inbound integration, not the PO transaction
Expected result:    Save rejected per AC-001, no PO number generated
Actual result:      PO 4500019283 created for <VENDOR_1>, which carries a purchasing block on
                    purchasing organization 1000
Reproducibility:    ALWAYS  — reproduced twice by resending the same message
```

**Functional checks already completed**

- Vendor master re-checked: the purchasing block on org 1000 is set and was set before 03:14.
  → rules out `MASTER_DATA` as the cause of the *block not existing*.
- The same vendor and document type entered manually in the PO transaction is correctly rejected.
  → rules out `CUSTOM_LOGIC` failing in general, and rules out `CUSTOMIZING` of the document type.
- Compared with a manual creation by a named user with the same data: rejected as expected.
  → the difference is the creation path, not the data.

**Hypotheses**

| Hypothesis | Supporting | Contradicting | Confidence | Check that settles it |
|---|---|---|---|---|
| The validation was implemented only on the dialog transaction path and the integration path does not pass through it | Manual creation rejects, integration creates; the two use different entry points | none found | `High` | Ask the developer which enhancement point was used and whether the integration path traverses it |
| The interface user bypasses the check through an authorization difference | Different user | The check is a business validation, not authorization-based; manual creation by a low-privilege user is also rejected | `Low` | Re-send the message under a second technical user |
| Vendor block was replicated to QAS after the PO was created | — | Block timestamp precedes the PO by two days | `Low` | already contradicted |

**Next discriminating check:** re-send the same message with a *returns* document type. If it is also
created, the integration path never reaches the validation at all — which distinguishes "wrong scope"
from "validation present but wrong condition".

**Failure domain:** `FUNCTIONAL_REQUIREMENT` and `CUSTOM_LOGIC`.

This is the important call. The instinct is to log a code defect. But `Q-003` was answered "manual
creation only, the interface is out of scope" — so the code **matches the decision**, and the
decision was wrong. Classifying this purely as `CUSTOM_LOGIC` sends it to ABAP, who will correctly
close it as "works as specified", and a week is lost.

Classify both, and escalate the scope question first.

### Developer handoff — *not yet*

The right next action is not a handoff. It is:

> `Q-003` was answered "interface out of scope". QAS shows the integration creating purchase orders
> for blocked vendors at a rate of roughly 40/night. Procurement and the architect need to decide
> whether the block applies to the integration path before go-live on 30/09. Recommendation: it
> should, because Finance's original rework problem is not path-specific — the invoice arrives the
> same way either way.
>
> If the decision is to extend the scope, the handoff below goes to ABAP with the enhancement point
> question already answered.

Once the decision is made, the handoff follows the format in `templates.md` §11, with
"Functional checks already completed" populated from the three checks above — which is what stops the
developer repeating them.

---

## Stage 4 — `REGRESSION_ANALYSIS`

Assume the scope is extended and the validation is added to the integration path.

| Ring | Scope | Cases | Mandatory? |
|---|---|---|---|
| 1 | The changed rule on the integration path, plus the original defect | Re-send the failing message; confirm rejection and no PO | yes |
| 2 | Adjacent: returns doc types via integration; vendor blocked on a different purch. org via integration; unblocked vendor via integration | `TC-002`/`TC-003`/`TC-004` equivalents on the integration path | yes |
| 3 | Shared: the manual path must still behave identically — the enhancement is now shared by two callers | Re-run `TC-001`, `TC-002`, `TC-004` | yes |
| 4 | Downstream: messages that now fail must produce a usable error status, not a silent drop; the sending system must be able to reprocess | Error mapping and reprocessing test | yes |
| 5 | Existing: open POs and in-flight messages created before the transport | `TC-005`, plus a message already in the queue at transport time | recommended |

Ring 4 is the one teams forget. Adding a validation to an integration path converts silent success
into failure, and if the error is not mapped to a retriable business status, forty messages a night
disappear. **A new validation on an interface always requires an error-handling test.**

### Detection gap for the RCA

Why did testing not catch this before QAS? Because `Q-003` scoped the integration out, and the
coverage limitation was recorded but never escalated as a risk at the readiness gate. The permanent
correction is not "add a test case" — it is: when a scope answer removes an entire execution path
from coverage, record it as a `RISK-###` with an owner, not as a note under the traceability table.

That is the difference between an RCA that produces a test and one that produces a habit.
