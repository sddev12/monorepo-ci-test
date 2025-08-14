Push-Location $PSScriptRoot

$ErrorActionPreference = "Stop"

Write-Output "Running git diff...`n"
# $files = git diff-tree --no-commit-id --name-only -r main

$files = "azure/aks/app_one/main.go`napp_two/main.go"

Write-Output "Changed files: $files`n"

$paths = $files -split "\n"

$parentDirs = @()

Write-Output "Detecting checks for building..."
foreach ($path in $paths) {
    $parentDir = $path

    while ($true) {
        # Write-Host $parentDir
        if (Test-Path "$parentDir/go.mod") {
            $parentDirs += $parentDir
            break
        }

        if ($null -ne $parentDir -and $parentDir -ne "") {
            $parentDir = Split-Path $parentDir -Parent
            continue
        }

        break
    }
}

$parentDirs = $parentDirs | Sort-Object -Unique

Write-Output "Checks to be built: $parentDirs"

"checks=$($parentDirs | ConvertTo-Json -AsArray -Compress)" >> $env:GITHUB_OUTPUT