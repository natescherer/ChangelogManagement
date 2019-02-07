$NL = [System.Environment]::NewLine

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
        Get-ChangelogData
        Returns an object containing Header, Unreleased, Released, Footer, and LastVersion properties.

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

    $ChangeTypes = @("Added", "Changed", "Deprecated", "Removed", "Fixed", "Security")
    $ChangelogData = Get-Content -Path $Path -Raw

    $Output = [PSCustomObject]@{
        "Header" = ""
        "Unreleased" = [PSCustomObject]@{}
        "Released" = @()
        "Footer" = ""
        "LastVersion" = ""
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

    # Split the Unreleased section into $UnreleasedTemp, then remove it from $Sections
    $UnreleasedTemp = $Sections[0]
    $Sections.Remove($UnreleasedTemp)

    # Construct the $Output.Unreleased object
    foreach ($ChangeType in $ChangeTypes) {
        if ($UnreleasedTemp -notlike "*### $ChangeType*") {
            Set-Variable -Name "Unreleased$ChangeType" -Value $null
        }
        else {
            $Value = (($UnreleasedTemp -split "### $ChangeType$NL")[1] -split "###")[0].TrimEnd($NL) -split $NL | ForEach-Object { $_.TrimStart("- ") }
            Set-Variable -Name "Unreleased$ChangeType" -Value $Value
        }       
    }
    $Output.Unreleased = [PSCustomObject]@{
        "RawData" = $UnreleasedTemp
        "Link" = (($Output.Footer -split "Unreleased\]: ")[1] -split $NL)[0]
        "Data" = [PSCustomObject]@{
            Added = $UnreleasedAdded
            Changed = $UnreleasedChanged
            Deprecated = $UnreleasedDeprecated
            Removed = $UnreleasedRemoved
            Fixed = $UnreleasedFixed
            Security = $UnreleasedSecurity
        }
    }

    # Construct the $Output.Released array
    foreach ($Release in $Sections) {
        foreach ($ChangeType in $ChangeTypes) {
            if ($Release -notlike "*### $ChangeType*") {
                Set-Variable -Name "Release$ChangeType" -Value $null
            }
            else {
                $Value = (($Release -split "### $ChangeType$NL")[1] -split "###")[0].TrimEnd($NL) -split $NL | ForEach-Object { $_.TrimStart("- ") }
                Set-Variable -Name "Release$ChangeType" -Value $Value
            }       
        }

        $LoopVersionNumber = $Release.Split("[")[1].Split("]")[0]
        $Output.Released += [PSCustomObject]@{
            "RawData" = $Release
            "Date" = Get-Date ($Release -split "\] \- ")[1].Split($NL)[0]
            "Version" = $LoopVersionNumber
            "Link" = (($Output.Footer -split "$LoopVersionNumber\]: ")[1] -split $NL)[0]
            "Data" = [PSCustomObject]@{
                Added = $ReleaseAdded
                Changed = $ReleaseChanged
                Deprecated = $ReleaseDeprecated
                Removed = $ReleaseRemoved
                Fixed = $ReleaseFixed
                Security = $ReleaseSecurity
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

function Add-ChangelogData {
    <#
    .SYNOPSIS
        Adds an item to a changelog file in Keep a Changelog 1.0.0 format.

    .DESCRIPTION
        This cmdlet adds new Added/Changed/Deprecated/Removed/Fixed/Security items to the Unreleased section of a
        changelog in Keep a Changelog 1.0.0 format.

    .INPUTS
        This cmdlet does not accept pipeline input

    .OUTPUTS
        This cmdlet does not generate output

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
        [parameter(Mandatory=$false)]
        [ValidateScript({Test-Path -Path $_})]
        # The path to the source changelog file, if it is different than .\CHANGELOG.md
        [string]$Path = "CHANGELOG.md",

        [parameter(Mandatory=$false)]
        [ValidatePattern(".*\.md")]
        # The path to the output changelog file, if it is different than than the source path
        [string]$OutputPath = $Path,

        [parameter(Mandatory=$true)]
        [ValidateSet("Added","Changed","Deprecated","Removed","Fixed","Security")]
        # Exclude the statement about Semantic Versioning from the changelog, if your project uses another
        # versioning scheme
        [string]$Type,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # The value of the change you are adding to the changelog
        [string]$Data
    )

    $ChangelogData = Get-ChangelogData -Path $Path

    $Output = ""
    $Output += $ChangelogData.Header
    $Output += $ChangelogData.Unreleased.RawData -replace "### $Type","### $Type$NL- $Data"
    foreach ($Release in $ChangelogData.Released) {
        $Output += $Release.RawData
    }
    $Output += $ChangelogData.Footer

    Set-Content -Value $Output -Path $OutputPath -NoNewline
}

function New-Changelog {
    <#
    .SYNOPSIS
        Creates a new, blank changelog in Keep a Changelog 1.0.0 format.

    .DESCRIPTION
        This cmdlet creates a new, blank changelog in Keep a Changelog 1.0.0 format.

    .INPUTS
        This cmdlet does not accept pipeline input

    .OUTPUTS
        This cmdlet does not generate output

    .EXAMPLE
        New-Changelog
        Does not generate output, but creates a new changelog at .\CHANGELOG.md

    .EXAMPLE
        New-Changelog -Path project\CHANGELOG.md -NoSemVer
        Does not generate output, but creates a new changelog at project\CHANGELOG.md, and excludes SemVer statement from the header.

    .LINK
        https://github.com/natescherer/ChangelogManagement
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        # The path to the output changelog file, if it is different than .\CHANGELOG.md
        [string]$Path = "CHANGELOG.md",

        [parameter(Mandatory=$false)]
        # Exclude the statement about Semantic Versioning from the changelog, if your project uses another
        # versioning scheme
        [switch]$NoSemVer
    )

    $Output = ""

    $Output += "# Changelog$NL"
    $Output += "All notable changes to this project will be documented in this file.$NL$NL"
    $Output += "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)"
    if ($NoSemVer -eq $false) {
        $Output += ",$NL"
        $Output += "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)"
    }
    $Output += ".$NL$NL"
    $Output += "## [Unreleased]$NL"

    Set-Content -Value $Output -Path $Path -NoNewline
}

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
        Update-Changelog -ReleaseVersion 1.1.1 -LinkMode Automatic -LinkPattern @{FirstRelease="https://github.com/testuser/testrepo/tree/v{CUR}";NormalRelease="https://github.com/testuser/testrepo/compare/v{PREV}..v{CUR}";Unreleased="https://github.com/testuser/testrepo/compare/v{CUR}..HEAD"}
        Does not generate output, but:
        1. Takes all Unreleased changes in .\CHANGELOG.md and adds them to a new release tagged with ReleaseVersion and today's date.
        2. Updates links according to LinkPattern.
        3. Creates a new, blank Unreleased section

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

        [parameter(Mandatory=$true)]
        # Mode used for adding links at the bottom of the Changelog for new versions. Can either be Automatic
        # (adding based pattern provided via -LinkPattern), Manual (adding placeholders which
        # will need manually updated), or None (not adding links).
        [ValidateSet("Automatic","Manual","None")]
        [string]$LinkMode,

        [parameter(Mandatory=$false)]
        # Pattern used for adding links at the bottom of the Changelog when -LinkMode is set to Automatic. This
        # is a hashtable that defines the format for the three possible types of links needed: FirstRelease, NormalRelease, 
        # and Unreleased. The current version in the patterns should be replaced with {CUR} and the previous 
        # versions with {PREV}.
        [ValidateNotNullOrEmpty()]
        [hashtable]$LinkPattern
    )

    if (($LinkMode -eq "Automatic") -and !($LinkPattern)) {
        throw "-LinkPattern must be used when -LinkMode is set to Automatic"
    }

    $ChangelogData = Get-ChangelogData -Path $Path

    # Create $NewRelease by removing empty sections from $ChangelogData.Unreleased
    $NewRelease = $ChangelogData.Unreleased.RawData -replace "## \[Unreleased\]$NL",""
    $NewRelease = $NewRelease -replace "### Added$NL$NL",""
    $NewRelease = $NewRelease -replace "### Changed$NL$NL",""
    $NewRelease = $NewRelease -replace "### Deprecated$NL$NL",""
    $NewRelease = $NewRelease -replace "### Removed$NL$NL",""
    $NewRelease = $NewRelease -replace "### Fixed$NL$NL",""
    $NewRelease = $NewRelease -replace "### Security$NL$NL",""

    If ([string]::IsNullOrWhiteSpace($NewRelease)) {
        Throw "No changes detected in current release, exiting."
    }

    # Edit $NewRelease to add version number and today's date
    $Today = (Get-Date -Format 'o').Split('T')[0]
    $NewRelease = "## [$ReleaseVersion] - $Today$NL" + $NewRelease

    # Inject links into footer
    if ($LinkMode -eq "Automatic") {
        if ($ChangelogData.Released -ne "") {
            $NewFooter = ("[Unreleased]: " + ($LinkPattern['Unreleased'] -replace "{CUR}", $ReleaseVersion) + "$NL" +
                "[$ReleaseVersion]: " + (($LinkPattern['NormalRelease'] -replace "{CUR}", $ReleaseVersion) -replace "{PREV}", $ChangelogData.LastVersion) + "$NL" +
                ($ChangelogData.Footer.Trim() -replace "\[Unreleased\].*","").TrimStart($NL))
        } else {
            $NewFooter = ("[Unreleased]: " + ($LinkPattern['Unreleased'] -replace "{CUR}", $ReleaseVersion) + "$NL" +
                "[$ReleaseVersion]: " + ($LinkPattern['FirstRelease'] -replace "{CUR}", $ReleaseVersion))
        }
    }
    if ($LinkMode -eq "Manual") {
        if ($ChangelogData.Released -ne "") {
            $NewFooter = ("[Unreleased]: ENTER-URL-HERE$NL" +
                "[$ReleaseVersion]: ENTER-URL-HERE$NL" +
                ($ChangelogData.Footer.Trim() -replace "\[Unreleased\].*","").TrimStart($NL))

        } else {
            $NewFooter = ("[Unreleased]: ENTER-URL-HERE$NL" +
                "[$ReleaseVersion]: ENTER-URL-HERE")
        }
        Write-Output ("Because you selected LinkMode Manual, you will need to manually update the links at the " +
            "bottom of the output file.")
    }
    if ($LinkMode -eq "None") {
        $NewFooter = $ChangelogData.Footer.Trim()
    }

    # Build & write updated CHANGELOG.md
    $Output += $ChangelogData.Header
    $Output += ("## [Unreleased]$NL" +
        "### Added$NL$NL" +
        "### Changed$NL$NL" +
        "### Deprecated$NL$NL" +
        "### Removed$NL$NL" +
        "### Fixed$NL$NL" +
        "### Security$NL$NL")
    $Output += $NewRelease
    if ($ChangelogData.Released) {
        #$Output += $NL
        foreach ($Release in $ChangelogData.Released) {
            $Output += $Release.RawData
        }
    }
    $Output += $NewFooter

    Set-Content -Value $Output -Path $OutputPath -NoNewline
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
        Does not generate output, but creates a file at docs\CHANGELOG.md that is the same as the input with the Unreleased section removed.

    .EXAMPLE
        Convertfrom-Changelog -Path .\CHANGELOG.md -Format Text -OutputPath CHANGELOG.txt
        .Does not generate output, but creates a file at CHANGELOG.txt that has header, markdown, and links removed.

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
        [string]$Format,

        [parameter(Mandatory=$false)]
        # Exclude header from output
        [switch]$NoHeader
    )

    $ChangelogData = Get-ChangelogData -Path $Path
    $Output = ""
    if ($NoHeader -eq $false) {
        if ($Format -like "Text*") {
            $Output += (($ChangelogData.Header -replace "\[","") -replace "\]"," ").Trim()
        } else {
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
        $Output += $ChangelogData.Footer -replace "\[Unreleased\].*$NL",""
    }

    if ($Format -like "Text*") {
        $Output = $Output -replace "### ",""
        $Output = $Output -replace "## ",""
        $Output = $Output -replace "# ",""
    }

    Set-Content -Value $Output -Path $OutputPath -NoNewline
}

Export-ModuleMember -Function Get-ChangelogData, Add-ChangelogData, New-Changelog, Update-Changelog, Convertfrom-Changelog