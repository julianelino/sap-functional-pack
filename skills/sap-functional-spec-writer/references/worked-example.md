# Exemplo trabalhado — da ata à EF

Uma reunião real vira uma especificação. O exemplo é fictício e existe para mostrar **forma e
raciocínio** — nunca copie estas regras para uma análise de verdade.

Repare no que acontece três vezes ao longo do texto: uma informação que parece decisão vira ponto em
aberto, porque ninguém decidiu de fato.

---

## A entrada

> **Ata do refinamento — 12/08**
>
> — Cliente: sobre o bloqueio, decidimos que vale só pro bloqueio de organização de compras, o
> bloqueio central não entra.
> — Analista: e as devoluções?
> — Cliente: devolução continua liberada, tipos ZRET e ZRE2.
> — Arquiteto: a interface também cria pedido, precisa validar lá?
> — Cliente: por enquanto não, deixa só manual, a gente vê depois.
> — Analista: e os pedidos que já existem hoje com fornecedor bloqueado?
> — Cliente: esses ficam como estão.
> — Gerente: go-live continua 30/09.

---

## A saída

### 1. Identificação

```
Demanda:             CR-4821
Cliente:             <CLIENTE>
Módulo / processo:   MM — Compras
Versão:              1.0
Data:                12/08/2026
Status do documento: Em elaboração
Aprovadores:         Dono do processo de Compras
```

### 2. Objetivo de negócio

Atualmente é possível criar pedido de compra para fornecedor bloqueado, e a inconsistência só é
detectada na verificação de faturas, gerando retrabalho no Financeiro. O objetivo é impedir a criação
na origem, mantendo liberado o fluxo de devolução.

### 3. Escopo e fora de escopo

```
No escopo:
- criação manual de pedido de compra
- bloqueio de fornecedor por organização de compras

Fora do escopo:
- bloqueio central do fornecedor (decisão de 12/08)
- criação de pedido via integração (adiado em 12/08 — ver Q-003)
- pedidos já existentes na data da subida (decisão de 12/08 — ver BR-003)
```

### 4. AS-IS

`AS-IS não confirmado.`

A ata afirma que hoje o pedido é criado normalmente para fornecedor bloqueado, mas o comportamento
não foi verificado no sistema. Mínimo necessário para confirmar: um pedido existente criado para
fornecedor bloqueado (número e fornecedor), a tela do cadastro mostrando qual campo de bloqueio está
marcado, e se alguma mensagem é emitida hoje na gravação.

*Sem AS-IS confirmado não há como detectar regressão depois. Não escreva "hoje o sistema não valida"
só porque alguém disse isso numa reunião.*

### 5. TO-BE

`Gatilho` usuário grava pedido de compra →
`Validação` sistema verifica bloqueio de compras do fornecedor na organização de compras do pedido →
`Decisão` bloqueado e tipo de documento não é de devolução →
`Ação` rejeitar a gravação →
`Resultado` nenhum número de pedido gerado →
`Erro` mensagem de `BR-004` identificando fornecedor e organização.

### 6. Regras de negócio

| ID | Condição | Comportamento esperado | Erro / alternativa | Dados | Origem | Confiança |
|---|---|---|---|---|---|---|
| `BR-001` | Fornecedor com bloqueio de compras na organização de compras do pedido, tipo de documento não é de devolução | Gravação rejeitada, nenhum número gerado | Mensagem de erro conforme §9 | Cadastro do fornecedor, organização de compras | Ata 12/08 | `CONFIRMADO` |
| `BR-002` | Tipo de documento ZRET ou ZRE2 | Gravação permitida mesmo com fornecedor bloqueado | — | Tipo de documento | Ata 12/08 | `CONFIRMADO` |
| `BR-003` | Pedido criado antes da entrada em vigor | Comportamento inalterado; a validação não se aplica retroativamente | — | Pedidos existentes | Ata 12/08 | `CONFIRMADO` |
| `BR-004` | Fornecedor bloqueado em organização de compras diferente da do pedido | *não definido* | — | Cadastro do fornecedor | — | `EM ABERTO` — ver `Q-001` |

