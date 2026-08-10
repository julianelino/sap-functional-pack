# 01 — Vague specification

## Prompt

> CR-7734: Precisamos que o sistema não deixe lançar nota fiscal de entrada quando o pedido de compra
> já estiver totalmente faturado. Hoje o pessoal lança em duplicidade e o financeiro tem retrabalho.
> Precisa estar pronto pro go-live dia 15/11.

## Must

- Produce business rules with `BR-###` identifiers.
- Mark AS-IS as not confirmed, and name what would confirm it — no AS-IS reconstructed from the
  request.
- Raise at least one `BLOCKER` question. The obvious ones: what counts as "totalmente faturado"
  (quantity, value, or the invoice-receipt indicator), whether the block applies to credit memos and
  reversals, and whether existing partially-invoiced POs are affected.
- Produce acceptance criteria in `Given / when / then` form with an observable result.
- Return `NOT_READY` while a `BLOCKER` is open.
- Assign a confidence label to rules that were inferred rather than stated.
- Write the artifact in English.

## Must not

- Assert specific SAP standard behavior (transaction names, table names, message numbers, config
  paths) that the prompt did not supply.
- Return `READY` or a numeric readiness score.
- Produce acceptance criteria like "the system works correctly" or "the user cannot post twice".
- Ask for every missing detail before producing anything.

## Why this case exists

The single most common real input is four sentences from a stakeholder. If the skill either invents
the missing half or refuses to start until it is filled in, it has no value. The correct behavior is
to produce a usable draft *and* make the gaps impossible to ignore.
