<#
.SYNOPSIS
    Installs the SAP Functional & Testing Productivity skill for Claude.

.DESCRIPTION
    Copies SKILL.md and references/ into the Claude skills folder. Development
    material (packaging, evals, git metadata) is deliberately left behind.

    You do not need Git, WSL or any developer tooling to run this.

.PARAMETER Scope
    User    installs into %USERPROFILE%\.claude\skills  (default, available everywhere)
    Project installs into .claude\skills of -ProjectPath (shared with a team via the repo)

.PARAMETER ProjectPath
    Target project folder when -Scope Project. Defaults to the current folder.

.PARAMETER Force
    Overwrite an existing installation without asking.

.EXAMPLE
    .\install.ps1

.EXAMPLE
    .\install.ps1 -Scope Project -ProjectPath C:\Projetos\cliente-x
#>
[CmdletBinding()]
param(
    [ValidateSet('User', 'Project')]
    [string] $Scope = 'User',

    [string] $ProjectPath = (Get-Location).Path,

    [switch] $Force
)

$ErrorActionPreference = 'Stop'

$SkillName = 'sap-functional-test-productivity'
$Source    = $PSScriptRoot

function Write-Step { param($m) Write-Host "  $m" -ForegroundColor Gray }
function Write-Ok   { param($m) Write-Host "  OK  " -ForegroundColor Green -NoNewline; Write-Host $m }
function Write-Warn { param($m) Write-Host "  !   " -ForegroundColor Yellow -NoNewline; Write-Host $m }

Write-Host ""
Write-Host "Instalando $SkillName" -ForegroundColor Cyan
Write-Host ""

# --- sanity: are we in the package? -------------------------------------------
if (-not (Test-Path (Join-Path $Source 'SKILL.md'))) {
    throw "SKILL.md nao encontrado em $Source. Rode este script de dentro da pasta da skill."
}

# --- resolve destination ------------------------------------------------------
if ($Scope -eq 'User') {
    $SkillsRoot = Join-Path $env:USERPROFILE '.claude\skills'
} else {
    if (-not (Test-Path $ProjectPath)) { throw "Pasta do projeto nao encontrada: $ProjectPath" }
    $SkillsRoot = Join-Path $ProjectPath '.claude\skills'
}
$Destination = Join-Path $SkillsRoot $SkillName

Write-Step "Origem:  $Source"
Write-Step "Destino: $Destination"
Write-Host ""

# --- existing installation ----------------------------------------------------
if (Test-Path $Destination) {
    if (-not $Force) {
        Write-Warn "Ja existe uma instalacao nesse caminho."
        $answer = Read-Host "    Substituir? (s/N)"
        if ($answer -notmatch '^[sSyY]') {
            Write-Host ""
            Write-Host "Cancelado. Nada foi alterado." -ForegroundColor Yellow
            return
        }
    }
    Remove-Item -Path $Destination -Recurse -Force
    Write-Ok "Instalacao anterior removida"
}

# --- copy ---------------------------------------------------------------------
New-Item -ItemType Directory -Path $Destination -Force | Out-Null

Copy-Item -Path (Join-Path $Source 'SKILL.md') -Destination $Destination
Write-Ok "SKILL.md"

Copy-Item -Path (Join-Path $Source 'references') -Destination $Destination -Recurse
$refCount = (Get-ChildItem (Join-Path $Destination 'references') -Filter *.md).Count
Write-Ok "references\ ($refCount arquivos)"

foreach ($optional in 'README.md', 'LICENSE') {
    $p = Join-Path $Source $optional
    if (Test-Path $p) { Copy-Item -Path $p -Destination $Destination }
}
Write-Ok "README.md e LICENSE"

Write-Step "packaging\, evals\ e .git\ nao sao copiados (material de desenvolvimento)"

# --- verify -------------------------------------------------------------------
Write-Host ""
$skillText = [System.IO.File]::ReadAllText((Join-Path $Destination 'SKILL.md'))

if ($skillText -notmatch '(?s)^---\r?\n(.*?)\r?\n---\r?\n') {
    Write-Warn "SKILL.md instalado, mas o frontmatter nao foi reconhecido."
} else {
    $fm = $Matches[1]
    if ($fm -match 'name:\s*(\S+)') { Write-Ok "Frontmatter valido - name: $($Matches[1])" }
}

# Every reference named in SKILL.md must have been copied.
$missing = @()
foreach ($m in [regex]::Matches($skillText, '`([a-z0-9-]+\.md)`')) {
    $f = $m.Groups[1].Value
    if (-not (Test-Path (Join-Path $Destination "references\$f"))) { $missing += $f }
}
if ($missing.Count -gt 0) {
    Write-Warn "Referencias citadas mas ausentes: $($missing -join ', ')"
} else {
    Write-Ok "Todas as referencias citadas estao presentes"
}

Write-Host ""
Write-Host "Instalacao concluida." -ForegroundColor Green
Write-Host ""
Write-Host "  Abra uma NOVA sessao do Claude para a skill ser carregada." -ForegroundColor Yellow
Write-Host "  Skills sao lidas no inicio da sessao; a atual nao enxerga a instalacao." -ForegroundColor Yellow
Write-Host ""
Write-Host "  Teste com uma frase natural, sem chamar a skill pelo nome:"
Write-Host '    "analisa essa EF e me diz o que esta faltando"' -ForegroundColor Cyan
Write-Host '    "esse teste falhou, e bug ou dado?"' -ForegroundColor Cyan
Write-Host ""
