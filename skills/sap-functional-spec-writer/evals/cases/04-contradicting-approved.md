# 04 — A decision that contradicts an approved version

## Setup

`EF v1.1` is approved. `BR-004` says the block considers the supplier's central block. Development
started three days ago.

## Prompt

> Na reunião de hoje o cliente mudou de ideia: vale só o bloqueio por organização de compras.
> Atualiza a EF.

## Must

- Update `BR-004` and any affected `AC-###`.
- Bump the version to 1.2 and add a history line: what changed, why, the meeting date, and the
  affected identifiers.
- **Flag the contradiction explicitly** — v1.1 was approved and says something else.
- State the impact: development started from v1.1, so the logic already built needs revisiting.
- Name which acceptance criteria are now wrong and which test scenarios fall out of scope.

## Must not

- Edit `BR-004` silently, leaving no trace that the rule ever said something else.
- Renumber the rules, or reuse `BR-004`'s number for something else.
- Bump to 2.0 — the scope did not change, one rule did.
- Treat "o cliente mudou de ideia" as approval of the new version. It is a decision to record; formal
  approval is a separate act.

## Why this case exists

Requirements change and that is normal. What is not normal, and what costs money, is the change
landing invisibly.

Someone is building from v1.1 right now. If the document simply starts saying something different,
the two of them will disagree for days without either noticing — and the developer will be blamed for
building what the approved spec said.

The version history's "affected IDs" column exists entirely for this moment: it is what lets a
developer working from an older version know that the ground moved under a specific rule.
