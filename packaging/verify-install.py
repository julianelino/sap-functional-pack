#!/usr/bin/env python3
"""Verifica a integridade das skills instaladas em ~/.claude/skills.

Testa CARREGAMENTO e INTEGRIDADE — nao testa disparo automatico nem comportamento.
"""
import io, os, re, sys, unicodedata
from pathlib import Path

try:
    import yaml
except ImportError:
    print("pyyaml ausente"); sys.exit(2)

INSTALLED = Path.home() / ".claude" / "skills"
SOURCE    = Path(__file__).resolve().parent.parent / "skills"
NAMES     = sorted(p.name for p in SOURCE.iterdir()
                   if p.is_dir() and (p / "SKILL.md").is_file()) \
            if SOURCE.is_dir() else []

G, R, Y, D = "\033[32m", "\033[31m", "\033[33m", "\033[0m"
fails, warns = [], []

def ok(m):   print(f"  {G}ok{D}    {m}")
def bad(m):  print(f"  {R}FAIL{D}  {m}"); fails.append(m)
def warn(m): print(f"  {Y}warn{D}  {m}"); warns.append(m)

for name in NAMES:
    inst = INSTALLED / name
    print(f"\n\033[1m### {name}\033[0m")

    if not inst.is_dir():
        bad(f"{name} nao esta instalada em {INSTALLED}"); continue

    skill_path = inst / "SKILL.md"
    if not skill_path.is_file():
        bad("SKILL.md ausente"); continue

    raw = skill_path.read_bytes()

    # --- 1. encoding -------------------------------------------------------
    if raw.startswith(b"\xef\xbb\xbf"):
        bad("SKILL.md tem BOM UTF-8 — quebra o parser de frontmatter")
    try:
        text = raw.decode("utf-8")
        ok("UTF-8 valido, sem BOM")
    except UnicodeDecodeError as e:
        bad(f"SKILL.md nao e UTF-8 valido: {e}"); continue

    if b"\r\n" in raw:
        warn("SKILL.md tem CRLF (funciona, mas .gitattributes fixa LF)")

    # --- 2. frontmatter ----------------------------------------------------
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        bad("frontmatter nao reconhecido"); continue
    try:
        fm = yaml.safe_load(m.group(1))
    except yaml.YAMLError as e:
        bad(f"YAML invalido: {e}"); continue

    missing = [k for k in ("name", "description", "license", "allowed-tools") if k not in fm]
    if missing:
        bad(f"frontmatter sem: {', '.join(missing)}")
    else:
        ok(f"frontmatter completo — license={fm['license']}, tools={fm['allowed-tools']}")

    if fm.get("name") != name:
        bad(f"name '{fm.get('name')}' != diretorio '{name}'")

    desc = fm.get("description", "")
    if isinstance(desc, str):
        ok(f"description com {len(desc)} chars")
        if len(desc) > 1024:
            warn("description longa; pode ser truncada por alguma plataforma")

    # --- 3. references citadas resolvem ------------------------------------
    refdir = inst / "references"
    if not refdir.is_dir():
        bad("pasta references/ ausente"); continue

    named = sorted(set(re.findall(r"`([a-z0-9-]+\.md)`", text)))
    missing_refs = [f for f in named if not (refdir / f).is_file()]
    if missing_refs:
        bad(f"citadas mas ausentes: {', '.join(missing_refs)}")
    else:
        ok(f"{len(named)} references citadas, todas presentes")

    on_disk = sorted(p.name for p in refdir.glob("*.md"))
    orphans = [f for f in on_disk if f not in named]
    if orphans:
        bad(f"orfas (no disco, nao citadas): {', '.join(orphans)}")
    else:
        ok(f"{len(on_disk)} arquivos em references/, nenhum orfao")

    # --- 4. references legiveis e integras ---------------------------------
    problems = []
    for p in refdir.glob("*.md"):
        b = p.read_bytes()
        if not b.strip():
            problems.append(f"{p.name} vazio")
            continue
        if b.startswith(b"\xef\xbb\xbf"):
            problems.append(f"{p.name} com BOM")
        try:
            b.decode("utf-8")
        except UnicodeDecodeError:
            problems.append(f"{p.name} nao e UTF-8")
    if problems:
        for x in problems: bad(x)
    else:
        total = sum(len(p.read_bytes()) for p in refdir.glob("*.md"))
        ok(f"todas legiveis e nao vazias ({total:,} bytes)")

    # --- 5. copia instalada == fonte ---------------------------------------
    src = SOURCE / name
    if src.is_dir():
        drift = []
        if (src / "SKILL.md").read_bytes() != raw:
            drift.append("SKILL.md")
        for p in (src / "references").glob("*.md"):
            q = refdir / p.name
            if not q.is_file() or q.read_bytes() != p.read_bytes():
                drift.append(f"references/{p.name}")
        if drift:
            bad(f"instalada divergente da fonte: {', '.join(drift)}")
        else:
            ok("instalada identica a fonte")

    # --- 6. fronteiras com as irmas ----------------------------------------
    others = [n for n in NAMES if n != name]
    undeclared = [n for n in others if n not in text]
    if undeclared:
        bad(f"nao declara fronteira com: {', '.join(undeclared)}")
    else:
        ok("fronteiras declaradas com as duas irmas")

# --- 7. emoji do status-report sobreviveram --------------------------------
print(f"\n\033[1m### encoding critico\033[0m")
sr = INSTALLED / "sap-functional-status-report" / "references" / "official-functional-status-model.md"
if sr.is_file():
    t = sr.read_text(encoding="utf-8")
    found = [e for e in "🟢🔵🟠🔴🔄" if e in t]
    if len(found) == 5:
        ok("os 5 emoji de status intactos apos a copia (" + " ".join(found) + ")")
    else:
        bad(f"emoji de status corrompidos: encontrados {len(found)} de 5")
else:
    bad("official-functional-status-model.md ausente")

print()
print("=" * 62)
if fails:
    print(f"{R}{len(fails)} FALHA(S){D}")
    sys.exit(1)
print(f"{G}Carregamento e integridade: OK nas tres skills.{D}")
if warns:
    print(f"{Y}{len(warns)} aviso(s) nao bloqueante(s).{D}")
print("\nNAO testado aqui: disparo automatico, comportamento, PowerShell.")
