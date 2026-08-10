#!/usr/bin/env bash
# Build and validate distribution artifacts for the sap-functional-spec-writer skill.
#
#   ./packaging/build.sh          build + validate
#   ./packaging/build.sh --check  validate only, write nothing (use in CI)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL="$ROOT/SKILL.md"
REFDIR="$ROOT/references"
OUTDIR="$ROOT/packaging/openai"

CHECK_ONLY=0
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=1

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

# --- 4. the discipline that defines this skill --------------------------------
mark
# Without these, the skill degrades into a template filler that invents rules.
grep -qi 'Never write a rule nobody decided' "$SKILL" \
  || err "the core no-invention rule is missing from SKILL.md §2"
for cm in CONFIRMADO 'A VALIDAR' 'EM ABERTO'; do
  grep -qF "$cm" "$SKILL" || err "confidence mark '$cm' is missing from SKILL.md"
done
grep -q 'Q-###' "$SKILL" || err "open-point identifier Q-### is missing from SKILL.md"
sec_ok "no-invention discipline and confidence marks present"

# --- 5. boundaries with the sibling skills ------------------------------------
mark
# All three cover SAP functional work and will compete for the same phrasing.
for sib in sap-functional-test-productivity sap-functional-status-report; do
  grep -q "$sib" "$SKILL" || err "SKILL.md does not declare its boundary with $sib"
done
grep -qi 'authors\|authoring\|escrever\|writes' "$SKILL" \
  || err "SKILL.md must state that it authors rather than analyzes"
sec_ok "sibling boundaries declared"

# --- 6. emit ------------------------------------------------------------------
mark
if (( CHECK_ONLY == 0 )); then
  echo
  echo "==> Writing artifacts"
  mkdir -p "$OUTDIR"

  {
    echo "# SAP Functional Specification Writer"
    echo
    printf '%s\n' "$core"
    echo
    echo "Knowledge files carry the depth. \`spec-template.md\` defines the document structure."
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
