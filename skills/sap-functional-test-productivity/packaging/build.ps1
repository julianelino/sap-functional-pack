<#
.SYNOPSIS
    Builds and validates the distribution artifacts for sap-functional-test-productivity.

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

# Count Unicode code points, matching `wc -m`. A naive .Length would count an
# astral character (emoji) as 2 because .NET strings are UTF-16.
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
# @() keeps this an array when only one match exists; a bare scalar has no
# reliable .Count on Windows PowerShell 5.1.
$named = @([regex]::Matches($text, '`([a-z0-9-]+\.md)`') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
foreach ($f in $named) {
    if (-not (Test-Path (Join-Path $RefDir $f))) { Fail "SKILL.md names '$f' but references\$f does not exist" }
}
SecOk "$($named.Count) referenced files resolved"

foreach ($file in @(Get-ChildItem $RefDir -Filter *.md)) {
    if ($text -notmatch [regex]::Escape("``$($file.Name)``")) { Fail "references\$($file.Name) is never named in SKILL.md (orphan)" }
}
SecOk "no orphan references"

# --- 4. vocabulary consistency ------------------------------------------------
Mark
$allText = $text
foreach ($file in @(Get-ChildItem $RefDir -Filter *.md)) { $allText += "`n" + (Read-Utf8 $file.FullName) }

foreach ($pat in 'NOT REPRODUCED', 'NOT RUN', 'READY WITH RISKS', 'GO WITH ACCEPTED RISK', 'DONE WITH RESIDUAL RISK') {
    if ($allText.Contains($pat)) { Fail "inconsistent keyword spelling found: '$pat'" }
}

foreach ($s in 'test-review', 'logic-review', 'bug-investigator', 'systematic-debugging',
                'root-cause-analysis', 'verification-before-completion', 'writing-plans') {
    if ($allText.Contains("``$s``")) { Fail "SKILL.md or a reference depends on external skill '$s'" }
}
SecOk "vocabulary and dependency checks passed"

# --- 5. safety rules present --------------------------------------------------
Mark
if ($text -notmatch 'SM30') { Fail "the never-suggest transaction list is missing from SKILL.md" }
if (-not (Test-Path (Join-Path $RefDir 'safety-and-data-handling.md'))) { Fail "references\safety-and-data-handling.md is required" }
SecOk "safety rules present"

# --- 6. emit ------------------------------------------------------------------
Mark
if (-not $Check) {
    Write-Host ""
    Write-Host "==> Writing artifacts"
    New-Item -ItemType Directory -Path $OutDir -Force | Out-Null

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)

    $corePrompt = @(
        '# SAP Functional & Testing Productivity'
        ''
        $core
        ''
        'Knowledge files carry the depth. `templates.md` defines every artifact format.'
    ) -join "`n"
    $corePrompt += "`n"

    $corePath = Join-Path $OutDir 'core-prompt.md'
    [System.IO.File]::WriteAllText($corePath, $corePrompt, $utf8NoBom)

    $emitted = Get-CharCount $corePrompt
    if ($emitted -gt $GptLimit) { Fail "generated core-prompt.md is $emitted chars, over $GptLimit" }
    else { Ok "packaging\openai\core-prompt.md - $emitted/$GptLimit chars" }

    # Assistants API / Projects: strip the frontmatter, keep everything else.
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
