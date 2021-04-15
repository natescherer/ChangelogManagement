function Add-ChangelogData {
    <#
    .SYNOPSIS
        Adds an item to a changelog file in Keep a Changelog 1.0.0 format.

    .DESCRIPTION
        This cmdlet adds new Added/Changed/Deprecated/Removed/Fixed/Security items to the Unreleased section of a
        changelog in Keep a Changelog 1.0.0 format.

    .INPUTS
        This cmdlet does not accept pipeline input.

    .OUTPUTS
        This cmdlet does not generate output.

    .EXAMPLE
        Add-ChangelogData -Type "Added" -Data "Spanish language translation"
        Does not generate output, but adds a new Added change into changelog at  .\CHANGELOG.md.

    .EXAMPLE
        Add-ChangelogData -Type "Removed" -Data "TLS 1.0 support" -Path project\CHANGELOG.md
        Does not generate output, but adds a new Security change into changelog at project\CHANGELOG.md.

    .LINK
        https://github.com/natescherer/ChangelogManagement
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        [ValidateScript( { Test-Path -Path $_ })]
        # The path to the source changelog file; defaults to .\CHANGELOG.md
        [string]$Path = "CHANGELOG.md",

        [parameter(Mandatory = $false)]
        [ValidatePattern(".*\.md")]
        # The path to the output changelog file; defaults to the same path as the source file
        [string]$OutputPath = $Path,

        [parameter(Mandatory = $true)]
        [ValidateSet("Added", "Changed", "Deprecated", "Removed", "Fixed", "Security")]
        # Type of change to add to the changelog (Added, Changed, Deprecated, Removed, Fixed, or Security)
        [string]$Type,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # The value of the change you are adding to the changelog
        [string]$Data
    )

    $NL = [System.Environment]::NewLine
    if ((Get-Content -Path $Path -Raw) -like "*`r`n*") {
        $FileNewline = "`r`n"
    }
    else {
        $FileNewline = "`n"
    }

    $ChangeTypes = @("Added", "Changed", "Deprecated", "Removed", "Fixed", "Security")
    $ChangelogData = Get-ChangelogData -Path $Path

    $Output = ""
    $Output += $ChangelogData.Header
    $Output += "## [Unreleased]$FileNewline"
    foreach ($ChangeType in $ChangeTypes) {
        $ChangeMade = $false
        if ($Type -eq $ChangeType) {
            $Output += "### $ChangeType$FileNewline"
            $Output += "- $Data$FileNewline"
            $ChangeMade = $true
        }
        if ($ChangelogData.Unreleased.Data.$ChangeType) {
            if ($Output -notlike "*### $ChangeType*") {
                $Output += "### $ChangeType$FileNewline"
            }
            foreach ($Datum in $ChangelogData.Unreleased.Data.$ChangeType) {
                $Output += "- $Datum$FileNewline"
                $ChangeMade = $true
            }
        }
        if ($ChangeMade) {
            $Output += $FileNewline
        }
    }
    foreach ($Release in $ChangelogData.Released) {
        $Output += $Release.RawData
    }
    $Output += $ChangelogData.Footer

    Set-Content -Value $Output -Path $OutputPath -NoNewline
}