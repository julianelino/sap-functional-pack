# Como escrever cada peça

O teste que vale para tudo neste arquivo: **duas pessoas lendo isto isoladamente construiriam a mesma
coisa?** Se não, ainda não está escrito.

---

## 1. Regra de negócio

Condição, comportamento esperado, caminho alternativo. As três.

> ❌ `BR-004` — O sistema deve validar o fornecedor.
> Validar o quê? Contra o quê? E se falhar?
>
> ❌ `BR-004` — Não permitir pedido para fornecedor bloqueado.
> Melhor, mas: bloqueado onde? E o que acontece exatamente — erro, alerta, o documento é gravado?
>
> ✅ `BR-004` — Quando o fornecedor informado possuir bloqueio de compras na organização de compras
> do pedido, a gravação deve ser rejeitada com a mensagem definida em §9, e nenhum número de pedido
> deve ser gerado. Aplica-se a todos os tipos de documento exceto os de devolução (`BR-005`).
> Origem: reunião de refinamento 12/08. Confiança: `CONFIRMADO`.

Uma frase com "e também" costuma ser duas regras. Separe.

### O caminho de erro é obrigatório

Regra sem caminho alternativo não está pronta. Se ninguém decidiu o que acontece quando a condição
falha, isso não é detalhe de implementação — é `Q-###`.

---

## 2. Regra de campo

"Campo obrigatório" não é regra de campo. Uma regra de campo responde: obrigatoriedade, origem do
dado, valores permitidos, formato, e o que acontece depois que o documento muda de status.

> ❌ Campo Centro: obrigatório.
>
> ✅ Campo Centro: obrigatório na criação. Preenchido por padrão com o centro do usuário, editável
> até a liberação do documento e somente exibição depois. Valores permitidos: centros ativos da
> empresa do pedido. Zeros à esquerda preservados.

---

## 3. Estado e transição

Descreva o que é permitido **e o que é proibido**. A lista de proibições é onde estão os defeitos.

> ✅ Estado: Liberado
> - Condição de entrada: aprovação concluída conforme `BR-011`
> - Ações permitidas: recebimento, alteração de data de entrega
> - Ações proibidas: alteração de fornecedor, alteração de valor total
> - Próximos estados: Recebido parcialmente, Recebido, Cancelado
> - Recuperação de erro: cancelamento devolve ao estado Bloqueado, nunca a Em elaboração

E a pergunta que quase nunca está na ata: **o que acontece se o usuário cancelar enquanto a
integração está em curso?** Se não há resposta, é `Q-###`.

---

## 4. Mensagem

O texto faz parte da especificação. "Mensagem a definir" transfere ao desenvolvedor uma decisão de
negócio, e o resultado costuma ser uma mensagem técnica exibida ao usuário final.

> ❌ Exibir mensagem de erro apropriada.
>
> ✅ Erro, bloqueia a gravação:
> "Fornecedor &1 possui bloqueio de compras para a organização &2. Pedido não pode ser criado."
> Ação esperada: o usuário deve acionar o cadastro de fornecedores ou escolher outro fornecedor.

Mensagem boa diz **o que houve, com qual dado, e o que fazer agora**.

---

## 5. Critério de aceite

`Dado <condição>, quando <ação>, então <resultado observável>.`

O resultado precisa ser observável por alguém que não participou das reuniões.

> ❌ `AC-003` — A integração funciona corretamente.
> ❌ `AC-004` — O usuário consegue criar o pedido.
> Ambos passam com qualquer comportamento.
>
> ✅ `AC-003` — Dado um fornecedor com bloqueio de compras na organização 1000, quando o usuário
> gravar um pedido de compra para essa organização com tipo de documento NB, então a gravação é
> rejeitada, a mensagem de `BR-004` é exibida e nenhum número de pedido é gerado.

Em processo SAP, estenda o "então" até a consequência que importa de verdade: o documento resultante
e seu status, o efeito a jusante, o comportamento de erro. "A tela salvou" raramente é o critério.

---

## 6. Ponto em aberto

Force uma escolha concreta, respondível em uma frase, e diga quem responde.

> ❌ `Q-002` — Esclarecer o processo de devolução.
> ❌ `Q-002` — Como funciona o bloqueio?
>
> ✅ `Q-002` — O bloqueio deve considerar o bloqueio central do fornecedor, o bloqueio por
> organização de compras, ou ambos? Os dois existem e são independentes. Responsável: dono do
> processo de Compras. Bloqueia `BR-004`.

Acrescentar **por que você precisa saber** transforma pergunta em decisão. Sem isso a resposta é
"depende" e a reunião segue.

---

## 7. Premissa

Premissa é o que você está assumindo sem ter confirmado. Deixá-la implícita é como um defeito nasce
já com aprovação do cliente em cima.

> ✅ Premissa: assume-se que todos os fornecedores relevantes já possuem o bloqueio corretamente
> mantido no cadastro. Se o cadastro estiver inconsistente, a validação rejeitará pedidos legítimos.
> Responsável pela confirmação: Cadastro/MDM.

---

## 8. AS-IS

Só o que foi confirmado. Duas armadilhas:

**Reconstruir o AS-IS a partir do TO-BE.** "Hoje o sistema não valida o fornecedor" só pode ser
escrito se alguém verificou. Sem AS-IS confiável, ninguém detecta regressão depois.

**Confundir comportamento observado com regra aprovada.** Se o sistema faz algo hoje, isso é
comportamento atual — não é necessariamente o que o negócio quer. Escreva "comportamento observado
em DD/MM", nunca "regra de negócio".

---

## 9. Vocabulário a evitar

Palavras que parecem especificação e não são: *adequado, apropriado, correto, normal, usual,
conforme necessário, se aplicável, tratamento padrão, de acordo com a regra do negócio*.

Cada uma delas é um `Q-###` disfarçado. Quando aparecerem no material de origem, pergunte o que
significam em vez de copiá-las para dentro do documento.

E do outro lado: não escreva em linguagem técnica o que é regra de negócio. `BAdI`, `enhancement`,
`tabela Z`, `classe` não pertencem a uma EF — o **comportamento** pertence, a implementação é decisão
de quem desenvolve.
