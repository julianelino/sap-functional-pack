# Versões, revisão e controle de mudança

Uma EF não é escrita uma vez. Ela atravessa reuniões, revisões e decisões que se contradizem — e
alguém já começou a construir a partir da versão anterior.

---

## 1. Quando incrementar

| Mudança | Versão |
|---|---|
| Regra nova, alterada ou removida | incrementa |
| Critério de aceite alterado | incrementa |
| Escopo alterado | incrementa |
| Ponto em aberto respondido e virou regra | incrementa |
| Correção de digitação, formatação, reordenação | não incrementa |

Menor (1.1 → 1.2) para ajuste dentro do escopo acordado. Maior (1.x → 2.0) quando o escopo muda ou
uma regra já aprovada é revertida.

---

## 2. Histórico

| Versão | Data | Autor | O que mudou | Origem da mudança | IDs afetados |
|---|---|---|---|---|---|
| 1.2 | 12/08/2026 | | Bloqueio passa a considerar apenas organização de compras | Refinamento 12/08 | `BR-004`, `AC-003` |

A coluna **IDs afetados** é a que faz o histórico servir para alguma coisa. Sem ela, quem trabalha
com a v1.1 não tem como saber se o que ele está construindo mudou.

---

## 3. Contradizer algo já aprovado

Quando uma decisão nova contraria algo que já foi aprovado, **diga isso em voz alta**. Não edite em
silêncio.

> ⚠️ Atenção — mudança sobre versão aprovada
>
> A v1.1 definia em `BR-004` que o bloqueio consideraria o bloqueio central do fornecedor. A decisão
> de 12/08 substitui isso: passa a valer apenas o bloqueio por organização de compras.
>
> Impacto: se o desenvolvimento já começou a partir da v1.1, a lógica precisa ser revista.
> `AC-003` foi reescrito e o cenário de bloqueio central sai de escopo.

Editar em silêncio é como duas pessoas constroem coisas diferentes achando que concordam.

---

## 4. Regra removida

Nunca reaproveite um número. Mantenha o ID e marque a remoção:

```
BR-007 — REMOVIDA na v1.3. O tratamento diferenciado para devolução de importação saiu de escopo
(decisão de 14/08, ver Q-006). Mantida a numeração para não conflitar com a v1.2, a partir da qual o
desenvolvimento começou.
```

Alguém trabalhando com a v1.2 não pode encontrar `BR-007` significando outra coisa na v1.3.

---

## 5. Status do documento

- **Em elaboração** — sendo escrita; ninguém deve construir a partir dela.
- **Em revisão** — completa o suficiente para leitura crítica; comentários abertos.
- **Aprovada** — o negócio aprovou; desenvolvimento pode começar. Mudança daqui em diante passa por
  §3.
- **Substituída** — existe versão posterior aprovada.

Nunca marque **Aprovada** por inferência. Aprovação é ato de alguém, com data. Se o usuário disse
"o cliente concordou na reunião", isso é registro de decisão — pergunte se conta como aprovação
formal do documento antes de mudar o status.

---

## 6. Revisão

Ao preparar uma EF para revisão, entregue junto:

- o que mudou desde a última versão lida pelos revisores;
- os pontos em aberto que dependem **deles** especificamente;
- as premissas que precisam de confirmação;
- as decisões que precisam sair da reunião, se houver.

Revisor que recebe 30 páginas sem nada disso devolve "ok" sem ler. A lista curta é o que produz
revisão de verdade.

---

## 7. Aprovação com ressalva

Comum e legítimo: aprova-se para começar, com pontos abertos nomeados.

Registre no documento, não só na ata:

```
Aprovada com ressalvas em 15/08/2026.
Ressalvas: Q-005 (comportamento de estorno após integração) e Q-007 (tratamento de pedidos
existentes). Ambas devem ser respondidas até 22/08, antes do início dos testes integrados.
Responsável: dono do processo de Compras.
```

Ressalva sem responsável e sem data não é ressalva — é um problema que ninguém está resolvendo, com
aprovação por cima.
