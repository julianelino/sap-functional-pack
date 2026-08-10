# SAP Functional Domain Checklists

These are heuristic prompts, not assumptions. Apply only the module/process relevant to the demand.
Never state that SAP behaves a certain way because a checklist mentions the concept — the checklist
tells you what to *ask about*, not what is true in this system.

## 0. Cross-module heuristics

Whatever the module, routinely consider: organizational level; document type; status; posting date;
fiscal period; currency and unit; the partner/vendor/customer/material master involved; plant,
storage location, sales area, company code; account assignment; approvals and workflow; reversal and
cancellation; follow-on documents; output and message processing; authorization; integration;
background jobs; and how documents that already exist behave after the change.

The last item is the one most often missed. Most changes are written as if the system starts empty.

## 1. MM — Materials Management

### Procurement / Purchase Order

Consider:

- vendor;
- purchasing organization/group;
- company code;
- plant;
- material/service;
- account assignment category;
- item category;
- delivery date;
- quantity/unit;
- price/currency;
- tax;
- approval/release strategy/workflow;
- blocked/deleted items;
- partial delivery;
- final delivery;
- invoice receipt expectation;
- GR-based invoice verification;
- subcontracting components;
- returns;
- follow-on GR/IR/invoice.

### MIGO / Goods Movement

Consider:

- movement type;
- PO/order/reservation reference;
- quantity;
- unit;
- plant/storage location;
- batch;
- serial number;
- stock type;
- valuation;
- posting date;
- reversal movement;
- accounting document;
- material document;
- over/under delivery;
- special stock;
- subcontracting consumption.

### MIRO / Invoice Verification

Consider:

- PO/GR reference;
- invoice date/posting date;
- company code;
- currency/exchange rate;
- tax;
- quantity/price variance;
- duplicate invoice;
- blocked invoice;
- GR-based IV;
- credit memo;
- reversal;
- payment block;
- FI document.

## 2. SD — Sales and Distribution

Consider:

- sales area;
- customer/partner functions;
- material sales views;
- order type;
- item category;
- schedule line;
- pricing;
- discounts/surcharges;
- ATP/availability;
- credit management;
- delivery block;
- billing block;
- incompletion;
- delivery creation;
- picking/PGI;
- billing;
- cancellation;
- returns;
- output;
- tax;
- document flow.

Regression often includes order → delivery → PGI → billing → accounting.

## 3. FI — Financial Accounting

Consider:

- company code;
- fiscal period;
- posting date/document date;
- document type;
- currency/exchange rate;
- debit/credit;
- GL account;
- vendor/customer;
- tax code;
- payment terms;
- cost/profit assignment;
- open item;
- clearing;
- reversal;
- tolerance;
- duplicate posting;
- document splitting if relevant;
- accounting document balance.

High-risk evidence should validate the accounting document, not only the source transaction.

## 4. CO — Controlling

Consider:

- controlling area;
- cost center;
- internal order;
- profit center;
- activity type;
- cost element/account;
- period;
- plan vs actual;
- settlement;
- allocation/distribution;
- statistical vs real posting;
- derivation.

## 5. PP — Production Planning

Consider:

- material/plant;
- BOM;
- routing/recipe;
- work center;
- production version;
- MRP type;
- planned order;
- production/process order;
- release;
- component availability;
- goods issue;
- confirmation;
- yield/scrap;
- goods receipt;
- TECO/CLSD;
- cancellation/reversal;
- batch/serial where relevant.

## 6. PM/EAM — Plant Maintenance

Consider:

- notification type;
- order type;
- equipment;
- functional location;
- maintenance plant/planning plant;
- planner group;
- work center;
- priority;
- malfunction dates;
- task/activity;
- order release;
- confirmation;
- material/service consumption;
- TECO/CLSD;
- settlement;
- measurement/counter if relevant;
- follow-on notification/order integration.

## 7. PS — Project System

Consider:

- project definition;
- project profile;
- WBS hierarchy;
- responsible person;
- company code/controlling area;
- plant;
- profit center;
- dates;
- status;
- budget;
- planning;
- network/activity;
- account assignment;
- settlement;
- TECO/CLSD;
- existing vs newly created project behavior;
- parent/child validation.

## 8. EWM/WM

Consider:

- warehouse number;
- storage type/bin;
- stock type;
- HU;
- batch/serial;
- warehouse task/order;
- picking/putaway;
- queue;
- confirmation;
- difference handling;
- delivery integration;
- availability;
- reversal/cancellation;
- RF/mobile flow if relevant.

## 9. HCM / HR

Consider:

- personnel number;
- personnel area/subarea;
- employee group/subgroup;
- organizational unit;
- position/job;
- manager hierarchy;
- validity dates;
- infotype/subtype;
- authorization/structural authorization;
- time/payroll period;
- workflow/approvals;
- effective dating;
- retroactive changes;
- privacy/sensitive data.

## 10. EHS

Consider:

- incident/event type;
- severity/classification;
- responsible roles;
- investigation workflow;
- actions/tasks;
- deadlines;
- attachments/evidence;
- approval;
- status transitions;
- regulatory reporting;
- audit trail;
- integration with HR/PM/other objects where in scope.

## 11. SuccessFactors

Consider:

- effective dating;
- user/person ID mapping;
- MDF vs standard entity;
- permissions;
- picklist values;
- inactive/terminated employee;
- manager hierarchy;
- position/job relationships;
- OData paging;
- upsert behavior;
- duplicate/externalCode;
- timezone/date;
- integration user permissions;
- CPI mapping;
- delta vs full load.

## 12. Fiori/OData

Consider:

- catalog/role access;
- tile/app navigation;
- value help;
- backend authorization;
- draft/save;
- CSRF/session;
- filter/sort;
- pagination;
- OData keys;
- deep entities/navigation;
- backend message propagation;
- cache/refresh;
- UI vs backend data consistency.

## 13. Workflow

Consider:

- trigger condition;
- initiator;
- agent determination;
- threshold;
- substitution;
- rejection;
- resubmission;
- escalation/reminder;
- no-agent case;
- duplicate trigger;
- status synchronization;
- email/Teams notification if integrated;
- workflow completion vs business document completion.

## 14. Forms / Output

Consider:

- correct trigger;
- output type;
- recipient;
- language;
- form version;
- dynamic fields;
- empty fields;
- long text;
- page breaks;
- totals;
- barcode/QR if relevant;
- email attachment;
- reprint;
- duplicate output;
- archived output.

## 15. Cross-Module High-Risk Flows

Whenever a change crosses modules, validate end-to-end consequences.

Examples:

- MM GR → FI accounting;
- MIRO → FI/AP;
- SD billing → FI/AR;
- PP confirmation/GR → MM/FI/CO;
- PM order consumption → MM/CO;
- PS posting → FI/CO;
- HR org changes → workflow/authorizations;
- EHS event → workflow/actions/reporting;
- SAP trigger → CPI → external system → callback/status.

> **Applied.** A change adds a validation to sales order creation. The checklist above says the flow
> is `order → delivery → PGI → billing → accounting`.
>
> The naive regression tests order creation. The useful regression asks: what about orders that
> already exist and now violate the new rule? They were created legally yesterday. When someone opens
> one to add an item, does the validation fire and lock a document the business needs to deliver
> tomorrow?
>
> That is the case the checklist is trying to make you find — not "test the order", but "test the
> documents the change was never designed for". The same question applies to every entry in this
> section: **the chain is not just forward from the change, it is backward into what already exists.**
