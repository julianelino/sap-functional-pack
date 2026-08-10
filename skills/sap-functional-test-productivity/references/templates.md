# Artifact Templates

**Single source of truth for every format this skill produces.** When another reference or the main
skill mentions an artifact, the shape is defined here. If you find a conflicting layout elsewhere,
this file wins.

All artifacts are written in English (see the language contract in `SKILL.md` §7). Identifiers and
keywords are never translated.

Fill only the fields that have content. Delete an empty field rather than writing "N/A".

---

## Identifier conventions

| Prefix | Artifact |
|---|---|
| `BR-###` | business rule |
| `AC-###` | acceptance criterion |
| `TC-###` | test case |
| `Q-###` | open question / ambiguity |
| `DEF-###` | defect |
| `RISK-###` | accepted residual risk |

Numbers are stable within a demand and never reused. If the project uses different prefixes, follow
the project (see `SKILL.md` §16) and state the mapping once.

---

## 1. Demand intake

```
Customer / business unit:
CR / GAP / WI:
SAP process / module:
Priority:
Target date / go-live:

Business problem:
AS-IS:
TO-BE:
Inputs:
Outputs:
Dependencies:
Known constraints:
Open questions:
```

---

## 2. Business rule

| Field | Value |
|---|---|
| ID | `BR-001` |
| Name | |
| Trigger / condition | |
| Expected behavior | |
| Error / alternative behavior | |
| Data involved | |
| Source | |
| Confidence | `CONFIRMED` / `LIKELY` / `UNKNOWN` |

For several rules, use one row per rule:

| ID | Trigger / condition | Expected behavior | Error / alternative | Data | Source | Confidence |
|---|---|---|---|---|---|---|

---

## 3. Acceptance criterion

```
AC-001 — Given <condition>, when <action>, then <observable result>.
```

For SAP processes, extend "then" with the resulting document and status, the downstream consequence,
and the error/recovery behavior when they are part of the acceptance.

---

## 4. Open question

| ID | Question | Classification | Blocks | Owner | Needed by |
|---|---|---|---|---|---|
| `Q-001` | | `BLOCKER` / `IMPORTANT` / `ENHANCEMENT` | `BR-00x`, `AC-00x` | | |

---

## 5. Test matrix

The overview and traceability artifact. **Nine columns, no steps** — steps belong in the test case.

| TC | BR/AC | Scenario | Type | Priority | Test data | Expected result | Evidence | Status |
|---|---|---|---|---|---|---|---|---|

- **Type**: `HAPPY` / `NEGATIVE` / `BOUNDARY` / `STATE` / `AUTH` / `INTEGRATION` / `REGRESSION` /
  `DATA`
- **Priority**: `P0` / `P1` / `P2` / `P3`
- **Status**: `NOT_RUN` / `PASSED` / `FAILED` / `BLOCKED`

---

## 6. Test case

```
TC-001 — <title stating the behavior proved, not the click path>

Related BR/AC:
Priority:
Type:
Risk covered:
Environment:
User / role:

Preconditions:
Test data:

Steps
  1.
  2.
  3.

Expected result:
Business / backend verification:
Evidence required:
Cleanup / reset:
Dependencies:
Status: NOT_RUN | PASSED | FAILED | BLOCKED
```

A title like "Test the purchase order screen" is wrong. "Blocked vendor is rejected at PO save with
no document created" is right — it names what the test proves.

---

## 7. Traceability

| Requirement | BR | AC | TC | Evidence | Defect |
|---|---|---|---|---|---|

Flag in prose beneath the table: requirements with no test; critical rules with no negative test;
acceptance criteria covered only by a happy path; fixed defects with no regression case.

---

## 8. Execution pack

```
Scope of this run:
Environment / client:
User(s) and role(s):

Prerequisite configuration:
Prerequisite master data:
Transactional input data:

Execution order:
  1. TC-00x — <why first>
  2. ...

Per case: transaction/app path, exact steps, expected result at each critical step,
final business outcome, evidence to capture, cleanup.

Known data dependencies between cases:
Cases blocked by missing data or access:
```

---

## 9. Defect report

```
Defect ID:
CR / WI:
Test case:
Environment / client:
User / role:
Date / time:
Transaction / app / interface:

Summary:            <one sentence, business behavior, not "error occurred">
Expected result:
Actual result:
Preconditions:
Exact test data:

Steps to reproduce
  1.
  2.
  3.

Error / message:            <text and message number when visible>
Evidence:                   <screenshots, document IDs, log/payload references, timestamps>
Reproducibility:            ALWAYS | DATA_DEPENDENT | USER_DEPENDENT | ENVIRONMENT_DEPENDENT |
                            INTERMITTENT | NOT_REPRODUCED | UNKNOWN
Functional checks already completed:
Failure-domain classification:
Current hypothesis:         <label LIKELY unless root cause is proven>
Business impact:
Severity / priority:        S1-S4 / P0-P3
Retest criteria:
Regression candidates:
```

