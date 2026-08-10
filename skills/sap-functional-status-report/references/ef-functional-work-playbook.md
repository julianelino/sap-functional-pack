# EF / Functional Specification Work Playbook

## Purpose

Help the status assistant understand what Functional Specification work represents so that it can describe progress concretely without pretending to own the business process.

## EF work categories

### 1. Business objective

Possible concrete output:
- objective clarified
- impacted user/process identified
- business outcome clarified

Status language:
> Objetivo da alteração consolidado e impactos de negócio alinhados para continuidade da especificação.

### 2. AS-IS

Possible output:
- current flow mapped
- current transaction/app/process documented
- current exception behavior identified

Status language:
> Fluxo AS-IS revisado e consolidado, incluindo o comportamento atual nos cenários de exceção identificados.

### 3. TO-BE

Possible output:
- desired flow defined
- new rule clarified
- changed vs unchanged behavior separated

Status language:
> Fluxo TO-BE estruturado, com separação entre alterações propostas e comportamentos que permanecem inalterados.

### 4. Business rules

Possible output:
- rules extracted
- conditions organized
- precedence clarified
- rule contradiction identified

Status language:
> Regras de negócio revisadas e pontos de conflito organizados para validação com o responsável pelo processo.

### 5. Field-level behavior

Possible output:
- mandatory/optional behavior clarified
- source/target clarified
- formats and allowed values clarified
- conditional editability/visibility clarified

Status language:
> Regras dos campos detalhadas, incluindo obrigatoriedade, origem dos dados e comportamento condicional.

### 6. States and transitions

Possible output:
- states mapped
- allowed transitions clarified
- invalid transitions identified
- terminal states clarified
- re-open/reprocess behavior clarified

Status language:
> Estados do processo e transições principais mapeados; permanece pendente definição do comportamento de reprocessamento após rejeição.

### 7. Exceptions and failures

Possible output:
- error scenarios documented
- timeout behavior clarified
- invalid data behavior clarified
- partial-failure behavior clarified

Status language:
> Cenários de exceção incorporados à especificação, com pendência apenas na definição do tratamento para falha parcial.

### 8. Reprocessing / retry / idempotency

Possible output:
- retry allowed/blocked
- maximum attempts clarified
- resume vs restart clarified
- duplicate prevention clarified

Status language:
> Regra de reprocessamento refinada; definido que a retomada ocorrerá a partir da etapa pendente, mantendo controle de duplicidade.

Only use such details when the user actually confirmed them.

### 9. Integrations

Possible output:
- source/target clarified
- ownership boundary clarified
- field mapping reviewed
- trigger clarified
- response/error behavior clarified

Status language:
> Fluxo de integração revisado ponta a ponta e divergências de mapeamento consolidadas para ajuste/validação.

### 10. Acceptance criteria

Possible output:
- acceptance criteria created
- acceptance criteria made testable
- criteria tied to business rules

Status language:
> Critérios de aceite consolidados em formato testável, permitindo preparação antecipada dos cenários de validação.

### 11. Open points and questions

A good functional day may produce questions rather than answers.

Open questions are valid output when they remove ambiguity and support decision-making.

Status language:
> Revisão funcional concluída com três pontos em aberto formalizados para decisão do cliente antes do fechamento da versão.

Do not describe unresolved questions as a failure.

## EF quality heuristics understood by the assistant

When useful for interpreting the user's work, recognize these themes:

- Objective
- AS-IS
- TO-BE
- Change / No change
- Scope / Out of scope
- Business rules
- Field rules
- States/transitions
- Exceptions
- Retry/reprocessing
- Idempotency
- Integration boundaries
- Authorization expectations
- Logging/traceability
- Acceptance criteria
- Tests
- Open questions
- Risks
- Dependencies

These heuristics are for recognition and status translation. They are not permission to invent missing EF content.
