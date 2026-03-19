param(
    [Parameter(Mandatory = $true)]
    [string[]]$AliasNames,

    [string]$Distro,

    [switch]$OpenInNewWindows,

    [switch]$Background,

    [int]$WaitTimeoutSeconds = 30,

    [int]$PollIntervalSeconds = 2,

    [switch]$NoWait
)

$ErrorActionPreference = "Stop"

if (-not $AliasNames -or $AliasNames.Count -eq 0) {
    throw "Provide at least one alias in -AliasNames."
}

$normalizedAliases = @()
foreach ($entry in $AliasNames) {
    if ([string]::IsNullOrWhiteSpace($entry)) {
        continue
    }

    $normalizedAliases += ($entry -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

if (-not $normalizedAliases -or $normalizedAliases.Count -eq 0) {
    throw "Provide at least one non-empty alias in -AliasNames."
}

$duplicateAliases = $normalizedAliases |
    Group-Object |
    Where-Object { $_.Count -gt 1 } |
    Select-Object -ExpandProperty Name

if ($duplicateAliases) {
    throw "Duplicate aliases in -AliasNames are not allowed: $($duplicateAliases -join ', ')"
}

if ($WaitTimeoutSeconds -lt 1) {
    throw "-WaitTimeoutSeconds must be at least 1."
}

if ($PollIntervalSeconds -lt 1) {
    throw "-PollIntervalSeconds must be at least 1."
}

function Get-WslSshCommand {
    param(
        [string]$AliasName,
        [string]$DistroName,
        [switch]$UseBackground
    )

    $sshArgs = if ($UseBackground) { "ssh -MNf $AliasName" } else { "ssh $AliasName" }

    if ($DistroName) {
        return "wsl -d $DistroName $sshArgs"
    }

    return "wsl $sshArgs"
}

function Test-SharedSession {
    param(
        [string]$AliasName,
        [string]$DistroName
    )

    $wslArgs = @()
    if ($DistroName) {
        $wslArgs = @("-d", $DistroName)
    }

    & wsl @wslArgs ssh -O check $AliasName *> $null
    return ($LASTEXITCODE -eq 0)
}

function Wait-ForSharedSessions {
    param(
        [string[]]$PendingAliases,
        [string]$DistroName,
        [int]$TimeoutSeconds,
        [int]$IntervalSeconds
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    $remainingAliases = [System.Collections.Generic.List[string]]::new()
    foreach ($alias in $PendingAliases) {
        $remainingAliases.Add($alias)
    }

    Write-Host "Waiting up to $TimeoutSeconds second(s) for shared session login to complete."

    while ($remainingAliases.Count -gt 0 -and (Get-Date) -lt $deadline) {
        $activatedAliases = @()
        foreach ($alias in @($remainingAliases)) {
            if (Test-SharedSession -AliasName $alias -DistroName $DistroName) {
                $activatedAliases += $alias
            }
        }

        foreach ($alias in $activatedAliases) {
            [void]$remainingAliases.Remove($alias)
            Write-Host "Shared session is ready for '$alias'"
        }

        if ($remainingAliases.Count -eq 0) {
            return
        }

        Start-Sleep -Seconds $IntervalSeconds
    }

    throw "Timed out after $TimeoutSeconds second(s) waiting for shared session login to complete for: $($remainingAliases -join ', '). Stop the current conversation flow and ask the user to start a new request after login succeeds."
}

if ($OpenInNewWindows) {
    foreach ($alias in $normalizedAliases) {
        $command = Get-WslSshCommand -AliasName $alias -DistroName $Distro -UseBackground:$Background
        Write-Host "Opening new PowerShell window for '$alias'"
        $windowArgs = if ($Background) {
            @("-Command", $command)
        } else {
            @("-NoExit", "-Command", $command)
        }
        Start-Process powershell -ArgumentList $windowArgs | Out-Null
    }

    if (-not $NoWait) {
        Wait-ForSharedSessions -PendingAliases $normalizedAliases -DistroName $Distro -TimeoutSeconds $WaitTimeoutSeconds -IntervalSeconds $PollIntervalSeconds
    }

    if ($Background) {
        Write-Host "Opened $($normalizedAliases.Count) PowerShell window(s). Each window will close after authentication completes and the shared session backgrounds."
    } else {
        Write-Host "Opened $($normalizedAliases.Count) PowerShell window(s). Complete authentication in each window."
    }
    exit 0
}

if ($normalizedAliases.Count -eq 1) {
    $command = Get-WslSshCommand -AliasName $normalizedAliases[0] -DistroName $Distro -UseBackground:$Background
    Write-Host "Starting shared SSH session for '$($normalizedAliases[0])'"
    Invoke-Expression $command
    exit $LASTEXITCODE
}

foreach ($alias in $normalizedAliases) {
    $command = Get-WslSshCommand -AliasName $alias -DistroName $Distro -UseBackground:$Background
    Write-Host $command
}

if ($Background) {
    Write-Host "Run the commands above one by one, or rerun with -OpenInNewWindows -Background to launch separate PowerShell windows that close automatically after authentication."
} else {
    Write-Host "Run the commands above one by one, or rerun with -OpenInNewWindows to launch separate PowerShell windows."
}
