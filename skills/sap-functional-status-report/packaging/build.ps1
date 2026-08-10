<#
.SYNOPSIS
    Builds and validates the distribution artifacts for sap-functional-status-report.

.DESCRIPTION
    PowerShell equivalent of build.sh, for Windows without WSL or Git Bash.
    Both scripts run the same checks and produce byte-identical output.

.PARAMETER Check
    Validate only; write nothing. Use this in CI.

.EXAMPLE
    .\packaging\build.ps1

.EXAMPLE
    .\packaging\build.ps1 -Check
#>
[CmdletBinding()]
param([switch] $Check)

$ErrorActionPreference = 'Stop'

$Root   = Split-Path -Parent $PSScriptRoot
$Skill  = Join-Path $Root 'SKILL.md'
$RefDir = Join-Path $Root 'references'
$Origin = Join-Path $Root 'docs\origin'
$OutDir = Join-Path $Root 'packaging\openai'

# Custom GPT caps the instructions field at 8000 characters.
$GptLimit = 8000

$script:Failed = $false
function Fail { param($m) Write-Host "  FAIL  " -ForegroundColor Red -NoNewline; Write-Host $m; $script:Failed = $true }
function Ok   { param($m) Write-Host "   ok   " -ForegroundColor Green -NoNewline; Write-Host $m }
# Only report success when nothing in the current section failed. An
# unconditional Ok after a Fail makes the output contradict itself.
$script:SecMark = $false
function Mark  { $script:SecMark = $script:Failed }
function SecOk { param($m) if ($script:SecMark -eq $script:Failed) { Ok $m } }

# Count Unicode code points, matching `wc -m`. A naive .Length would count the
# status emoji as 2 each because .NET strings are UTF-16.
function Get-CharCount {
    param([string] $Text)
    $n = 0
    for ($i = 0; $i -lt $Text.Length; $i++) {
        if ([char]::IsHighSurrogate($Text[$i])) { $i++ }
        $n++
    }
    return $n
}

function Read-Utf8 { param($Path) [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($false)) }

Write-Host ""
Write-Host "==> Validating $Skill"

$text  = Read-Utf8 $Skill
$lines = $text -split "`r?`n"

# --- 1. frontmatter -----------------------------------------------------------
Mark
if ($lines[0] -ne '---') { Fail "SKILL.md must start with YAML frontmatter" }
foreach ($key in 'name', 'description', 'license', 'allowed-tools') {
    if ($text -notmatch "(?m)^${key}:") { Fail "frontmatter is missing '${key}:'" }
}

$dirName = Split-Path -Leaf $Root
if ($text -match '(?m)^name:\s*(\S+)') {
    if ($Matches[1] -ne $dirName) { Fail "frontmatter name '$($Matches[1])' does not match directory '$dirName'" }
    else { Ok "name matches directory: $dirName" }
}

# --- 2. CORE markers ----------------------------------------------------------
Mark
$beginCount = ([regex]::Matches($text, 'CORE:BEGIN')).Count
$endCount   = ([regex]::Matches($text, 'CORE:END')).Count
if ($beginCount -ne 1) { Fail "expected exactly one CORE:BEGIN marker (found $beginCount)" }
if ($endCount   -ne 1) { Fail "expected exactly one CORE:END marker (found $endCount)" }

# Tolerate CRLF even though .gitattributes pins .md to LF — a file edited in
# Notepad and saved back would otherwise silently break the extraction.
$core = ''
if ($text -match '(?s)CORE:BEGIN[^\r\n]*\r?\n(.*?)\r?\n[^\r\n]*CORE:END') {
    $core = $Matches[1] -replace "`r`n", "`n"
    $core = $core.Trim("`n")
}
if ([string]::IsNullOrWhiteSpace($core)) { Fail "could not extract the CORE block between the markers" }
$coreChars = Get-CharCount $core

if ($coreChars -gt $GptLimit) { Fail "CORE block is $coreChars chars, over the $GptLimit Custom GPT limit" }
else { Ok "CORE block fits Custom GPT: $coreChars/$GptLimit chars" }

