# Deploying to OpenAI

Run the build first (`.\packaging\build.ps1` on Windows, `./packaging/build.sh` elsewhere) — it regenerates both prompt files from `SKILL.md` and fails if
either exceeds its budget.

Both files in this directory are **generated**. Never edit them by hand; edit `SKILL.md` and rebuild.

---

## Custom GPT

The instructions field caps at **8,000 characters**, which is why `SKILL.md` carries
`<!-- CORE:BEGIN -->` / `<!-- CORE:END -->` markers around the behavioral spine.

1. Create the GPT → **Configure**.
2. **Name:** `Status Report Funcional SAP`
3. **Description:** Transforma anotações do dia em Status Report executivo, com contabilidade de 8h,
   bloqueios, leitura executiva e prioridade do dia seguinte. Não inventa nada.
4. **Instructions:** paste `core-prompt.md`.
5. **Knowledge:** upload the nine files from `references/`. **Do not upload anything from
   `docs/origin/`** — those files carry a developer persona and live instructions to a model, and
   uploading them recreates the exact contamination this structure removed.
6. **Capabilities:** turn all of them off. This skill reads notes and writes text. Web browsing in
   particular invites the model to invent SAP behavior from unvetted sources.
7. **Conversation starters:**
   - `#status`
   - `Monta meu fechamento do dia`
   - `Versão curta pro Teams`
   - `Prioridade de amanhã`

### What the Custom GPT loses

The core excludes `SKILL.md` §8–§17: the report structure detail, ad-hoc rules, continuity, time
math, output modes, the pre-check and the quality gate. Retrieval over the knowledge files covers
most of it, but the template will be less consistent than on Claude or the Assistants API. If the
exact section order matters — and for this report it usually does — use the Assistants build.

---

## Assistants API / Projects

The instructions field is far larger here (256,000 characters), so ship the whole skill.

1. Use `full-prompt.md` as the assistant's `instructions`.
2. Attach `references/` to a vector store and enable `file_search`. Again, exclude `docs/origin/`.
3. Do not enable tools the skill has no use for.

```python
from openai import OpenAI
from pathlib import Path

client = OpenAI()

store = client.vector_stores.create(name="sap-status-references")
for path in Path("references").glob("*.md"):
    client.vector_stores.files.upload(vector_store_id=store.id, file=open(path, "rb"))

assistant = client.beta.assistants.create(
    name="Status Report Funcional SAP",
    instructions=Path("packaging/openai/full-prompt.md").read_text(),
    model="gpt-4.1",
    tools=[{"type": "file_search"}],
    tool_resources={"file_search": {"vector_store_ids": [store.id]}},
)
```

---

## Keeping platforms in sync

`SKILL.md` is the only source. After any edit:

```powershell
.\packaging\build.ps1           # Windows: rebuild + validate
.\packaging\build.ps1 -Check    # validate only, for CI
```
```bash
./packaging/build.sh             # macOS / Linux
./packaging/build.sh --check
```

Both scripts run the same checks and emit identical files.

Then re-paste `core-prompt.md` into the Custom GPT and re-upload any changed reference.

Before releasing to more than one platform, run `evals/cases/01-no-invention.md` and
`02-ai-work-attribution.md` on each. Those two are the integrity rules; if a platform loses either,
the report becomes a liability rather than a time-saver.
