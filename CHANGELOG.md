# Changelog — SAP Functional Pack

Versão do conjunto. Cada skill tem o próprio `CHANGELOG.md` com o detalhe.

Versionamento segue [Semantic Versioning](https://semver.org/). Para um pacote de skills, "breaking"
significa mudança que altera a forma dos artefatos gerados ou o vocabulário que as equipes já
adotaram.

## [1.0.0] — 2026-08-10

Primeira versão do pacote reunido. As três skills existiam separadas; agora formam um ciclo com
fronteiras declaradas e identificadores compartilhados.

### Composição

| Skill | Versão | Papel |
|---|---|---|
| `sap-functional-spec-writer` | 1.0.0 | Escreve a EF |
| `sap-functional-test-productivity` | 3.2.0 | Analisa, projeta testes, tria defeito, decide Go/No-Go |
| `sap-functional-status-report` | 2.2.0 | Reporta o dia, mantém continuidade entre dias |

### O que faz disso um pacote e não três coisas soltas

- **Identificadores compartilhados.** `BR-###` e `AC-###` são criados pela `spec-writer` de forma
  estável e consumidos pela `test-productivity` para montar cobertura. A `status-report` consegue
  dizer o que mudou citando o ID.
- **Fronteiras declaradas e verificadas.** Cada `description` diz o que **não** é dela, cada
  `SKILL.md` nomeia as irmãs, e `packaging/build-all.sh` falha se qualquer uma parar de declarar.
  Sem isso, `escreve a EF` e `analisa essa EF` — separadas por um verbo — disputariam a mesma frase.
- **Disciplina comum.** Nenhuma inventa fato, nenhuma sugere ação destrutiva, nenhuma expõe dado
  pessoal, nenhuma afirma sem evidência, e nenhuma reporta trabalho da IA como trabalho da usuária.

### Adicionado neste release

- `README.md` guarda-chuva com o diagrama de encaixe e a tabela de qual skill faz o quê.
- `install.ps1` único, instalando as três de uma vez, com `-Only` para instalar uma e `-Scope
  Project` para compartilhar via repositório.
- `packaging/build-all.sh` — roda o build de cada skill e valida invariantes do conjunto: nomes
  únicos, fronteiras declaradas entre todas as combinações, eval de roteamento cobrindo todas as
  skills, licenças presentes.
- `packaging/verify-install.py` — verificação pós-instalação: encoding, BOM, frontmatter, references
  citadas versus presentes, órfãs, divergência entre cópia instalada e fonte, e integridade dos
  emoji de status.
- `packaging/make-release.sh` — gera o zip para a usuária final, sem material de desenvolvimento, e
  recusa a construir se a validação falhar.
- `RELEASE-CHECKLIST.md` — o que foi verificado, o que não foi, e o que precisa ser feito à mão antes
  de enviar.
- `.github/workflows/validate.yml` — CI que valida o pacote no Linux e confere a sintaxe dos `.ps1`
  num runner Windows. **Escrito mas ainda não ativo:** publicar arquivo de workflow exige o escopo
  `workflow` no token, que não estava disponível na publicação. Ver `RELEASE-CHECKLIST.md`.

### Limitação conhecida desta versão

Os 26 casos em `evals/` foram escritos e **não executados**, e os quatro scripts PowerShell não foram
executados em Windows. Ambos exigem ambiente que a máquina de desenvolvimento não tinha. Ver
`RELEASE-CHECKLIST.md`.

O núcleo da `sap-functional-test-productivity` está em 7.987 de 8.000 caracteres do limite do Custom
GPT. Qualquer adição futura ao bloco `CORE` dela exige remover algo antes.
