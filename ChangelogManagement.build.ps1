# Requires -Modules InvokeBuild, platyPs, MarkdownToHtml

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "", Justification="This erroneously triggers on Invoke-Build scripts.")]
[CmdletBinding(DefaultParameterSetName="Snapshot")]
param (
    [parameter(ParameterSetName="Snapshot",Mandatory=$true)]
    [parameter(ParameterSetName="Release",Mandatory=$true)]
    [ValidateSet("Snapshot","Release")]
    [string]$BuildMode,

    [parameter(ParameterSetName="Release",Mandatory=$true)]
    [string]$ReleaseVersion,

    [parameter(ParameterSetName="Release",Mandatory=$false)]
    [string]$LinkBase
)

Enter-Build {
    switch ($BuildMode) {
        "Snapshot" {}
        "Release" {
            if (!$ReleaseVersion) {
                throw "ReleaseVersion must be specified in Release BuildMode"
            }
        }
    } 

    $ModuleName = (Get-ChildItem -Path src\ -Filter *.psd1).Name.Split(".")[0]
    Write-Build Green "Assuming `$ModuleName value of $ModuleName based on project folder name."
}

# Synopsis: Perform all build tasks.
task . Clean, UpdateManifest, GenerateMarkdownHelp, UpdateHelpLinkInReadme, UpdateChangelog, MarkDownHelpToHtml, Zip

# Synopsis: Removes files from build, doc, and out.
task Clean -If {($BuildMode -eq "Snapshot") -or ($BuildMode -eq "Release")} {
    Remove-Item -Path "docs/*" -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "out/*" -Recurse -ErrorAction SilentlyContinue
}

# Synopsis: Updates the module manifest file for the new release.
task UpdateManifest -If {$BuildMode -eq "Release"} {
    $ManifestPath = ".\src\$ModuleName.psd1"

    $Description = ((Get-Content -Path ".\README.md" -Raw) -split "## Getting Started")[0] -replace "#.*",""
    $Description = ((($Description -replace "!\[.*","") -replace "\[","") -replace "\]"," ").Trim()

    $ManifestData = @{
        'Path' = $ManifestPath
        'ModuleVersion' = $ReleaseVersion
        'ReleaseNotes' = ((Get-ChangelogData).Released[0].RawData -replace "## \[.*","").Trim()
        'Description' = $Description
    }
    Update-ModuleManifest @ManifestData
}

# Synopsis: Generates Markdown help file from comment-based help in script.
task GenerateMarkdownHelp -If {($BuildMode -eq "Snapshot") -or ($BuildMode -eq "Release")} {
    New-MarkdownHelp -Module $ModuleName -OutputFolder docs -NoMetadata | Out-Null
}

# Synopsis: Updates the help link in the readme to point to the file in the new version.
task UpdateHelpLinkInReadme -If {$BuildMode -eq "Release"} {
    $ReadmeData = Get-Content -Path "README.md"
    $ReadmeOutput = @()
    $UpdateNeeded = $true

    foreach ($Line in $ReadmeData) {
        if ($Line -match "^\[DocsDir\].*") {
            if ($Line -match "^\[DocsDir\]: \.\./v$ReleaseVersion/docs") {
                $UpdateNeeded = $false
            } else {
                $ReadmeOutput += "[DocsDir]: ../v" + $ReleaseVersion + "/docs/"
            }
        } else {
            $ReadmeOutput += $Line
        }
    }

    if ($UpdateNeeded) {
        Set-Content -Value $ReadmeOutput -Path "README.md"
    } else {
        Write-Build Yellow "README.md already updated."
    }
}

# Synopsis: Updates the CHANGELOG.md file for the new release.
task UpdateChangelog -If {$BuildMode -eq "Release"} {
    Update-Changelog -ReleaseVersion $ReleaseVersion -LinkBase $LinkBase -ReleasePrefix "v"
}

# Synopsis: Converts README.md and anything matching docs*.md to HTML, and puts in out folder.
task MarkdownHelpToHtml -If {($BuildMode -eq "Snapshot") -or ($BuildMode -eq "Release")} {
    if (!(Test-Path -Path "docs\CHANGELOG.md")) {
        Copy-Item -Path "CHANGELOG.md" -Destination "docs\"
    }
    Copy-Item -Path "README.md" -Destination "docs"
    Convert-MarkdownToHTML -Path "docs" -Destination "out\$ModuleName\docs" -Template "src\MarkdownToHtmlTemplate" | Out-Null
 
    Remove-Item -Path "docs\README.md"
    Remove-Item -Path "docs\CHANGELOG.md"
}

# Synopsis: Zip up files.
task Zip -If {($BuildMode -eq "Snapshot") -or ($BuildMode -eq "Release")} {
    Copy-Item -Path "src\*" -Destination "out\$ModuleName\"

    if ($ReleaseVersion) {
        Compress-Archive -Path "out\$ModuleName\*" -DestinationPath "out\$ModuleName-v$ReleaseVersion.zip"
    } else {
        Compress-Archive -Path "out\$ModuleName\*" -DestinationPath "out\$ModuleName-snapshot$( Get-Date -Format yyMMdd ).zip"
    }
}