param(
    [string] $Variant = "",
    [switch] $DefinitionsOnly,
    [switch] $ExcludeTestOrigin
)

$ErrorActionPreference = "Stop"

$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$ModsRoot = Join-Path $Root "mods"
$VariantsRoot = Join-Path $Root "variants"
$I18nRoot = Join-Path $Root "i18n"

& (Join-Path $PSScriptRoot "check_brush_layout_versions.ps1") -Root (Join-Path $Root "src")

$TextExtensions = @(".nut", ".xml", ".json", ".md", ".txt", ".cfg", ".cnut", ".js", ".css")
$SourceModulesByPackageGroup = @{
    "battle-valkyries" = @(
        @{
            Root = Join-Path $Root "src\battle-valkyries"
            SourcePrivateFolder = "battle-valkyries"
            SourcePreloadFile = "battle-valkyries.nut"
            SourceScenarioScript = "battle_valkyries_test_company_scenario"
            SourceIconPrefix = "battle-valkyries"
            RenderTestOrigin = $true
            PrivateFolderTarget = { param($VariantData) $VariantData.privateFolder }
            UiTarget = { param($VariantData) "ui\mods\$($VariantData.privateFolder)" }
            ItemIconTarget = { param($VariantData) "gfx\ui\items\$($VariantData.iconPrefix)" }
        }
    )
    "alchemy-enchantment-system" = @(
        @{
            Root = Join-Path $Root "src\alchemy-enchantment-system"
            SourcePrivateFolder = "alchemy-enchantment-system"
            SourcePreloadFile = "alchemy-enchantment-system.nut"
            SourceScenarioScript = ""
            SourceIconPrefix = "alchemy-enchantment-system"
            RenderTestOrigin = $false
            PrivateFolderTarget = { param($VariantData) $VariantData.privateFolder }
            UiTarget = { param($VariantData) "ui\mods\$($VariantData.privateFolder)" }
            ItemIconTarget = { param($VariantData) "gfx\ui\items\$($VariantData.iconPrefix)" }
        }
    )
}
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Read-JsonObject {
    param([string] $Path)
    return Get-Content -Raw -Encoding UTF8 -LiteralPath $Path | ConvertFrom-Json
}

