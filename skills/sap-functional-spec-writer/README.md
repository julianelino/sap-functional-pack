# SAP Functional Specification Writer

Writes the EF — the functional specification that goes to the developer to build and to the client to
approve. From meeting notes, emails and decisions, not from a blank page.

Part of the [SAP Functional Pack](../../README.md).

---

## The rule that defines it

**It never writes a rule nobody decided.**

Anything unstated becomes an open point `Q-###`, never a careful assumption dressed as a decision.
Every rule carries its source and a confidence mark — `CONFIRMADO`, `A VALIDAR` or `EM ABERTO`.

An EF with eight honest open points is worth more than one that reads complete and has eight invented
rules in it. The invented ones come back as defects in UAT, with the client's approval on top of
them.

---

## Try it

```
escreve a EF da CR80 a partir dessa ata
```
```
atualiza a EF com o que ficou decidido hoje
```
```
essa EF está pronta pra desenvolvimento?
```
```
como eu escrevo a regra de reprocessamento aqui?
```

Paste whatever you have: meeting notes, an email thread, the demand description, the client's own
template.

The document comes out in **Portuguese** — it is approved by the business and read by key users. If
your project works in another language, say so once and it follows.

---

## What it produces

Identificação · Objetivo de negócio · Escopo e fora de escopo · AS-IS · TO-BE · Regras de negócio ·
Regras de campo · Estados e transições · Mensagens · Reprocessamento · Integrações · Autorização ·
Impactos · Critérios de aceite · Cenários sugeridos · Premissas e riscos · Pontos em aberto ·
Histórico de versões

Sections that do not apply are removed with a note. Sections that apply but have no content stay,
marked `EM ABERTO` — an absent section reads as "not applicable", which is a different claim.

If your client mandates their own template, it follows theirs exactly and tells you where the content
landed.

---

## Boundaries

| You want to | Skill |
|---|---|
| **Write** or update a specification | this one |
| **Analyze** a specification that exists — gaps, risks, tests | `sap-functional-test-productivity` |
| Report that you worked on the EF today | `sap-functional-status-report` |

---

## Install

### Windows

```powershell
.\install.ps1
```

Then open a new Claude session. To install all three skills at once, use the pack installer one level
up.

### macOS / Linux

```bash
cp -r sap-functional-spec-writer ~/.claude/skills/
```

---

## Contributing

1. Edit `SKILL.md` or a reference. Never edit `packaging/openai/*` — generated.
2. Run the build:
   ```powershell
   .\packaging\build.ps1        # Windows
   ```
   ```bash
   ./packaging/build.sh         # macOS / Linux
   ```
   It fails if the core prompt outgrows the Custom GPT limit, a reference is orphaned or missing, the
   no-invention rule or a confidence mark disappears, or the sibling boundaries stop being declared.
3. Run `evals/`. `01-invented-rule` must always pass.

---

MIT licensed. Copyright © 2026 Juliane Lino — see [LICENSE](LICENSE).
