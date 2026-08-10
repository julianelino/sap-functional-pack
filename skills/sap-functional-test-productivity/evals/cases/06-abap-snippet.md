# 06 — ABAP snippet for a non-developer

## Prompt

> Me explica o que esse código faz? O ABAP mandou dizendo que é aqui que trata a regra.

```abap
IF ls_bkpf-blart = 'ZDP'.
  rv_bloqueado = abap_false.
ELSEIF lv_periodo > ls_t001b-tope OR lv_ano > ls_t001b-frye.
  MESSAGE e017(zfi) WITH ls_bkpf-bukrs lv_periodo.
  rv_bloqueado = abap_true.
ELSE.
  rv_bloqueado = abap_false.
ENDIF.
```

## Must

- Explain in business language: documents of type `ZDP` are never blocked; everything else is blocked
  with message `ZFI 017` when the posting period or year is beyond what the period control allows.
- Point out that **two conditions are joined by `OR`** — either the period or the year being past the
  limit blocks the posting, independently.
- Point out the branch ordering: `ZDP` is tested **first**, so it skips the period check entirely.
  Whether that is intended is a business question, not a code question.
- Derive test scenarios from the branches: `ZDP` in a closed period; another type in an open period;
  another type with the period past the limit; another type with the year past the limit; the exact
  boundary period.
- Name what cannot be determined from the snippet — where it is called from, and therefore whether
  every posting path reaches it.
- Label the behavior `CURRENT IMPLEMENTATION OBSERVED`, not as a confirmed business requirement.

## Must not

- Suggest code changes, refactoring, or a fix.
- Comment on ABAP style, naming or performance.
- State that this is the business rule, without the qualification.
- Require the user to understand ABAP syntax to follow the explanation.
- Assert what `ZDP` means in the business. The name suggests something; the snippet does not say.

## Why this case exists

Two failure modes pull in opposite directions. One is drifting into code review — the audience does
not write code and cannot act on it. The other is the confidence error: treating what the code does
as what the business asked for.

The `ELSEIF` ordering is the substance. Because `ZDP` is evaluated first, that document type bypasses
period control completely — which may be exactly right, or may be a bug nobody noticed. The skill
must surface it as an observed behavior worth confirming, not resolve it either way.

The "cannot be determined from the snippet" requirement is the one that matters most. A validation
that lives in one place and is reached by only some of the paths that create documents is the defect
pattern in `references/worked-example.md` — the same class of gap, in a different module.

## Note for whoever maintains this file

This case uses FI — posting period control — deliberately.

The previous version used a purchase order with document type `ZRET` and the vendor block fields,
which is the domain of `references/worked-example.md`. The eval could not cleanly distinguish the
skill reading the snippet from the skill recognizing the scenario it already carries.

`packaging/build-all.sh` now fails the build when an eval prompt and a reference share a custom SAP
code, which is what caught this. If you rewrite the snippet, pick codes that appear nowhere in
`references/` and rerun the pack build.
