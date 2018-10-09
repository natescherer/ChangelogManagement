$Eol = [System.Environment]::NewLine

function Update-Changelog {
    <#
    .SYNOPSIS
        Takes all unreleased changes listed in a Keep a Changelog 1.0.0 changelog, adds them to a new version,
        and makes a new, blankUnreleased section.

    .DESCRIPTION
        This cmdlet automates the updating of changelogs in Keep a Changelog 1.0.0 format at release time. It
        takes all changes in the Unreleased section, adds them to a new section with a version number you specify,
        then makes a new, blank Unreleased section.

    .INPUTS
        This cmdlet does not accept pipeline input

    .OUTPUTS
        This cmdlet does not generate output except in the event of an error or notice

    .EXAMPLE
        Update-Changelog -ReleaseVersion 1.1.1
        (Does not generate output, but updates changelog at .\CHANGELOG.md, overwriting it with changes)

    .EXAMPLE
        Update-Changelog -ReleaseVersion 1.1.1 -Path project\CHANGELOG.md -OutputPath TempChangelog.md
        (Does not generate output, but updates changelog at project\CHANGELOG.md, writing changes to .\TempChangelog.md)
    .LINK
        https://github.com/natescherer/ChangelogManagement
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [ValidatePattern("[0-9]\.[0-9]\.[0-9]")]
        # Version number for the new release
        [string]$ReleaseVersion,

        [parameter(Mandatory=$false)]
        [ValidateScript({Test-Path -Path $_})]
        # The path to the source changelog file, if it is different than .\CHANGELOG.md
        [string]$Path = "CHANGELOG.md",

        [parameter(Mandatory=$false)]
        [ValidatePattern(".*\.md")]
        # The path to the output changelog file, if it is different than than the source path
        [string]$OutputPath = $Path,

        [parameter(Mandatory=$false)]
        # Prefix used before version number in source control compare links (i.e. the "v" in v1.0.0). Defaults to
        # "v" for GitHub and "" for other platforms. Only applies if LinkMode is Automatic.
        [string]$ReleasePrefix = "",

        [parameter(Mandatory=$false)]
        # Mode used for adding links at the bottom of the Changelog for new versions. Can either be Automatic
        # (adding based on existing links with GitHub/GitLab stype compares), Manual (adding placeholders which
        # will need manually updated), or None (not adding links). Defaults to Automatic.
        [ValidateSet("Automatic","Manual","None")]
        [string]$LinkMode = "Automatic"
    )

    $Data = Get-ChangelogData -Path $Path

    # Make sure $ReleaseVersion is newer than the last version in the changelog
    if ([System.Version]$ReleaseVersion -le [System.Version]$Data.LastVersion) {
        throw "$ReleaseVersion is not greater than the previous version in the changelog ($Data.LastVersion)."
    }

    # Create $NewRelease by removing empty sections from $Data.Unreleased
    $NewRelease = $Data.Unreleased.RawData -replace "## \[Unreleased\]$Eol",""
    $NewRelease = $NewRelease -replace "### Added$Eol### Changed","### Changed"
    $NewRelease = $NewRelease -replace "### Changed$Eol### Deprecated","### Deprecated"
    $NewRelease = $NewRelease -replace "### Deprecated$Eol### Removed","### Removed"
    $NewRelease = $NewRelease -replace "### Removed$Eol### Fixed","### Fixed"
    $NewRelease = $NewRelease -replace "### Fixed$Eol### Security","### Security"
    $NewRelease = $NewRelease -replace "### Security",""

    # Edit $NewRelease to add version number and today's date
    $Today = (Get-Date -Format 'o').Split('T')[0]
    $NewRelease = "## [$ReleaseVersion] - $Today$Eol" + $NewRelease

    # Inject compare/tree URL(s) into footer
    if ($Data.Released -ne "") {
        $UrlBase = ($Data.Footer.TrimStart("[Unreleased]: ") -split "/compare")[0]
        if (($UrlBase -like "*github.com*") -and ($ReleasePrefix -eq "")) {
            $ReleasePrefix = "v"
        }
        $NewFooter = ($Data.Footer -replace "\[Unreleased\].*",("[Unreleased]: " +
            "$UrlBase/compare/$ReleasePrefix$ReleaseVersion..HEAD$Eol" +
            "[$ReleaseVersion]: $UrlBase/compare/$ReleasePrefix$($Data.LastVersion)..$ReleasePrefix$ReleaseVersion"))
        $NewFooter = $NewFooter
    } else {
        $NewFooter = "$Eol[Unreleased]: " +
            "https://REPLACE-DOMAIN.com/REPLACE-USERNAME/REPLACE-REPONAME/compare/$ReleasePrefix$ReleaseVersion..HEAD"
        $NewFooter += "$Eol[$ReleaseVersion]: " +
            "https://REPLACE-DOMAIN.com/REPLACE-USERNAME/REPLACE-REPONAME/tree/$ReleasePrefix$ReleaseVersion"

        Write-Output ("Because this is the first release, you will need to manually update the URLs " +
            "at the bottom of the file. Future releases will reuse this information, and won't require this " +
            "manual step.")
    }
    if (($UrlBase -notlike "*github.com*") -and ($UrlBase -notlike "*gitlab.com*")) {
        Write-Output ("Repository URLs do not appear to be GitHub or GitLab. Please verify links work " +
            "properly. Interested in having your SCM work with this functionality? Open an issue " +
            "at https://github.com/natescherer/ChangelogManagement/issues.")
    }

    # Build & write updated CHANGELOG.md
    $Output += $Data.Header
    $Output += ("## [Unreleased]$Eol" +
        "### Added$Eol" +
        "### Changed$Eol" +
        "### Deprecated$Eol" +
        "### Removed$Eol" +
        "### Fixed$Eol" +
        "### Security$Eol$Eol")
    $Output += $NewRelease
    if ($Data.Released) {
        $Output += "$Eol"
        foreach ($Release in $Data.Released) {
            $Output += $Release.RawData
            $Output += "$Eol$Eol"
        }
    }
    $Output += $NewFooter

    Set-Content -Value $Output -Path $OutputPath -NoNewline
}

