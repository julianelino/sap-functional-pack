# Deploying to OpenAI

Two targets, two different limits. Run the build first (`.\packaging\build.ps1` on Windows, `./packaging/build.sh` elsewhere) — it regenerates both prompt
files from `SKILL.md` and fails the build if either exceeds its budget.

Both files in this directory are **generated**. Never edit them by hand; edit `SKILL.md` and rebuild.

---

## Custom GPT

The instructions field caps at **8,000 characters**, which is why `SKILL.md` carries
`<!-- CORE:BEGIN -->` / `<!-- CORE:END -->` markers around the behavioral spine. The build extracts
exactly that block.

1. Create the GPT → **Configure**.
2. **Name:** `SAP Functional & Testing Copilot`
3. **Description:** Proactive SAP functional analysis, test design, defect triage, evidence review
   and release gates — for analysts and testers who do not write code.
4. **Instructions:** paste the full contents of `core-prompt.md`.
5. **Knowledge:** upload all ten files from `references/`. Do not upload `SKILL.md` — its core is
   already in the instructions and the duplication degrades retrieval.
6. **Capabilities:** enable Code Interpreter only if the team needs spreadsheet output for test
   matrices. Leave Web Browsing and DALL·E off — neither serves this workflow and browsing invites
   the model to invent SAP behavior from unvetted sources.
7. **Conversation starters:**
   - `Analyze this functional specification and tell me what is missing.`
   - `Build the test matrix for this change.`
   - `This test failed — help me triage it before I send it to DEV.`
   - `Is this evidence enough to close the acceptance criterion?`

### What the Custom GPT loses

The core block excludes `SKILL.md` §9–§17: the reference-loading table, the lifecycle, the mode
briefs, the anti-patterns and the project-adaptation rules. Retrieval over the knowledge files
compensates for most of it, but mode output shapes will be less consistent than on Claude or the
Assistants API. If the team depends on exact artifact structure, use the Assistants build.

---

## Assistants API / Projects

The instructions field here is far larger (256,000 characters), so ship the whole skill.

1. Use `full-prompt.md` as the assistant's `instructions` — it is `SKILL.md` with the YAML
   frontmatter stripped.
2. Attach all of `references/` to a vector store and enable `file_search`.
3. Do **not** enable tools the skill has no use for. The Claude build declares
   `allowed-tools: Read, Write, Edit, Glob, Grep` and deliberately excludes shell access; keep the
   equivalent restraint here.

```python
from openai import OpenAI

client = OpenAI()

store = client.vector_stores.create(name="sap-functional-references")
for path in Path("references").glob("*.md"):
    client.vector_stores.files.upload(vector_store_id=store.id, file=open(path, "rb"))

assistant = client.beta.assistants.create(
    name="SAP Functional & Testing Copilot",
    instructions=Path("packaging/openai/full-prompt.md").read_text(),
    model="gpt-4.1",
    tools=[{"type": "file_search"}],
    tool_resources={"file_search": {"vector_store_ids": [store.id]}},
)
```

---

## Keeping the platforms in sync

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

Then re-paste `core-prompt.md` into the Custom GPT and re-upload any changed reference. The build
fails loudly rather than silently shipping an over-length prompt, so wire `--check` into CI if this
package lives in a repository.

Before releasing a change to more than one platform, run the same eval case from `evals/` on each and
compare the artifacts. Divergence usually means the core lost a rule that the full prompt still has.
