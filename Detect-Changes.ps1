$files = git diff-tree --no-commit-id --name-only -r main

# $filePaths = "azure/aks/app_one/checks/check.go`napp_two/main.go"

$paths = $files -split "\n"

$paths.Length
$paths[0]
$paths[1]
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

foreach ($app in $parentDirs) {
    $appName = $app.Replace("/", "_")
    Push-Location $PSScriptRoot
    Set-Location "./$app"
    go build -o $appName
    Pop-Location
}