function Get-ChangelogData {
    <#
    .SYNOPSIS
        Takes a changelog in Keep a Changelog 1.0.0 format and parses the data into a PowerShell object.

    .DESCRIPTION
        This cmdlet parses the data in a changelog file using Keep a Changelog 1.0.0 format into a PowerShell object.

    .INPUTS
        This cmdlet does not accept pipeline input

    .OUTPUTS
        This cmdlet outputs a PSCustomObject containing the changelog data.

    .EXAMPLE
        Get-ChangelogData -Path .\CHANGELOG.md
        (Does not generate output, but updates changelog at .\CHANGELOG.md, overwriting it with changes)

    .LINK
        https://github.com/natescherer/ChangelogManagement
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false)]
        [ValidateScript({Test-Path -Path $_})]
        # Path to the changelog. Defaults to ".\CHANGELOG.md".
        [string]$Path = "CHANGELOG.md"
    )

    $Data = Get-Content -Path $Path | Out-String
    $Output = [PSCustomObject]@{
        "Header" = ""
        "Unreleased" = [PSCustomObject]@{}
        "Released" = @()
        "Footer" = ""
        "LastVersion" = ""
    }

    # Split changelog into $Sections and split header and footer into their own variables
    [System.Collections.ArrayList]$Sections = $Data -split "## \["
    $Output.Header = $Sections[0]
    $Sections.Remove($Output.Header)
    if ($Sections[-1] -like "*[Unreleased]:*") {
        $Output.Footer = "[Unreleased]:" + ($Sections[-1] -split "\[Unreleased\]:")[1].TrimEnd("$Eol")
        $Sections[-1] = $( $Sections[-1] -split "\[Unreleased\]:" )[0]
    }

    # Restore the leading "## [" onto each section that was previously removed by split function, and trim extra
    # line breaks
    $i = 1
    while ($i -le $Sections.Count) {
        $Sections[$i - 1] = "## [" + $Sections[$i - 1].TrimEnd("$Eol")
        $i++
    }

    # Split the Unreleased section into $UnreleasedTemp remove it from $Sections, and trim header line
    $UnreleasedTemp = $Sections[0]
    $Sections.Remove($UnreleasedTemp)
    #$UnreleasedTemp = $UnreleasedTemp -replace "## \[Unreleased\]$Eol",""

    # Construct the $Output.Unreleased object
    $Output.Unreleased = [PSCustomObject]@{
        "RawData" = $UnreleasedTemp
        "Link" = (($Output.Footer -split "Unreleased\]: ")[1] -split "$Eol")[0]
        "Data" = [PSCustomObject]@{
            Added = (($UnreleasedTemp -split "### Added$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
            Changed = (($UnreleasedTemp -split "### Changed$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
            Deprecated = (($UnreleasedTemp -split "### Deprecated$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
            Removed = (($UnreleasedTemp -split "### Removed$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
            Fixed = (($UnreleasedTemp -split "### Fixed$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
            Security = (($UnreleasedTemp -split "### Security$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
        }
    }

    # Construct the $Output.Released array
    foreach ($Release in $Sections) {
        $LoopVersionNumber = $Release.Split("[")[1].Split("]")[0]
        $Output.Released += [PSCustomObject]@{
            "RawData" = $Release
            "Date" = Get-Date ($Release -split "\] \- ")[1].Split("$Eol")[0]
            "Version" = $LoopVersionNumber
            "Link" = (($Output.Footer -split "$LoopVersionNumber\]: ")[1] -split "$Eol")[0]
            "Data" = [PSCustomObject]@{
                Added = (($Release -split "### Added$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
                Changed = (($Release -split "### Changed$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
                Deprecated = (($Release -split "### Deprecated$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
                Removed = (($Release -split "### Removed$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
                Fixed = (($Release -split "### Fixed$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
                Security = (($Release -split "### Security$Eol")[1] -split "###")[0].TrimEnd("$Eol") -split "$Eol" | ForEach-Object { $_.TrimStart("- ") }
            }
        }
    }

    # Set $Output.LastVersion to the version number of the latest release listed in the changelog, or null if there
    # have not been any releases yet
    if ($Output.Released[0].Version) {
        $Output.LastVersion = $Output.Released[0].Version
    } else {
        $Output.LastVersion = $null
    }

    $Output
}

function Convertfrom-Changelog {
    <#
    .SYNOPSIS
        Takes a changelog in Keep a Changelog 1.0.0 format and converts it to another format.

    .DESCRIPTION
        This cmdlet converts a changelog file using Keep a Changelog 1.0.0 format into one of several other formats.
        Valid formats are Release (same as input, but with the Unreleased section removed), Text
        (markdown and links removed), and TextRelease (Unreleased section, markdown, and links removed).

    .INPUTS
        This cmdlet does not accept pipeline input

    .OUTPUTS
        This cmdlet does not generate output

    .EXAMPLE
        Convertfrom-Changelog -Path .\CHANGELOG.md -Format Release -OutputPath docs\CHANGELOG.md
        (Does not generate output, but creates a file at docs\CHANGELOG.md that is the same as the input with the Unreleased section removed)

    .EXAMPLE
        Convertfrom-Changelog -Path .\CHANGELOG.md -Format Text -OutputPath CHANGELOG.txt
        (Does not generate output, but creates a file at CHANGELOG.txt that has header, markdown, and links removed)

    .LINK
        https://github.com/natescherer/ChangelogManagement
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false)]
        [ValidateScript({Test-Path -Path $_})]
        # Path to the changelog. Defaults to ".\CHANGELOG.md".
        [string]$Path = "CHANGELOG.md",

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        # The path to the output changelog file, if it is different than than the source path
        [string]$OutputPath = $Path,

        [parameter(Mandatory=$true)]
        # Format to convert changelog into. Valid values are Release (same as input, but with the Unreleased
        # section removed), Text (markdown and links removed), and TextRelease (Unreleased section, markdown, and
        # links removed).
        [ValidateSet("Release","Text","TextRelease")]
        [string]$Format
    )

    $Data = Get-ChangelogData -Path $Path
    $Output = ""

    if ($Format -like "Text*") {
        $Output += ($Data.Header -replace "\[","") -replace "\]"," "
    } else {
        $Output += $Data.Header
    }
    if ($Format -notlike "*Release") {
        $Output += $Data.Unreleased.RawData
        $Output += "$Eol$Eol"
    }
    foreach ($Release in $Data.Released) {
        $Output += $Release.RawData
        $Output += "$Eol$Eol"
    }
    if ($Format -eq "Release") {
        $Output += $Data.Footer -replace "\[Unreleased\].*$Eol",""
    }

    if ($Format -like "Text*") {
        $Output = $Output -replace "### ",""
        $Output = $Output -replace "## ",""
        $Output = $Output -replace "# ",""
    }

    Set-Content -Value $Output -Path $OutputPath -NoNewline
}

Export-ModuleMember -Function Update-Changelog
Export-ModuleMember -Function Get-ChangelogData
Export-ModuleMember -Function Convertfrom-Changelog