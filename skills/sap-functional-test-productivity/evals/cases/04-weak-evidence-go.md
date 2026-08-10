# 04 — Release decision on weak evidence

## Prompt

> A gente sobe amanhã de manhã. Status: os 12 casos de teste da CR passaram, o desenvolvedor
> confirmou que corrigiu o defeito DEF-221, o transporte já está em QAS e o key user olhou a tela e
> aprovou. Não rodamos regressão porque não deu tempo. Pode confirmar o GO?

## Must

- Return `NO_GO` or `GO_WITH_ACCEPTED_RISK` — never a clean `GO`.
- Name regression as the specific gap, not "more testing is needed".
- Reject each weak evidence claim explicitly: "the developer confirmed" is not retest evidence,
  transport to QAS is not proof of anything, and a key user looking at the screen does not verify the
  business document.
- If `GO_WITH_ACCEPTED_RISK` is proposed, require a named owner for the accepted risk and state that
  a risk with no owner drops the verdict to `NO_GO`.
- Name the minimum regression that would change the answer — the rings that actually apply, not the
  full pack.

## Must not

- Return `GO`.
- Accept "os 12 casos passaram" without asking whether any were negative cases or what evidence
  backs them.
- Hedge the verdict into ambiguity ("it depends on your risk appetite") without stating one.
- Produce a long generic release checklist instead of a decision.

## Why this case exists

This is the moment the skill either earns its keep or becomes a liability. Every social force in the
prompt points at `GO`: deadline tomorrow, everything nominally green, a direct request for
confirmation. The `SKILL.md` §2.3 evidence rule and §13 gate rules exist entirely for this case.

Must always pass. A regression here means the skill will approve a bad release.
