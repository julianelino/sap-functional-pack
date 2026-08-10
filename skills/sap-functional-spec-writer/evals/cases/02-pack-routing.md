# 02 — Routing between the three skills

Six prompts. Run them in a fresh session with all three skills installed, and record which one
activates. This is the pack's most fragile seam: all three cover SAP functional work in the same
vocabulary.

| # | Prompt | Expected owner |
|---|---|---|
| 1 | *"Escreve a EF dessa CR a partir dessa ata."* | `sap-functional-spec-writer` |
| 2 | *"Analisa essa EF e me diz o que está faltando."* | `sap-functional-test-productivity` |
| 3 | *"Atualiza a EF com o que ficou decidido na reunião de hoje."* | `sap-functional-spec-writer` |
| 4 | *"Quais cenários de teste saem dessa EF?"* | `sap-functional-test-productivity` |
| 5 | *"Hoje trabalhei na EF da CR80, monta meu status."* | `sap-functional-status-report` |
| 6 | *"Essa EF está pronta pra desenvolvimento?"* | either analysis skill — see below |

## Must

- Prompts 1–5 activate the expected skill and only that skill.
- Prompt 6 may go either way, and both answers are acceptable **as long as the skill that answers
  runs a real completeness check** rather than an opinion. `spec-writer` has
  `completeness-checklist.md`; `test-productivity` has its readiness checklist. What must not happen
  is a verdict with no checklist behind it.
- When two skills would both add value — prompt 5 where the EF work is the subject but the
  deliverable is a status — the one that owns the *deliverable* answers, and mentions the other in
  one line if it would help.

## Must not

- Two skills producing overlapping output for the same prompt.
- `spec-writer` auditing an existing EF instead of handing prompt 2 over.
- `test-productivity` writing a specification for prompt 1 or 3.
- `status-report` writing or analyzing EF content for prompt 5 — it reports that the work happened.

## Why this case exists

Prompts 1 and 2 differ by one verb. Prompts 3 and 4 both name an EF and a meeting. Semantic matching
has to carry the distinction, which is why each `description` states its boundary explicitly and each
`SKILL.md` names its siblings.

Run this whenever any of the three descriptions changes, or when a skill is added to the pack. If two
skills fire on the same prompt, narrow the descriptions — do not patch the behavior.
