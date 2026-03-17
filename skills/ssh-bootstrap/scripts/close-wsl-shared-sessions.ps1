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

$duplicateAliases = $normalizedAliases |
    Group-Object |
    Where-Object { $_.Count -gt 1 } |
    Select-Object -ExpandProperty Name

if ($duplicateAliases) {
    throw "Duplicate aliases in -AliasNames are not allowed: $($duplicateAliases -join ', ')"
}

$wslArgs = @()
if ($Distro) {
    $wslArgs = @("-d", $Distro)
}

$failedAliases = @()
foreach ($alias in $normalizedAliases) {
    Write-Host "Closing WSL shared SSH session for alias '$alias'"
    & wsl @wslArgs ssh -O exit $alias
    if ($LASTEXITCODE -ne 0) {
        $failedAliases += $alias
    }
}

if ($failedAliases.Count -gt 0) {
    throw "Failed to close shared SSH session for: $($failedAliases -join ', ')"
}

exit 0
