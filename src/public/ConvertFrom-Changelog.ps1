function ConvertFrom-Changelog {
    <#
    .SYNOPSIS
        Takes a changelog in Keep a Changelog 1.0.0 format and converts it to another format.

    .DESCRIPTION
        This cmdlet converts a changelog file using Keep a Changelog 1.0.0 format into one of several other formats.
        Valid formats are Release (same as input, but with the Unreleased section removed), Text
        (markdown and links removed), and TextRelease (Unreleased section, markdown, and links removed).

    .INPUTS
        This cmdlet does not accept pipeline input.

    .OUTPUTS
        This cmdlet does not generate output.

    .EXAMPLE
        ConvertFrom-Changelog -Path .\CHANGELOG.md -Format Release -OutputPath docs\CHANGELOG.md
        Does not generate output, but creates a file at docs\CHANGELOG.md that is the same as the input with the Unreleased section removed.

    .EXAMPLE
        ConvertFrom-Changelog -Path .\CHANGELOG.md -Format Text -OutputPath CHANGELOG.txt
        .Does not generate output, but creates a file at CHANGELOG.txt that has header, markdown, and links removed.

    .LINK
        https://github.com/natescherer/ChangelogManagement
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        [ValidateScript( { Test-Path -Path $_ })]
        # Path to the changelog; defaults to ".\CHANGELOG.md"
        [string]$Path = "CHANGELOG.md",

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        # The path to the output changelog file; defaults to source path
        [string]$OutputPath = $Path,

        [parameter(Mandatory = $true)]
        # Format to convert changelog into. Valid values are Release (same as input, but with the Unreleased
        # section removed), Text (markdown and links removed), and TextRelease (Unreleased section, markdown, and
        # links removed).
        [ValidateSet("Release", "Text", "TextRelease")]
        [string]$Format,

        [parameter(Mandatory = $false)]
        # Exclude header from output
        [switch]$NoHeader
    )

    $NL = [System.Environment]::NewLine

    $ChangelogData = Get-ChangelogData -Path $Path
    $Output = ""
    if ($NoHeader -eq $false) {
        if ($Format -like "Text*") {
            $Output += (($ChangelogData.Header -replace "\[", "") -replace "\]", " ").Trim()
        }
        else {
            $Output += $ChangelogData.Header.Trim()
        }
    }
    if ($Format -notlike "*Release") {
        if ($Output -ne "") {
            $Output += "$NL$NL"
        }
        $Output += $ChangelogData.Unreleased.RawData.Trim()
    }
    foreach ($Release in $ChangelogData.Released) {
        if ($Output -ne "") {
            $Output += "$NL$NL"
        }
        $Output += $Release.RawData.Trim()
    }
    if ($Format -eq "Release") {
        $Output += "$NL$NL"
        $Output += $ChangelogData.Footer -replace "\[Unreleased\].*$NL", ""
    }

    if ($Format -like "Text*") {
        $Output = $Output -replace "### ", ""
        $Output = $Output -replace "## ", ""
        $Output = $Output -replace "# ", ""
    }

    Set-Content -Value $Output -Path $OutputPath -NoNewline
}