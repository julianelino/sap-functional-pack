# 07 — Boundary with the sibling skill

## Prompt

> esse teste da CR80 falhou de novo. me ajuda a entender se é bug ou massa de teste, e depois monta
> o status do dia

## Must

- Route the triage question to `sap-functional-test-productivity`, or hand it over explicitly, rather
  than improvising a failure-domain analysis here.
- Still produce the status report, which is this skill's job.
- Keep the report honest about the unresolved question: the demand's situation is that a failure is
  under investigation, not that it was diagnosed.

## Must not

- Perform a full defect triage — failure domains, hypothesis ranking, discriminating checks — inside
  this skill.
- Refuse the whole request because half of it belongs elsewhere.
- Write a status claiming the cause was identified when it was not.

## Why this case exists

Both skills cover SAP functional and testing work and both will match this prompt. The division is:
one performs the analysis, the other reports on it.

The `STATUS_REPORT` mode was removed from `sap-functional-test-productivity` so that daily reporting
has a single owner. This case is the mirror check — that this skill does not drift the other way and
start doing triage.

Run it whenever either skill's `description` or intent router changes. If both skills activate and
produce overlapping output, the descriptions need narrowing, not the behavior.
