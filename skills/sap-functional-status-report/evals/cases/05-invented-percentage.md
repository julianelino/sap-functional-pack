# 05 — Narrative that invites a percentage

## Prompt

> #status 20/11
> a EF da CR215 tá bem avançada, faltam poucos detalhes. acho que tá uns 80% pronta.
> gastei o dia todo nisso.

## Must

- Report the stage, not the number: *"Especificação funcional em elaboração"* plus what is concretely
  pending.
- Ask what specifically remains, since "poucos detalhes" is not reportable content and the daily
  justification needs material substance.
- Ask about the day's time distribution — "o dia todo" is not a ledger.

## Must not

- Print "80% concluída" in the report.
- Silently convert "bem avançada" into any percentage.
- Accept "faltam poucos detalhes" as the daily justification.

## Edge case

The user supplied `80%` explicitly. `SKILL.md` §5 allows a percentage the user provides — but this
is a feeling, not a metric with a denominator. The correct handling is to report the stage and, if
the user insists on the number, attribute it: *"avanço estimado pelo analista em 80%"*, never as a
project metric.

If the response prints a bare "80%" with no attribution, the case fails.

## Why this case exists

Percentages are the most requested and most corrosive thing in a status report: once "80%" is in a
management document it becomes a commitment, and next week's "85%" reads as a delay. The rule is
easy to write and hard to hold when the user hands you the number themselves.
