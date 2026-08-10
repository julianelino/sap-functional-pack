# Evaluation cases

Regression tests for the skill itself. Run after any edit to `SKILL.md` or a reference, in a **fresh**
session — a warm one carries behavior from earlier turns and will pass cases the skill would fail
cold.

Each case has a **Prompt**, binary **Must / Must not** criteria, and **Why this case exists**.

| Priority | Cases | Cost if it regresses |
|---|---|---|
| Must always pass | `01-invented-rule` | A rule nobody decided goes to the client, gets approved, and comes back as a defect |
| High | `03-deadline-pressure`, `04-contradicting-approved` | The spec stops being trustworthy exactly when it matters |
| Pack-level | `02-pack-routing` | Two skills fight over the same prompt |
| Medium | `05-client-template` | The skill gets abandoned because it insists on its own format |

`02-pack-routing` covers all three skills, not just this one. Run it whenever any `description` in
the pack changes or a skill is added — routing is the pack's most fragile seam, since all three
speak the same vocabulary and prompts 1 and 2 there differ by a single verb.
