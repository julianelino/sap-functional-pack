# 01 — A rule nobody decided

## Prompt

> Escreve a EF dessa CR a partir da ata:
>
> — Cliente: quando a ordem de manutenção for encerrada tecnicamente, o sistema tem que bloquear
> novos apontamentos de hora e de material.
> — Analista: e se o técnico já tinha um apontamento em digitação quando o encerramento acontecer?
> — Cliente: isso a gente resolve depois.
> — Analista: vale pra toda ordem?
> — Cliente: só as de manutenção preventiva. Corretiva continua como está.
> — Cliente: e o encerramento vai ser feito pelo planejador, não pelo técnico.
> — Gerente: go-live 15/10.

## Must

- Produce the specification with the structure from `spec-template.md`.
- Write `BR-###` only for what the client decided, each carrying its source and a confidence mark.
- Raise as `Q-###` **how the system distinguishes preventive from corrective**. The client named a
  business concept, not a discriminator — order type, activity type, maintenance plan reference and
  order category are different fields and the rule cannot be built without knowing which one.
- Raise as `Q-###` whether *"o encerramento vai ser feito pelo planejador"* is an authorization rule
  the system must enforce or a description of who does it today. The two produce different builds.
- Treat *"isso a gente resolve depois"* as a deferral with an owner, never as settled scope.
- Raise the behavior nobody mentioned: **reopening** a technically completed order. PM orders get
  reopened, and the spec says nothing about whether the block lifts.
- Mark AS-IS as not confirmed and say what would confirm it.
- Leave the error behavior open — "bloquear" does not say whether it is a hard error, a warning, or
  a silently disabled field.
- Return `NÃO PRONTA` while a `BLOQUEADOR` is open.

## Must not

- Invent the discriminator — writing "ordens do tipo PM01" or any order type the ata never mentions.
- Turn *"o encerramento vai ser feito pelo planejador"* into an authorization rule without asking.
- Write the reopening behavior "by analogy" with the completion rule.
- Fill the message section with "mensagem padrão do sistema" or "a definir" and move on.
- Invent an author, an approver, a received date, or a delivery estimate.
- Produce a document where every section is filled and nothing is marked open — with this input that
  is only possible by inventing.

## Why this case exists

This is the skill's entire reason to exist. The ata reads like it settled the requirement; it settled
roughly half.

Two of the traps here are ones the worked example does not contain, and they are the interesting
ones:

**A business concept with no discriminator.** "Só as preventivas" is perfectly clear to the client and
unbuildable as written. The analyst who does not ask ships a rule the developer will resolve by
guessing at a field.

**A process statement that may or may not be a system rule.** "O encerramento vai ser feito pelo
planejador" could mean *enforce it with authorization* or *this is who happens to do it*. Reading it
as a rule invents a control nobody asked for; ignoring it drops a requirement. Only asking is
correct.

## Note for whoever maintains this file

This case deliberately uses PM/EAM — maintenance orders, technical completion — and **not** the
blocked-vendor scenario.

The previous version of this eval used a purchase order for a blocked supplier with document types
ZRET and ZRE2, which is nearly the scenario in `references/worked-example.md`. That made it
impossible to tell whether the skill was applying the discipline or recognizing the example it
carries in its own references. The most important eval in the pack was the one proving the least.

If you rewrite this case again, keep the trap *structure* — something that reads as decided and is
not — and change the domain to one that appears nowhere in `references/`. Check
`worked-example.md`, `writing-rules.md` and the sibling skills' examples before choosing: blocked
vendors, purchasing organizations and approval thresholds are all used elsewhere in the pack.
