# Requires -Modules InvokeBuild, platyPs, MarkdownToHtml

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "", Justification="This erroneously triggers on Invoke-Build scripts.")]
[CmdletBinding(DefaultParameterSetName="Snapshot")]
param (
    [parameter(ParameterSetName="Snapshot",Mandatory=$true)]
    [parameter(ParameterSetName="Release",Mandatory=$true)]
    [ValidateSet("Snapshot","Release")]
    [string]$BuildMode,

    [parameter(ParameterSetName="Release",Mandatory=$true)]
    [string]$ReleaseVersion
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

    $ModuleName = "src\$( $BuildRoot.Split("\")[-1] ).ps1"
    Write-Build Green "Assuming $ModuleName value of $ModuleName based on project folder name."
}

# Synopsis: Perform all build tasks.
task . Clean, GenerateMarkdownHelp, UpdateHelpLinkInReadme, UpdateChangelog, MarkDownHelpToHtml, Zip

# Synopsis: Removes files from build, doc, and out.
task Clean -If {($BuildMode -eq "Snapshot") -or ($BuildMode -eq "Release")} {
    Remove-Item -Path "docs/*" -Recurse
    Remove-Item -Path "out/*" -Recurse -ErrorAction SilentlyContinue
}

# Synopsis: Generates Markdown help file from comment-based help in script.
task GenerateMarkdownHelp -If {($BuildMode -eq "Snapshot") -or ($BuildMode -eq "Release")} {
    New-MarkdownHelp -Module $ModuleName -OutputFolder docs -NoMetadata | Out-Null
    #Rename-Item -Path "docs\$NameWithExt.md" -NewName "$NameWithoutExt.md"
}

# Synopsis: Updates the help link in the readme to point to the file in the new version.
task UpdateHelpLinkInReadme -If {$BuildMode -eq "Release"} {
    $ReadmeData = Get-Content -Path "README.md"
    $ReadmeOutput = @()
    $UpdateNeeded = $true

    foreach ($Line in $ReadmeData) {
        if ($Line -like "*``[HelpMarkdown``]:*") {
            if ($Line -like "*``[HelpMarkdown``]: ../v$ReleaseVersion*") {
                $UpdateNeeded = $false
            } else {
                $ReadmeOutput += "[HelpMarkdown]: ../v" + $ReleaseVersion + "/doc/"
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
    # Update me
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
    if ($ReleaseVersion) {
        Compress-Archive -Path "out\$ModuleName\*" -DestinationPath "out\$ModuleName-v$ReleaseVersion.zip"
    } else {
        Compress-Archive -Path "out\$ModuleName\*" -DestinationPath "out\$ModuleName-snapshot$( Get-Date -Format yyMMdd ).zip"
    }
}