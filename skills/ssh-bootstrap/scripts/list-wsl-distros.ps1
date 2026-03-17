param()

$ErrorActionPreference = "Stop"

$raw = & wsl -l -q
if ($LASTEXITCODE -ne 0) {
    throw "Failed to list WSL distros."
}

$distros = @()
foreach ($line in $raw) {
    $name = ($line -replace "`0", "").Trim()
    if ($name) {
        $distros += $name
    }
}

if (-not $distros -or $distros.Count -eq 0) {
    throw "No WSL distros found."
}

$distros | Write-Output
