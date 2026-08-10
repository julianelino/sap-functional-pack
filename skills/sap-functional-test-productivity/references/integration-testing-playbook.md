# SAP Integration Functional Testing Playbook

Use for CPI/Integration Suite, SAP Proxy, SOAP, REST, OData, IDoc, RFC, SuccessFactors, external
SaaS, files, and hybrid integrations. Formats are in `templates.md`.

## 0. The five layers

Every integration test belongs to exactly one of these. Saying which one a test covers prevents the
most common integration mistake: proving the middleware ran and calling the business process tested.

1. **Business trigger** — should the message have been sent at all?
2. **Source payload** — did SAP produce the correct data?
3. **Transformation / routing** — did middleware map and route correctly?
4. **Target processing** — did the target accept and process it?
5. **Business reconciliation** — does the final business state match expectations on both sides?

A green middleware status covers layer 3 only. It is not evidence for layers 1, 2, 4 or 5.

### Isolation

Walk the chain and find the **first checkpoint where actual diverges from expected**:

`SAP source → outbound payload → middleware input → middleware output → target response → SAP final state`

Everything downstream of that point is a symptom. Report the divergence point, not the last error
message you saw.

## 1. Integration Test Model

Always separate the flow into observable checkpoints:

1. business trigger;
2. source extraction;
3. source message construction;
4. middleware ingress;
5. mapping/transformation;
6. routing/conditions;
7. receiver request;
8. receiver response;
9. middleware post-processing;
10. SAP/business final state;
11. monitoring/reconciliation.

The first checkpoint where actual diverges from expected usually narrows the failure domain.

## 2. Contract Inventory

Capture:

- sender;
- receiver;
- protocol;
- endpoint/environment;
- authentication type;
- sync/async;
- business key;
- message ID/correlation ID;
- schema/version;
- retry policy;
- timeout;
- idempotency behavior;
- monitoring tool;
- reprocessing mechanism;
- error owner.

## 3. Field Mapping Matrix

For important fields create:

| Business field | Source | Transformation | Target | Mandatory? | Empty behavior | Validation |
|---|---|---|---|---|---|---|

Check:

- wrong source field;
- wrong target field;
- condition reversed;
- truncation;
- lost leading zeros;
- wrong date format;
- timezone;
- decimal precision;
- unit/currency conversion;
- boolean/code mapping;
- lookup table missing entry;
- optional node omitted vs empty;
- repeating nodes cardinality.

## 4. Positive Integration Cases

- standard business message;
- multiple line items;
- optional fields populated;
- optional fields absent;
- alternate valid code mappings;
- all supported organizational branches.

## 5. Negative Schema/Data Cases

- missing mandatory field;
- invalid code;
- invalid format;
- too-long field;
- unexpected special character;
- invalid date;
- invalid decimal;
- malformed payload;
- empty collection;
- duplicate line;
- unsupported enumeration.

## 6. Connectivity Cases

- target unavailable;
- DNS/network failure where safely testable;
- authentication failure;
- expired credential/certificate simulation where process permits;
- timeout;
- HTTP 4xx;
- HTTP 5xx;
- connection reset;
- slow receiver.

Do not deliberately break shared production-like infrastructure without explicit authorization.

## 7. Retry and Idempotency

Validate:

- first send success;
- first send failure + retry success;
- repeated retry while target remains down;
- manual reprocess after automatic retry;
- duplicate message after success;
- duplicate business key;
- partial receiver processing then timeout;
- callback duplicated;
- retry count exhausted;
- final error status/log.

Critical question:

“Can a retry create a duplicate business document?”

## 8. Asynchronous Integrations

Validate:

- trigger creates outbound message;
- message queued;
- processing completes;
- final business status eventually updates;
- delayed response handling;
- out-of-order messages;
- callback correlation;
- stale status prevention;
- monitoring/reconciliation for lost messages.

## 9. Error Mapping

Check whether technical errors are converted into usable business statuses/messages.

Verify:

- original receiver error retained somewhere;
- user-facing message understandable;
- recoverable vs nonrecoverable errors distinguished;
- retryable status assigned correctly;
- no false success after receiver rejection.

## 10. Reconciliation

A successful middleware status is not enough.

Reconcile:

- source business object;
- outbound payload;
- target object/document;
- returned identifier;
- final SAP status;
- quantities/amounts;
- number of records;
- error records;
- duplicate count.

## 11. CPI Functional Evidence

When available, useful evidence includes:

- iFlow name/version;
- MPL/message ID;
- start/end time;
- sender payload;
- mapping result;
- receiver payload;
- receiver response;
- exception details;
- custom headers/properties relevant to routing;
- retry/reprocess evidence.

Avoid copying credentials/tokens/secrets into defect reports.

## 12. SOAP/Proxy Functional Evidence

Capture:

- operation/service;
- message ID;
- request XML;
- response/fault;
- namespace/schema version;
- business key;
- timestamp;
- SAP final status.

## 13. OData/REST Functional Evidence

Capture:

- HTTP method;
- resource/path;
- request parameters;
- request body;
- response status;
- response body;
- business key;
- CSRF/auth behavior where relevant;
- final backend state.

Do not include secrets or bearer tokens in shared evidence.

## 14. IDoc Functional Evidence

Capture:

- IDoc number;
- message type;
- status;
- status text;
- key data segments;
- partner/receiver;
- reprocess result;
- created target object.

## 15. File Integrations

Test:

- correct filename pattern;
- empty file;
- header only;
- one record;
- many records;
- duplicate file;
- invalid row;
- partial valid/invalid rows;
- encoding;
- delimiter;
- decimal/date format;
- line endings;
- reprocessing same file;
- archive/error folder behavior.

## 16. Security from Functional Perspective

Validate only what functional testers are authorized to verify:

- unauthorized calls rejected;
- sensitive values not displayed in user-facing errors;
- logs do not expose passwords/secrets;
- least-privileged integration user behavior where defined;
- environment endpoints/credentials not mixed.

## 17. Integration Regression Pack

After mapping/routing changes, include:

- changed field;
- adjacent mapped fields;
- missing optional field;
- all conditional mapping branches;
- duplicate/retry;
- target rejection;
- reconciliation;
- old payload compatibility if required.
