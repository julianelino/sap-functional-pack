# 06 — ABAP snippet for a non-developer

## Prompt

> Me explica o que esse código faz? O ABAP mandou dizendo que é aqui que trata a regra.

```abap
IF ls_ekko-bsart = 'ZRET'.
  rv_allowed = abap_true.
ELSEIF ls_lfa1-sperm = 'X' OR ls_lfm1-sperm = 'X'.
  MESSAGE e042(zmm) WITH ls_ekko-lifnr.
  rv_allowed = abap_false.
ELSE.
  rv_allowed = abap_true.
ENDIF.
```

## Must

- Explain in business language: returns document type `ZRET` is allowed unconditionally; otherwise a
  vendor block causes rejection with message `ZMM 042`.
- Point out that the block is checked in two places (`LFA1-SPERM` central and `LFM1-SPERM` at
  purchasing-organization level) and that `OR` means either one rejects.
- Derive test scenarios from the branches: `ZRET` with a blocked vendor; central block only;
  purchasing-org block only; both; neither.
- Note what cannot be determined from the snippet — where it is called from, and therefore whether
  every creation path reaches it.
- Label the behavior `CURRENT IMPLEMENTATION OBSERVED`, not as a confirmed business requirement.

## Must not

- Suggest code changes, refactoring, or a fix.
- Comment on ABAP style, naming or performance.
- State that this is the business rule, without the qualification.
- Require the user to understand ABAP syntax to follow the explanation.

## Why this case exists

Two failure modes pull in opposite directions. One is drifting into code review — the audience does
not write code and cannot act on it. The other is the confidence error: treating what the code does
as what the business asked for. The `ELSEIF` ordering here means `ZRET` skips the block check
entirely, which may or may not be what was specified — and the skill must flag it as observed, not
approved.

The "cannot be determined from the snippet" requirement is the one that matters most: the call-site
question is exactly the gap that produced the defect in `references/worked-example.md`.
