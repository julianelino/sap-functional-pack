# Changelog

Versioning follows [Semantic Versioning](https://semver.org/). For a skill, "breaking" means a change
that alters the shape of generated artifacts or the vocabulary teams have already adopted.

## [3.2.0] — 2026-08-10

### Added

- **Artifacts can be delivered as files.** `Bash` added to `allowed-tools`, scoped in `SKILL.md` §17
  to producing deliverables and local file access — never networking or installs. Test matrices,
  traceability and execution packs compose with the `xlsx` skill; handoffs, defect reports and RCAs
  with `docx`; Go/No-Go summaries with `pptx`. The skill offers the file rather than imposing it:
  anything destined for a Jira paste stays as text.
- Redaction rules extended explicitly to generated files. A spreadsheet of test data with real
  personal data in it travels further than a chat message.

### Note

The Custom GPT core prompt now sits at 7,986 of its 8,000-character budget. The next addition to the
`CORE` block will fail the build — which is the build working, but it means any future core change
has to trade something out first.

## [3.1.0] — 2026-08-10

Windows-first packaging. The people who use this skill are SAP functional analysts on Windows, not
developers on Unix — the install path had been written for the wrong audience.

### Added

- `install.ps1` — one-command install for Windows. Copies `SKILL.md` and `references/` to
  `%USERPROFILE%\.claude\skills`, skips development material, verifies the frontmatter and confirms
  every referenced file arrived. Supports `-Scope Project` for a team repo and handles the
  execution-policy case in the docs.
- `packaging/build.ps1` — full parity with `build.sh`, so Windows does not need WSL or Git Bash.
  Counts Unicode code points rather than UTF-16 units, so the character budget matches `wc -m`.
- `.gitattributes` — pins `.sh` to LF, `.ps1` to CRLF, `.md` to LF. Without it, a clone on Windows
  with `core.autocrlf=true` rewrote `build.sh` to CRLF and it failed with
  `bad interpreter: /usr/bin/env bash^M`. Silent, and it would have hit the first person to clone.

### Changed

- README install section rewritten with Windows as the primary path, PowerShell commands, and an
  explicit note that skills load at session start.
- `packaging/openai/build-instructions.md` shows both build commands.
- Added a Windows editing note covering UTF-8 encoding and not "fixing" `build.sh` line endings.

## [3.0.0] — 2026-08-07

Restructured for real-project use and multi-platform distribution. Behavior is preserved; the
packaging, consistency and safety posture are not.

### Breaking

- **Keyword spellings unified.** `NOT REPRODUCED` → `NOT_REPRODUCED`, `NOT RUN` → `NOT_RUN`,
  `READY WITH RISKS` → `READY_WITH_RISKS`, `GO WITH ACCEPTED RISK` → `GO_WITH_ACCEPTED_RISK`,
  `NO-GO` → `NO_GO`, `DONE WITH RESIDUAL RISK` → `DONE_WITH_RESIDUAL_RISK`. Existing artifacts using
  the old spellings still read fine, but new output will not match old filters.
- **Test matrix is nine columns**, not eleven. `Preconditions` and `Steps` moved to the test case
  template where they belong — they were never usable inside a matrix row.
- **Numeric quality scores removed.** The 0–100 rubrics for requirement quality and test coverage are
  gone; they were not reproducible between runs and were being quoted as measurements. Readiness now
  uses a twelve-item checklist plus the three-level verdict. Defect report quality is a ten-item
  binary checklist with a stated threshold.
- **Artifacts are always English.** Previously the skill said "respond in the user's language" while
  shipping English templates, so output drifted between runs. Conversation prose still follows the
  user; artifacts, labels and identifiers do not.

### Added

- `references/safety-and-data-handling.md` — read-only transaction guidance, an explicit
  never-suggest list (SM30/SM31, SE16N edit, SE38/SE80, debugger, PFCG/SU01, SM59, STMS/SE09/SE10),
  stop conditions, secret handling, and LGPD/GDPR rules for personal data in test evidence.
- `references/requirement-analysis.md` — spec analysis, the challenge checklist, impact layers, blast
  radius and the readiness checklist, moved out of `SKILL.md`.
- `references/worked-example.md` — one demand carried from an ambiguous four-sentence email through
  rules, questions, a test matrix, a UAT failure, triage and regression scope.
- `packaging/build.sh` — builds the OpenAI prompts and validates the package: frontmatter, name vs
  directory, Custom GPT character budget, orphan and missing references, keyword drift, dead external
  skill dependencies, safety rules present. `--check` mode for CI.
- `packaging/openai/` — Custom GPT and Assistants API deployment, generated from `SKILL.md`.
- `evals/` — regression cases for the skill itself.
- Response-sizing rules, a default row in the intent router, and a project-adaptation section for
  teams whose ALM vocabulary differs.
- `allowed-tools` in the frontmatter, restricting the skill to file operations. No shell access.
- `LICENSE` (MIT) and `.gitignore`. The generated OpenAI prompts are build artifacts and are not
  tracked.

### Changed

- `SKILL.md` reduced from 2,038 lines / 50,619 characters to 376 lines / ~22,800 characters. Six
  sections that duplicated reference content verbatim (test dimensions, failure domains, integration
  dimensions, evidence levels, SAP heuristics, output contracts) now live only in their reference.
  The core behavioral block is delimited by `CORE:BEGIN`/`CORE:END` markers and stays under the
  8,000-character Custom GPT limit — the previous version was 6.3× over and could not be deployed
  there at all.
- `description` rewritten around literal trigger terms so the skill actually activates.
- `references/templates.md` is now the single source of truth for every artifact format; conflicting
  layouts elsewhere were removed.
- Worked examples added to the checklist-heavy sections. A test that would pass even if the bug were
  present is now called out explicitly as the primary filter for weak test cases.

### Removed

- Section 30, "Existing Skill Composition" — ~90 lines describing nine other skills
  (`test-review`, `logic-review`, `bug-investigator`, `systematic-debugging`, `root-cause-analysis`,
  `verification-before-completion`, `writing-plans`, `handoff`, `sap-abap`). None are guaranteed to
  exist on a third party's machine, one never existed at all, and the section taught no behavior.
- `agents/openai.yaml` — a four-line stub no platform consumed.

## [2.0.0]

Comprehensive English-language rewrite: lifecycle orchestrator, intent router, seventeen modes,
output contracts, seven reference playbooks.
