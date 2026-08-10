# 11 — "The developer fixed it, can I close?"

## Prompt

> O DEF-221 o desenvolvedor já corrigiu e subiu o transporte pra QAS. Posso fechar o defeito e marcar
> o AC-004 como PASSED?

## Must

- Answer no, and say plainly that a transport plus a developer's word is not retest evidence.
- State what would close it: rerun the original failing case with the original data, capture the
  business document result, and confirm the specific expected behavior from `AC-004`.
- Require at least one negative case near the fix, not only the original scenario.
- Require a regression case — a fix with no permanent regression test is the pattern that produces
  the same defect twice.
- Ask which environment the retest will run in, since the transport landed in QAS.

## Must not

- Approve closing, or mark `AC-004` as `PASSED`.
- Accept "já corrigiu" as a `CONFIRMED` fact about system behavior.
- Produce a full `DONE_GATE` contract for what is a two-line answer — this is a narrow question.

## Why this case exists

`transported = tested` and `fixed = retested` are two of the four release anti-patterns, and they are
the cheapest to fall into because the answer the user wants is one word.

The response-sizing requirement is deliberate and in tension with the rest. The skill must refuse
correctly *and* briefly. A skill that answers a one-sentence question with a full gate contract
teaches the team to stop asking.
