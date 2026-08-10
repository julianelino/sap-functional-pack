# Evaluation cases

Regression tests for the skill itself. Run after any edit to `SKILL.md` or a reference, before
releasing.

Each case in `cases/` has a **Prompt** (paste verbatim into a fresh session), **Must / Must not**
criteria that are binary and observable, and **Why this case exists**.

A fresh session matters. A warm one carries behavior from earlier turns and will pass cases the
skill would fail cold.

## Priority

| Priority | Cases | Cost if it regresses |
|---|---|---|
| Must always pass | `01-no-invention`, `02-ai-work-attribution` | The report contains something that did not happen, in a document sent to management |
| High | `03-time-gap`, `04-blocker-vs-work-remains`, `06-origin-persona` | The model's core discipline is gone while the output still looks right |
| Medium | the rest | Wording and consistency drift |

## When to add a case

Every time the skill gets something wrong in real use, add the case before fixing it. That is the
only way to know the fix worked and stayed working.

## Sibling skill

`sap-functional-test-productivity` handles analysis, test design and defect triage. This one reports
on that work. Case `07-scope-boundary` guards the line between them — run it whenever either skill's
description or router changes.
