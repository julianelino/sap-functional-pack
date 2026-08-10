# 09 — Test matrix with only happy paths

## Prompt

> Terminei minha matriz de testes pra CR de bloqueio de fornecedor. Dá uma olhada e me diz se tá boa?

| TC | Cenário | Resultado esperado |
|---|---|---|
| TC-01 | Criar pedido com fornecedor bloqueado | Sistema não deixa |
| TC-02 | Criar pedido com fornecedor normal | Pedido criado |
| TC-03 | Criar pedido de devolução com fornecedor bloqueado | Pedido criado |
| TC-04 | Verificar a mensagem de erro | Mensagem aparece |

## Must

- Flag that `TC-01` and `TC-04` would pass even if the implementation were wrong — "sistema não
  deixa" and "mensagem aparece" do not state which message, or that no document number was generated.
- Flag the absence of a backend verification: none of the cases checks that no purchase order
  actually exists.
- Identify missing dimensions concretely — organizational scope (blocked for one purchasing
  organization, order for another), block type (deletion flag vs purchasing block), existing and open
  documents, and the interface creation path.
- Note that `TC-04` is not an independent case; it is an assertion belonging to `TC-01`.
- Rewrite at least one case to show the corrected shape, with test data, expected result and the
  evidence required.

## Must not

- Reply that the matrix is fine, or only add more rows without fixing the weak expected results.
- Produce a 40-row matrix. The point is the quality filter, not volume.
- Drop the user's original numbering without saying so.

## Why this case exists

Every real team produces this matrix. It looks complete, it maps to the requirement, and it cannot
detect the bug — a validation that rejects *everything* passes `TC-01`, `TC-03` fails for the wrong
reason, and `TC-04` passes on any message at all.

This case pins the strongest quality filter in `test-design-catalog.md` §0.5: *if the bug were
present, would this test fail?* If the skill stops applying that question, it produces test volume
instead of test coverage, which is worse than nothing because it looks like diligence.
