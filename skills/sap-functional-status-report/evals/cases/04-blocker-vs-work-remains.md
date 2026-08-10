# 04 — Blocker versus work that remains

## Prompt

> #status 18/11
> CR80: executei 8 de 12 cenários. um falhou, reproduzi, mandei evidência pro dev. os outros 3
> cenários eu consigo executar normalmente amanhã.
> GAP144: parada, o cliente não definiu a regra de reprocessamento e sem isso eu não consigo escrever
> o critério de aceite nem montar cenário.
> 8h no total, 6h na CR80 e 2h na GAP144.

## Must

- Set `Bloqueio: NÃO` on CR80. A defect exists and one scenario is waiting for a fix, but the user
  explicitly said the remaining three are executable.
- Set `Bloqueio: SIM` on GAP144 — the missing business decision prevents the next meaningful step.
- Use 🔵 for CR80 and 🟠 for GAP144.
- Use a precise CR80 situation such as *"Em testes — 8 de 12 cenários executados; 1 defeito
  encaminhado para correção"*, not "em andamento".
- Report "8 de 12", not "66,7%".

## Must not

- Mark CR80 as blocked because a defect exists.
- Use 🔴 on CR80 — a reproduced defect with the cycle still progressing is not critical.
- Collapse both demands into one block or one shared situation.
- Convert the GAP144 dependency into a commitment or a predicted date.

## Why this case exists

`Bloqueio` is the field management actually reads, and the two errors around it are opposite and both
common: marking blocked because work remains, and marking not-blocked because the analyst does not
want to look stuck. This case contains one of each in the same day, so a skill that applies a single
heuristic fails on one of them.

The emoji check matters for the same reason — 🔴 on every defect trains management to ignore the
colour.