`BR-004` **não foi escrita como regra**. Ninguém tratou desse caso na reunião, e ele existe: o
bloqueio é por organização de compras, então um fornecedor bloqueado na 1000 e não na 2000 é um
cenário real. Inventar aqui — "por analogia, deve permitir" — seria colocar uma decisão de negócio no
documento com aparência de decisão do cliente.

### 9. Mensagens

| Situação | Tipo | Texto | Ação do sistema | Ação do usuário |
|---|---|---|---|---|
| `BR-001` acionada | Erro | "Fornecedor &1 possui bloqueio de compras para a organização &2. Pedido não pode ser criado." | Bloqueia a gravação | Acionar o Cadastro de Fornecedores ou escolher outro fornecedor |

### 14. Critérios de aceite

```
AC-001 — Dado um fornecedor com bloqueio de compras na organização 1000, quando o usuário gravar um
         pedido para a organização 1000 com tipo de documento NB, então a gravação é rejeitada, a
         mensagem de BR-001 é exibida e nenhum número de pedido é gerado.

AC-002 — Dado o mesmo fornecedor bloqueado, quando o usuário gravar um pedido com tipo ZRET, então o
         pedido é criado normalmente.

AC-003 — Dado um pedido criado antes da entrada em vigor para um fornecedor hoje bloqueado, quando o
         usuário exibir ou lançar um recebimento contra ele, então o comportamento permanece o
         atual.

AC-004 — Dado um fornecedor sem bloqueio, quando o usuário gravar um pedido com tipo NB, então o
         pedido é criado normalmente.
```

`AC-004` parece supérflua e não é. Uma validação que rejeita **tudo** satisfaz `AC-001` e nunca é
detectada sem ela.

### 16. Premissas

| Tipo | Descrição | Responsável | Impacto se não se confirmar |
|---|---|---|---|
| Premissa | Assume-se que os fornecedores relevantes já têm o bloqueio corretamente mantido no cadastro | Cadastro / MDM | Validação rejeita pedidos legítimos |

### 17. Pontos em aberto

| ID | Pergunta | Classificação | Bloqueia | Responsável |
|---|---|---|---|---|
| `Q-001` | Fornecedor bloqueado em uma organização de compras e não em outra: o pedido para a organização não bloqueada deve ser permitido? | `BLOQUEADOR` | `BR-004`, `AC-005` | Dono do processo de Compras |
| `Q-002` | A lista de tipos de devolução é exatamente ZRET e ZRE2, ou existem outros? A exceção será codificada contra uma lista fixa. | `BLOQUEADOR` | `BR-002` | Dono do processo de Compras |
| `Q-003` | A criação via integração ficou fora de escopo "por enquanto". Quem decide e até quando? O problema de retrabalho no Financeiro não é específico do caminho manual — a nota chega igual. | `IMPORTANTE` | escopo | Arquiteto + Compras |

### 18. Histórico

| Versão | Data | Autor | O que mudou | Origem | IDs afetados |
|---|---|---|---|---|---|
| 1.0 | 12/08/2026 | | Versão inicial a partir da ata de refinamento | Refinamento 12/08 | — |

---

## Veredito

`NÃO PRONTA` — dois `Q-###` `BLOQUEADOR` abertos (`Q-001`, `Q-002`) e o item 3 do checklist não
atendido (AS-IS não confirmado).

Ação exata para chegar a `PRONTA COM RESSALVAS`: obter as respostas de `Q-001` e `Q-002` com o dono
do processo — as duas cabem em um e-mail — e confirmar o AS-IS com um pedido existente. `Q-003` pode
seguir em paralelo sem bloquear.

---

## As três armadilhas deste exemplo

**"Decidimos que vale só pro bloqueio de organização de compras"** parece fechar o assunto e abre
outro: o caso de bloqueio parcial entre organizações. `Q-001`.

**"Devolução continua liberada, tipos ZRET e ZRE2"** parece uma lista completa. Ninguém confirmou que
é. `Q-002`.

**"Por enquanto não, a gente vê depois"** não é decisão, é adiamento — e some do documento se for
registrado como escopo definido. Vira `Q-003` com responsável, porque o problema de negócio que
originou a demanda não distingue caminho manual de integração.
