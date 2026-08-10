# Checklist de completude

Use antes de dizer que uma EF está pronta para desenvolvimento. Mostre o checklist junto com o
veredito — e, para cada item não atendido, a **ação exata** que o fecha.

Não produza nota numérica. Duas execuções sobre o mesmo documento não concordariam, e um número em
documento de gestão vira compromisso.

---

## Checklist

| # | Verificação | Atende? |
|---|---|---|
| 1 | Objetivo de negócio escrito sem citar objeto técnico | |
| 2 | Escopo **e** fora de escopo explícitos | |
| 3 | AS-IS confirmado, ou marcado como não confirmado com o que falta para confirmar | |
| 4 | TO-BE ordenado, com caminho de erro para cada fluxo | |
| 5 | Toda `BR-###` tem condição, comportamento **e** caminho alternativo | |
| 6 | Toda `BR-###` tem origem nomeada e marca de confiança | |
| 7 | Regras de campo cobrem obrigatoriedade, origem, valores e comportamento pós-status | |
| 8 | Estados listam ações proibidas e transições inválidas, não só as permitidas | |
| 9 | Textos de mensagem escritos, não "a definir" | |
| 10 | Comportamento de reprocessamento e duplicidade definido, quando a ação é repetível | |
| 11 | Autorização descrita como comportamento esperado | |
| 12 | Impacto sobre documentos que já existem está tratado | |
| 13 | Todo `AC-###` é observável e rastreia a uma `BR-###` | |
| 14 | Premissas explícitas, com responsável pela confirmação | |
| 15 | Nenhum `Q-###` `BLOQUEADOR` em aberto | |
| 16 | Versão e histórico atualizados | |

---

## Veredito

- **`PRONTA`** — todos os itens atendidos.
- **`PRONTA COM RESSALVAS`** — nenhum `BLOQUEADOR` aberto, mas itens não atendidos permanecem. Liste
  cada um com risco, responsável e data.
- **`NÃO PRONTA`** — qualquer `Q-###` `BLOQUEADOR` aberto, ou os itens 4, 5, 13 não atendidos.

Os itens 4, 5 e 13 são estruturais: sem caminho de erro, sem alternativa nas regras, ou sem critério
observável, o desenvolvedor vai adivinhar e o teste não vai conseguir reprovar.

---

## O teste que pega o resto

Três perguntas que valem mais que o checklist inteiro:

**1. Um desenvolvedor construiria isso sem perguntar nada?**
Leia como quem nunca esteve nas reuniões. Todo ponto onde você precisaria explicar oralmente é uma
lacuna do documento.

**2. Um key user reconheceria o próprio processo aqui?**
Se a EF só faz sentido para quem participou, ela não vai ser aprovada com entendimento — vai ser
aprovada por confiança, que é como escopo errado passa.

**3. Um teste escrito a partir deste `AC-###` conseguiria reprovar?**
Se o critério passa independentemente do comportamento, ele não é critério.

---

## Pressão de prazo

O momento em que este checklist é ignorado é sempre o mesmo: a data está próxima e o desenvolvimento
precisa começar.

`PRONTA COM RESSALVAS` existe exatamente para isso — permite começar com o risco nomeado, com dono e
com data. O que não existe é `PRONTA` com bloqueador aberto. Amolecer o veredito porque o prazo
aperta transfere o problema para a homologação, com aprovação do cliente em cima dele.

Se o usuário pedir para liberar assim mesmo, registre como ressalva com responsável — nunca reclassificando
o `Q-###` para `IMPORTANTE` só para o veredito fechar.
