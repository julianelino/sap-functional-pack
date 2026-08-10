# SAP Functional Defect Triage Playbook

Use this reference to isolate failures before escalating them to the wrong team. Formats are in
`templates.md`.

## 1. Triage Objective

The goal is not to prove that ABAP is wrong. The goal is to determine the most likely failure domain
with enough evidence for the correct owner to act quickly.

### 1.1 Failure domains

Classify into one or more. Never force a single class when evidence supports several — an
overconfident classification sends the defect to the wrong queue and costs a day.

`FUNCTIONAL_REQUIREMENT` · `TEST_DATA` · `MASTER_DATA` · `CUSTOMIZING` · `AUTHORIZATION` ·
`CUSTOM_LOGIC` · `WORKFLOW` · `INTEGRATION_CPI` · `ODATA_FIORI` · `PROXY_SOAP` · `IDOC_RFC` ·
`BACKGROUND_JOB` · `INFRASTRUCTURE` · `ENVIRONMENT_TRANSPORT` · `USER_ERROR` · `UNKNOWN`

`UNKNOWN` is a valid classification when the next check has not been run yet. It is more useful than
a guess.

### 1.2 Reproducibility

`ALWAYS` deterministic · `DATA_DEPENDENT` specific data or condition · `USER_DEPENDENT` role or user
dependent · `ENVIRONMENT_DEPENDENT` system or config dependent · `INTERMITTENT` not deterministic ·
`NOT_REPRODUCED` evidence exists but the current reproduction attempt failed · `UNKNOWN`.

`NOT_REPRODUCED` is not the same as "not a defect". Record what was tried and what differed from the
original occurrence.

### 1.3 Hypothesis ranking

For each hypothesis state: the hypothesis; supporting evidence; **contradicting evidence**;
confidence `High` / `Medium` / `Low`; and the single check that would confirm or reject it.

Do not assign percentages without a quantitative basis — "70% likely a mapping issue" is invented
precision that later gets quoted as fact.

The contradicting-evidence column is the one people skip and the one that prevents wasted days.

### 1.4 The next discriminating check

Always name **one** check — the one that splits the hypothesis space fastest.

| Check | Separates |
|---|---|
| Same data, different user | authorization vs data/logic |
| Same user, known-good data | data vs general logic |
| Same payload sent directly vs through CPI | middleware mapping vs backend |
| Same transaction in another environment | environment/config vs design |
| Document status inspected before execution | eligibility rule vs technical failure |
| Same document type in two plants | organizational configuration |
| GUI vs Fiori for the same action | UI/OData layer vs backend business logic |

### 1.5 When to hand off to a developer

Create a handoff when: custom logic remains the likely cause after functional, data and configuration
checks; a dump or runtime error points at custom code; confirmed business behavior is violated while
configuration and data are consistent; an interface backend response suggests custom processing
failure; or the user explicitly asks to send it to DEV.

Do not hand off a defect that fails the readiness checklist in `templates.md` §10 unless business
impact forces immediate escalation — and then say which items are missing.

## 2. Universal First Checks

Before deep diagnosis, confirm:

1. expected behavior is actually defined;
2. correct environment/client is used;
3. correct test data is used;
4. prerequisite document/master data status is correct;
5. user is appropriate for the scenario;
6. issue is reproducible;
7. current behavior differs from baseline/requirement;
8. no known transport/config dependency is missing.

## 3. Failure Domain: Functional Requirement

Indicators:

- two documents describe different expected behavior;
- business owner and tester disagree;
- no rule exists for the observed state;
- current system behavior matches old process but new process is unclear.

Evidence to collect:

- requirement version;
- exact rule/acceptance criterion;
- meeting decision;
- process owner confirmation.

Owner likely:

- Functional/business decision, not DEV yet.

## 4. Failure Domain: Test Data

Indicators:

- known-good data passes;
- only one specific object fails;
- input violates a documented prerequisite;
- test object has unexpected status/history.

Checks:

- compare failing vs passing object;
- validate status;
- validate organizational assignment;
- validate dates/period;
- validate quantities/amounts;
- validate linked documents.

## 5. Failure Domain: Master Data

Indicators:

- process fails for material/vendor/customer/employee/object only;
- required view/attribute is missing;
- object is blocked/deletion flagged;
- object valid in another organizational unit.

Checks depend on module but may include:

- active/block status;
- organizational views;
- validity dates;
- account assignment fields;
- partner roles;
- valuation/procurement/sales data;
- mapping to external IDs.

## 6. Failure Domain: Customizing

Indicators:

- same code behaves differently by company/plant/document type;
- behavior differs across DEV/QAS/PRD;
- a configured value or mapping is missing;
- no dump/technical error, but process is rejected systematically.

Evidence:

- exact org values;
- relevant document type/movement/status;
- comparison between working and failing configuration branch;
- transport/config history if available.

Do not guess the exact SPRO node without evidence.

## 7. Failure Domain: Authorization

Indicators:

- another user succeeds with same data;
- error references authorization;
- action/display differs by user;
- organizational scope differs.

Useful evidence when available/authorized:

- user ID;
- role context;
- exact error;
- SU53 immediately after failure;
- comparison with known-good user.

