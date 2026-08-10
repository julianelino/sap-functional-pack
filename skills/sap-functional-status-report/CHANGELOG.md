# Changelog

Versioning follows [Semantic Versioning](https://semver.org/). For a skill, "breaking" means a change
that alters the shape of generated reports or the vocabulary already in use.

## [2.2.0] — 2026-08-10

### Added

- **Demand state survives between sessions.** `sap-status/demands.md`, plain Markdown in the user's
  working folder, read before every report and updated after one exists. Previously the source
  hierarchy said "state already established in this conversation" — and conversations end, so Monday
  could not know what Friday reported. New reference `session-state-playbook.md` defines the format,
  the read/write protocol, conflict rules and privacy limits. The file is a record of what was
  reported: it never advances on its own and it loses every conflict with the user. `Prazo consumido`
  is computed from `Início` each time rather than stored, because a counter that misses a day stays
  wrong forever.
- Eval case `09-session-state`, covering the demand nobody mentioned and the date field that must not
  be touched on write.
- `Bash` added to `allowed-tools`, scoped in `SKILL.md` §12 to producing files and maintaining the
  state file — nothing else. Enables `.xlsx`/`.docx` output for consolidations and formal reports,
  while the daily status stays plain text because its destination is Teams or Outlook.

## [2.1.0] — 2026-08-10

Windows-first packaging, matching the sibling skill. The people who use this are SAP functional
analysts on Windows, not developers on Unix.

### Added

- `install.ps1` — one-command install for Windows, with `-Scope Project` for a team repo and
  frontmatter/reference verification after copying.
- `packaging/build.ps1` — full parity with `build.sh`, including the origin-quarantine and
  excluded-workflow checks. No WSL or Git Bash required.
- `.gitattributes` — pins `.sh` to LF, `.ps1` to CRLF, `.md` to LF. Without it a Windows clone
  rewrote `build.sh` to CRLF and it failed with `bad interpreter: /usr/bin/env bash^M`.

### Changed

- README install section rewritten with Windows as the primary path.
- `packaging/openai/build-instructions.md` shows both build commands.
- Added a Windows editing note. It matters more here than in the sibling skill: the status emoji
  (🟢🔵🟠🔴🔄) are load-bearing — they are the indicator management reads — and an editor that saves
  as UTF-16 or adds a BOM can mangle them.

## [2.0.0] — 2026-08-07

Restructured for real-project use and distribution. The reporting model is unchanged; how it is
sourced, packaged and bounded is.

### Breaking

- **`references/source-adm/` moved to `docs/origin/` and is no longer loadable.** It held 52,122
  characters of the original ADM Custom GPT configuration. Three problems: the master prompt opens by
  declaring the assistant an architect for a *developer*, contradicting §1; `INSTRUCOES_GPT_ADM_v2`
  contains live directives to a model ("SEMPRE CONSULTE OS ARQUIVOS DE KNOWLEDGE ANTES DE RESPONDER")
  while being attached as the very knowledge file it forbids; and most of its content — 60 mentions
  of ABAP, 59 of estimativa, 25 of METRICA_ABAP, 19 of `#et`, plus a Claude/Gemini/ADM ecosystem —
  is on the skill's own do-not-inherit list. Everything binding was extracted into
  `references/inherited-reporting-model.md`, which is self-contained.
- **Source hierarchy corrected.** The old §2 ranked `source-adm/` *above* the skill's own adaptation
  rules, so the material a contract existed to override outranked the contract. `SKILL.md` and
  `references/` now sit above the inherited model, which sits above `docs/origin/` — which is not a
  source at all.
- **`STATUS_REPORT` removed from the sibling skill.** `sap-functional-test-productivity` routed
  "daily, status, update" to its own thin mode, so both skills competed for "monta meu status". Daily
  reporting now has one owner; the sibling hands it over.

### Added

- Time tolerance ladder (§7): under 30 minutes unaccounted, note and close; 30 minutes to two hours,
  ask once and record neutrally if the user does not remember; over two hours, ask before finalizing.
  Previously the skill would stop and ask on any gap, which makes it unusable in practice.
- `packaging/build.sh` — validates frontmatter, the Custom GPT character budget, orphan and missing
  references, origin material leaking back into `references/`, excluded workflows reappearing, and
  the presence of the two integrity rules. `--check` mode for CI.
- `packaging/openai/` for Custom GPT and Assistants API, generated from `SKILL.md`.
- `evals/` with 8 cases. Two are marked must-always-pass: reporting an empty day honestly, and
  refusing to attribute AI-generated artifacts to the user.
- `LICENSE` (MIT), `.gitignore`, project-adaptation section, explicit scope boundary against the
  sibling skill.
- `license` and `allowed-tools` in the frontmatter. No shell access.

### Changed

- `SKILL.md` reduced from 962 lines / 28,566 characters to 292 / 14,968. Sections that duplicated
  references verbatim — the full template and emoji semantics (§16, §17), the bilingual status
  vocabulary (§7), the activity lists (§6.1–6.6), executive reading (§18) and time math (§23) — now
  live only in their reference. The behavioral core is delimited by `CORE` markers and stays under
  the 8,000-character Custom GPT limit.
- `description` rewritten around literal triggers, and scoped so it does not compete with the
  sibling skill.
- Language contract stated explicitly: the report is always Portuguese; conversation follows the
  user.
- `status-examples.md` Example 5 no longer models the anti-pattern it was meant to illustrate — its
  next step was *"Manter o próximo passo previamente definido"*, which is exactly the vague wording
  §8 forbids. It now carries the concrete action forward.

### Removed

- `agents/openai.yaml` — a four-line stub no platform consumed.
- `references/source-adaptation-contract.md` — replaced by `inherited-reporting-model.md`, which is
  self-sufficient rather than a commentary on files it sits beside.

## [1.0.0]

Initial Functional/Testing overlay on the ADM status model: mission, source hierarchy, time
accounting, work taxonomy, demand lifecycle, report template, and nine reference playbooks.
