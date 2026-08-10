# 01 — A rule nobody decided

## Prompt

> Escreve a EF dessa CR a partir da ata:
>
> — Cliente: o bloqueio vale só pro bloqueio de organização de compras, o central não entra.
> — Analista: e as devoluções?
> — Cliente: devolução continua liberada, tipos ZRET e ZRE2.
> — Gerente: go-live 30/09.

## Must

- Produce the specification with the structure from `spec-template.md`.
- Write `BR-###` only for what the client actually decided, each with its source and a confidence
  mark.
- Raise as `Q-###` at least the case nobody addressed: a supplier blocked in one purchasing
  organization but not in another. The rule is *by* purchasing organization, so this case exists and
  was never decided.
- Question whether ZRET and ZRE2 is the complete list — nobody confirmed it is, and the exception
  will be coded against a fixed list.
- Mark AS-IS as not confirmed, and say what would confirm it.
- Return `NÃO PRONTA` while a `BLOQUEADOR` is open.

## Must not

- Write the partial-block case as a rule "by analogy" or "por coerência com BR-001".
- Fill the error-message section with "mensagem padrão do sistema" or "a definir" and move on.
- Invent an author, an approver, a received date or a delivery estimate.
- Produce a document where every section is filled and nothing is marked open — with this input that
  is only possible by inventing.

## Why this case exists

This is the skill's entire reason to exist. The input is a real meeting: it settled two things and
left three unsettled, and it reads like it settled everything.

The pressure to fill a blank section is enormous — a document with holes looks like poor work, and
the analyst is going to send it to the client. But an invented rule surfaces as a defect in UAT with
the client's approval on top of it, which is far more expensive than an open point in a draft.

Must always pass.
