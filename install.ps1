<#
.SYNOPSIS
    Instala as skills do SAP Functional Pack para o Claude.

.DESCRIPTION
    Copia SKILL.md e references/ de cada skill para a pasta de skills do Claude.
    Material de desenvolvimento (packaging, evals, docs, git) nao e copiado.

    Nao e preciso Git, WSL nem ferramenta de desenvolvedor.

.PARAMETER Only
    Instala apenas a skill informada. Por padrao instala todas.

.PARAMETER Scope
    User    instala em %USERPROFILE%\.claude\skills  (padrao, vale em qualquer pasta)
    Project instala em .claude\skills de -ProjectPath (compartilhado pelo repositorio)

.PARAMETER ProjectPath
    Pasta do projeto quando -Scope Project. Padrao: pasta atual.

.PARAMETER Force
    Sobrescreve instalacao existente sem perguntar.

.EXAMPLE
    .\install.ps1

.EXAMPLE
    .\install.ps1 -Only sap-functional-spec-writer

.EXAMPLE
    .\install.ps1 -Scope Project -ProjectPath C:\Projetos\cliente-x
#>
[CmdletBinding()]
param(
    [ValidateSet('sap-functional-spec-writer',
                 'sap-functional-test-productivity',
                 'sap-functional-status-report')]
    [string] $Only,

    [ValidateSet('User', 'Project')]
    [string] $Scope = 'User',

    [string] $ProjectPath = (Get-Location).Path,

    [switch] $Force
)

$ErrorActionPreference = 'Stop'

$SkillsSource = Join-Path $PSScriptRoot 'skills'

function Write-Step { param($m) Write-Host "  $m" -ForegroundColor Gray }
function Write-Ok   { param($m) Write-Host "  OK  " -ForegroundColor Green -NoNewline; Write-Host $m }
function Write-Warn { param($m) Write-Host "  !   " -ForegroundColor Yellow -NoNewline; Write-Host $m }

Write-Host ""
Write-Host "SAP Functional Pack" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $SkillsSource)) {
    throw "Pasta 'skills' nao encontrada em $PSScriptRoot. Rode este script da raiz do pacote."
}

# --- destino ------------------------------------------------------------------
if ($Scope -eq 'User') {
    $SkillsRoot = Join-Path $env:USERPROFILE '.claude\skills'
} else {
    if (-not (Test-Path $ProjectPath)) { throw "Pasta do projeto nao encontrada: $ProjectPath" }
    $SkillsRoot = Join-Path $ProjectPath '.claude\skills'
}

Write-Step "Destino: $SkillsRoot"
Write-Host ""

# --- o que instalar -----------------------------------------------------------
$toInstall = if ($Only) {
    @(Get-Item (Join-Path $SkillsSource $Only))
} else {
    @(Get-ChildItem $SkillsSource -Directory | Where-Object {
        Test-Path (Join-Path $_.FullName 'SKILL.md')
    })
}

if ($toInstall.Count -eq 0) { throw "Nenhuma skill encontrada em $SkillsSource" }

$installed = @()
$skipped   = @()

foreach ($skill in $toInstall) {
    $name        = $skill.Name
    $destination = Join-Path $SkillsRoot $name

    Write-Host "$name" -ForegroundColor White

    if (Test-Path $destination) {
        if (-not $Force) {
            Write-Warn "Ja instalada."
            $answer = Read-Host "      Substituir? (s/N)"
            if ($answer -notmatch '^[sSyY]') {
                Write-Step "Mantida a versao existente."
                $skipped += $name
                Write-Host ""
                continue
            }
        }
        Remove-Item -Path $destination -Recurse -Force
    }

    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    Copy-Item -Path (Join-Path $skill.FullName 'SKILL.md') -Destination $destination
    Copy-Item -Path (Join-Path $skill.FullName 'references') -Destination $destination -Recurse

    foreach ($optional in 'README.md', 'LICENSE') {
        $p = Join-Path $skill.FullName $optional
        if (Test-Path $p) { Copy-Item -Path $p -Destination $destination }
    }

    $refCount = (Get-ChildItem (Join-Path $destination 'references') -Filter *.md).Count
    Write-Ok "SKILL.md + references\ ($refCount arquivos)"

    # verificacao: toda reference citada no SKILL.md precisa ter chegado
    $skillText = [System.IO.File]::ReadAllText((Join-Path $destination 'SKILL.md'))
    $missing = @()
    foreach ($m in [regex]::Matches($skillText, '`([a-z0-9-]+\.md)`')) {
        $f = $m.Groups[1].Value
        if (-not (Test-Path (Join-Path $destination "references\$f"))) { $missing += $f }
    }
    if ($missing.Count -gt 0) {
        Write-Warn "Referencias citadas mas ausentes: $($missing -join ', ')"
    } else {
        Write-Ok "Referencias conferidas"
    }

    $installed += $name
    Write-Host ""
}

# --- resumo -------------------------------------------------------------------
Write-Host "-------------------------------------------" -ForegroundColor DarkGray
if ($installed.Count -gt 0) {
    Write-Host "Instaladas: $($installed.Count)" -ForegroundColor Green
    foreach ($n in $installed) { Write-Host "  - $n" }
}
if ($skipped.Count -gt 0) {
    Write-Host "Mantidas como estavam: $($skipped -join ', ')" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Abra uma NOVA sessao do Claude para as skills serem carregadas." -ForegroundColor Yellow
Write-Host "  Skills sao lidas no inicio da sessao; a atual nao enxerga a instalacao." -ForegroundColor Yellow
Write-Host ""
Write-Host "  Escreva naturalmente, sem chamar a skill pelo nome:"
Write-Host '    "escreve a EF da CR80 a partir dessa ata"' -ForegroundColor Cyan
Write-Host '    "analisa essa EF e me diz o que esta faltando"' -ForegroundColor Cyan
Write-Host '    "#status"' -ForegroundColor Cyan
Write-Host ""
