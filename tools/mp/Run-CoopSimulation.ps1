[CmdletBinding()]
param(
    [ValidateRange(2, 4)]
    [int] $Clients = 2,

    [ValidateSet('Idle', 'Movement', 'Combat', 'DashCombat', 'GoreImpact')]
    [string] $Scenario = 'DashCombat',

    [ValidateRange(5, 600)]
    [int] $DurationSeconds = 30,

    [ValidateRange(30, 300)]
    [int] $StartupTimeoutSeconds = 120,

    [string] $Map = 'MAP01',

    [string] $Engine = 'S:\Doom\uzdoom.exe',

    [string] $Iwad = 'S:\Doom\DOOM2.WAD',

    [string] $ResourcePackage = '',

    [int] $Port = 0,

    [switch] $KeepProcesses,

    [switch] $AsymmetricLocalGore
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$addonRoot = Join-Path $PSScriptRoot 'addon'
$runsRoot = Join-Path $PSScriptRoot 'runs'
if ([string]::IsNullOrWhiteSpace($ResourcePackage)) {
    $ResourcePackage = Join-Path $PSScriptRoot 'cache\Project_Brutality-test.pk3'
}

foreach ($requiredPath in @($Engine, $Iwad, $ResourcePackage, $addonRoot)) {
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        throw "Required path does not exist: $requiredPath"
    }
}

if ($Port -eq 0) {
    $portProbe = [System.Net.Sockets.UdpClient]::new(0)
    try {
        $Port = ([System.Net.IPEndPoint] $portProbe.Client.LocalEndPoint).Port
    }
    finally {
        $portProbe.Dispose()
    }
}

$runName = '{0:yyyyMMdd-HHmmss}-{1}-{2}p-{3}' -f (Get-Date), $Scenario.ToLowerInvariant(), $Clients, $Port
$runRoot = Join-Path $runsRoot $runName
New-Item -ItemType Directory -Path $runRoot -Force | Out-Null

