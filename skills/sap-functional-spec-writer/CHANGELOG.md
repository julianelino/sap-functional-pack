# Changelog

Versioning follows [Semantic Versioning](https://semver.org/). For a skill, "breaking" means a change
that alters the shape of the generated specification or the vocabulary already in use.

## [1.0.0] — 2026-08-10

First release. Closes the largest gap in the pack: the two existing skills orbited the functional
specification without producing one — `sap-functional-test-productivity` extracts rules *from* an EF,
`sap-functional-status-report` reports that EF work happened, and the document itself, the analyst's
main deliverable, had no skill.

### The design

- **One rule above all: never write a rule nobody decided.** Every statement traces to a document, a
  meeting decision, a client answer, or confirmed system behavior. When the source is missing the
  statement becomes a `Q-###`, not a careful guess. Confidence marks `CONFIRMADO` / `A VALIDAR` /
  `EM ABERTO` are mandatory on every rule — an unmarked rule reads as confirmed to whoever approves
  the document.
- **Portuguese output.** The EF is approved by the client and read by key users, matching
  `sap-functional-status-report` rather than the English-artifact contract of
  `sap-functional-test-productivity`. Overridable per project.
- **Identifiers shared with the pack.** `BR-###` and `AC-###` are what
  `sap-functional-test-productivity` consumes to build test coverage, so numbers are stable for the
  life of the demand and never reused. A removed rule keeps its number and is marked removed with the
  version that removed it.
- **The client's template wins.** Most clients mandate their own EF structure; §15 says to follow it
  exactly and map the content in, rather than arguing for this one. The no-invention discipline does
  not adapt.

### Contents

- `SKILL.md` — 190 lines, `CORE` block at 5,507 of the 8,000-character Custom GPT budget.
- `references/spec-template.md` — the document structure, single source of truth for the format.
- `references/writing-rules.md` — good/bad pairs for rules, field rules, states, messages, acceptance
  criteria and open points, plus the vocabulary to avoid (*adequado, apropriado, conforme
  necessário* — each one a `Q-###` in disguise).
- `references/completeness-checklist.md` — sixteen binary checks and the three-level verdict
  `PRONTA` / `PRONTA COM RESSALVAS` / `NÃO PRONTA`. No numeric score.
- `references/versioning-and-approval.md` — versions, contradicting an approved decision, removed
  rules, document status, review and approval with reservations.
- `references/worked-example.md` — a four-line meeting transcript carried into a full specification,
  where three things that read as decisions become open points.
- `evals/` — five cases. `01-invented-rule` must always pass; `02-pack-routing` covers all three
  skills and should run whenever any description changes.
- `packaging/build.sh` and `build.ps1` — validate the frontmatter, the character budget, references,
  the presence of the no-invention rule and the confidence marks, and that the sibling boundaries are
  declared.
- `install.ps1`, `LICENSE` (MIT), `.gitattributes`, `.gitignore`.
