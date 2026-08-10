#!/usr/bin/env bash
# Builds the distributable zip for end users.
#
#   ./packaging/make-release.sh
#
# The zip contains only what an SAP functional analyst needs to install and use
# the pack. Development material — evals, packaging, docs/origin, git metadata —
# is left out: it is noise for the recipient and doubles the download.
#
# Refuses to build unless every skill validates first.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(awk '/^## \[/{gsub(/[^0-9.]/,"",$2); print $2; exit}' "$ROOT/CHANGELOG.md")"
STAGE="$ROOT/.release/sap-functional-pack"
OUT="$ROOT/.release/sap-functional-pack-${VERSION}.zip"

echo "==> Validating before packaging"
bash "$ROOT/packaging/build-all.sh" --check >/dev/null || {
  echo "Validation failed — refusing to build a release. Run ./packaging/build-all.sh"
  exit 1
}
echo "  ok    all skills validate"

echo
echo "==> Staging v${VERSION}"
rm -rf "$ROOT/.release"
mkdir -p "$STAGE/skills"

cp "$ROOT/README.md" "$ROOT/LICENSE" "$ROOT/CHANGELOG.md" "$ROOT/install.ps1" "$STAGE/"

for dir in "$ROOT"/skills/*/; do
  name="$(basename "$dir")"
  [[ -f "$dir/SKILL.md" ]] || continue
  mkdir -p "$STAGE/skills/$name"
  cp "$dir/SKILL.md" "$STAGE/skills/$name/"
  cp -r "$dir/references" "$STAGE/skills/$name/"
  for f in README.md LICENSE install.ps1; do
    [[ -f "$dir/$f" ]] && cp "$dir/$f" "$STAGE/skills/$name/"
  done
  echo "  ok    $name"
done

# Windows recipients open these in Notepad; CRLF avoids one long unreadable line.
if command -v unix2dos >/dev/null 2>&1; then
  find "$STAGE" -name '*.ps1' -exec unix2dos -q {} \;
else
  find "$STAGE" -name '*.ps1' -exec sed -i 's/$/\r/' {} \;
fi
echo "  ok    .ps1 convertidos para CRLF"

echo
echo "==> Zipping"
( cd "$ROOT/.release" && zip -qr "$(basename "$OUT")" sap-functional-pack )

size="$(du -h "$OUT" | cut -f1)"
files="$(unzip -l "$OUT" | tail -1 | awk '{print $2}')"

echo "  ok    $(basename "$OUT") — ${size}, ${files} arquivos"
echo
echo "Pronto: $OUT"
echo
echo "Antes de enviar, confirme o RELEASE-CHECKLIST.md — a validacao acima cobre"
echo "estrutura e integridade, nao comportamento."