function New-UZDoomProcess {
    param(
        [Parameter(Mandatory)] [string] $Name,
        [Parameter(Mandatory)] [string[]] $Arguments
    )

    $clientRoot = Join-Path $runRoot $Name
    $saveRoot = Join-Path $clientRoot 'save'
    $shotRoot = Join-Path $clientRoot 'screenshots'
    New-Item -ItemType Directory -Path $clientRoot, $saveRoot, $shotRoot -Force | Out-Null

    $logPath = Join-Path $clientRoot 'engine.log'
    $configPath = Join-Path $clientRoot 'uzdoom.ini'

    $allArguments = @(
        '-iwad', $Iwad,
        '-file', $ResourcePackage, $addonRoot,
        '-noautoload',
        '-nosound',
        '-nomusic',
        '-window',
        '-width', '320',
        '-height', '200',
        '-config', $configPath,
        '-savedir', $saveRoot,
        '-shotdir', $shotRoot,
        '+logfile', $logPath,
        '+developer', '1'
    ) + $Arguments

    $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $Engine
    $startInfo.WorkingDirectory = Split-Path -Parent $Engine
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $startInfo.Arguments = (($allArguments | ForEach-Object {
        '"' + ([string] $_).Replace('"', '\"') + '"'
    }) -join ' ')

    $process = [System.Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    if (-not $process.Start()) {
        throw "Failed to start $Name"
    }
    [pscustomobject]@{
        Name = $Name
        Process = $process
        LogPath = $logPath
        Root = $clientRoot
    }
}

$started = [System.Collections.Generic.List[object]]::new()
try {
    $scenarioNumber = switch ($Scenario) {
        'Idle' { 0 }
        'Movement' { 1 }
        'Combat' { 2 }
        'DashCombat' { 3 }
        'GoreImpact' { 4 }
    }
    $warpArguments = if ($Map -match '^MAP(\d\d)$') {
        @([string] ([int] $Matches[1]))
    }
    elseif ($Map -match '^E(\d)M(\d)$') {
        @($Matches[1], $Matches[2])
    }
    else {
        @($Map)
    }
    $hostArgs = @('-host', [string] $Clients, '-port', [string] $Port, '-warp') + $warpArguments + @('-skill', '3', '+pbmp_scenario', [string] $scenarioNumber)
    if ($AsymmetricLocalGore) {
        $hostArgs += @('+pb_localgoremult', '2.0', '+pb_hidebloodmist', '0')
    }
    $started.Add((New-UZDoomProcess -Name 'host' -Arguments $hostArgs))
    Start-Sleep -Milliseconds 1200

    for ($index = 1; $index -lt $Clients; $index++) {
        $joinArgs = @('-join', '127.0.0.1', '-port', [string] $Port)
        if ($AsymmetricLocalGore) {
            if (($index % 2) -eq 1) {
                $joinArgs += @('+pb_localgoremult', '0.0', '+pb_hidebloodmist', '1')
            }
            else {
                $joinArgs += @('+pb_localgoremult', '0.5', '+pb_hidebloodmist', '0')
            }
        }
        $started.Add((New-UZDoomProcess -Name "client$index" -Arguments $joinArgs))
        Start-Sleep -Milliseconds 350
    }

    $startupDeadline = (Get-Date).AddSeconds($StartupTimeoutSeconds)
    do {
        $exited = @($started | Where-Object { $_.Process.HasExited })
        if ($exited.Count -gt 0) {
            $names = ($exited.Name -join ', ')
            throw "One or more instances exited during startup: $names"
        }

        $startupErrors = @($started | Where-Object {
            (Test-Path -LiteralPath $_.LogPath) -and
            (Select-String -LiteralPath $_.LogPath -Pattern 'script error|fatal error|VM execution aborted' -Quiet)
        })
        if ($startupErrors.Count -gt 0) {
            $names = ($startupErrors.Name -join ', ')
            throw "Script or engine errors occurred during startup: $names"
        }

        $ready = @($started | Where-Object {
            (Test-Path -LiteralPath $_.LogPath) -and
            (Select-String -LiteralPath $_.LogPath -SimpleMatch 'PBMPSTART ' -Quiet)
        })
        if ($ready.Count -eq $started.Count) {
            break
        }
        Start-Sleep -Milliseconds 500
    } while ((Get-Date) -lt $startupDeadline)

    if ($ready.Count -ne $started.Count) {
        throw "Clients did not reach the test map within $StartupTimeoutSeconds seconds"
    }

    $deadline = (Get-Date).AddSeconds($DurationSeconds)
    while ((Get-Date) -lt $deadline) {
        $exited = @($started | Where-Object { $_.Process.HasExited })
        if ($exited.Count -gt 0) {
            $names = ($exited.Name -join ', ')
            throw "One or more instances exited early: $names"
        }
        Start-Sleep -Milliseconds 500
    }
}
finally {
    if (-not $KeepProcesses) {
        foreach ($instance in $started) {
            if (-not $instance.Process.HasExited) {
                $instance.Process.Kill()
            }
        }
        foreach ($instance in $started) {
            $instance.Process.WaitForExit(5000) | Out-Null
        }
    }
}

$errorPattern = 'out of sync|desync|consistency failure|VM execution aborted|script error|fatal error|unknown class|unknown identifier|unknown command'
$fingerprintsByInstance = @{}
$results = foreach ($instance in $started) {
    $logText = if (Test-Path -LiteralPath $instance.LogPath) { Get-Content -LiteralPath $instance.LogPath -Raw } else { '' }
    $checkpoints = [regex]::Matches($logText, '(?m)^PBMPCHK .+$') | ForEach-Object Value
    $players = [regex]::Matches($logText, '(?m)^PBMPPLAYER .+$') | ForEach-Object Value
    $whizDiagnostics = [regex]::Matches($logText, '(?m)^PBMPWHIZ .+$') | ForEach-Object Value
    $visualDiagnostics = [regex]::Matches($logText, '(?m)^PBMPVISUAL .+$') | ForEach-Object Value
    $fingerprintsByInstance[$instance.Name] = @($checkpoints) + @($players) + @($whizDiagnostics)
    $errors = [regex]::Matches($logText, "(?im)^.*(?:$errorPattern).*$") | ForEach-Object Value
    [pscustomobject]@{
        Instance = $instance.Name
        ExitCode = if ($instance.Process.HasExited) { $instance.Process.ExitCode } else { $null }
        Checkpoints = $checkpoints.Count
        PlayerSnapshots = $players.Count
        WhizDiagnostics = $whizDiagnostics.Count
        VisualDiagnostics = $visualDiagnostics.Count
        Errors = $errors.Count
        Log = $instance.LogPath
    }
}

$baselineName = $started[0].Name
$fingerprintMismatches = 0
foreach ($instance in $started | Select-Object -Skip 1) {
    $fingerprintMismatches += @(Compare-Object $fingerprintsByInstance[$baselineName] $fingerprintsByInstance[$instance.Name]).Count
}

$results | Format-Table -AutoSize
$results | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath (Join-Path $runRoot 'summary.json')

if (($results | Measure-Object -Property Checkpoints -Minimum).Minimum -eq 0) {
    throw "No deterministic checkpoints were captured. Inspect logs in $runRoot"
}
if (($results | Measure-Object -Property Errors -Sum).Sum -gt 0) {
    throw "Engine or synchronization errors were detected. Inspect logs in $runRoot"
}
if ($fingerprintMismatches -gt 0) {
    throw "$fingerprintMismatches deterministic checkpoint differences were detected. Inspect logs in $runRoot"
}

Write-Host "Simulation completed: $runRoot"
