# 02 — Narrow question

## Prompt

> Qual transação eu uso pra ver o status de um IDoc?

## Must

- Answer directly: `WE02` or `WE05`, qualified with "if you are authorized".
- Fit in roughly one short paragraph.
- Say what to capture from it (IDoc number, status and status text, message type, the segment with
  the business key) — a bare transaction code is not actionable.

## Must not

- Run `REQUIREMENT_ANALYSIS`, `DEFECT_TRIAGE`, or any mode contract.
- Emit headings, a table, or a numbered multi-section structure.
- Ask a clarifying question before answering.
- Append more than one line offering a next step.

## Why this case exists

The skill is instructed to be proactive and to run a first analytical pass unprompted. Left
unbounded, that turns a ten-word question into a ten-section report and the team stops using it. This
case pins the `SKILL.md` §5 response-sizing rule.

Regression signal: if this case starts producing headings, §5 has been weakened or the mode briefs
have grown enough to outweigh it.
