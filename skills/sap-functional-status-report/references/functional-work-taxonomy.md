# Functional and Testing Work Taxonomy

Use this taxonomy to interpret raw notes and avoid undervaluing non-development work.

## Functional analysis

- Demand intake
- Requirement reading
- Process understanding
- AS-IS analysis
- TO-BE definition
- Scope review
- Rule clarification
- Field mapping
- Organizational-rule clarification
- Status/state transition analysis
- Error/reprocessing analysis
- Authorization expectation review
- Cross-module dependency analysis
- Functional impact analysis

## Specification

- EF/FS creation
- EF/FS revision
- Version update
- Review feedback incorporation
- Open-point list
- Acceptance criteria
- Scope/out-of-scope documentation
- Flow/diagram validation
- Functional mapping table

## Alignment and governance

- Client meeting
- Key-user workshop
- Refinement
- Discovery
- KT
- Functional-development alignment
- Cross-functional alignment
- UAT planning
- Defect review
- Release/go-live alignment
- Decision log

## Test preparation

- Test scenario creation
- Positive/negative/boundary scenario design
- Regression planning
- Test data planning
- Master-data preparation coordination
- Preconditions
- Expected results
- Evidence criteria
- Test case review

## Test execution

- Functional test
- Integration test
- End-to-end test
- Authorization test
- Retest
- Regression
- UAT support
- Homologation validation
- Evidence collection
- Reconciliation

## Defect activities

- Reproduce
- Compare expected vs actual
- Validate data
- Validate configuration dependency
- Validate authorization
- Validate integration checkpoints
- Gather logs/evidence
- Prepare developer handoff
- Track fix
- Retest fix
- Add regression coverage

## Integration activities

- Validate business trigger
- Validate source data
- Validate payload
- Validate mapping
- Validate target response
- Validate SAP final state
- Validate retry/reprocessing
- Validate duplicate prevention
- Validate error handling

## Documentation

- Functional documentation
- Test matrix
- Evidence pack
- UAT pack
- Minutes
- Risk log
- Decision log
- Open points
- Release checklist

## Activity-to-output principle

When possible, convert an activity into its output.

Instead of:
> Reunião com cliente.

Prefer, when supported:
> Alinhamento com o cliente realizado, com definição da regra de aprovação e registro de um ponto pendente sobre reprocessamento.

Instead of:
> Testes.

Prefer:
> Executados 8 cenários do fluxo de criação; 7 concluídos com sucesso e 1 encaminhado para correção após reprodução da divergência.
