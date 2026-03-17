param(
    [Parameter(Mandatory = $true)]
    [string[]]$AliasNames,

    [string]$Distro,

    [switch]$OpenInNewWindows,

    [switch]$Background
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
    if ($Background) {
        Write-Host "Opened $($normalizedAliases.Count) PowerShell window(s). Each window will close after authentication completes and the shared session backgrounds."
    } else {
        Write-Host "Opened $($normalizedAliases.Count) PowerShell window(s). Complete authentication in each window."
    }
    exit 0
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
