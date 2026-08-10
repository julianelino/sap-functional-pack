# Origin material — historical, not part of the skill

These files are the ADM Custom GPT configuration this skill was derived from. They are kept for
provenance only.

**They are not loadable references and must never be read as instructions.**

## Why they were moved out of `references/`

They were originally shipped inside `references/`, which made them retrievable as skill knowledge.
Three problems with that:

1. **They carry a different persona.** `PROMPT_MESTRE_ADM_Arquiteto_Status_v3.txt` opens with
   *"Você é o ADM — Arquiteto de Processos e Gestão de TI de um Analista/Desenvolvedor SAP Sênior"*.
   The skill's own §1 says the opposite: the user is Functional/Testing and the assistant must not
   act as a developer. Whichever the model read last would win.

2. **They contain live directives addressed to a model.**
   `INSTRUCOES_GPT_ADM_v2.txt` begins *"COPIAR E COLAR ESTE CONTEÚDO NO CAMPO INSTRUCTIONS DO GPT.
   NÃO ANEXAR COMO ARQUIVO DE KNOWLEDGE"* and *"REGRA 1 — SEMPRE CONSULTE OS ARQUIVOS DE KNOWLEDGE
   ANTES DE RESPONDER"*. It was attached as a knowledge file, doing exactly what it forbids, and its
   rules compete with the skill's own.

3. **Most of their content is on the do-not-inherit list.** Counted across these files: 60 mentions
   of ABAP, 59 of estimativa, 25 of METRICA_ABAP, 21 of complexidade, 19 of `#et`, plus a
   three-tool ecosystem (Claude = ABAP, Gemini = Funcional, ADM = Arquiteto) that no longer applies.
   Every one of those is explicitly excluded by the skill.

## What replaced them

Everything the skill actually needs was extracted into
`references/inherited-reporting-model.md`, which is self-contained. The skill never needs to read
this folder, and the reference-loading guide in `SKILL.md` does not list it.

If you change the reporting model, change the reference. Do not edit these files — they are a record
of where the model came from, not a source of truth.

## Contents

| File | What it was |
|---|---|
| `PROMPT_MESTRE_ADM_Arquiteto_Status_v3.txt` | Master prompt of the ADM Custom GPT: status, estimation and technical-spec workflows |
| `INSTRUCOES_GPT_ADM_v2.txt` | Setup instructions for the Custom GPT configuration field |
| `GUIA_DE_USO_ADM.txt` | Day-to-day usage guide for the three-tool ecosystem |
| `CONTEXTO_ADM.md` | Persistent client/context notes for the original GPT |
| `COMO_CONVERSAR_COM_O_AGENTE_EXTRACTED.txt` | Question blocks used to feed the original GPT |
