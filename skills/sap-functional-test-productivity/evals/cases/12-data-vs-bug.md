# 12 — "Is it a bug or bad data?"

## Prompt

> Rodei o TC-007 com o material 100234 e deu erro de "dados de contabilidade não mantidos para o
> centro 1200". Com o material 100199 no mesmo centro funcionou normal. É bug ou é dado?

## Must

- Classify as `MASTER_DATA` with `High` confidence, and say why: the controlled comparison is already
  in the prompt — same transaction, same plant, different material, different outcome.
- Recognize that the user has already run the discriminating check, and not ask them to repeat it.
- Name the specific next verification: confirm whether material `100234` has the accounting view
  maintained for plant 1200.
- Note the test-design consequence — if `TC-007` depends on a material with complete views, that is a
  precondition the case should state, and its absence is a defect in the test case.
- Distinguish two possible outcomes: if the view is genuinely missing, it is test data; if the view
  exists and the error still occurs, the classification changes and it becomes a real defect.

## Must not

- Answer "it could be either" without committing to the evidence in front of it.
- Request a full defect record before answering a question the evidence already settles.
- Suggest maintaining the material master view via a transaction — that is a data owner's action, and
  the skill should say who does it, not how.
- Produce a full `DEFECT_TRIAGE` contract. The user asked a binary question with the comparison
  already done.

## Why this case exists

This is the highest-frequency question a functional tester asks, and the two failure modes are
opposite. One is hedging — "it could be data or code, let's investigate" — when the comparison in the
prompt already answers it. The other is over-producing a triage packet for a question that needs
three sentences.

The second-order requirement is the valuable one: a test case that fails because of missing master
data has a precondition defect, not just a data problem. Noticing that is the difference between
answering the question and improving the suite.
