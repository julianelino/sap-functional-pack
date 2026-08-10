# Official Functional Status Model

This is the Functional/Testing overlay for the ADM status structure. It does not replace the original sources under `source-adm/`; it translates their structure to Functional/Testing work.

## Full format

```text
STATUS DE FECHAMENTO DO DIA - DD/MM


DEMANDAS AD-HOC / URGÊNCIAS ATENDIDAS NO DIA
(Omitir caso não existam.)

[CLIENTE - NOME DA DEMANDA]

- Atuação: <análise funcional, alinhamento, especificação, teste, triagem, validação, reunião, UAT etc.>
- Tempo consumido: <horas/período>
- Status: <Concluído / Em andamento>
- Planejamento: <continuidade, se houver>


------------------------------------------------------------


STATUS DAS DEMANDAS DA EXPECTATIVA DIÁRIA


[EMOJI] [CLIENTE - WI / CRQ / GAP / INC]

- Demanda: <título/resumo>
- Recebimento: <DD/MM> | Início: <DD/MM>
- Prazo estimado / Entrega prevista: <data ou Indefinido - motivo>
- Prazo consumido: <X dias úteis> | Bloqueio: <SIM/NÃO>

- Situação:
  <etapa funcional/teste + estado concreto>

- Justificativa do dia:
  <avanço material, validação, teste, descoberta, decisão ou razão objetiva de não avanço>

- Próximo passo:
  <ação imediata seguinte>

💡 Leitura executiva:
- <risco, dependência, decisão ou entrega relevante>
- <impacto/condição para continuidade, quando aplicável>


------------------------------------------------------------


PLANEJAMENTO / PRIORIDADE DE PRIMEIRA HORA DE AMANHÃ - DD/MM

<primeiro foco concreto do próximo dia útil>
```

## Emoji semantics

- 🟢 Concluído / entrega finalizada
- 🔵 Prioridade / em execução / aguardando aprovação sem bloqueio total
- 🟠 Bloqueado / dependência externa que impede próximo passo
- 🔴 Crítico / problema de impacto relevante
- 🔄 Ad-hoc / replanejamento

## Functional-specific situation vocabulary

### Discovery / requirements
- Em levantamento
- Em análise funcional
- Em refinamento
- Especificação funcional em elaboração
- Especificação funcional em revisão
- Aguardando definição funcional
- Aguardando validação do cliente

### Build dependency
- Pronta para desenvolvimento
- Aguardando desenvolvimento
- Aguardando correção

### Testing
- Preparando cenários de teste
- Preparando massa de teste
- Pronta para testes
- Em testes
- Em reteste
- Em regressão

### Acceptance
- Pronta para UAT
- Em UAT
- Aguardando homologação
- Homologada
- Concluída

## Wording guardrails

Do not use vague status such as `em andamento` when a more precise stage is known.

Do not call specification work `desenvolvimento`.

Do not call developer waiting `bloqueio` if the functional team still has meaningful work that can proceed.

Do not call every defect `crítico`.
