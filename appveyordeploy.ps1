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
            Path        = "$PSScriptRoot\src\($env:APPVEYOR_PROJECT_NAME).psm1"
            NuGetApiKey = $env:NuGetApiKey
            ErrorAction = "Stop"
        }
        Publish-Module @PM
        Write-Host "$($env:APPVEYOR_PROJECT_NAME) PowerShell Module version $NewVersion published to the PowerShell Gallery." -ForegroundColor Cyan
    }
    Catch {
        # Sad panda; it broke
        Write-Warning "Publishing update $NewVersion to the PowerShell Gallery failed."
        throw $_
    }

    # Publish the new version back to master on GitHub
    Try {
        $env:Path += ";$env:ProgramFiles\Git\cmd"
        Import-Module posh-git -ErrorAction Stop
        git checkout master
        git add --all
        git status
        git commit -s -m "Release via Appveyor: $NewVersion"
        git tag -a v$($env:ReleaseVersion)
        git push origin master
        Write-Host "$($env:APPVEYOR_PROJECT_NAME) PowerShell Module version $NewVersion published to GitHub." -ForegroundColor Cyan
    }
    Catch {
        Write-Warning "Publishing update $NewVersion to GitHub failed."
        throw $_
    }
} else {
    if ($env:APPVEYOR_REPO_BRANCH -ne 'master') {
        Write-Warning -Message "Branch wasn't master, skipping deploy."
    } elseif ($env:APPVEYOR_REPO_COMMIT_MESSAGE -notlike "*!Deploy*") {
        Write-Warning -Message "Branch was master, but commit message did not include '!Deploy', skipping deploy."
    }
}