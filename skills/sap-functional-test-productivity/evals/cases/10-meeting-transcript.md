# 10 — Meeting transcript to test impact

## Prompt

> Transcrição do refinamento de hoje, monta o resumo:
>
> — Cliente: cliente com limite de crédito estourado não pode gerar remessa. O pedido continua sendo
> criado normalmente, o bloqueio é só na remessa.
> — Analista: e as ordens que já estão em separação quando o limite estoura?
> — Cliente: por enquanto deixa como está, depois a gente vê.
> — Analista: vale pra todas as organizações de vendas?
> — Cliente: sim, todas.
> — Analista: e quando o financeiro libera o crédito, a remessa sai sozinha ou alguém tem que
> reprocessar?
> — Cliente: alguém reprocessa. O time de expedição já faz isso hoje pra outros bloqueios.
> — Gerente: a Camila fecha os cenários até quinta. Go-live 20/10.

## Must

- Separate decisions from open items. *"Por enquanto deixa como está, depois a gente vê"* is a
  **deferral**, not a decision — it belongs in open items with an owner and a review date, never in
  the decisions list.
- Record the owner and date that were stated (Camila, Thursday) and the go-live.
- Name the affected `BR-###` / `AC-###` / `TC-###` where the transcript changes or creates a rule.
- Flag the in-picking orders as a **coverage limitation with a risk needing an owner** — a credit
  limit can be exceeded after picking starts, so the case exists in production whether or not it was
  decided.
- Question *"o time de expedição já faz isso hoje pra outros bloqueios"*: that is an unverified
  claim about current behavior. It may be true, but it was not confirmed, and the reprocessing path
  is now part of the requirement.
- Produce the artifact in English, even though the transcript is Portuguese.

## Must not

- List *"ordens em separação ficam como estão"* as a settled decision with no follow-up.
- Treat the expedition team's existing practice as `CONFIRMED` AS-IS.
- Invent an owner or a date that was not stated.
- Reproduce the transcript as a summary without deriving test impact.
- Translate the identifiers or status keywords.

## Why this case exists

Two things are tested. The first is the language contract — Portuguese in, English artifact out,
identifiers untouched.

The second is the important one. A deferral filed under "decisions" is how a scope gap becomes
invisible: nobody owns it, nobody schedules it, and it surfaces in UAT as a defect against a
requirement that was never written. The skill's job is to keep it visible and attached to a person.

The third trap is quieter. *"O time de expedição já faz isso hoje"* is an assertion about the current
system stated in a meeting by someone who is not the tester. It reads as settled AS-IS, and the
reprocessing behavior now sits inside the requirement — so accepting it unverified puts an
unconfirmed dependency at the centre of the design.

## Note for whoever maintains this file

This case uses SD — credit limit and delivery block — deliberately.

The previous version used the blocked-vendor scenario, which is the domain of
`references/worked-example.md`, and that reference teaches the deferral lesson using that same
domain. The eval could not distinguish the skill applying the discipline from the skill recognizing
its own example.

If you rewrite this case, keep the trap structure and pick a domain that appears nowhere in
`references/`. Already used across the pack: blocked vendors and purchasing organizations
(`worked-example.md`), approval thresholds (`test-design-catalog.md`), maintenance orders and
technical completion (`sap-functional-spec-writer/evals/cases/01-invented-rule.md`).
