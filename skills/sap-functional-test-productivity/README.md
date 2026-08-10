# SAP Functional & Testing Productivity

An AI skill for **SAP functional analysts and testers who do not write code**. It turns
specifications into testable rules, rules into risk-based coverage, failures into evidence-backed
defects, and stops "it's done" claims that no evidence supports.

You do not need to learn any commands. Paste what you have and ask in plain language.

---

## What it does for you

| You have | You get |
|---|---|
| A CR, GAP, WI or functional spec | Business rules, acceptance criteria, the questions nobody asked, and a readiness verdict |
| A change about to be built | What else it can break, and the regression scope that matters |
| A test to design | A risk-ordered test matrix with expected results and the evidence each case needs |
| A test to run | An execution pack — data, preconditions, steps, what to capture |
| A failed test | Triage: is it data, config, authorization, or code — and the one check that settles it |
| A screenshot someone called "proof" | Whether it actually proves the claim, and exactly what is missing |
| An ABAP/CDS/CPI artifact | What it does in business terms, and which test scenarios its branches imply |
| A meeting tomorrow | The decisions to force and the questions that get a usable answer |
| A release decision | `GO` / `GO_WITH_ACCEPTED_RISK` / `NO_GO`, with the blocker named |

It will **not** write ABAP for you, and it will not tell you a defect is fixed because someone said
so.

---

## Try it

Speak naturally, in your own language. The skill routes itself.

- *"Analisa essa EF e me diz o que está faltando."*
- *"Quais cenários de teste estão faltando aqui?"*
- *"Prepara meus testes de UAT pra essa mudança."*
- *"Esse teste falhou — é bug ou dado ruim?"*
- *"Essa evidência é suficiente pra fechar o AC-004?"*
- *"Que regressão eu rodo depois dessa correção?"*
- *"Explica funcionalmente esse trecho de ABAP."*
- *"Prepara as perguntas pra reunião de refinamento."*
- *"A gente pode subir pra produção?"*

Paste alongside the question whatever you have: spec text, an email, a screenshot, an error message,
a payload, a CPI log, meeting notes, a spreadsheet of test cases.

Answers come back in your language; **generated artifacts are always in English**, because they get
pasted into Jira/ALM and read by mixed teams. Identifiers (`BR-001`, `TC-014`, `PASSED`, `NO_GO`)
never change.

---

## Install

### Windows (Claude Code / Claude.ai)

Open **PowerShell** in the folder you unzipped, and run:

```powershell
.\install.ps1
```

That is all. The script copies the skill to `%USERPROFILE%\.claude\skills`, checks the frontmatter
and confirms every reference arrived.

If PowerShell refuses to run the script — *"execution of scripts is disabled on this system"* — allow
it for that window only:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

To install into a specific project instead, so the whole team gets it from the repo:

```powershell
.\install.ps1 -Scope Project -ProjectPath C:\Projetos\cliente-x
```

**Then open a new Claude session.** Skills are read at session start, so the one you are in will not
see it. After that the skill activates on its own when you mention a CR, a test, a defect, evidence,
an interface failure or a release decision. There is no command to memorize.

### macOS / Linux

```bash
cp -r sap-functional-test-productivity ~/.claude/skills/     # everywhere
cp -r sap-functional-test-productivity .claude/skills/       # one project
```

### OpenAI (Custom GPT or Assistants API)

See `packaging/openai/build-instructions.md`. Build first — `.\packaging\build.ps1` on Windows,
`./packaging/build.sh` elsewhere.

### Any other assistant

Use `SKILL.md` as the system prompt and make `references/` retrievable.

---

## What is in the package

```
SKILL.md            The skill itself — role, doctrine, routing, modes, gates.
references/         Loaded on demand, not all at once:
  templates.md                       every artifact format (single source of truth)
  requirement-analysis.md            spec analysis, impact, readiness
  test-design-catalog.md             coverage heuristics, 24 categories
  defect-triage-playbook.md          failure domains and isolation
  integration-testing-playbook.md    CPI, Proxy, OData, IDoc, RFC, files
  sap-domain-checklists.md           MM, SD, FI, CO, PP, PM, PS, EWM, HCM, SF, Fiori…
  evidence-and-quality-gates.md      evidence levels, Ready/Done/Go-No-Go
  safety-and-data-handling.md        transaction limits, LGPD/GDPR, secrets
  meeting-and-productivity-playbook.md
  worked-example.md                  one demand carried end to end
packaging/          Multi-platform build + validation
evals/              Regression cases for the skill itself
```

---

## Safety

The skill only suggests **read-only** diagnostic transactions, and only qualified by "if you are
authorized". It will not walk a tester through table maintenance, the debugger, role changes,
transport manipulation or any bypass of a control — those get routed to the team that owns them.

It redacts secrets and personal data from anything it generates, and it flags material that should
not be pasted into a ticket as-is. See `references/safety-and-data-handling.md`.

---

## Adapting it to your project

The skill ships a default vocabulary (`BR-`/`AC-`/`TC-` prefixes, `S1–S4`, `P0–P3`,
`NOT_RUN/PASSED/FAILED/BLOCKED`). If your Jira, ALM, Solution Manager or Azure DevOps project uses
different values, state them once in a project `CLAUDE.md` or a pinned instruction — the skill honors
the project over its own defaults. See `SKILL.md` §16.

---

## Contributing changes

1. Edit `SKILL.md` or a reference. Never edit anything under `packaging/openai/` — it is generated.
2. Run the build. It fails if the core prompt outgrows the Custom GPT limit, if a reference is
   orphaned or missing, or if a keyword spelling drifts.

   ```powershell
   .\packaging\build.ps1            # Windows
   .\packaging\build.ps1 -Check     # validate only, for CI
   ```
   ```bash
   ./packaging/build.sh             # macOS / Linux
   ./packaging/build.sh --check
   ```

   Both scripts run the same checks and produce identical output.
3. Run the cases in `evals/` and compare against their acceptance criteria.
4. Record the change in `CHANGELOG.md`.

### Editing on Windows

`.gitattributes` pins `.md` and `.sh` to LF and `.ps1` to CRLF, so a clone behaves the same on every
machine. Two things still to watch:

- **Save as UTF-8.** These files contain accented Portuguese. Notepad defaults to UTF-8 on current
  Windows, but older editors and `Out-File` in PowerShell 5.1 may write UTF-16 or add a BOM, which
  breaks the frontmatter parser. VS Code shows the encoding in the status bar.
- **Never "fix" the line endings of `packaging/build.sh`.** Converted to CRLF it dies with
  `bad interpreter: /usr/bin/env bash^M` for anyone on WSL or macOS.

Keep `SKILL.md` lean. Everything that is not routing, doctrine or a contract belongs in a reference —
`SKILL.md` is loaded into context on every activation; references are not.

---

MIT licensed. Copyright © 2026 Juliane Lino — see [LICENSE](LICENSE).

Built from real SAP functional and testing work. If you adapt it for your own landscape, the parts
worth changing first are `references/sap-domain-checklists.md` and the vocabulary in `SKILL.md` §16.
