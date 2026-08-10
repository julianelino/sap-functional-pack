# Release checklist

O que está verificado, o que não está, e o que precisa ser feito à mão antes de enviar o pacote para
alguém.

---

## Verificado automaticamente

Roda sozinho e trava o release se falhar.

```bash
./packaging/build-all.sh        # estrutura, orçamento de caracteres, fronteiras
python3 packaging/verify-install.py   # integridade das cópias instaladas
```

- [x] Frontmatter das três parseia, com `name`, `description`, `license`, `allowed-tools`
- [x] `name` bate com o diretório nas três
- [x] Bloco `CORE` de cada uma cabe no limite de 8.000 chars do Custom GPT
- [x] Toda reference citada existe; nenhuma órfã no disco
- [x] Vocabulário consistente; nenhuma dependência de skill externa
- [x] Material legado da status-report quarentenado em `docs/origin`, fora de `references/`
- [x] Regras de integridade presentes (não inventar, não creditar trabalho da IA)
- [x] Cada skill declara fronteira com as outras duas
- [x] Eval de roteamento cobre as três
- [x] Arquivos UTF-8 sem BOM, cópia instalada idêntica à fonte
- [x] Emoji de status íntegros

---

## NÃO verificado — precisa de você

Estas duas coisas não podem ser feitas na máquina de desenvolvimento. Enquanto estiverem abertas, o
pacote está construído mas não comprovado.

### 1. Os seis evals críticos

Sessão **nova** do Claude, com as três instaladas. Cole o prompt do arquivo, leia a resposta contra os
critérios `Must` / `Must not`. Uns 15 minutos.

- [ ] `skills/sap-functional-spec-writer/evals/cases/01-invented-rule.md`
      → não pode escrever regra que ninguém decidiu
- [ ] `skills/sap-functional-test-productivity/evals/cases/04-weak-evidence-go.md`
      → não pode devolver `GO` limpo
- [ ] `skills/sap-functional-test-productivity/evals/cases/07-prohibited-transaction.md`
      → não pode ensinar SE16N em edição
- [ ] `skills/sap-functional-test-productivity/evals/cases/08-personal-data.md`
      → não pode reproduzir CPF, salário ou conta bancária
- [ ] `skills/sap-functional-status-report/evals/cases/01-no-invention.md`
      → não pode inventar atividade num dia vazio
- [ ] `skills/sap-functional-status-report/evals/cases/02-ai-work-attribution.md`
      → não pode creditar à usuária o que a IA produziu

Se qualquer um falhar, **não distribua**. Estes seis são os que causam dano real: regra inventada
aprovada pelo cliente, subida ruim liberada, ação destrutiva em QAS, dado pessoal vazado, dia
inventado para a gestão.

### 2. PowerShell em Windows

- [ ] `.\install.ps1` — instala as três
- [ ] `.\install.ps1 -Only sap-functional-spec-writer` — instala uma
- [ ] `.\packaging\build.ps1` dentro de cada skill — as três
- [ ] Sessão nova enxerga as três skills depois da instalação

É o caminho que suas colegas vão usar. Se `install.ps1` falhar, nada mais importa. Erros prováveis:
política de execução (`-ExecutionPolicy Bypass` resolve) e alguma diferença do PowerShell 5.1 que eu
não consegui testar.

### 3. Roteamento entre as três — recomendado

- [ ] `skills/sap-functional-spec-writer/evals/cases/02-pack-routing.md` — seis prompts

Costura mais frágil do pacote. Se duas skills dispararem no mesmo prompt, estreite as `description`,
não o comportamento.

---

## Gerar o pacote

Só depois dos itens acima.

```bash
./packaging/make-release.sh
```

Produz `.release/sap-functional-pack-1.0.0.zip`, sem `evals/`, `packaging/`, `docs/origin/` nem
metadados de git — só o que a usuária final precisa.

---

## Ao enviar

- [ ] Diga a versão do pacote (`1.0.0`) — a pessoa precisa saber o que recebeu
- [ ] Diga que precisa **abrir sessão nova** depois de instalar; skills carregam no início da sessão
- [ ] Se for a segunda versão que essa pessoa recebe, aponte o `CHANGELOG.md`

---

## O que dizer se perguntarem se está testado

A resposta honesta, depois de completar o acima:

> Estrutura e integridade são validadas automaticamente a cada mudança. Os seis cenários de risco
> foram executados manualmente na versão 1.0.0. Não há teste automatizado de comportamento — cada
> alteração exige rodar os evals de novo.

Não diga "testado" sem qualificar. É a mesma disciplina que as skills aplicam: transporte concluído
não é teste, e "passou" sem evidência não vale.
