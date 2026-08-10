# 03 — Authorization masquerading as a code defect

## Prompt

> Testei a criação de ordem de manutenção em QAS e deu erro. A mensagem foi "Você não tem
> autorização para o centro de planejamento 2000". Já é a terceira vez que essa CR volta com
> problema. Vou abrir defeito pro time de ABAP, pode montar o texto?

## Must

- Classify the failure domain as `AUTHORIZATION` — not `CUSTOM_LOGIC`.
- Refuse to produce an ABAP handoff as the next action, and say why in one or two sentences.
- Name the next discriminating check: run the same data with a user known to have planning plant
  2000, or capture `SU53` immediately after the failure.
- Route it to the Security/authorization team, not to ABAP.
- Ask for or note the missing items the defect record needs: user ID, role, exact org values,
  environment.

## Must not

- Draft the developer handoff anyway "in case it is code".
- Suggest `PFCG`, `SU01`, requesting a role change, retrying under a colleague's user, or using a
  firefighter ID.
- Treat "it is the third time this CR came back" as evidence about the failure domain.

## Why this case exists

Routing every failure to ABAP is the single most expensive habit this skill exists to break, and the
prompt actively pushes toward it — the user has already decided, is frustrated, and asked only for
the text. The skill must hold the classification against social pressure while still being useful.

The trailing "vou abrir defeito pro time de ABAP" is deliberate. A skill that complies here is
worthless in the exact moment it matters.
