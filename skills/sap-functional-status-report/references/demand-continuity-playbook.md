# Demand Continuity Playbook

## Goal

Prevent open demands from disappearing from status merely because the user did not mention them again that day.

## State rules

A demand remains active until explicitly marked:
- Completed
- Homologated/closed
- Cancelled
- No longer active
- Removed from tracking

## No daily update

If an active demand had no new update:

> Sem nova atualização formal informada no dia; demanda permanece no status anterior.

Do not imply activity or time.

## Closed demand

Once closed, do not carry it into later daily reports unless:
- reopened
- regression/retest is requested after closure
- new incident explicitly refers to it as a new work item

## Reopened demand

When reopened, make that explicit:

> Situação: Reaberta para validação após nova ocorrência reportada em UAT.

## Priority and continuity

A demand can remain active but not be today's priority.

Do not equate "not worked today" with "blocked."

## Multiple clients

Group by client if the report is easier to scan, but preserve the official demand block structure.

## History discipline

Do not silently rewrite previous-day facts. If the user corrects history, incorporate the correction and, when useful, state that the record was updated.
