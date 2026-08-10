# SAP Functional Pack

**v1.0.1** · Três skills para quem trabalha com SAP funcional e testes e **não programa**. Elas
cobrem o ciclo inteiro de uma demanda: escrever a especificação, analisar e testar, e reportar o
trabalho.

Nenhuma delas escreve ABAP. Nenhuma delas inventa fato.

---

## Qual skill faz o quê

| Você quer | Skill | Ela entrega |
|---|---|---|
| **Escrever a EF** — a partir de ata, e-mail, decisão do cliente | `sap-functional-spec-writer` | Especificação funcional em português, com regras rastreadas à origem e o que ninguém decidiu como ponto em aberto |
| **Analisar e testar** — EF pronta, matriz de testes, defeito, evidência, Go/No-Go | `sap-functional-test-productivity` | Regras extraídas, lacunas, cobertura baseada em risco, triagem de defeito antes do desenvolvedor, portões de qualidade |
| **Reportar o dia** — fechamento, status pra gestão, prioridade de amanhã | `sap-functional-status-report` | Status Report executivo com contabilidade de 8h, bloqueios, leitura executiva e continuidade entre dias |

Você não precisa escolher nem chamar pelo nome. Escreva naturalmente e a skill certa assume.

### A diferença que mais confunde

`escreve a EF` → **spec-writer**. `analisa essa EF` → **test-productivity**.

Uma **produz** o documento, a outra **audita** o que já existe. Um verbo separa as duas, e é por isso
que cada uma declara a fronteira na própria descrição.

---

## Como elas se encaixam

```
   ata, e-mail, decisão do cliente
                │
                ▼
      ┌──────────────────────┐
      │    spec-writer       │  escreve a EF
      └──────────┬───────────┘  produz BR-### e AC-###
                 │
                 ▼
      ┌──────────────────────┐
      │  test-productivity   │  consome BR-### e AC-###
      └──────────┬───────────┘  matriz de testes, execução, defeito, Go/No-Go
                 │
                 ▼
      ┌──────────────────────┐
      │    status-report     │  reporta o que aconteceu
      └──────────────────────┘  fechamento do dia, continuidade entre dias
```

Os identificadores `BR-###` e `AC-###` são o que faz isso ser um pacote e não três coisas soltas: a
spec-writer os cria estáveis, a test-productivity constrói cobertura em cima deles, e a status-report
consegue dizer o que mudou citando o ID.

---

## Instalação

### Windows

Abra o **PowerShell** na pasta que você descompactou:

```powershell
.\install.ps1
```

Instala as três de uma vez em `%USERPROFILE%\.claude\skills`.

Se o PowerShell recusar — *"execution of scripts is disabled on this system"* — libere só para
aquela janela:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Para instalar só uma:

```powershell
.\install.ps1 -Only sap-functional-spec-writer
```

**Depois abra uma sessão nova do Claude.** Skills são lidas no início da sessão; a atual não enxerga
a instalação.

### macOS / Linux

```bash
cp -r skills/* ~/.claude/skills/
```

### OpenAI

Cada skill tem `packaging/openai/build-instructions.md`. Rode o build da skill antes.

---

## O que elas nunca fazem

Vale para as três, e é o que sustenta o pacote:

- **Não inventam.** Nem regra, nem progresso, nem hora, nem bloqueio, nem percentual, nem data, nem
  objeto SAP, nem resultado de teste. O que ninguém decidiu vira ponto em aberto, não suposição.
- **Não confundem trabalho da IA com trabalho seu.** Se a IA analisou a EF ou gerou os casos de
  teste, isso não entra no seu status como coisa que você fez — a não ser que você diga que revisou e
  usou.
- **Não sugerem ação destrutiva.** Só transação de exibição, sempre com "se você tiver autorização".
  Nada de SE16N em edição, SM30, debug, alteração de role ou manipulação de transporte.
- **Não expõem dado pessoal.** Redigem CPF, nome, dados bancários, folha e saúde de qualquer
  artefato gerado, e avisam quando o material de origem não deveria ser colado num chamado.
- **Não afirmam sem evidência.** Nenhuma delas diz "pronto", "corrigido" ou "pode subir" sem apontar
  o que sustenta a afirmação.

---

## Estrutura

```
sap-functional-pack/
├── README.md                      este arquivo
├── CHANGELOG.md                   versão do conjunto
├── install.ps1                    instala as três
├── LICENSE
├── packaging/
│   ├── build-all.sh               valida as três + invariantes do pacote
│   ├── verify-install.py          confere as cópias instaladas
│   └── make-release.sh            gera o zip para a usuária final
└── skills/
    ├── sap-functional-spec-writer/
    ├── sap-functional-test-productivity/
    └── sap-functional-status-report/
```

Cada skill é independente: tem seu próprio `SKILL.md`, `references/`, `evals/`, build e instalador.
Você pode distribuir uma sozinha.

---

## Para quem for mexer

1. Edite `SKILL.md` ou uma reference da skill. Nunca edite `packaging/openai/*` — é gerado.
2. Rode o build da skill, ou o de todas:
   ```bash
   ./packaging/build-all.sh
   ```
3. Rode os `evals/`. Os que nunca podem falhar:
   - `spec-writer` → `01-invented-rule`
   - `test-productivity` → `04-weak-evidence-go`, `07-prohibited-transaction`, `08-personal-data`
   - `status-report` → `01-no-invention`, `02-ai-work-attribution`
4. Mexeu em qualquer `description`? Rode
   `skills/sap-functional-spec-writer/evals/cases/02-pack-routing.md`. É a costura mais frágil do
   pacote — as três falam o mesmo vocabulário.

### Regra de ouro

`SKILL.md` entra em contexto toda vez que a skill dispara; `references/` não. Tudo que não for
roteamento, doutrina ou contrato pertence a uma reference.

---

MIT. Copyright © 2026 Juliane Lino — ver [LICENSE](LICENSE).
