[CmdletBinding()]
param(
    [string] $OutputPath = ''
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $PSScriptRoot 'cache\Project_Brutality-test.pk3'
}

$outputDirectory = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null

$tar = Get-Command tar -ErrorAction Stop
$packageInputs = Get-ChildItem -LiteralPath $repoRoot -Force |
    Where-Object { $_.Name -notin @('.git', 'tools') } |
    ForEach-Object Name
$arguments = @(
    '--format', 'zip',
    '-cf', $OutputPath
) + $packageInputs

Push-Location $repoRoot
try {
    & $tar.Source @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Package build failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

Get-Item -LiteralPath $OutputPath | Select-Object FullName, Length, LastWriteTime
