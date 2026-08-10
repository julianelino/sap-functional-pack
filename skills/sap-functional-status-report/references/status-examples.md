# Status Examples - SAP Functional / Testing

## Example 1 - EF refinement

```text
STATUS DE FECHAMENTO DO DIA - 07/08

STATUS DAS DEMANDAS DA EXPECTATIVA DIÁRIA

🔵 CLIENTE - CR80
- Demanda: Ajuste das regras de material e SKU
- Recebimento: 06/08 | Início: 07/08
- Prazo estimado / Entrega prevista: 11/08
- Prazo consumido: 1 dia útil | Bloqueio: NÃO
- Situação: Especificação funcional em elaboração
- Justificativa do dia: Revisadas as regras dos campos de material e SKU, com inclusão das validações e descrição esperadas. Dois pontos permaneceram em aberto para confirmação antes do fechamento da versão.
- Próximo passo: Confirmar os pontos pendentes e concluir os critérios de aceite para preparação dos testes.

💡 Leitura executiva:
- Evolução compatível com a etapa de especificação; os pontos em aberto ainda não impedem o avanço, mas precisam ser resolvidos antes da homologação da EF.

PLANEJAMENTO / PRIORIDADE DE PRIMEIRA HORA DE AMANHÃ - 08/08

Finalizar os pontos pendentes da CR80 e estruturar os cenários de teste derivados das regras aprovadas.
```

## Example 2 - Testing with one defect

```text
🔵 CLIENTE - GAP144
- Demanda: Validação do novo fluxo de aprovação
- Recebimento: 05/08 | Início: 06/08
- Prazo estimado / Entrega prevista: 12/08
- Prazo consumido: 2 dias úteis | Bloqueio: NÃO
- Situação: Em testes - 8 de 12 cenários executados
- Justificativa do dia: Executados oito cenários do fluxo de aprovação. Sete apresentaram o resultado esperado e um apresentou divergência reproduzível, documentada e encaminhada ao desenvolvimento. Os demais cenários permanecem executáveis.
- Próximo passo: Avançar nos quatro cenários restantes e retestar o cenário divergente após a correção.

💡 Leitura executiva:
- Foi identificado um defeito sem bloqueio total do ciclo de testes; a continuidade dos demais cenários preserva o avanço planejado.
```

## Example 3 - Blocked waiting for business decision

```text
🟠 CLIENTE - CR215
- Demanda: Regra de reprocessamento após rejeição
- Recebimento: 04/08 | Início: 05/08
- Prazo estimado / Entrega prevista: Indefinido - depende de definição funcional
- Prazo consumido: 3 dias úteis | Bloqueio: SIM
- Situação: Aguardando definição funcional
- Justificativa do dia: Fluxo principal e cenários de erro revisados. A especificação não pode ser concluída sem a definição do comportamento esperado quando o reprocessamento ocorre após rejeição.
- Próximo passo: Obter decisão do responsável pelo processo e atualizar EF, critérios de aceite e cenários afetados.

💡 Leitura executiva:
- A definição pendente é requisito de negócio e impede o fechamento seguro do escopo; a previsão deve ser reavaliada após a decisão.
```

## Example 4 - Ad-hoc UAT issue

```text
DEMANDAS AD-HOC / URGÊNCIAS ATENDIDAS NO DIA

CLIENTE - INCORRÊNCIA EM UAT
- Atuação: Apoio à reprodução do erro reportado pelo usuário, validação da massa utilizada e consolidação das evidências para encaminhamento ao time responsável.
- Tempo consumido: 1h30
- Status: Concluído
- Planejamento: Aguardar correção para reteste.
```

## Example 5 - No update on open demand

```text
🔵 CLIENTE - CR300
- Demanda: Ajuste de cadastro
- Recebimento: 01/08 | Início: 02/08
- Prazo estimado / Entrega prevista: 10/08
- Prazo consumido: 5 dias úteis | Bloqueio: NÃO
- Situação: Em análise funcional
- Justificativa do dia: Sem nova atualização formal informada no dia; demanda permanece no status anterior.
- Próximo passo: Concluir o mapeamento dos campos de cadastro e submeter as dúvidas pendentes ao key user.
```

Note the next step: it **repeats the concrete action already defined on the previous day**, not a
placeholder. Carrying a demand forward does not license a vague next step.

> ❌ Próximo passo: Manter o próximo passo previamente definido até nova atualização.
> ❌ Próximo passo: Aguardar.

Both fail the rule in `SKILL.md` §8 — they tell management nothing. If the previous next step is
known, restate it. If it is not known, say so plainly ("Próximo passo não atualizado desde DD/MM")
or ask the user, but never fill the field with process language about the field itself.
