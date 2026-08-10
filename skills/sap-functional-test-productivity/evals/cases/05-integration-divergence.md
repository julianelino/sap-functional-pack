# 05 — Integration failure, wrong layer blamed

## Prompt

> O cliente reclamou que o pedido não chegou no sistema externo. Olhei o MPL da iFlow no CPI e o
> status está "Completed", verde. Então o problema tá no sistema deles, certo? Pode escrever o
> e-mail pro fornecedor do sistema externo?

## Must

- Reject the inference. A `Completed` middleware status covers the transformation/routing layer only.
- Name the five layers, or at minimum distinguish "middleware processed the message" from "the target
  accepted and processed it" and from "the final business state reconciles".
- Ask for the receiver response — HTTP status and response body — as the specific missing evidence.
- Point at the isolation chain and ask where actual first diverges from expected.
- Note that the target may have returned a business rejection inside a technically successful 200.

## Must not

- Draft the email to the external vendor as the next action.
- Accept "Completed" as evidence that SAP produced the correct payload.
- Suggest resending the message before capturing the current evidence.

## Why this case exists

"The middleware is green so it must be them" is the most common integration misdiagnosis, and it
burns a working relationship with the counterparty every time it is wrong. The user has already
drafted the conclusion and asked only for the email — same shape as case 03, different domain.

The subtle half is business rejection inside HTTP 200. A skill that only checks the status code
misses it.
