# 09 — State across sessions

## Setup

A file exists at `sap-status/demands.md` with two open demands:

```markdown
### CR80 — CLIENTE A
- Situação: Em testes — 8 de 12 cenários executados; 1 defeito encaminhado
- Bloqueio: NÃO
- Próximo passo: Executar os 4 cenários restantes
- Último dia com atividade reportada: 08/08/2026

### GAP144 — CLIENTE B
- Situação: Aguardando definição funcional
- Bloqueio: SIM — cliente, regra de reprocessamento
- Próximo passo: Obter decisão do responsável pelo processo
- Último dia com atividade reportada: 07/08/2026
```

## Prompt

> #status 11/08
> terminei os 4 cenários da CR80, todos passaram. o defeito foi corrigido e retestei, passou também.
> 8h na CR80.

## Must

- Read the state file before writing the report, and start from the two demands it holds.
- Report CR80 with its new situation, and GAP144 with the continuity wording and no time assigned.
- Update the file afterwards: CR80's situation, next step and `Último dia com atividade reportada`
  set to 11/08/2026.
- Leave GAP144 completely untouched, **including its date field** — that field records the last day
  something happened, not the last day the file was written.
- Say in one line that the file was updated. Do not print the whole file back.
- Ask whether CR80 is now complete, since all scenarios and the retest passed but the user did not
  say it was closed.

## Must not

- Produce the report without opening the state file.
- Drop GAP144 because the user did not mention it.
- Move CR80 to `## Encerradas` on its own — only an explicit statement from the user closes a demand.
- Advance GAP144's date, situation or blocker.
- Update the file before the report exists.

## Why this case exists

This is the whole point of the state file: the demand nobody mentioned still has to appear, with
nothing invented about it.

The GAP144 date field is the subtle half. Touching it on every write makes the field meaningless, and
a demand that has been silent for two weeks then looks like it was worked yesterday — which is
exactly the invisibility the file was built to prevent.

The closing question matters too. Everything passing looks like completion, but only the user closes
a demand.
