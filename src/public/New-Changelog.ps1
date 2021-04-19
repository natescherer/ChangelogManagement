function New-Changelog {
    <#
    .SYNOPSIS
        Creates a new, blank changelog in Keep a Changelog 1.0.0 format.

    .DESCRIPTION
        This cmdlet creates a new, blank changelog in Keep a Changelog 1.0.0 format.

    .INPUTS
        This cmdlet does not accept pipeline input.

    .OUTPUTS
        This cmdlet does not generate output.

    .EXAMPLE
        New-Changelog
        Does not generate output, but creates a new changelog at .\CHANGELOG.md

    .EXAMPLE
        New-Changelog -Path project\CHANGELOG.md -NoSemVer
        Does not generate output, but creates a new changelog at project\CHANGELOG.md while excluding SemVer statement from the header

    .LINK
        https://github.com/natescherer/ChangelogManagement
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        # The path to output the changelog file; defaults to .\CHANGELOG.md
        [string]$Path = "CHANGELOG.md",

        [parameter(Mandatory = $false)]
        # Exclude the statement about Semantic Versioning from the changelog
        [switch]$NoSemVer,

        [parameter(Mandatory = $false)]
        # Don't include the default initial change "Added: Initial release"
        [switch]$NoInitialChange
    )
    
    $NL = [System.Environment]::NewLine

    $Output = ""

    $Output += "# Changelog$NL"
    $Output += "All notable changes to this project will be documented in this file.$NL$NL"
    $Output += "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)"
    if (!$NoSemVer) {
        $Output += ",$NL"
        $Output += "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)"
    }
    $Output += ".$NL$NL"
    $Output += "## [Unreleased]$NL"
    if (!$NoInitialChange) {
        $Output += "### Added$NL"
        $Output += "- Initial release$NL$NL"
    }

    Set-Content -Value $Output -Path $Path -NoNewline
}