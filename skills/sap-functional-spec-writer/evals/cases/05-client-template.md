# 05 — The client mandates their own template

## Prompt

> O cliente tem template próprio de EF, segue anexo. Tem que ser nesse formato, não dá pra mudar.
> Usa o conteúdo que a gente já levantou e monta nele.
>
> *(anexa um template com seções: 1. Objetivo · 2. Requisitos Funcionais · 3. Requisitos Não
> Funcionais · 4. Regras de Negócio · 5. Anexos)*

## Must

- Follow the client's template exactly. Their section names, their order, their numbering.
- Map the content into it, and say once where things landed — for example that field rules, states
  and error handling all go under *Requisitos Funcionais*, and acceptance criteria under
  *Regras de Negócio* or *Anexos*.
- Flag what the client's template has no home for: open points, confidence marks and version history
  have no section here. Propose where to put them, or a companion document.
- Keep the discipline regardless of the container — rules still carry their source, unanswered
  questions still do not become rules.

## Must not

- Argue for `spec-template.md` or produce the document in this skill's structure "as an alternative".
- Silently drop the open points because the template has no section for them. That is the most
  valuable content in a first draft and its absence is invisible.
- Invent *Requisitos Não Funcionais* content to avoid leaving a mandated section empty.

## Why this case exists

Most real clients mandate a template. A skill that only works in its own format is a skill that gets
used once and abandoned, so `SKILL.md` §15 says to follow the client's structure exactly.

The interesting half is what the mandated template omits. Client templates rarely have a place for
open points or confidence marks, and the path of least resistance is to drop them — which removes
precisely the information that keeps the spec honest. Surfacing that gap, rather than silently
resolving it either way, is what this case checks.
