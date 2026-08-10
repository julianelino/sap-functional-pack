# Estrutura da Especificação Funcional

**Fonte única do formato.** Se algum outro arquivo mostrar um layout diferente, este vale.

Seções que não se aplicam são removidas com uma linha dizendo por quê. Seções que se aplicam mas
ainda não têm conteúdo permanecem, marcadas `EM ABERTO` — seção ausente é lida como "não se aplica",
que é uma afirmação diferente e perigosa.

---

## 1. Identificação

```
Demanda:            CR / GAP / WI / INC
Cliente:
Módulo / processo:
Autor:
Versão:             1.0
Data:               DD/MM/AAAA
Status do documento: Em elaboração | Em revisão | Aprovada | Substituída
Aprovadores:        <papel — não nome pessoal, salvo pedido do usuário>
```

## 2. Objetivo de negócio

Um parágrafo. O problema de negócio, não a solução técnica.

> ✅ Hoje é possível criar pedido de compra para fornecedor bloqueado, e a inconsistência só é
> detectada no recebimento da nota fiscal, gerando retrabalho no Financeiro. O objetivo é impedir a
> criação na origem.
>
> ❌ Implementar validação no BAdI de gravação do pedido de compra.

Se você não consegue escrever este parágrafo sem citar objeto técnico, o objetivo ainda não foi
compreendido.

## 3. Escopo e fora de escopo

Duas listas. A segunda é a que evita discussão na homologação.

```
No escopo:
- criação manual de pedido de compra pela transação padrão
- tipos de documento NB e ZNB

Fora do escopo:
- criação via integração (decidido em 12/08, ver Q-003)
- pedidos já existentes na data da subida
- bloqueio central de fornecedor (apenas bloqueio por organização de compras)
```

Todo item de "fora do escopo" que veio de uma decisão precisa da data e da referência ao ponto em
aberto que o originou.

## 4. AS-IS

Comportamento atual, **apenas com base no que foi confirmado**. Se o comportamento atual não foi
verificado, escreva `AS-IS não confirmado` e liste o mínimo necessário para confirmá-lo.

Nunca reconstrua o AS-IS a partir do TO-BE. Sem AS-IS confiável não há como detectar regressão
depois.

## 5. TO-BE

Fluxo ordenado, orientado a evento:

`Gatilho → Validação → Decisão → Ação → Resultado → Caminho de erro/alternativo`

Um fluxo por cenário principal. Cenários alternativos ganham subseção própria, não parênteses no meio
do texto.

## 6. Regras de negócio

| ID | Condição / gatilho | Comportamento esperado | Erro / alternativa | Dados envolvidos | Origem | Confiança |
|---|---|---|---|---|---|---|
| `BR-001` | | | | | | `CONFIRMADO` / `A VALIDAR` / `EM ABERTO` |

A coluna **Origem** é obrigatória: documento e seção, data da reunião, e-mail, ou "observado no
sistema em DD/MM". Regra sem origem não entra.

A coluna **Erro / alternativa** vazia significa regra inacabada. Abra um `Q-###`.

## 7. Regras de campo

| Campo | Obrigatório | Origem do dado | Valores permitidos | Formato / tamanho | Editável quando | Observação |
|---|---|---|---|---|---|---|

Cubra também: valor padrão, ajuda de pesquisa, zeros à esquerda, maiúsculas/minúsculas, dependência
de outro campo, e comportamento após mudança de status.

## 8. Estados e transições

```
Estado: <nome>
- Condição de entrada:
- Ações permitidas:
- Ações proibidas:
- Próximos estados:
- Recuperação de erro:
```

Feche com a lista de transições **inválidas** que devem ser impedidas. É a seção que ninguém escreve
e onde os defeitos aparecem.

## 9. Mensagens e tratamento de erro

| Situação | Tipo | Texto da mensagem | Ação do sistema | Ação esperada do usuário |
|---|---|---|---|---|

Tipo: erro (bloqueia), alerta (permite seguir), informativa.

O texto da mensagem faz parte da especificação. Deixar "mensagem a definir" transfere para o
desenvolvedor uma decisão de negócio.

## 10. Reprocessamento

Quando existe repetição, retentativa ou reprocessamento:

- a ação pode ser repetida?
- repetir gera documento novo ou retoma o existente?
- existe controle de duplicidade? por qual chave?
- há limite de tentativas?
- o que acontece após sucesso parcial?

## 11. Integrações

Quando houver. Por interface:

```
Interface:          <nome / iFlow / serviço>
Sentido:            SAP → externo | externo → SAP
Protocolo:          IDoc | Proxy/SOAP | OData/REST | RFC | arquivo
Gatilho:
Chave de negócio:
Síncrona/assíncrona:
Comportamento em erro:
Reprocessamento:
Responsabilidade:   <quem trata o quê>
```

Mais o mapeamento campo a campo, quando conhecido.

## 12. Autorização

Quem pode executar, quem pode apenas exibir, restrição por nível organizacional, separação entre
solicitante e aprovador, e comportamento do usuário de interface ou de job.

Não invente objeto de autorização. Descreva o comportamento esperado; o objeto é decisão técnica.

## 13. Impactos

- documentos e registros que já existem na data da subida;
- relatórios, formulários e saídas;
- jobs e processamento em lote;
- outros módulos e processos a jusante;
- migração ou ajuste de dados, se necessário;
- treinamento ou mudança de procedimento.

O primeiro item é o mais esquecido. A maioria das especificações é escrita como se o sistema
estivesse vazio.

## 14. Critérios de aceite

```
AC-001 — Dado <condição>, quando <ação>, então <resultado observável>.
```

Um critério por comportamento. Referencie a `BR-###` correspondente. Todo critério precisa ser
executável por alguém que não participou das reuniões.

## 15. Cenários de teste sugeridos

Lista curta dos cenários que as regras já implicam — positivos, negativos, limites, autorização,
integração, regressão. **Não é a matriz de testes**; é o insumo dela.

A matriz completa é responsabilidade da skill `sap-functional-test-productivity`.

## 16. Premissas, dependências e riscos

| Tipo | Descrição | Responsável | Impacto se não se confirmar |
|---|---|---|---|

Premissa é o que se está assumindo como verdadeiro sem ter confirmado. Deixá-la implícita é como um
defeito nasce com aprovação do cliente em cima.

## 17. Pontos em aberto

| ID | Pergunta | Classificação | Bloqueia | Responsável | Prazo |
|---|---|---|---|---|---|
| `Q-001` | | `BLOQUEADOR` / `IMPORTANTE` / `MELHORIA` | `BR-00x` | | |

`BLOQUEADOR` significa que desenvolvimento ou teste não podem prosseguir com segurança.

## 18. Histórico de versões

| Versão | Data | Autor | O que mudou | Origem da mudança | IDs afetados |
|---|---|---|---|---|---|
| 1.0 | | | Versão inicial | | |

Mudança substantiva sempre incrementa a versão. Correção de digitação, não.
