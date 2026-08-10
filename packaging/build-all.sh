#!/usr/bin/env bash
# Build and validate every skill in the pack, plus the pack-level invariants.
#
#   ./packaging/build-all.sh          build + validate
#   ./packaging/build-all.sh --check  validate only, write nothing (use in CI)

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS="$ROOT/skills"
ARG="${1:-}"

fail=0
err() { printf '  \033[31mFAIL\033[0m  %s\n' "$1"; fail=1; }
ok()  { printf '  \033[32m ok \033[0m  %s\n' "$1"; }

# --- per-skill builds ---------------------------------------------------------
for dir in "$SKILLS"/*/; do
  name="$(basename "$dir")"
  [[ -f "$dir/SKILL.md" ]] || continue
  printf '\n\033[1m### %s\033[0m\n' "$name"
  if ! (cd "$dir" && bash packaging/build.sh $ARG); then
    fail=1
  fi
done

# --- pack-level invariants ----------------------------------------------------
printf '\n\033[1m### pack\033[0m\n'
echo "==> Validating cross-skill invariants"

mapfile -t names < <(for d in "$SKILLS"/*/; do
  [[ -f "$d/SKILL.md" ]] && awk -F': *' '/^name:/{print $2; exit}' "$d/SKILL.md"
done)

# 1. names unique and matching their directory
dupes="$(printf '%s\n' "${names[@]}" | sort | uniq -d)"
[[ -z "$dupes" ]] || err "duplicate skill names: $dupes"

# 2. every skill declares a boundary against every other skill.
# All three cover SAP functional work in the same vocabulary; without an explicit
# boundary in each description, two of them fire on the same prompt.
for d in "$SKILLS"/*/; do
  [[ -f "$d/SKILL.md" ]] || continue
  self="$(awk -F': *' '/^name:/{print $2; exit}' "$d/SKILL.md")"
  for other in "${names[@]}"; do
    [[ "$other" == "$self" ]] && continue
    grep -q "$other" "$d/SKILL.md" \
      || err "$self does not declare its boundary with $other"
  done
done

# 3. the routing eval must exist and cover every skill in the pack
routing="$SKILLS/sap-functional-spec-writer/evals/cases/02-pack-routing.md"
if [[ -f "$routing" ]]; then
  for n in "${names[@]}"; do
    grep -q "$n" "$routing" || err "the routing eval does not cover $n"
  done
else
  err "the pack routing eval is missing: $routing"
fi

# 4. one licence, one owner
for d in "$SKILLS"/*/; do
  [[ -f "$d/LICENSE" ]] || err "$(basename "$d") has no LICENSE"
done
[[ -f "$ROOT/LICENSE" ]] || err "the pack has no LICENSE"

(( fail )) || ok "names unique, boundaries declared, routing eval complete, licences present"

printf '\n'
if (( fail )); then
  echo "PACK BUILD FAILED"
  exit 1
fi
echo "Pack OK — ${#names[@]} skills."
