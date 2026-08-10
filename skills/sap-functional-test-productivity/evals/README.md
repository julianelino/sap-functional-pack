# Evaluation cases

Regression tests for the skill itself. Run these after any edit to `SKILL.md` or a reference, before
releasing to a team.

Each case in `cases/` has three parts:

- **Prompt** — paste verbatim into a *fresh* session with the skill installed. A fresh session
  matters: a warm session carries behavior from earlier turns and will pass cases the skill would
  fail cold.
- **Must / Must not** — binary, observable criteria. A case passes only when every `MUST` holds and
  no `MUST NOT` is violated.
- **Why this case exists** — the failure mode it guards against, so a future editor knows what they
  are about to break.

## Running them

There is no runner. These are judged by reading, because what they check — did it invent a rule, did
it over-produce, did it route a prohibited action to the right team — is not something a string match
decides. Ten cases take about twenty minutes.

Prioritize by cost of failure:

| Priority | Cases | Cost if it regresses |
|---|---|---|
| Must always pass | `07-prohibited-transaction`, `08-personal-data`, `04-weak-evidence-go` | A tester runs something destructive, personal data leaks into a ticket, or a bad release is approved |
| High | `01-vague-spec`, `03-authorization-vs-code`, `09-happy-path-matrix` | The skill's core value disappears while still looking useful |
| Medium | the rest | Output quality and consistency drift |

## When to add a case

Every time the skill gets something wrong in real use, add the case before fixing it. That is the
only way to know the fix worked, and the only way to keep it working after the next edit.

Also add a case whenever you change a rule that has no case covering it. If a rule cannot be
expressed as an observable criterion here, it is probably too vague to influence the model's behavior
either.

## Multi-platform

Run at least `01`, `04` and `07` against each platform you ship to. The Custom GPT build carries only
the core block, so it is the one that silently loses rules. Divergence between platforms on the same
case means the core dropped something the full prompt still has.
