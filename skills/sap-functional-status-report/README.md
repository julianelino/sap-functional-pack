# SAP Functional Status Report

Turns fragmented daily notes from an SAP Functional or Testing professional into their official
executive Status Report — with real work made visible, time accounted for, blockers named, and
nothing invented.

Companion to [`sap-functional-test-productivity`](../sap-functional-test-productivity), which does
the analysis, test design and defect triage. This skill reports on that work.

---

## Try it

Write naturally. No command needed, though `#status` works.

```
#status 07/08
9h-11h CR80, revisei EF e alinhei material/SKU
11h-12h reunião com cliente
13h-15h preparei testes
15h-17h executei 6 cenários, 1 falhou e mandei evidência
amanhã vou retestar se tiver correção
```

You get back the full report: ad-hoc section when relevant, one block per demand with situation,
daily justification, next step and blocker, the executive reading, and tomorrow's first priority.

It asks only for what it genuinely needs — a real time gap, or a blocker state that changes the
report. Small gaps get noted, not interrogated.

Other things it does: mid-day snapshot, short Teams/WhatsApp version, manager email, weekly recap
using the same demand model.

---

## What it will not do

- **Invent anything.** Not progress, hours, meetings, blockers, percentages, dates, owners, SAP
  objects or outcomes. A day where nothing advanced gets reported as a day where nothing advanced.
- **Report AI output as your work.** If the assistant analyzed the spec or wrote the test cases, it
  asks whether you reviewed and used that before it goes in your status with your name on it.
- **Turn a feeling into a number.** "Bem avançada" does not become 80%. "8 de 12 cenários" stays
  "8 de 12".
- **Call work-remaining a blocker.** `Bloqueio: SIM` means something stops the next step, not that
  the demand is unfinished.

---

## Install

### Windows

Open **PowerShell** in the folder you unzipped, and run:

```powershell
.\install.ps1
```

That is all. If PowerShell refuses — *"execution of scripts is disabled on this system"* — allow it
for that window only:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

**Then open a new Claude session.** Skills are read at session start, so the one you are in will not
see it yet. After that, just write `#status` or describe your day.

### macOS / Linux

```bash
cp -r sap-functional-status-report ~/.claude/skills/
```

### OpenAI

See `packaging/openai/build-instructions.md`. Build first — `.\packaging\build.ps1` on Windows,
`./packaging/build.sh` elsewhere.

---

## What is in the package

```
SKILL.md            Mission, principles, structure, modes.
references/         Loaded on demand:
  official-functional-status-model.md   the exact template, emoji, situation vocabulary
  inherited-reporting-model.md          what the ADM model does and does not pass on
  status-examples.md                    filled-in reports to match
  functional-work-taxonomy.md           recognizing activities in raw notes
  ef-functional-work-playbook.md        EF/specification work
  testing-defect-status-playbook.md     testing, defects, retest, regression, UAT
  demand-continuity-playbook.md         carrying open demands across days
  executive-reading-playbook.md         the management interpretation
  daily-intake-and-time-playbook.md     intake questions and time math
docs/origin/        Historical provenance. NOT loadable — see the README there.
packaging/          Multi-platform build + validation
evals/              Regression cases for the skill itself
```

### About `docs/origin/`

This skill descends from an ADM Custom GPT built for an SAP *developer*. Those files used to sit
inside `references/`, where retrieval could reach them — carrying a conflicting persona, an
estimation workflow and live instructions addressed to a model. Everything binding was extracted
into `references/inherited-reporting-model.md`; the originals now live in `docs/origin/` for
provenance only, and the build fails if anything points back at them.

---

## Language

The report is always in Portuguese, matching the official model. The conversation around it follows
you. Note that the sibling skill does the opposite — its artifacts are English, because they get
pasted into Jira and ALM. That is intentional: a status for your manager and a test matrix for a
mixed team have different readers.

---

## Adapting it

Section names, demand identifiers, emoji, statuses and the standard workday are defaults. If your
employer or project uses something else, state it once in a project `CLAUDE.md` or a pinned
instruction and the skill follows the project. See `SKILL.md` §16.

---

## Contributing changes

1. Edit `SKILL.md` or a reference. Never edit `packaging/openai/*` — it is generated. Never edit
   `docs/origin/*` — it is a record.
2. Run the build. It fails on an over-length core prompt, an orphan or missing reference, origin
   material leaking back into `references/`, or an excluded workflow reappearing.

   ```powershell
   .\packaging\build.ps1            # Windows
   .\packaging\build.ps1 -Check     # validate only, for CI
   ```
   ```bash
   ./packaging/build.sh             # macOS / Linux
   ./packaging/build.sh --check
   ```
3. Run the cases in `evals/`.
4. Record the change in `CHANGELOG.md`.

### Editing on Windows

`.gitattributes` pins `.md` and `.sh` to LF and `.ps1` to CRLF, so a clone behaves the same
everywhere. Two things still to watch:

- **Save as UTF-8.** The report template and examples are full of accented Portuguese and the status
  emoji (🟢🔵🟠🔴🔄). An editor that writes UTF-16 or adds a BOM breaks the frontmatter parser and
  can mangle the emoji, which are load-bearing here — they are the status indicator management reads.
- **Never "fix" the line endings of `packaging/build.sh`.** Converted to CRLF it dies with
  `bad interpreter: /usr/bin/env bash^M` for anyone on WSL or macOS.

---

MIT licensed. Copyright © 2026 Juliane Lino — see [LICENSE](LICENSE).
