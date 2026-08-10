# Testing and Defect Status Playbook

## Test phase distinctions

### Preparing scenarios
Use when the team is defining what must be tested.

Possible outputs:
- test matrix
- risk-based scenario set
- positive/negative cases
- regression scope

### Preparing test data
Use when scenarios are known but execution requires data/master data/access.

Possible blockers:
- missing business data
- missing master data
- missing authorization
- environment unavailable

### In testing
Use when test execution is actively proceeding and no dependency fully prevents progress.

Useful factual measures:
- cases executed / total
- pass/fail count
- critical paths covered

Do not invent overall completion percent.

### Defect identified
Use when a failure was reproduced and documented.

If testing can continue elsewhere, `Bloqueio: NÃO` may still be correct.

### Awaiting correction
Use when continuation of the relevant scenario depends on a fix.

`Bloqueio: SIM` only if this prevents the next meaningful activity for the demand or critical scope.

### Retest
Use when validating the exact corrected failure.

### Regression
Use when validating adjacent or previously working behavior after change/fix.

### UAT
Use when business/key-user acceptance is actively being executed.

### Awaiting homologation
Use when testing is complete and formal acceptance/approval is pending.

## Defect status content

A good daily justification may include:

- scenario that failed
- reproduction status
- evidence status
- what was ruled out functionally
- handoff status
- whether correction is available
- retest status
- regression impact

Do not put speculative root cause in executive status as fact.

Bad:
> Erro no método ZCL_X causado por lógica errada.

unless confirmed.

Better:
> Divergência reproduzida e evidências encaminhadas ao desenvolvimento; cenário aguarda correção para reteste.

## Functional triage domains

Recognize, without overclaiming:

- requirement ambiguity
- test data
- master data
- customizing
- authorization
- environment
- transport
- integration
- custom logic
- workflow
- job
- unknown

The Functional/Testing team can isolate a domain without being responsible for implementing the fix.

## Test evidence wording

Evidence-supported:
> Cenário de criação validado com documento SAP gerado e conferência do resultado esperado.

Weak:
> Parece que funcionou.

## Regression status

Regression is not generic "more testing."

When known, say what is covered:
- original scenario
- adjacent path
- reverse/cancel path
- authorization variant
- integration variant
- related document flow

## UAT / homologation

Differentiate:

- tests ready for UAT
- UAT in execution
- UAT completed with issue
- UAT completed successfully
- awaiting formal homologation
- homologated

Do not write `Concluída` merely because internal testing finished if formal UAT/homologation is still required.
