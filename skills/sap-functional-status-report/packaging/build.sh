#!/usr/bin/env bash
# Build and validate distribution artifacts for the sap-functional-status-report skill.
#
#   ./packaging/build.sh          build + validate
#   ./packaging/build.sh --check  validate only, write nothing (use in CI)
#
# Exits non-zero on any validation failure.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL="$ROOT/SKILL.md"
REFDIR="$ROOT/references"
ORIGIN="$ROOT/docs/origin"
OUTDIR="$ROOT/packaging/openai"

CHECK_ONLY=0
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=1

# Custom GPT caps the instructions field at 8000 characters.
GPT_LIMIT=8000

fail=0
err() { printf '  \033[31mFAIL\033[0m  %s\n' "$1"; fail=1; }
ok()  { printf '  \033[32m ok \033[0m  %s\n' "$1"; }
# Only report success when nothing in the current section failed. Printing an
# unconditional ok after an err makes the output contradict itself.
mark()   { sec=$fail; }
sec_ok() { (( fail == sec )) && ok "$1"; return 0; }

echo "==> Validating $SKILL"

# --- 1. frontmatter -----------------------------------------------------------
mark
[[ "$(head -1 "$SKILL")" == "---" ]] || err "SKILL.md must start with YAML frontmatter"
for key in name description license allowed-tools; do
  grep -q "^${key}:" "$SKILL" || err "frontmatter is missing '${key}:'"
done

dirname_actual="$(basename "$ROOT")"
name_declared="$(awk -F': *' '/^name:/{print $2; exit}' "$SKILL")"
if [[ "$name_declared" != "$dirname_actual" ]]; then
  err "frontmatter name '$name_declared' does not match directory '$dirname_actual'"
else
  ok "name matches directory: $name_declared"
fi

# --- 2. CORE markers ----------------------------------------------------------
mark
[[ "$(grep -c 'CORE:BEGIN' "$SKILL")" == "1" ]] || err "expected exactly one CORE:BEGIN marker"
[[ "$(grep -c 'CORE:END'   "$SKILL")" == "1" ]] || err "expected exactly one CORE:END marker"

core="$(awk '/CORE:BEGIN/{f=1;next} /CORE:END/{f=0} f' "$SKILL" | awk 'NF||seen{seen=1;print}')"
core_chars="$(printf '%s' "$core" | wc -m | tr -d ' ')"

if (( core_chars > GPT_LIMIT )); then
  err "CORE block is ${core_chars} chars, over the ${GPT_LIMIT} Custom GPT limit"
else
  ok "CORE block fits Custom GPT: ${core_chars}/${GPT_LIMIT} chars"
fi

# --- 3. references referenced <-> present -------------------------------------
mark
mapfile -t named < <(grep -oE '`[a-z0-9-]+\.md`' "$SKILL" | tr -d '`' | sort -u)
for f in "${named[@]}"; do
  [[ -f "$REFDIR/$f" ]] || err "SKILL.md names '$f' but references/$f does not exist"
done
sec_ok "${#named[@]} referenced files resolved"

for path in "$REFDIR"/*.md; do
  f="$(basename "$path")"
  grep -q "\`$f\`" "$SKILL" || err "references/$f is never named in SKILL.md (orphan)"
done
sec_ok "no orphan references"

# --- 4. origin material stays quarantined -------------------------------------
mark
# The legacy ADM prompts carry a developer persona and live instructions to a
# model. They must never be loadable as skill knowledge.
if [[ -d "$REFDIR/source-adm" ]]; then
  err "references/source-adm/ exists — origin material must live in docs/origin/"
fi
if grep -qE 'references/source-adm|source-adaptation-contract' "$SKILL" "$REFDIR"/*.md; then
  err "something still points at the retired source-adm path or contract file"
fi
if grep -q 'docs/origin' "$SKILL" && ! grep -qE 'never|not.*(loaded|source)|historical' "$SKILL"; then
  err "SKILL.md mentions docs/origin without marking it non-loadable"
fi
if [[ -d "$ORIGIN" ]]; then
  [[ -f "$ORIGIN/README.md" ]] || err "docs/origin/ must carry a README explaining it is not loadable"
  # The loading table must not list any origin file.
  for path in "$ORIGIN"/*; do
    f="$(basename "$path")"
    [[ "$f" == "README.md" ]] && continue
    if grep -q "\`$f\`" "$SKILL"; then
      err "SKILL.md references origin file '$f' as if it were loadable"
    fi
  done
fi
sec_ok "origin material quarantined"

# --- 5. excluded workflows not reintroduced -----------------------------------
mark
# These belong to the original ADM GPT and are explicitly not inherited.
# inherited-reporting-model.md is the one place allowed to name them, because
# naming them is how it excludes them.
leaked=0
for pat in 'METRICA_ABAP' '#estimativa' '#et '; do
  while IFS= read -r hit; do
    [[ "$hit" == *"inherited-reporting-model.md"* ]] && continue
    err "excluded workflow '$pat' leaked into ${hit%%:*}"
    leaked=1
  done < <(grep -rlF "$pat" "$SKILL" "$REFDIR" 2>/dev/null || true)
done
grep -q 'inherited-reporting-model.md' "$SKILL" \
  || err "SKILL.md must point at inherited-reporting-model.md for the binding principles"
(( leaked )) || ok "excluded workflows absent outside the exclusion list"

# --- 6. integrity rules present -----------------------------------------------
mark
grep -qi 'never conflate AI work' "$SKILL" \
  || err "the AI-work-vs-user-work rule is missing from SKILL.md"
grep -qi 'never invent' "$SKILL" \
  || err "the no-invention rule is missing from SKILL.md"
sec_ok "integrity rules present"

# --- 7. emit ------------------------------------------------------------------
mark
if (( CHECK_ONLY == 0 )); then
  echo
  echo "==> Writing artifacts"
  mkdir -p "$OUTDIR"

  {
    echo "# SAP Functional Status Report"
    echo
    printf '%s\n' "$core"
    echo
    echo "Consult the uploaded knowledge files for depth. \`official-functional-status-model.md\`"
    echo "carries the report template and must be followed exactly."
  } > "$OUTDIR/core-prompt.md"

  emitted="$(wc -m < "$OUTDIR/core-prompt.md" | tr -d ' ')"
  if (( emitted > GPT_LIMIT )); then
    err "generated core-prompt.md is ${emitted} chars, over ${GPT_LIMIT}"
  else
    ok "packaging/openai/core-prompt.md — ${emitted}/${GPT_LIMIT} chars"
  fi

  awk 'NR==1 && $0=="---"{fm=1;next} fm && $0=="---"{fm=0;body=1;next} body' "$SKILL" \
    | grep -v 'CORE:BEGIN\|CORE:END' > "$OUTDIR/full-prompt.md"
  ok "packaging/openai/full-prompt.md — $(wc -m < "$OUTDIR/full-prompt.md" | tr -d ' ') chars"
fi

echo
if (( fail )); then
  echo "BUILD FAILED"
  exit 1
fi
echo "All checks passed."
