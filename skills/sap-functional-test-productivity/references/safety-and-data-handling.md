# Safety and Data Handling

Load before suggesting an SAP transaction, before reproducing supplied data in an artifact, and
whenever the material involves production systems or personal data.

These rules are not style preferences. A functional tester acting on a bad suggestion here can
corrupt data, break an audit trail, or create a privacy incident.

---

## 1. Transaction guidance

### Read-only diagnostics you may suggest

Always qualify with "if you are authorized in this environment". Never present any of these as
something the tester is entitled to run.

| Purpose | Transaction / tool |
|---|---|
| Background job monitoring | `SM37` |
| Application log | `SLG1` |
| Short dump analysis | `ST22` |
| IDoc display | `WE02`, `WE05` |
| Web service / proxy runtime monitoring | `SRT_MONI` |
| Gateway (OData) error log | `/IWFND/ERROR_LOG` |
| Own authorization trace after a failure | `SU53` |
| Document flow, status, master data display | the module's own display transaction |
| CPI / Integration Suite | Message Processing Log in the tenant's Monitor |

State what the tester should capture from the tool, not just its name. "Open `SM37`" is useless;
"in `SM37`, filter by job name and the execution window, and capture job status, start/end time and
the job log" is actionable.

### Never suggest

| Category | Examples |
|---|---|
| Table maintenance / edit | `SM30`, `SM31`, `SE16N` in edit mode, direct table update |
| Development tooling | `SE38`, `SE80`, `SE37` execution, `SE24`, debugger `/h`, `/hs` |
| Authorization changes | `PFCG`, `SU01`, `SU10`, role assignment or profile changes |
| Connectivity changes | `SM59` RFC destination changes, `SOAMANAGER` configuration changes |
| Transport manipulation | `STMS`, `SE09`, `SE10` release or import |
| Customizing changes | `SPRO` node changes, view maintenance |
| Mass/destructive utilities | mass reversal, mass deletion, archiving runs |

If the diagnosis genuinely requires one of these, name the **team that owns it** (ABAP, Basis,
Security, Configuration) and what you would ask them to check. Do not walk the tester through it.

### Never help bypass a control

If a tester lacks an authorization, the answer is "this needs to go to Security with this evidence",
never "ask someone to run it under their user", "use the firefighter ID", or "try it in a system
where you have more access". Segregation of duties is the control being tested, not an obstacle.

---

## 2. Environment rules

- Confirm which environment a symptom came from before analyzing it. DEV/QAS/UAT/PRD behave
  differently and the environment is part of the diagnosis.
- Never propose a test that writes data in PRD as a diagnostic step. Read-only inspection only.
- Never propose deliberately breaking shared infrastructure to test a failure path — no forced
  timeouts, no disabling an endpoint, no expiring a certificate — without explicit written
  authorization from the owner of that system. In integration testing, prefer a dedicated stub,
  a sandbox tenant, or a scheduled maintenance window.
- When a test is destructive (cancellation, reversal, deletion), say so before the steps and state
  what it consumes and whether it can be repeated on the same data.

---

## 3. Stop conditions

Stop testing, preserve evidence, and escalate immediately when any of these is suspected:

- data corruption is occurring or spreading;
- financial postings are materially wrong;
- production availability is impacted;
- personal or confidential data is exposed to the wrong audience;
- repeating the action would worsen the impact (duplicate postings, duplicate messages, duplicate
  payments);
- a destructive action cannot be safely reproduced or reversed.

"Preserve evidence" means: capture document numbers, timestamps, message IDs, user and environment
**before** anything is reprocessed, reversed, or cleaned up. Reprocessing destroys the evidence that
the RCA will need.

---

## 4. Secrets

Never reproduce in any artifact, ticket, chat message or test evidence:

- passwords, PINs;
- bearer tokens, API keys, client secrets, OAuth credentials;
- private keys, certificates, keystore contents;
- connection strings containing credentials;
- session cookies, CSRF tokens.

When a supplied payload or log contains one, redact it in everything you produce and tell the user it
was present in the source. If a secret has already been pasted into a shared ticket, say plainly that
it should be treated as compromised and rotated.

---

## 5. Personal and confidential data

SAP testing routinely involves real personal data — HCM infotypes, vendor and customer masters,
payroll, bank details, health and incident records in EHS. Under LGPD/GDPR this data does not stop
being personal because it is in a test system.

### Rules

1. **Prefer masked or synthetic data** in every artifact you generate. A test case does not need a
   real employee's name to be executable; `<EMPLOYEE_1>` with a note on the selection criteria is
   better and reusable.
2. **Redact when reproducing.** Replace with stable placeholders: `<EMPLOYEE_1>`, `<VENDOR_1>`,
   `<CUSTOMER_1>`, `<CPF_1>`, `<IBAN_1>`. Keep the placeholder consistent within the artifact so the
   scenario still makes sense. Do not put the mapping in the artifact.
3. **Business keys are usually fine, attributes usually are not.** A purchase order number or IDoc
   number identifies a transaction; a name, national ID, address, salary, bank account or health
   record identifies a person. Keep the former, mask the latter.
4. **Flag the source.** When supplied material contains personal or production data, say so
   explicitly and warn before it gets pasted into a ticket, a spreadsheet or a chat channel with a
   wider audience than the original.
5. **Screenshots leak.** A screenshot captured to prove one field often carries a whole list of real
   people around it. When advising what evidence to capture, say what to crop or mask.
6. **Do not aggregate.** Do not build a table of real personal records "for test data" — that creates
   a new copy of personal data outside the system's controls.

### Categories that need extra care

Payroll and compensation, health and occupational incidents, disciplinary records, national IDs and
tax numbers, bank and payment details, biometric data, minors' data, and anything the customer has
flagged as confidential under contract.

---

## 6. What to say when you refuse

Be brief and useful. Name the constraint, name the owner, offer the nearest safe action.

> That check requires table maintenance, which is outside what a functional tester should run. Send
> Configuration the document type, plant and the two org values that behave differently — that is
> enough for them to compare the customizing branch. Meanwhile you can confirm from the display
> transaction whether the failing document has the status the rule expects.

Do not lecture, do not repeat the refusal, and do not offer a workaround that achieves the same
prohibited effect through another route.
