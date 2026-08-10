# Requirement Analysis and Impact

Load when analyzing a CR, GAP, WI, EF/FS, functional specification, change email, process
description, or when assessing readiness and blast radius. Formats are in `templates.md`.

---

## 1. Output shape

1. Executive summary — business problem, requested change, expected outcome, affected users, critical
   dependencies.
2. AS-IS — only what evidence supports. If unknown, write `AS-IS not confirmed` and name the minimum
   information needed. Never reconstruct AS-IS from the TO-BE description.
3. TO-BE — ordered, event-driven:
   `Trigger → Validation → Decision → Action → Result → Error/alternative path`.
4. Business rules `BR-###`.
5. Field rules.
6. State rules.
7. Ambiguities `Q-###`.
8. Acceptance criteria `AC-###`.
9. Impact and risk.
10. Initial test implications.
11. Readiness verdict.

Include a section only when it has content.

---

## 2. The challenge checklist

Read the document twice: once for what it says, once for what it avoids saying. These are the gaps
that produce defects in UAT.

**Behavior gaps** — missing states; contradictory statements; undefined error behavior; undefined
retry or reprocessing behavior; partial-success behavior; cancellation and reversal; repeated action;
what happens to an object already processed.

**Data gaps** — null and empty; duplicates; invalid values; boundary values; decimal precision and
rounding; date and time edges; leading zeros; special and accented characters; unit and currency
conversion.

**Scope gaps** — cross-company and cross-plant differences; localization and language; which
organizational units are in scope; which document types are in scope.

**Time gaps** — impact on documents that already exist; open items; historical records; migration or
backfill needs; backward compatibility with the current interface contract.

**Control gaps** — authorization behavior; role segregation; auditability; manual contingency when
the automated path fails; user-facing message text.

**Dependency gaps** — upstream assumptions; downstream document consequences; integration downtime;
timeout behavior; duplicate message handling.

---

## 3. Business rules

One rule per behavior. If a sentence contains "and also", it is probably two rules.

| Field | Meaning |
|---|---|
| ID | `BR-001`, stable for the life of the demand |
| Trigger / condition | when the rule applies |
| Expected behavior | what the system must do |
| Error / alternative | what happens when the condition is not met |
| Data involved | fields, master data, documents |
| Source | document section, meeting, evidence |
| Confidence | `CONFIRMED` / `LIKELY` / `UNKNOWN` |

A rule whose "Error / alternative" column is empty is not finished — that empty cell is a `Q-###`.

---

## 4. Field rules

For every field the document mentions, decide whether each of these is specified or missing:
mandatory or optional; source system; default value; allowed values and value help; length; format;
date/time format; decimal precision; unit or currency; leading zeros; trimming and case sensitivity;
dependency on another field; editable versus read-only; visibility; behavior after a status change;
mapping across interfaces.

Do not invent a constraint. An unspecified constraint is a question, not an assumption.

---

## 5. State rules

When behavior depends on status, map every state: entry condition, allowed actions, prohibited
actions, next states, error recovery, terminal behavior.

Look specifically for transitions the document never mentions. Those are where defects live —
"what happens if the user cancels while the interface call is in flight?" is rarely in the spec.

---

## 6. Ambiguities

Create `Q-###` and classify:

- `BLOCKER` — implementation or testing cannot proceed reliably;
- `IMPORTANT` — work can continue but quality risk exists;
- `ENHANCEMENT` — improves clarity, does not block.

A good question forces a concrete choice and can be answered in one sentence.

> ❌ "Please clarify the process."
> ❌ "Can you explain the error flow?"
> ✅ "If the purchase order is already fully invoiced, should the new action be blocked, ignored, or
> processed with a warning?"
> ✅ "When CPI returns HTTP 500 after SAP already created the document, should reprocessing resend
> the same business key or create a new transaction?"

Route each question to the person who can actually answer it — process owner, key user, architect,
Security — and say so.

---

## 7. Acceptance criteria

`AC-###` — `Given <condition>, when <action>, then <observable result>.`

Every criterion must be objectively falsifiable by someone who was not in the meeting.

> ❌ "AC-003 — The interface works correctly."
> ❌ "AC-004 — The user can create the order."
> ✅ "AC-003 — Given a vendor with a purchasing block on plant 1000, when the user saves a purchase
> order for that vendor and plant, then the save is rejected with message ZMM 042 and no purchase
> order number is generated."

For SAP processes, extend the "then" to the consequence that actually matters: the resulting
document and status, the downstream effect, and the error/recovery behavior.

---

## 8. Impact analysis

### Layers

**Business process** — upstream, current, downstream, exception/contingency, reporting and audit.

**SAP functional scope** — transaction or app; document types; movement types; statuses;
organizational levels; master data; configuration dependencies; approval and workflow; output and
forms; background jobs; reports.

**Technical categories to investigate** — name the *category*, never an invented object name: custom
program or class; enhancement/BAdI/user exit; BAPI or function module; CDS; OData; Proxy/SOAP; IDoc;
RFC; CPI iFlow; workflow; form; scheduled job; authorization object; customizing table or view.

**Data** — existing documents; historical records; open items; master data; duplicates; cross-company
and cross-plant data; migration or backfill; reconciliation.

**Integration** — payload schema; field mapping; endpoint; authentication; retry; duplicate handling;
sequence; timeout; partial success; asynchronous status; monitoring; downstream availability.

### Blast radius

Classify each identified impact: `DIRECT` (explicitly changed) · `ADJACENT` (shares a rule, object,
data or process) · `DOWNSTREAM` (consumes the resulting document or data) · `UPSTREAM` (provides the
input or trigger) · `REGRESSION_CANDIDATE` (old behavior worth retesting) · `UNKNOWN` (needs
investigation).

`UNKNOWN` is a legitimate and useful answer. An impact list with no `UNKNOWN` entries on a
non-trivial change usually means the analysis stopped at the document boundary.

### Risk

`Risk = business impact × likelihood × difficulty of detection`, qualitative only —
Low / Medium / High / Critical. Difficulty of detection is the term people forget: a wrong tax code
that posts silently is far more dangerous than a dump, because nobody notices it for a month.

Order test priority by risk, not by document order.

---

## 9. Readiness verdict

Do **not** produce a numeric score. Two runs over the same document would not agree, and a number in
a status report gets treated as a measurement. Use the checklist and the three-level verdict.

| # | Check | Met? |
|---|---|---|
| 1 | Business objective is stated and unambiguous | |
| 2 | Scope and explicit out-of-scope are defined | |
| 3 | AS-IS is known well enough to detect a regression | |
| 4 | TO-BE is explicit and ordered | |
| 5 | Critical business rules are written, each with its error path | |
| 6 | Exception, retry and reprocessing behavior is defined | |
| 7 | Acceptance criteria are objectively testable | |
| 8 | Dependencies are identified (upstream, downstream, other teams) | |
| 9 | Authorization impact is considered | |
| 10 | Integration impact is considered | |
| 11 | Test data is obtainable in the target environment | |
| 12 | No `BLOCKER` question is open | |

- `READY` — all checks met.
- `READY_WITH_RISKS` — every `BLOCKER` resolved, but some checks unmet. List each unmet check with
  its risk, the owner, and the date by which it must be resolved.
- `NOT_READY` — any `BLOCKER` question open, or check 4, 5, 7 or 11 unmet.

Always show the checklist with the verdict, and for every unmet check state the **exact action**
that would close it — not "clarify the requirement" but "ask <role> whether X or Y, by <date>".
