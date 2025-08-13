$files = git diff-tree --no-commit-id --name-only -r main

Write-Output "Git Files: $files"

# $filePaths = "azure/aks/app_one/checks/check.go`napp_two/main.go"

$paths = $files -split "\n"
$paths

# exit

$parentDirs = @()

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

$parentDirs.Length
$parentDirs = $parentDirs | Sort-Object -Unique
$parentDirs


foreach ($app in $parentDirs) {
    $appName = $app.Replace("/", "_")
    Push-Location $PSScriptRoot
    Set-Location "./$app"
    go build -o $appName
    Pop-Location
}