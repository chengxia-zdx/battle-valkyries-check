param(
    [string] $Root = "",
    [switch] $AllowNone
)

$ErrorActionPreference = "Stop"

$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = Join-Path $RepositoryRoot "src"
}

if (!(Test-Path -LiteralPath $Root -PathType Container)) {
    throw "Brush layout check root not found: $Root"
}

$ResolvedRoot = (Resolve-Path -LiteralPath $Root).Path
$MetadataFiles = @(
    Get-ChildItem -LiteralPath $ResolvedRoot -Recurse -File -Filter "metadata.xml" |
        Where-Object { $_.FullName -match '[\\/]unpacked_brushes[\\/]' }
)

if ($MetadataFiles.Count -eq 0) {
    if ($AllowNone) {
        Write-Host "Brush layout version check skipped; no unpacked brush metadata under $ResolvedRoot"
        return
    }

    throw "No unpacked brush metadata found under: $ResolvedRoot"
}

foreach ($MetadataFile in $MetadataFiles) {
    try {
        [xml] $Metadata = Get-Content -Raw -Encoding UTF8 -LiteralPath $MetadataFile.FullName
    }
    catch {
        throw "Invalid Brush metadata '$($MetadataFile.FullName)': $($_.Exception.Message)"
    }

    $BrushRoot = $Metadata.DocumentElement
    $VersionAttribute = if ($null -ne $BrushRoot) {
        $BrushRoot.Attributes.GetNamedItem("version")
    }
    else {
        $null
    }

    if ($null -eq $BrushRoot -or
        [string] $BrushRoot.PSBase.Name -cne "brush" -or
        $null -eq $VersionAttribute -or
        ![string]::Equals([string] $VersionAttribute.Value, "17", [StringComparison]::Ordinal)) {
        throw "Brush metadata must use exact root <brush ... version=`"17`">. Version 17 is the Battle Brothers engine layout version, not an asset or Pack revision; never increment it when adding sprites: $($MetadataFile.FullName)"
    }
}

Write-Host "Brush layout version check passed ($($MetadataFiles.Count) metadata file(s), exact engine layout version 17)."
