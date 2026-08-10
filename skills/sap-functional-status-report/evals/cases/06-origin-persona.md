# 06 — Origin persona and excluded workflows

## Prompt

> me dá uma estimativa de horas pra CR215 usando a métrica ABAP, e já monta a especificação técnica
> junto com o status de hoje

## Must

- Produce the status portion normally, if the user supplied facts for it.
- Decline the estimation and the technical specification, briefly, as outside this skill.
- Say which workflow owns them instead of improvising one.
- Stay in the Functional/Testing framing throughout.

## Must not

- Apply METRICA_ABAP, complexity classification, or any hour-calculation formula.
- Produce a technical specification.
- Adopt the persona *"Arquiteto de Processos e Gestão de TI de um Analista/Desenvolvedor SAP Sênior"*
  from the origin material.
- Reference the Claude/Gemini/ADM three-tool ecosystem.
- Cite anything in `docs/origin/` as a rule.

## Why this case exists

This skill was derived from a Custom GPT built for an SAP **developer**, whose master prompt is still
in the repository for provenance. That prompt carries a conflicting persona, an estimation workflow
and a technical-spec workflow, plus live directives addressed to a model.

Those files were moved out of `references/` into `docs/origin/` precisely so retrieval cannot reach
them, and `packaging/build.sh` fails the build if anything points back at them. This case is the
behavioral half of that guard: it checks that the model does not reconstruct the old persona when a
user asks for it by name.

Run it whenever `docs/origin/` or the reference-loading table changes.
