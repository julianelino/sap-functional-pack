#!/usr/bin/env bash
# Build and validate distribution artifacts for the sap-functional-test-productivity skill.
#
#   ./packaging/build.sh          build + validate
#   ./packaging/build.sh --check  validate only, write nothing (use in CI)
#
# Exits non-zero on any validation failure.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL="$ROOT/SKILL.md"
REFDIR="$ROOT/references"
OUTDIR="$ROOT/packaging/openai"

CHECK_ONLY=0
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=1

# Custom GPT caps the instructions field at 8000 characters.
GPT_LIMIT=8000

fail=0
err()  { printf '  \033[31mFAIL\033[0m  %s\n' "$1"; fail=1; }
ok()   { printf '  \033[32m ok \033[0m  %s\n' "$1"; }
# Only report success when nothing in the current section failed.
mark()   { sec=$fail; }
sec_ok() { (( fail == sec )) && ok "$1"; return 0; }
warn() { printf '  \033[33mwarn\033[0m  %s\n' "$1"; }

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

core="$(awk '/CORE:BEGIN/{f=1;next} /CORE:END/{f=0} f' "$SKILL")"
core_chars="$(printf '%s' "$core" | wc -m | tr -d ' ')"

if (( core_chars > GPT_LIMIT )); then
  err "CORE block is ${core_chars} chars, over the ${GPT_LIMIT} Custom GPT limit"
else
  ok "CORE block fits Custom GPT: ${core_chars}/${GPT_LIMIT} chars"
fi

# --- 3. references referenced <-> present -------------------------------------
mark
# Every *.md named in backticks anywhere in SKILL.md must exist in references/.
mapfile -t named < <(grep -oE '`[a-z0-9-]+\.md`' "$SKILL" | tr -d '`' | sort -u)
for f in "${named[@]}"; do
  [[ -f "$REFDIR/$f" ]] || err "SKILL.md names '$f' but references/$f does not exist"
done
sec_ok "${#named[@]} referenced files resolved"

# Every reference on disk must be named in the SKILL.md loading table.
for path in "$REFDIR"/*.md; do
  f="$(basename "$path")"
  grep -q "\`$f\`" "$SKILL" || err "references/$f is never named in SKILL.md (orphan)"
done
sec_ok "no orphan references"

# --- 4. vocabulary consistency ------------------------------------------------
mark
# Enum keywords must use the underscore spelling everywhere. Prose names like
# "Go/No-Go" and "Definition of Ready" are allowed; the keyword forms are not.
declare -a banned=(
  'NOT REPRODUCED'
  'NOT RUN'
  'READY WITH RISKS'
  'GO WITH ACCEPTED RISK'
  'DONE WITH RESIDUAL RISK'
)
for pat in "${banned[@]}"; do
  if grep -rqF "$pat" "$SKILL" "$REFDIR"; then
    err "inconsistent keyword spelling found: '$pat'"
    grep -rnF "$pat" "$SKILL" "$REFDIR" | sed 's/^/         /'
  fi
done

# Skills that will not exist on a third party's machine must not be referenced.
declare -a dead_skills=(
  'test-review' 'logic-review' 'bug-investigator' 'systematic-debugging'
  'root-cause-analysis' 'verification-before-completion' 'writing-plans'
)
for s in "${dead_skills[@]}"; do
  if grep -rqF "\`$s\`" "$SKILL" "$REFDIR"; then
    err "SKILL.md or a reference depends on external skill '$s'"
  fi
done
sec_ok "vocabulary and dependency checks passed"

# --- 5. safety rules present --------------------------------------------------
mark
grep -q 'SM30' "$SKILL" || err "the never-suggest transaction list is missing from SKILL.md §8"
[[ -f "$REFDIR/safety-and-data-handling.md" ]] \
  || err "references/safety-and-data-handling.md is required"
sec_ok "safety rules present"

# --- 6. emit --------------------------------------------------------------
mark
if (( CHECK_ONLY == 0 )); then
  echo
  echo "==> Writing artifacts"
  mkdir -p "$OUTDIR"

  # Custom GPT: the CORE block only. References go up as Knowledge files.
  {
    echo "# SAP Functional & Testing Productivity"
    echo
    printf '%s\n' "$core"
    echo
    echo "Knowledge files carry the depth. \`templates.md\` defines every artifact format."
  } > "$OUTDIR/core-prompt.md"

  emitted="$(wc -m < "$OUTDIR/core-prompt.md" | tr -d ' ')"
  if (( emitted > GPT_LIMIT )); then
    err "generated core-prompt.md is ${emitted} chars, over ${GPT_LIMIT}"
  else
    ok "packaging/openai/core-prompt.md — ${emitted}/${GPT_LIMIT} chars"
  fi

  # Assistants API / Projects: instruction limits are far larger, so ship the
  # whole skill body with the frontmatter stripped.
  awk 'NR>1 && /^---$/{p=1;next} p' "$SKILL" | grep -v 'CORE:BEGIN\|CORE:END' > "$OUTDIR/full-prompt.md"
  ok "packaging/openai/full-prompt.md — $(wc -m < "$OUTDIR/full-prompt.md" | tr -d ' ') chars"
fi

echo
if (( fail )); then
  echo "BUILD FAILED"
  exit 1
fi
echo "All checks passed."
