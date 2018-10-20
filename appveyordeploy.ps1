# Line break for readability in Appveyor console
Write-Host -Object ''

# Make sure we're using the Master branch and that it's not a pull request
# Environmental Variables Guide: https://www.appveyor.com/docs/environment-variables/
if (($env:APPVEYOR_REPO_BRANCH -eq "master") -and ($env:DeployMode -eq "true")) {
    Write-Host "Starting Deploy..."
    # Publish the new version to the PowerShell Gallery
    try {
        # Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
        $PM = @{
            Path        = "$PSScriptRoot\out\$env:APPVEYOR_PROJECT_NAME"
            NuGetApiKey = $env:NuGetApiKey
            ErrorAction = "Stop"
        }
        #Publish-Module @PM
        Write-Host "$($env:APPVEYOR_PROJECT_NAME) PowerShell Module version $ReleaseVersion published to the PowerShell Gallery." -ForegroundColor Cyan
    }
    Catch {
        # Sad panda; it broke
        Write-Warning "Publishing update $ReleaseVersion to the PowerShell Gallery failed."
        throw $_
    }

    # Publish the new version back to master on GitHub
    Try {
        Remove-Item .\state.zip
        Remove-Item .\TestsResults.xml
        $env:Path += ";$env:ProgramFiles\Git\cmd"
        git checkout master --quiet
        git add --all
        git status
        git commit -s -m "Release via Appveyor: $ReleaseVersion"
        git tag -a v$($ReleaseVersion) -m v$($ReleaseVersion)
        git push origin master --porcelain
        Write-Host "$($env:APPVEYOR_PROJECT_NAME) PowerShell Module version $ReleaseVersion published to GitHub." -ForegroundColor Cyan
    }
    Catch {
        Write-Warning "Publishing update $ReleaseVersion to GitHub failed."
        throw $_
    }
} else {
    if ($env:APPVEYOR_REPO_BRANCH -ne 'master') {
        Write-Warning -Message "Branch wasn't master, skipping deploy."
    } elseif ($env:APPVEYOR_REPO_COMMIT_MESSAGE -notlike "*!Deploy*") {
        Write-Warning -Message "Branch was master, but commit message did not include '!Deploy', skipping deploy."
    }
}