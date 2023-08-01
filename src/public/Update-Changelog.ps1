function Update-Changelog {
    <#
    .SYNOPSIS
        Takes all unreleased changes listed in changelog, adds them to a new version,
        and makes a new, blank Unreleased section.

    .DESCRIPTION
        This cmdlet automates the updating of changelogs in Keep a Changelog 1.0.0 format at release time. It
        takes all changes in the Unreleased section, adds them to a new section with a version number you specify,
        then makes a new, blank Unreleased section.

    .INPUTS
        This cmdlet does not accept pipeline input.

    .OUTPUTS
        This cmdlet does not generate output except in the event of an error or notice.

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
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # Version number for the new release
        [string]$ReleaseVersion,

        [parameter(Mandatory = $false)]
        [ValidateScript( { Test-Path -Path $_ })]
        # The path to the source changelog file; defaults to .\CHANGELOG.md
        [string]$Path = "CHANGELOG.md",

        [parameter(Mandatory = $false)]
        [ValidatePattern(".*\.md")]
        # The path to the output changelog file; defaults to the source file
        [string]$OutputPath = $Path,

        [parameter(Mandatory = $true)]
        # Mode used for adding links at the bottom of the Changelog for new versions. Can either be Automatic
        # (adding based on pattern provided via -LinkPattern), Manual (adding placeholders which
        # will need manually updated), None (not adding links), GitHub (adding based on GitHub Actions context),
        # or AzureDevOps (adding based on Azure Pipelines environment variables).
        #
        # GITHUB ACTIONS NOTE: You must be running in a Github Actions workflow to use GitHub option. 
        #
        # AZURE DEVOPS NOTE: You must be running in an Azure Pipelines workflow to use AzureDevOps option.  
        # Additionally, your default branch must be 'main', if it is not, you should use the Automatic option with
        # a custom pattern for your default branch.
        [ValidateSet("Automatic", "Manual", "None", "GitHub", "AzureDevOps")]
        [string]$LinkMode,

        [parameter(Mandatory = $false)]
        # Pattern used for adding links at the bottom of the Changelog when -LinkMode is set to Automatic. This
        # is a hashtable that defines the format for the three possible types of links needed: FirstRelease, NormalRelease,
        # and Unreleased. The current version in the patterns should be replaced with {CUR} and the previous
        # version with {PREV}. See examples for details on format of hashtable.
        [ValidateNotNullOrEmpty()]
        [hashtable]$LinkPattern
    )

    $NL = [System.Environment]::NewLine
    if ((Get-Content -Path $Path -Raw) -like "*`r`n*") {
        $FileNewline = "`r`n"
    }
    else {
        $FileNewline = "`n"
    }

    if (($LinkMode -eq "Automatic") -and !($LinkPattern)) {
        throw "-LinkPattern must be used when -LinkMode is set to Automatic"
    }

    if ($LinkMode -eq "GitHub") {
        if (!$env:GITHUB_REPOSITORY) {
            throw "You must be running in GitHub Actions to use GitHub LinkMode"
        }
        $LinkPattern = @{
            FirstRelease = "https://github.com/$env:GITHUB_REPOSITORY/tree/v{CUR}"
            NormalRelease = "https://github.com/$env:GITHUB_REPOSITORY/compare/v{PREV}..v{CUR}"
            Unreleased = "https://github.com/$env:GITHUB_REPOSITORY/compare/v{CUR}..HEAD"
        }
    }
    if ($LinkMode -eq "AzureDevOps") {
        if (!$env:SYSTEM_TASKDEFINITIONSURI) {
            throw "You must be running in Azure Pipelines to use AzureDevOps LinkMode"
        }
        $BaseUri = $env:SYSTEM_TASKDEFINITIONSURI + $env:SYSTEM_TEAMPROJECT + "/_git/" + $env:BUILD_REPOSITORY_NAME
        $LinkPattern = @{
            FirstRelease = $BaseUri + "?version=GTv{CUR}"
            NormalRelease = $BaseUri + "/branchCompare?baseVersion=GTv{PREV}&targetVersion=GTv{CUR}&_a=commits"
            Unreleased = $BaseUri + "/branchCompare?baseVersion=GTv{CUR}&targetVersion=GBmain&_a=commits"
        }
    }

    $ChangelogData = Get-ChangelogData -Path $Path

    <#
        Create $NewRelease by removing header from old Unreleased section

        Using the regular expression '\r?\n' to look for either CRLF or just LF.
        This resolves issue #11.
    #>
    $NewRelease = $ChangelogData.Unreleased.RawData -replace "## \[Unreleased\]\r?\n", ""

    If ([string]::IsNullOrWhiteSpace($NewRelease)) {
        Throw "No changes detected in current release, exiting."
    }

    # Edit $NewRelease to add version number and today's date
    $Today = (Get-Date -Format 'o').Split('T')[0]
    $NewRelease = "## [$ReleaseVersion] - $Today$FileNewline" + $NewRelease

    # Inject links into footer
    if (($LinkMode -eq "Automatic") -or ($LinkMode -eq "GitHub") -or ($LinkMode -eq "AzureDevOps")) {
        if ($ChangelogData.Released -ne "") {
            $NewFooter = ("[Unreleased]: " + ($LinkPattern['Unreleased'] -replace "{CUR}", $ReleaseVersion) + "$FileNewline" +
                "[$ReleaseVersion]: " + (($LinkPattern['NormalRelease'] -replace "{CUR}", $ReleaseVersion) -replace "{PREV}", $ChangelogData.LastVersion) + "$FileNewline" +
                ($ChangelogData.Footer.Trim() -replace "\[Unreleased\].*", "").TrimStart($FileNewline))
        }
        else {
            $NewFooter = ("[Unreleased]: " + ($LinkPattern['Unreleased'] -replace "{CUR}", $ReleaseVersion) + "$FileNewline" +
                "[$ReleaseVersion]: " + ($LinkPattern['FirstRelease'] -replace "{CUR}", $ReleaseVersion))
        }
    }
    if ($LinkMode -eq "Manual") {
        if ($ChangelogData.Released -ne "") {
            $NewFooter = ("[Unreleased]: ENTER-URL-HERE$FileNewline" +
                "[$ReleaseVersion]: ENTER-URL-HERE$FileNewline" +
                ($ChangelogData.Footer.Trim() -replace "\[Unreleased\].*", "").TrimStart($FileNewline))

        }
        else {
            $NewFooter = ("[Unreleased]: ENTER-URL-HERE$FileNewline" +
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
    $Output += "## [Unreleased]$FileNewline$FileNewline"
    $Output += $NewRelease
    if ($ChangelogData.Released) {
        foreach ($Release in $ChangelogData.Released) {
            $Output += $Release.RawData
        }
    }
    $Output += $NewFooter

    Set-Content -Value $Output -Path $OutputPath -NoNewline
}