function Escape-ForSquirrelStringContent {
    param([AllowNull()][string] $Value)

    if ($null -eq $Value) {
        return ""
    }

    return $Value.Replace("\", "\\").Replace('"', '\"').Replace("`r", "").Replace("`n", "\n")
}

function Get-PropertyValue {
    param(
        [object] $Object,
        [string] $Key
    )

    foreach ($property in $Object.PSObject.Properties) {
        if ($property.Name -eq $Key) {
            return [string] $property.Value
        }
    }

    throw "Missing key '$Key'"
}

function Test-JsonProperty {
    param(
        [object] $Object,
        [string] $Key
    )

    foreach ($property in $Object.PSObject.Properties) {
        if ($property.Name -eq $Key) {
            return $true
        }
    }

    return $false
}

function Expand-Placeholders {
    param(
        [string] $Content,
        [object] $VariantData,
        [object] $Translations,
        [string] $Path
    )

    $result = [regex]::Replace($Content, '\$bvvar\{([^}]+)\}', {
        param($m)
        Get-PropertyValue $VariantData $m.Groups[1].Value
    })

    $result = [regex]::Replace($result, '\$bv\{([^}]+)\}', {
        param($m)
        Escape-ForSquirrelStringContent (Get-PropertyValue $Translations $m.Groups[1].Value)
    })

    if ($result -match '\$bv(var)?\{') {
        throw "Unresolved placeholder remains in $Path"
    }

    return $result
}

function Remove-TestOriginLoadInclude {
    param(
        [string] $Content,
        [string] $Path
    )

    $pattern = '(?m)^[\t ]*::include\("\$bvvar\{privateFolder\}/hooks/test_origin\.nut"\);[\t ]*(?:\r?\n|$)'
    $matches = [regex]::Matches($Content, $pattern)

    if ($matches.Count -ne 1) {
        throw "Expected exactly one test origin include in $Path, found $($matches.Count)"
    }

    return [regex]::Replace($Content, $pattern, "")
}

function Convert-RelativePath {
    param(
        [string] $RelativePath,
        [object] $VariantData,
        [hashtable] $Module
    )

    $path = $RelativePath
    $sourcePreloadFile = $Module["SourcePreloadFile"]
    $sourceScenarioScript = $Module["SourceScenarioScript"]
    $sourcePrivateFolder = $Module["SourcePrivateFolder"]
    $sourceIconPrefix = $Module["SourceIconPrefix"]

    if ($sourcePreloadFile -ne "" -and $path -eq "scripts\!mods_preload\$sourcePreloadFile") {
        return "scripts\!mods_preload\$($VariantData.preloadFile)"
    }

    if ($sourceScenarioScript -ne "" -and $path -eq "scripts\scenarios\world\$sourceScenarioScript.nut") {
        return "scripts\scenarios\world\$($VariantData.scenarioScript).nut"
    }

    if ($path.StartsWith("$sourcePrivateFolder\")) {
        $targetPrivateFolder = & $Module["PrivateFolderTarget"] $VariantData
        $path = $targetPrivateFolder + $path.Substring($sourcePrivateFolder.Length)
    }

    $iconPrefixPath = "gfx\ui\items\$sourceIconPrefix"
    if ($path.StartsWith("$iconPrefixPath\")) {
        $targetIconPath = & $Module["ItemIconTarget"] $VariantData
        $path = $targetIconPath + $path.Substring($iconPrefixPath.Length)
    }

    if ($sourcePrivateFolder -eq "battle-valkyries") {
        $traitIconPrefixPath = "gfx\ui\traits\$sourceIconPrefix"
        if ($path.StartsWith("$traitIconPrefixPath\")) {
            $path = "gfx\ui\traits\$($VariantData.iconPrefix)" + $path.Substring($traitIconPrefixPath.Length)
        }

        $backgroundIconPrefixPath = "gfx\ui\backgrounds\$sourceIconPrefix"
        if ($path.StartsWith("$backgroundIconPrefixPath\")) {
            $path = "gfx\ui\backgrounds\$($VariantData.iconPrefix)" + $path.Substring($backgroundIconPrefixPath.Length)
        }

        $eventIconPrefixPath = "gfx\ui\events\$sourceIconPrefix"
        if ($path.StartsWith("$eventIconPrefixPath\")) {
            $path = "gfx\ui\events\$($VariantData.iconPrefix)" + $path.Substring($eventIconPrefixPath.Length)
        }

        $skillIconPrefixPath = "gfx\skills\$sourceIconPrefix"
        if ($path.StartsWith("$skillIconPrefixPath\")) {
            $path = "gfx\skills\$($VariantData.iconPrefix)" + $path.Substring($skillIconPrefixPath.Length)
        }
    }

    $uiModPath = "ui\mods\$sourcePrivateFolder"
    if ($path.StartsWith("$uiModPath\")) {
        $targetUiPath = & $Module["UiTarget"] $VariantData
        $path = $targetUiPath + $path.Substring($uiModPath.Length)
    }

    return $path
}

function Assert-TargetPathIsSafe {
    param([string] $TargetPath)

    $modsFull = [System.IO.Path]::GetFullPath($ModsRoot)
    $targetFull = [System.IO.Path]::GetFullPath($TargetPath)

    if (!$targetFull.StartsWith($modsFull + [System.IO.Path]::DirectorySeparatorChar)) {
        throw "Refusing to write outside mods directory: $targetFull"
    }
}

function Resolve-RenderedTargetPath {
    param([string] $TargetFolder)

    if ([string]::IsNullOrWhiteSpace($TargetFolder)) {
        throw "Render target folder must not be empty"
    }

    if ([System.IO.Path]::IsPathRooted($TargetFolder)) {
        throw "Render target folder must not be rooted: $TargetFolder"
    }

    if ($TargetFolder -eq "." -or $TargetFolder -eq "..") {
        throw "Render target folder must be an ordinary directory name: $TargetFolder"
    }

    if ($TargetFolder -ne $TargetFolder.Trim() -or $TargetFolder.EndsWith(".")) {
        throw "Render target folder must not have leading/trailing whitespace or a trailing dot: '$TargetFolder'"
    }

    foreach ($separator in @([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)) {
        if ($TargetFolder.IndexOf($separator) -ge 0) {
            throw "Render target folder must not contain directory separators: $TargetFolder"
        }
    }

    if ($TargetFolder.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
        throw "Render target folder contains invalid filename characters: $TargetFolder"
    }

    $modsFull = [System.IO.Path]::GetFullPath($ModsRoot)
    $targetFull = [System.IO.Path]::GetFullPath((Join-Path $modsFull $TargetFolder))
    $targetParent = [System.IO.Path]::GetDirectoryName($targetFull)

    if (![string]::Equals($targetParent, $modsFull, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Render target must resolve as a direct child of mods: $targetFull"
    }

    Assert-TargetPathIsSafe $targetFull
    return $targetFull
}

function Assert-ExistingPathIsNotReparsePoint {
    param(
        [string] $Path,
        [string] $Label
    )

    if (!(Test-Path -LiteralPath $Path)) {
        return
    }

    $item = Get-Item -LiteralPath $Path -Force

    if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "Refusing rendered target cleanup because $Label is a reparse point: $($item.FullName)"
    }
}

function Remove-RenderedTargetWithRetry {
    param(
        [string] $Path,
        [switch] $Recurse
    )

    $lastError = $null

    for ($attempt = 1; $attempt -le 6; $attempt++) {
        if (!(Test-Path -LiteralPath $Path)) {
            return
        }

        try {
            if ($Recurse) {
                Remove-Item -LiteralPath $Path -Force -Recurse -ErrorAction Stop
            }
            else {
                Remove-Item -LiteralPath $Path -Force -ErrorAction Stop
            }
            return
        }
        catch [System.IO.IOException], [System.UnauthorizedAccessException] {
            $lastError = $_

            if ($attempt -lt 6) {
                Start-Sleep -Milliseconds (100 * $attempt)
            }
        }
    }

    throw $lastError
}

function Clear-RenderedTarget {
    param([string] $TargetFolder)

    $targetFull = Resolve-RenderedTargetPath $TargetFolder
    Assert-ExistingPathIsNotReparsePoint $Root "repository root"
    Assert-ExistingPathIsNotReparsePoint $ModsRoot "mods root"
    Assert-ExistingPathIsNotReparsePoint $targetFull "render target"

    if (Test-Path -LiteralPath $targetFull) {
        $targetItem = Get-Item -LiteralPath $targetFull -Force

        if ($targetItem.PSIsContainer) {
            $directories = [System.Collections.Generic.Stack[string]]::new()
            $directories.Push($targetFull)

            while ($directories.Count -gt 0) {
                $currentDirectory = $directories.Pop()

                foreach ($item in Get-ChildItem -LiteralPath $currentDirectory -Force) {
                    if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
                        throw "Refusing to replace render target containing reparse point: $($item.FullName)"
                    }

                    if ($item.PSIsContainer) {
                        $directories.Push($item.FullName)
                    }
                    elseif ($item.IsReadOnly) {
                        $item.IsReadOnly = $false
                    }
                }
            }
        }
        elseif ($targetItem.IsReadOnly) {
            $targetItem.IsReadOnly = $false
        }

        if (!$targetItem.PSIsContainer) {
            Remove-RenderedTargetWithRetry -Path $targetFull
        }
        else {
            Remove-RenderedTargetWithRetry -Path $targetFull -Recurse
        }

        if (Test-Path -LiteralPath $targetFull) {
            throw "Rendered target still exists after removal: $targetFull"
        }
    }

    New-Item -ItemType Directory -Path $targetFull -ErrorAction Stop | Out-Null
    $resolvedTarget = (Resolve-Path -LiteralPath $targetFull).Path
    Assert-TargetPathIsSafe $resolvedTarget

    if (![string]::Equals($resolvedTarget, $targetFull, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Rendered target resolved to an unexpected path: $resolvedTarget"
    }

    return $resolvedTarget
}

function Remove-RenderedRelativePath {
    param(
        [string] $TargetRoot,
        [string] $RelativePath
    )

    $target = Join-Path $TargetRoot $RelativePath
    Assert-TargetPathIsSafe $target

    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Force -Recurse
    }
}

function Remove-StaleEmbeddedAlchemyOutputs {
    param(
        [string] $TargetRoot,
        [object] $VariantData
    )

    Remove-RenderedRelativePath $TargetRoot "$($VariantData.privateFolder)\alchemy-enchantment-system"
    Remove-RenderedRelativePath $TargetRoot "ui\mods\$($VariantData.privateFolder)\alchemy_enchantment_system.js"
    Remove-RenderedRelativePath $TargetRoot "ui\mods\$($VariantData.privateFolder)\alchemy_enchantment_system.css"

    $alchemyItemIcons = @(
        "alchemy_enchantment_system_icon.png",
        "equipment_enchant_stone_white.png",
        "equipment_enchant_stone_green.png",
        "equipment_enchant_stone_blue.png",
        "equipment_enchant_stone_purple.png",
        "equipment_enchant_stone_red.png",
        "equipment_enchant_stone_prismatic.png",
        "equipment_removal_stone.png"
    )

    foreach ($icon in $alchemyItemIcons) {
        Remove-RenderedRelativePath $TargetRoot "gfx\ui\items\$($VariantData.iconPrefix)\$icon"
    }
}

if ($DefinitionsOnly) {
    return
}

$variantFiles = if ($Variant -ne "") {
    @(Join-Path $VariantsRoot "$Variant.json")
}
else {
    @(Get-ChildItem -LiteralPath $VariantsRoot -Filter "*.json" | ForEach-Object { $_.FullName })
}

foreach ($variantFile in $variantFiles) {
    if (!(Test-Path -LiteralPath $variantFile)) {
        throw "Variant not found: $variantFile"
    }

    $variantData = Read-JsonObject $variantFile
    $translations = Read-JsonObject (Join-Path $I18nRoot "$($variantData.language).json")
    $targetRoot = Resolve-RenderedTargetPath $variantData.targetFolder
    $packageGroup = if (Test-JsonProperty $variantData "packageGroup") { $variantData.packageGroup } else { "battle-valkyries" }

    if (!$SourceModulesByPackageGroup.ContainsKey($packageGroup)) {
        throw "Unknown packageGroup '$packageGroup' in $variantFile"
    }

    $targetRoot = Clear-RenderedTarget $variantData.targetFolder
    if ($packageGroup -eq "battle-valkyries") {
        Remove-StaleEmbeddedAlchemyOutputs $targetRoot $variantData
    }

    foreach ($module in $SourceModulesByPackageGroup[$packageGroup]) {
        $moduleRoot = $module["Root"]
        if (!(Test-Path -LiteralPath $moduleRoot)) {
            throw "Source root not found: $moduleRoot"
        }

        $moduleSupportsTestOrigin = [bool]$module["RenderTestOrigin"]
        $renderTestOrigin = $moduleSupportsTestOrigin -and !$ExcludeTestOrigin
        $excludeModuleTestOrigin = $moduleSupportsTestOrigin -and $ExcludeTestOrigin
        $sourcePrivateFolder = $module["SourcePrivateFolder"]
        $sourceScenarioScript = $module["SourceScenarioScript"]
        $testOriginHookRelative = "$sourcePrivateFolder\hooks\test_origin.nut"

        Get-ChildItem -LiteralPath $moduleRoot -Recurse -File | ForEach-Object {
            $relative = $_.FullName.Substring($moduleRoot.Length).TrimStart('\', '/')
            $targetRelative = Convert-RelativePath $relative $variantData $module
            $target = Join-Path $targetRoot $targetRelative
            $targetDir = Split-Path -Parent $target

            $isTestOriginScenario = $sourceScenarioScript -ne "" -and $relative -eq "scripts\scenarios\world\$sourceScenarioScript.nut"
            $isTestOriginHook = $excludeModuleTestOrigin -and $relative -eq $testOriginHookRelative
            if (!$renderTestOrigin -and ($isTestOriginScenario -or $isTestOriginHook)) {
                Assert-TargetPathIsSafe $target

                if (Test-Path -LiteralPath $target) {
                    Set-ItemProperty -LiteralPath $target -Name IsReadOnly -Value $false
                    Remove-Item -LiteralPath $target -Force
                }

                return
            }

            if (!(Test-Path -LiteralPath $targetDir)) {
                New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
            }

            if ($TextExtensions -contains $_.Extension) {
                $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $_.FullName

                if ($excludeModuleTestOrigin -and $relative -eq "$sourcePrivateFolder\load.nut") {
                    $content = Remove-TestOriginLoadInclude $content $_.FullName
                }

                $rendered = Expand-Placeholders $content $variantData $translations $_.FullName
                [System.IO.File]::WriteAllText($target, $rendered, $Utf8NoBom)
            }
            else {
                Copy-Item -LiteralPath $_.FullName -Destination $target -Force
            }
        }
    }

    $remaining = Get-ChildItem -LiteralPath $targetRoot -Recurse -File |
        Where-Object { $TextExtensions -contains $_.Extension } |
        Select-String -Pattern '\$bv(var)?\{' -List

    if ($remaining) {
        $paths = ($remaining | ForEach-Object { $_.Path }) -join ", "
        throw "Unresolved placeholders in rendered target: $paths"
    }

    if ($ExcludeTestOrigin -and $packageGroup -eq "battle-valkyries") {
        $testOriginScenarioTarget = Join-Path $targetRoot "scripts\scenarios\world\$($variantData.scenarioScript).nut"
        $testOriginHookTarget = Join-Path $targetRoot "$($variantData.privateFolder)\hooks\test_origin.nut"
        $renderedLoadPath = Join-Path $targetRoot "$($variantData.privateFolder)\load.nut"

        if (Test-Path -LiteralPath $testOriginScenarioTarget) {
            throw "Release render unexpectedly contains the test origin scenario: $testOriginScenarioTarget"
        }

        if (Test-Path -LiteralPath $testOriginHookTarget) {
            throw "Release render unexpectedly contains the test origin hook: $testOriginHookTarget"
        }

        if ((Get-Content -Raw -Encoding UTF8 -LiteralPath $renderedLoadPath) -match '/hooks/test_origin\.nut') {
            throw "Release render unexpectedly includes the test origin hook: $renderedLoadPath"
        }
    }

    Write-Host "Rendered $($variantData.targetFolder)"
}
