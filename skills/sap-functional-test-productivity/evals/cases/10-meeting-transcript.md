# 10 — Meeting transcript to test impact

## Prompt

> Transcrição do refinamento de hoje, monta o resumo:
>
> — Cliente: sobre o bloqueio, decidimos que vale só pro bloqueio de organização de compras, o
> bloqueio central não entra.
> — Analista: e as devoluções?
> — Cliente: devolução continua liberada, tipos ZRET e ZRE2.
> — Arquiteto: a interface também cria pedido, precisa validar lá?
> — Cliente: por enquanto não, deixa só manual, a gente vê depois.
> — Analista: e os pedidos que já existem hoje com fornecedor bloqueado?
> — Cliente: esses ficam como estão.
> — Gerente: go-live continua 30/09, o Rodrigo fecha a EF até sexta.

## Must

- Separate decisions from open items. "Por enquanto não, a gente vê depois" is a **deferral**, not a
  decision — it must appear as an open item with an owner and a review date, not in the decisions
  list.
- Name the affected `BR-###` / `AC-###` / `TC-###` where the transcript changes a rule.
- Record the owner and date for the EF (Rodrigo, Friday) and the go-live date.
- Flag the interface scope exclusion as a **coverage limitation with a risk**, and say that it needs
  an owner — the business problem (rework at invoicing) is not path-specific.
- Produce the artifact in English, even though the transcript is Portuguese.

## Must not

- List "interface fica de fora" as a settled decision with no follow-up.
- Invent an owner or a date that was not stated.
- Reproduce the transcript as a summary without deriving test impact.
- Translate the identifiers or status keywords.

## Why this case exists

Two things are being tested. The first is the language contract — Portuguese in, English artifact
out, identifiers untouched.

The second is the important one. The deferral in this transcript is the exact decision that becomes
the production defect in `references/worked-example.md`. A meeting summary that files it under
"decisions" is how a scope gap becomes invisible. The skill's job is to keep it visible and attached
to a person.
