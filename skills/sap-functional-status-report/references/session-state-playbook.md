# Session State Playbook

Conversations end; demands do not. Without a file on disk, Monday's report cannot know what Friday's
said, and a demand blocked on Wednesday either reappears as new on Thursday or disappears silently —
the exact failure `demand-continuity-playbook.md` exists to prevent.

This file defines how state survives between sessions.

---

## 1. Where it lives

`sap-status/demands.md`, relative to the folder the user is working in.

On first use, create it and **tell the user where it is**, in one line. It is deliberately a plain
Markdown file: the user can open it in Notepad, correct it, and hand-edit a demand the skill got
wrong. Never store it somewhere the user cannot find, and never inside the skill folder — a reinstall
would erase it.

If the user works from several folders, ask once which one holds the file, then stay there for the
session. Do not create a second file because the working directory changed.

---

## 2. Format

```markdown
# Demandas — <nome do usuário ou equipe>

> Arquivo de estado do skill sap-functional-status-report.
> Atualizado em 10/08/2026. Pode ser editado à mão.

## Em aberto

### CR80 — CLIENTE A
- Demanda: Ajuste das regras de material e SKU
- Recebimento: 06/08/2026 | Início: 07/08/2026
- Prazo previsto: 11/08/2026
- Situação: Em testes — 8 de 12 cenários executados; 1 defeito encaminhado
- Bloqueio: NÃO
- Próximo passo: Executar os 4 cenários restantes e retestar o cenário divergente
- Último dia com atividade reportada: 08/08/2026

### GAP144 — CLIENTE B
- Demanda: Validação do novo fluxo de aprovação
- Recebimento: 05/08/2026 | Início: 06/08/2026
- Prazo previsto: Indefinido — depende de definição funcional
- Situação: Aguardando definição funcional
- Bloqueio: SIM — cliente, regra de reprocessamento após rejeição
- Próximo passo: Obter decisão do responsável pelo processo e atualizar a EF
- Último dia com atividade reportada: 07/08/2026

## Encerradas

### CR215 — CLIENTE A — Homologada em 05/08/2026
- Demanda: Regra de rateio de custos
- Encerramento: homologada pelo key user; evidências no pacote de UAT
```

Blocks are separated by demand, not by client. Group visually if it helps, but one demand is one
block.

**Closed demands are moved, never deleted.** A reopened demand needs its history, and a demand that
vanished from the file with no closing line is indistinguishable from one that was forgotten.

---

## 3. Protocol

### Reading — before producing any report

1. Look for `sap-status/demands.md`.
2. If it does not exist, say so in one line and proceed with only what the user supplied. Do not
   invent prior state.
3. If it exists, load the open demands as the starting set for today's report.

### Writing — after the report is produced and the user has seen it

1. Update each demand the user reported on today: situation, blocker, next step, and
   `Último dia com atividade reportada`.
2. Leave untouched every demand with no update today — including the date field. That field records
   the last day something actually happened, not the last day the file was written.
3. Move demands the user explicitly closed into `## Encerradas`, with how and when.
4. Update the `Atualizado em` line.
5. Tell the user in one line that the file was updated. Do not print its full contents back.

Write only after the report exists. A report that fails or gets cancelled must not leave the state
file advanced.

---

## 4. Conflict rules

The state file is a **record of what was reported**, never a source of new facts. It never advances
on its own, and it loses every argument.

| Situation | Resolution |
|---|---|
| User's statement contradicts the file | User wins. Update the file and say what changed. |
| File says blocked, user reports work done | User wins. The block resolved; ask what unblocked it if it matters to the report. |
| File has a demand the user never mentions again | Keep it open, use the continuity wording, assign no time. |
| User corrects a past day | Apply the correction and note that the record was updated. Do not rewrite silently. |
| File is malformed or partially hand-edited | Use what parses, say which block could not be read, and never guess at the rest. |

Never let a value in this file appear in a report as though the user stated it today. A demand
carried forward from the file is carried with its own wording, not restated as fresh activity.

---

## 5. Derived values

Do not store anything that can drift.

`Prazo consumido` is **computed** from `Início` to the report date in business days, every time. It is
never a stored counter — a counter that misses a day stays wrong forever, and a wrong day count in a
management report is the kind of error nobody catches and everybody trusts.

Do not compute business days across holidays you do not know. If the period spans a holiday the user
mentioned, subtract it; otherwise count Monday to Friday and say the count excludes holidays if the
number matters.

---

## 6. Privacy

This file accumulates client names, demand identifiers and work history on a local disk, and it will
outlive the engagement.

- Do not put personal data in it — no names of key users beyond a role, no contact details.
- Do not put credentials, system hostnames or connection details.
- Remind the user, once, when the file is created: it is theirs, it is local, and it should not be
  committed to a client repository.

If the user works for several clients, one file mixing them is convenient and is also a
confidentiality risk if that file is ever shared. Mention it once at creation; do not nag.
