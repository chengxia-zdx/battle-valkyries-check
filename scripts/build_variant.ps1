param(
    [ValidateSet("en", "zh_CN")]
    [string] $Variant = "en",
    [switch] $IncludeTestOrigin
)

$ErrorActionPreference = "Stop"
$Root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$BuilderRoot = Join-Path $Root "tools\BBBuilder"
$Builder = Join-Path $BuilderRoot "BBBuilder.exe"
$ModsRoot = Join-Path $Root "mods"
$DistRoot = Join-Path $Root "dist"
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if (!(Test-Path -LiteralPath $Builder -PathType Leaf)) {
    throw "Missing build tool: $Builder"
}

# This tool normally installs into GamePath. For this source distribution,
# always redirect it to the repository's dist folder, including after relocation.
foreach ($path in @($ModsRoot, $DistRoot)) {
    if (Test-Path -LiteralPath $path) {
        $item = Get-Item -LiteralPath $path -Force
        if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "Output folder must not be a reparse point: $path"
        }
    }
    New-Item -ItemType Directory -Path $path -Force | Out-Null
}
$config = [ordered]@{
    GamePath = $DistRoot
    ModPath = $ModsRoot
    MoveZip = $true
    UseSteam = $false
    Verbose = $false
    LogTime = $false
    SetPath = $false
    FoldersArray = @()
}
[IO.File]::WriteAllText((Join-Path $BuilderRoot "tools\config.json"), ($config | ConvertTo-Json), $Utf8NoBom)

$renderArgs = @{ Variant = $Variant }
if (!$IncludeTestOrigin) { $renderArgs.ExcludeTestOrigin = $true }
& (Join-Path $PSScriptRoot "render_mods.ps1") @renderArgs

$variantData = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $Root "variants\$Variant.json") | ConvertFrom-Json
$modDir = Join-Path $ModsRoot $variantData.targetFolder
& (Join-Path $PSScriptRoot "check_brush_layout_versions.ps1") -Root $modDir

Push-Location $BuilderRoot
try {
    & $Builder build $modDir -rebuild
    if ($LASTEXITCODE -ne 0) {
        throw "BBBuilder failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

$zip = Join-Path $DistRoot ($variantData.targetFolder + ".zip")
if (!(Test-Path -LiteralPath $zip -PathType Leaf)) {
    throw "Build did not produce the expected archive: $zip"
}
Write-Host "Package: $zip"
