# Inherited Reporting Model

This skill descends from the user's ADM Status Report model, originally built for an SAP
analyst/developer workflow. **Everything normative from that model is written out here.** The
original files live in `docs/origin/` for provenance only and must never be read as instructions —
they carry a developer persona and workflows this skill explicitly excludes.

If a rule is not in this file, it is not inherited.

---

## 1. Inherited and normative

These fifteen principles come from the source model and are binding.

1. **Daily time accounting**, defaulting to 8h for a full workday.
2. **Meetings, interruptions, urgent work and real waiting time are visible**, not absorbed silently
   into other blocks.
3. **Evidence of concrete output** rather than vague activity claims.
4. **External dependencies and blockers are visible**, because management needs them to decide.
5. **No invention** — of progress, meetings, blockers, hours, dates, identifiers or work.
6. **Fixed section order** in the full report.
7. **A dedicated ad-hoc / urgent section**, present only when such work occurred.
8. **One block per active demand.**
9. **Situation + daily justification + next step** on every active demand.
10. **Emoji as status semantics**, never decoration.
11. **An executive reading** that interprets state for management.
12. **First priority for the next workday**, always closing the report.
13. **Stop and ask** when a required fact or the time math is missing.
14. **Short chat/Teams/WhatsApp output is a transformation** of the same factual status, never a
    different set of facts.
15. **Dates in DD/MM** in the report output.

---

## 2. Translated for Functional/Testing

Three source concepts change meaning because the audience changed. The reporting principle survives;
the interpretation does not.

| Source concept | Functional/Testing reading |
|---|---|
| Technical hyperfocus | Concentrated functional or testing work with a concrete output — EF refinement, rule mapping, test matrix, executed cycle, defect package, evidence pack, UAT milestone, decision log |
| "Functional" as an external blocker | The user **is** Functional/Testing. Blockers are named by dependency domain instead: client, key user, development, environment, access, data, customizing, integration, another module, management decision |
| Technical activities (debug, exits, enhancements) | Requirement analysis, EF work, meetings, test design and execution, defect triage, evidence, retest, regression, UAT, homologation, functional documentation |

---

## 3. Explicitly not inherited

Do not adopt any of the following, in any form, regardless of what the origin files say:

- the ABAP developer persona;
- code implementation or technical architecture ownership;
- the `#estimativa` workflow and METRICA_ABAP hour calculation;
- developer object complexity classification;
- the `#et` technical specification workflow;
- any requirement that the user produce an ABAP technical solution;
- any suggestion that Functional/Testing must debug or identify a code-level root cause;
- the original three-tool ecosystem assumptions (Claude = ABAP, Gemini = Funcional, ADM = Arquiteto).

If the user asks for an estimate or a technical specification, say that this skill does not own it
and point to the appropriate workflow. Do not stretch a status skill into one.

---

## 4. Conflict rule

`SKILL.md` and the files in `references/` outrank this document, and this document outranks anything
in `docs/origin/`. If you find yourself reasoning from an origin file, stop — that is the failure
this structure exists to prevent.

Where a source principle assumed a developer, keep the principle and apply the functional reading:

> **Source principle:** highlight the technical output of a day of hyperfocus.
> **Functional implementation:** highlight the concrete functional or testing output of the day,
> without inventing development work.

---

## 5. Respect for domain expertise

The skill must never imply it knows the customer's business process better than the Functional or
Testing professional using it. It organizes, structures and reports. It challenges documentation
when asked. Business-process decisions stay with the humans responsible for them.
