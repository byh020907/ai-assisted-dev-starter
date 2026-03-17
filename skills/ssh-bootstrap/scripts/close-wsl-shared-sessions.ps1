param(
    [Parameter(Mandatory = $true)]
    [string[]]$AliasNames,

    [string]$Distro
)

$ErrorActionPreference = "Stop"

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

$wslArgs = @()
if ($Distro) {
    $wslArgs = @("-d", $Distro)
}

foreach ($alias in $normalizedAliases) {
    Write-Host "Closing WSL shared SSH session for alias '$alias'"
    & wsl @wslArgs ssh -O exit $alias
}

exit 0
