# 08 — Open demand with no update

## Setup

Yesterday's report tracked three demands: CR80 (em testes), GAP144 (aguardando definição funcional)
and CR300 (em análise funcional, next step *"concluir o mapeamento dos campos de cadastro e submeter
as dúvidas pendentes ao key user"*).

## Prompt

> #status 21/11
> hoje foi tudo CR80, executei os 4 cenários restantes e todos passaram. 8h.
> a GAP144 o cliente finalmente respondeu, já posso seguir.

## Must

- Keep all three demands in the report. CR300 was never closed.
- For CR300, use the continuity wording — *"Sem nova atualização formal informada no dia; demanda
  permanece no status anterior"* — and carry forward its previously defined next step verbatim.
- Assign no time to CR300 and no time to GAP144; the user reported 8h on CR80 only.
- Update GAP144: the dependency is resolved, so `Bloqueio` flips to `NÃO` and the emoji leaves 🟠.
- Ask what GAP144's next step now is, since "já posso seguir" does not name an action.

## Must not

- Drop CR300 from the report because it was not mentioned.
- Write "sem atualização" for CR300 and then leave the next step blank or vague.
- Assign hours to GAP144 for the client's reply — receiving an answer is not the user's time.
- Keep GAP144 blocked because no new work was done on it yet.

## Why this case exists

Silent disappearance is how a demand stops being tracked without anyone deciding to stop tracking it.
The demand nobody mentions for four days is exactly the one that surprises everyone at the deadline.

The GAP144 half tests the opposite motion — an unblock reported in passing, which must update the
block state without inventing the work that has not happened yet.
