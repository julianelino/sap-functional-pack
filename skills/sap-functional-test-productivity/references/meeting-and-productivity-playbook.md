# Meeting and Productivity Playbook

Meetings and status reporting are where functional analysts lose the most time and where scope
decisions quietly go unrecorded. Formats are in `templates.md`.

---

## 1. Before a refinement

Arrive with a draft, not with questions. A refinement where the analyst presents an interpretation
takes half the time of one where the business is asked to explain from scratch — because correcting a
wrong draft is faster for everyone than producing a right one out loud.

Bring: a one-sentence objective; the AS-IS as you understand it; a TO-BE draft; the blocker questions;
the edge cases you found; draft acceptance criteria; testability concerns; dependencies.

### Design the questions

Every question should force a concrete choice and be answerable in one sentence. A question that
invites a story will get one.

> ❌ "Como funciona o processo de devolução hoje?"
> Produces fifteen minutes of narrative and no decision.
>
> ✅ "Na devolução, se a nota já foi contabilizada, o estorno deve gerar documento novo ou reverter o
> original? Preciso escolher um dos dois pra escrever o critério de aceite."
> Produces a decision, and says why it matters.

Adding *why you need it* is what converts a question into a decision. Without it, the business
answers "depende" and moves on.

### Do not spend meeting time on

Anything answerable from the documents you were already sent. Read them first. Asking the process
owner something that is on page 2 of the spec they wrote costs you credibility for the questions that
actually matter.

---

## 2. During any meeting

Capture three things that are easy to lose and expensive to reconstruct:

1. **Decisions, with who made them.** "Ficou decidido" with no name is not a decision.
2. **Deferrals, marked as deferrals.** "Por enquanto não, a gente vê depois" is the single most
   dangerous sentence in a refinement. It sounds like a decision and behaves like a gap. Write it
   down as an open item with an owner and a review date, or it will resurface as a production defect.
3. **Rejected assumptions.** When someone says "não, não é assim que funciona", that correction is
   worth more than the decision that follows it — it tells you where your model of the process is
   wrong.

---

## 3. After a refinement or customer meeting

Produce immediately, while the context is fresh: confirmed rules; changed rules; rejected
assumptions; new scope; removed scope; owners; deadlines; testing impact; development impact;
documentation to update.

**When a meeting changes a rule, name the affected `BR-###`, `AC-###` and `TC-###`.** A summary that
says "decidimos que o bloqueio é por organização de compras" without saying that this rewrites
`BR-001` and invalidates `TC-003` leaves the traceability to be rediscovered later, usually by
someone executing an obsolete test.

Send it the same day. A summary that arrives Thursday for a Tuesday meeting gets corrections nobody
remembers well enough to make.

---

## 4. Knowledge transfer

### Before

Prepare the questions, not just the recording. Bring: the process map as you understand it; the
transactions and apps involved; the document flow; master data; statuses; the errors you have already
seen; integrations; the unknowns you want closed.

### During

Capture "why it behaves this way", not only "how to execute it". The click path is in the manual. The
reason a step exists — which is what lets you judge whether a change is safe — only exists in the head
of the person leaving.

The highest-value KT question is: **"o que costuma dar errado aqui, e como você percebe?"** It
produces the support scenarios, the monitoring points and the regression cases in one answer.

### After

Convert notes into business rules, a troubleshooting decision tree, test cases, known issues, the
escalation path, and a glossary. Notes that stay as notes are lost within a month.

---

## 5. Daily and end-of-day

Use the skill to prioritize today's tests by risk, prepare the test data checklist, draft defect
packets, turn raw notes into status, and surface which tests are still blocked by missing data or
access — that last one is where UAT time actually disappears.

At close of day, generate: what was completed with evidence; what remains; blockers; new defects;
tomorrow's first action; delivery risk.

The purpose is not reporting. It is that tomorrow's first action is decided today, while the context
is still loaded.

---

## 6. Test cycle management

For larger UAT or regression cycles, track: total cases; not run; passed; failed; blocked; open
defects; defects awaiting retest; `P0`/`P1` status; requirements with no coverage; evidence missing.

Manage by risk, not by count. "180 de 200 casos executados" says nothing if the 20 remaining are the
`P0` financial postings. Report the shape of what is left, not the percentage.

Blocked cases deserve their own line. A case blocked for four days on missing master data is a
dependency nobody is chasing, and it will still be blocked on the day of the go/no-go.

---

## 7. Reusable knowledge

At the close of a demand, update: known issues; the regression pack; test data recipes; common
authorization problems; common integration errors; module-specific edge cases; customer-specific
rules.

The test data recipes are the most undervalued of these. "Um fornecedor bloqueado na organização 1000
com pedido em aberto" takes forty minutes to construct the first time and thirty seconds to find the
second time — if someone wrote down how it was built.

---

## 8. Productivity indicators

Useful because they point at a behavior worth changing:

| Indicator | What it tells you |
|---|---|
| Time from requirement received to test-ready | Whether analysis is the bottleneck |
| Questions raised before development started | Whether ambiguity is being caught early or in UAT |
| Requirements with test coverage | Traceability gaps, before they become escapes |
| Negative scenarios per critical rule | Whether the suite can actually fail |
| Defects returned for insufficient evidence | Whether triage is happening before handoff |
| Defects routed to the wrong team | Whether failure-domain classification is working |
| Mean time to a reproducible defect | The real cost driver in a UAT cycle |
| Defects escaped to UAT or production | The outcome all the others predict |
| Defect reopen rate | Whether retests verify the fix or just the happy path |
| UAT time blocked by missing data or access | Usually the largest single loss, and the least tracked |

Avoid vanity metrics — number of test cases written, number of AI prompts, lines of documentation.
They reward volume and are trivially gamed.

Do not report an indicator you cannot act on. If nobody owns "defects routed to the wrong team",
measuring it changes nothing and costs the credibility of the numbers that do matter.