---

## 10. Defect readiness checklist

Replaces any numeric quality score. Each item is binary and verifiable by reading the report.
Show the checklist, then the count.

| # | Item | Met? |
|---|---|---|
| 1 | Expected behavior is stated and traceable to a `BR-###`/`AC-###` or a documented process | |
| 2 | Actual behavior is stated objectively | |
| 3 | Reproduction steps are exact enough for someone else to follow | |
| 4 | Test data is captured (document numbers, keys, org values) | |
| 5 | Environment, client and user/role are recorded | |
| 6 | Evidence is attached and proves the failure, not just the screen | |
| 7 | Reproducibility class is assigned | |
| 8 | Business impact and severity are stated | |
| 9 | Obvious data / authorization / configuration causes were checked | |
| 10 | Retest criteria are explicit | |

**8 or fewer met → improve before developer handoff**, unless business impact requires immediate
escalation — in which case send it and name the missing items in the handoff.

Items 1, 3, 4 and 6 are mandatory regardless of count. A defect missing any of them will bounce.

---

## 11. Developer handoff

The developer receives a packet, not "please check".

```
Summary:                    <one sentence describing the failed business behavior>
Confirmed business rule:    BR-### / AC-### and its source
Environment and context:    system/client, user/role, transaction/app/interface, date/time
Reproduction:               numbered steps with exact data
Expected:
Actual:
Evidence:                   screenshots, document IDs, payload/log references, message text,
                            timestamps
Functional checks already completed:
                            e.g. master data validated, authorization compared with a known-good
                            user, configuration branch compared, reproduced with a second user,
                            outbound payload confirmed
Current hypothesis:         LIKELY <domain> — with the evidence supporting it
Impact:                     business/process impact and severity
Retest criteria:            exactly what must pass after the correction
Regression candidates:      nearby behaviors that must be revalidated
```

---

## 12. RCA

```
Incident / defect:
Symptom:                    what the user observed
Failure mechanism:          how the failure occurred
Root cause:                 the underlying reason that allowed it
Contributing factors:
Detection gap:              why testing or monitoring did not catch it earlier
Corrective action:          fixes the current cause
Preventive action:          reduces recurrence
Regression test added:      the permanent case, with its TC-### 
Residual risk:
```

An RCA whose corrective action is "code corrected" and whose detection gap is blank is not finished.

---

## 13. Regression scope

| Ring | Scope | Cases | Mandatory? |
|---|---|---|---|
| 1 | Changed rule and original defect | | yes |
| 2 | Adjacent statuses, values, roles, org units | | |
| 3 | Shared document, master data, config, interface, output | | |
| 4 | Downstream documents, postings, workflow, forms, reports | | |
| 5 | Existing and open documents created before the change | | |

State beneath: rationale, dependencies, data required, and what was deliberately excluded.

---

## 14. Meeting preparation

```
Objective:                  one sentence
Decisions required:
  1.
Blocker questions:          Q-### each, phrased as a concrete choice
  1.
Risks to discuss:
Examples / data to bring:
Expected outputs:
```

---

## 15. Meeting notes

```
Decisions:
Requirement changes:        with the affected BR-###, AC-###, TC-###
Rejected assumptions:
Scope added / removed:
```

| Open item | Owner | Due | Impact |
|---|---|---|---|

```
Test impact:
Documentation to update:
```

---

## 16. Status update

```
Demand:
Work completed:
Current state:
Evidence / result:
Blocker / dependency:
Next step:
Delivery impact:
```

Do not report a percentage that counts only development. If testing, evidence, UAT or deployment
remain, the demand is not near done.

---

## 17. Gate decision

```
Verdict:   READY | READY_WITH_RISKS | NOT_READY
           DONE  | DONE_WITH_RESIDUAL_RISK | NOT_DONE
           GO    | GO_WITH_ACCEPTED_RISK   | NO_GO

Basis:                      the evidence behind the verdict
Unmet checks:               each with the exact action that would close it
```

---

## 18. Residual risk record

| ID | Risk | Affected process | Likelihood | Impact | Workaround / contingency | Owner | Review by |
|---|---|---|---|---|---|---|---|
| `RISK-001` | | | Low/Med/High | | | | |

A risk with no named owner is not accepted — it is ignored. Drop the verdict to the negative one.

---

## 19. UAT sign-off pack

```
Scope and out-of-scope:
Business owners:
Acceptance criteria and their status:
Executed tests:             passed / failed / blocked / not run counts
Critical evidence:          links or document IDs
Defects and disposition:
Regression summary:
Residual risks:             RISK-### each, with owner
Sign-off decision:
```
