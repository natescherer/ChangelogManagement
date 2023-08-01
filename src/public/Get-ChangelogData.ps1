function Get-ChangelogData {
    <#
    .SYNOPSIS
        Takes a changelog in Keep a Changelog 1.0.0 format and parses the data into a PowerShell object.

    .DESCRIPTION
        Takes a changelog in Keep a Changelog 1.0.0 format and parses the data into a PowerShell object.

    .INPUTS
        This cmdlet does not accept pipeline input.

    .OUTPUTS
        This cmdlet outputs a PSCustomObject containing the changelog data.

    .EXAMPLE
        Get-ChangelogData
        Returns an object containing Header, Unreleased, Released, Footer, and LastVersion properties.

    .LINK
        https://github.com/natescherer/ChangelogManagement
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        [ValidateScript( { Test-Path -Path $_ })]
        # Path to the changelog; defaults to ".\CHANGELOG.md"
        [string]$Path = "CHANGELOG.md"
    )

    $NL = [System.Environment]::NewLine
    if ((Get-Content -Path $Path -Raw) -like "*`r`n*") {
        $FileNewline = "`r`n"
    }
    else {
        $FileNewline = "`n"
    }

    $ChangeTypes = @("Added", "Changed", "Deprecated", "Removed", "Fixed", "Security")
    $ChangelogData = Get-Content -Path $Path -Raw

    $Output = [PSCustomObject]@{
        "Header"       = ""
        "Unreleased"   = [PSCustomObject]@{ }
        "Released"     = @()
        "Footer"       = ""
        "LastVersion"  = ""
        "ReleaseNotes" = ""
    }

    # Split changelog into $Sections and split header and footer into their own variables
    [System.Collections.ArrayList]$Sections = $ChangelogData -split "## \["
    $Output.Header = $Sections[0]
    $Sections.Remove($Output.Header)
    if ($Sections[-1] -match ".*\[Unreleased\]:.*") {
        $Output.Footer = "[Unreleased]:" + ($Sections[-1] -split "\[Unreleased\]:")[1]
        $Sections[-1] = ($Sections[-1] -split "\[Unreleased\]:")[0]
    }

    # Restore the leading "## [" onto each section that was previously removed by split function, and trim extra
    # line breaks
    $i = 1
    while ($i -le $Sections.Count) {
        $Sections[$i - 1] = "## [" + $Sections[$i - 1]
        $i++
    }

    # If found, split the Unreleased section into $UnreleasedTemp, then remove it from $Sections
    if ($Sections[0] -match "## \[Unreleased\].*") {
        $UnreleasedTemp = $Sections[0]
        $Sections.Remove($UnreleasedTemp)
    }
    else {
        $UnreleasedTemp = $null
    }

    if ($UnreleasedTemp) {
        # Construct the $Output.Unreleased object
        foreach ($ChangeType in $ChangeTypes) {
            if ($UnreleasedTemp -notlike "*### $ChangeType*") {
                Set-Variable -Name "Unreleased$ChangeType" -Value $null
            }
            else {
                $Value = (($UnreleasedTemp -split "### $ChangeType$FileNewline")[1] -split "###")[0].TrimEnd($FileNewline) -split $FileNewline | ForEach-Object { $_.TrimStart("- ") }
                Set-Variable -Name "Unreleased$ChangeType" -Value $Value
            }
        }

        $Output.Unreleased = [PSCustomObject]@{
            "RawData"     = $UnreleasedTemp
            "Link"        = (($Output.Footer -split "Unreleased\]: ")[1] -split $FileNewline)[0]
            "Data"        = [PSCustomObject]@{
                Added      = $UnreleasedAdded
                Changed    = $UnreleasedChanged
                Deprecated = $UnreleasedDeprecated
                Removed    = $UnreleasedRemoved
                Fixed      = $UnreleasedFixed
                Security   = $UnreleasedSecurity
            }
            "ChangeCount" = $UnreleasedAdded.Count + $UnreleasedChanged.Count + $UnreleasedDeprecated.Count + $UnreleasedRemoved.Count + $UnreleasedFixed.Count + $UnreleasedSecurity.Count
        }
    }
    else {
        $Output.Unreleased = $null
    }

    # Construct the $Output.Released array
    foreach ($Release in $Sections) {
        foreach ($ChangeType in $ChangeTypes) {
            if ($Release -notlike "*### $ChangeType*") {
                Set-Variable -Name "Release$ChangeType" -Value $null
            }
            else {
                $Value = (($Release -split "### $ChangeType$FileNewline")[1] -split "###")[0].TrimEnd($FileNewline) -split $FileNewline | ForEach-Object { $_.TrimStart("- ") }
                Set-Variable -Name "Release$ChangeType" -Value $Value
            }
        }

        $LoopVersionNumber = $Release.Split("[")[1].Split("]")[0]
        $Output.Released += [PSCustomObject]@{
            "RawData"     = $Release
            "Date"        = Get-Date ($Release -split "\] \- ")[1].Split($FileNewline)[0]
            "Version"     = $LoopVersionNumber
            "Link"        = (($Output.Footer -split "$LoopVersionNumber\]: ")[1] -split $FileNewline)[0]
            "Data"        = [PSCustomObject]@{
                Added      = $ReleaseAdded
                Changed    = $ReleaseChanged
                Deprecated = $ReleaseDeprecated
                Removed    = $ReleaseRemoved
                Fixed      = $ReleaseFixed
                Security   = $ReleaseSecurity
            }
            "ChangeCount" = $ReleaseAdded.Count + $ReleaseChanged.Count + $ReleaseDeprecated.Count + $ReleaseRemoved.Count + $ReleaseFixed.Count + $ReleaseSecurity.Count
        }
    }

    # Set $Output.LastVersion to the version number of the latest release listed in the changelog, or null if there
    # have not been any releases yet
    if ($Output.Released[0].Version) {
        $Output.LastVersion = $Output.Released[0].Version
    }
    else {
        $Output.LastVersion = $null
    }

    if ($Output.Released[0]) {
        $Output.ReleaseNotes = ($Output.Released[0].RawData -replace "^## .*", "").Trim()
    }
    else {
        $Output.ReleaseNotes = $null
    }

    $Output
}