# --- 3. references referenced <-> present -------------------------------------
Mark
$named = @([regex]::Matches($text, '`([a-z0-9-]+\.md)`') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
foreach ($f in $named) {
    if (-not (Test-Path (Join-Path $RefDir $f))) { Fail "SKILL.md names '$f' but references\$f does not exist" }
}
SecOk "$($named.Count) referenced files resolved"

foreach ($file in @(Get-ChildItem $RefDir -Filter *.md)) {
    if ($text -notmatch [regex]::Escape("``$($file.Name)``")) { Fail "references\$($file.Name) is never named in SKILL.md (orphan)" }
}
SecOk "no orphan references"

# --- 4. origin material stays quarantined -------------------------------------
Mark
# The legacy ADM prompts carry a developer persona and live instructions to a
# model. They must never be loadable as skill knowledge.
$allText = $text
foreach ($file in @(Get-ChildItem $RefDir -Filter *.md)) { $allText += "`n" + (Read-Utf8 $file.FullName) }

if (Test-Path (Join-Path $RefDir 'source-adm')) {
    Fail "references\source-adm\ exists - origin material must live in docs\origin\"
}
if ($allText -match 'references/source-adm|source-adaptation-contract') {
    Fail "something still points at the retired source-adm path or contract file"
}
if ($text.Contains('docs/origin') -and $text -notmatch 'never|not a source|historical') {
    Fail "SKILL.md mentions docs/origin without marking it non-loadable"
}
if (Test-Path $Origin) {
    if (-not (Test-Path (Join-Path $Origin 'README.md'))) {
        Fail "docs\origin\ must carry a README explaining it is not loadable"
    }
    foreach ($file in @(Get-ChildItem $Origin -File)) {
        if ($file.Name -eq 'README.md') { continue }
        if ($text -match [regex]::Escape("``$($file.Name)``")) {
            Fail "SKILL.md references origin file '$($file.Name)' as if it were loadable"
        }
    }
}
SecOk "origin material quarantined"

# --- 5. excluded workflows not reintroduced -----------------------------------
Mark
# inherited-reporting-model.md is the one place allowed to name them, because
# naming them is how it excludes them.
$leaked = $false
foreach ($pat in 'METRICA_ABAP', '#estimativa', '#et ') {
    foreach ($file in @(Get-ChildItem $RefDir -Filter *.md) + @(Get-Item $Skill)) {
        if ($file.Name -eq 'inherited-reporting-model.md') { continue }
        if ((Read-Utf8 $file.FullName).Contains($pat)) {
            Fail "excluded workflow '$pat' leaked into $($file.Name)"
            $leaked = $true
        }
    }
}
if ($text -notmatch 'inherited-reporting-model\.md') {
    Fail "SKILL.md must point at inherited-reporting-model.md for the binding principles"
}
if (-not $leaked) { Ok "excluded workflows absent outside the exclusion list" }

# --- 6. integrity rules present -----------------------------------------------
Mark
if ($text -notmatch '(?i)never conflate AI work') { Fail "the AI-work-vs-user-work rule is missing from SKILL.md" }
if ($text -notmatch '(?i)never invent')           { Fail "the no-invention rule is missing from SKILL.md" }
SecOk "integrity rules present"

# --- 7. emit ------------------------------------------------------------------
Mark
if (-not $Check) {
    Write-Host ""
    Write-Host "==> Writing artifacts"
    New-Item -ItemType Directory -Path $OutDir -Force | Out-Null

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)

    $corePrompt = @(
        '# SAP Functional Status Report'
        ''
        $core
        ''
        'Consult the uploaded knowledge files for depth. `official-functional-status-model.md`'
        'carries the report template and must be followed exactly.'
    ) -join "`n"
    $corePrompt += "`n"

    $corePath = Join-Path $OutDir 'core-prompt.md'
    [System.IO.File]::WriteAllText($corePath, $corePrompt, $utf8NoBom)

    $emitted = Get-CharCount $corePrompt
    if ($emitted -gt $GptLimit) { Fail "generated core-prompt.md is $emitted chars, over $GptLimit" }
    else { Ok "packaging\openai\core-prompt.md - $emitted/$GptLimit chars" }

    $body = $text -replace '(?s)\A---\r?\n.*?\r?\n---\r?\n', ''
    $body = ($body -split "`r?`n" | Where-Object { $_ -notmatch 'CORE:(BEGIN|END)' }) -join "`n"

    $fullPath = Join-Path $OutDir 'full-prompt.md'
    [System.IO.File]::WriteAllText($fullPath, $body, $utf8NoBom)
    Ok "packaging\openai\full-prompt.md - $(Get-CharCount $body) chars"
}

Write-Host ""
if ($script:Failed) {
    Write-Host "BUILD FAILED" -ForegroundColor Red
    exit 1
}
Write-Host "All checks passed." -ForegroundColor Green