Do not instruct bypassing controls.

## 8. Failure Domain: ABAP / Custom Logic

Indicators:

- confirmed business rule is violated consistently;
- configuration and data are valid;
- custom error/dump occurs;
- issue starts after custom transport;
- same branch fails across users and valid data.

Functional team's job:

- isolate conditions;
- produce reproducible packet;
- identify likely business branch;
- avoid prescribing code fix unless technically validated.

## 9. Failure Domain: Workflow

Indicators:

- document saves but approval does not start;
- wrong approver;
- workflow stuck;
- status not updated after decision;
- notification missing.

Checks:

- triggering condition;
- requester/approver data;
- thresholds;
- current workflow status;
- substitution/delegation;
- document status;
- workflow log if available.

## 10. Failure Domain: Background Job

Indicators:

- online action succeeds but later processing does not;
- expected overnight/status update missing;
- issue occurs at scheduled time only.

Useful evidence:

- job name/time;
- job status;
- job log/spool;
- variant;
- processed object IDs;
- downstream dependency.

Common transaction for authorized support users: `SM37` for job monitoring.

## 11. Failure Domain: Application Log

When process uses application logs, `SLG1` may be useful if the team has access and knows the object/subobject.

Capture:

- timestamp;
- object/business key;
- error/warning text;
- message class/number if visible;
- sequence of messages.

Do not invent object/subobject names.

## 12. Failure Domain: Runtime Dump

If a short dump occurs, `ST22` may contain the runtime error and custom program context for authorized users.

Functional handoff should capture:

- runtime error name;
- timestamp;
- user;
- transaction;
- program/include if visible;
- business steps/data that caused it.

Do not ask non-developers to diagnose ABAP stack internals unless they want to.

## 13. Failure Domain: OData/Fiori

Indicators:

- UI generic error;
- backend service returns failure;
- metadata/property mismatch;
- save succeeds in backend but UI shows stale data.

Useful evidence when available:

- browser/network request;
- HTTP status;
- request URL;
- request payload;
- response body;
- timestamp;
- `/IWFND/ERROR_LOG` in Gateway environments when authorized;
- backend application log.

Classify separately:

- UI presentation;
- OData service;
- backend business logic;
- authorization;
- connectivity.

## 14. Failure Domain: Proxy/SOAP

Useful evidence:

- message ID;
- timestamp;
- sender/receiver;
- request XML;
- response/fault;
- business key;
- proxy/monitor status.

`SRT_MONI` may be relevant for web service runtime monitoring in some ABAP landscapes when authorized.

## 15. Failure Domain: IDoc

Useful evidence:

- IDoc number;
- message type;
- status;
- status text;
- control record partner/system;
- data segment containing business key;
- reprocessing result.

`WE02`/`WE05` are commonly used to display IDocs when available to the team.

Do not assume an IDoc is used unless evidence confirms it.

## 16. Failure Domain: RFC

Collect:

- called destination if known;
- business action;
- timestamp;
- exact error;
- whether target system is reachable by other flows;
- same call behavior in another environment if available.

Avoid instructing functional testers to change RFC destinations.

## 17. Failure Domain: CPI / Integration Suite

Collect:

- iFlow name;
- message processing log ID;
- timestamp;
- sender payload;
- receiver payload;
- mapping output;
- HTTP status/receiver error;
- retry/reprocess status;
- business key.

Find the first divergence from expected data.

## 18. Failure Domain: Environment / Transport

Indicators:

- DEV works, QAS fails;
- one system lacks field/config/object;
- issue appears immediately after transport;
- service activation differs.

Checks:

- transport present?
- dependent transport present?
- configuration transported/manual?
- service active?
- cache/reload issue?
- version mismatch?

Do not conclude “transport issue” without comparison evidence.

## 19. Failure Domain: User Error / Process Misuse

Only classify here if:

- expected process is documented;
- user action clearly deviated;
- UI behavior is not misleading;
- training/process documentation is sufficient.

Avoid blaming users when the process design is unclear.

## 20. Diagnostic Comparison Matrix

Use controlled comparisons:

| Comparison | What it helps isolate |
|---|---|
| Same user, good vs bad data | Data/master data vs general logic |
| Same data, good vs bad user | Authorization/user-specific context |
| Same scenario, DEV vs QAS | Environment/config/transport |
| Same payload, direct vs CPI | Middleware mapping/routing vs backend |
| Same business object before vs after transport | Change regression |
| Same action in GUI vs Fiori | UI/OData vs backend business logic |
| Same document type across two plants | Organizational configuration |

## 21. Defect Escalation Readiness

A defect is developer-ready when:

- expected behavior is traceable;
- reproduction is exact;
- test data is captured;
- issue is reproduced or carefully delimited;
- obvious data/auth/config causes were checked when appropriate;
- evidence is attached;
- impact is stated;
- retest criteria are clear.

## 22. Triage Stop Conditions

Stop and escalate immediately when:

- potential data corruption is occurring;
- financial postings are materially wrong;
- production availability is impacted;
- security/privacy exposure is suspected;
- repeated processing may worsen impact;
- destructive action cannot be safely reproduced.

In such cases, preserve evidence and avoid further risky testing.
