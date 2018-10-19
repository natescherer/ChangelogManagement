# Line break for readability in Appveyor console
Write-Host -Object ''

# Make sure we're using the Master branch and that it's not a pull request
# Environmental Variables Guide: https://www.appveyor.com/docs/environment-variables/
if ($env:APPVEYOR_REPO_BRANCH -ne 'master') {
    Write-Warning -Message "Skipping version increment and publish for branch $env:APPVEYOR_REPO_BRANCH"
} elseif ($env:APPVEYOR_PULL_REQUEST_NUMBER -gt 0) {
    Write-Warning -Message "Skipping version increment and publish for pull request #$env:APPVEYOR_PULL_REQUEST_NUMBER"
} else {
    try {
        # This is where the module manifest lives
        $ManifestPath = ".\src\$($env:APPVEYOR_PROJECT_NAME).psd1"

        # Start by importing the manifest to determine the version, then add 1 to the revision
        $Manifest = Test-ModuleManifest -Path $ManifestPath
        [System.Version]$Version = $Manifest.Version
        Write-Output "Old Module Version: $Version"
        [String]$NewVersion = New-Object -TypeName System.Version -ArgumentList ($Version.Major, $Version.Minor, $Version.Build, $env:APPVEYOR_BUILD_NUMBER)
        Write-Output "New Module Version: $NewVersion"

        # Update the manifest with the new version value and fix the weird string replace bug
        #$FunctionList = ((Get-ChildItem -Path .\Rubrik\Public).BaseName)
        $splat = @{
            'Path'              = $ManifestPath
            'ModuleVersion'     = $NewVersion
            #'FunctionsToExport' = $FunctionList
            #'Copyright'         = "(c) 2015-$( (Get-Date).Year ) Rubrik, Inc. All rights reserved."
        }
        Update-ModuleManifest @splat
        (Get-Content -Path $ManifestPath) -replace 'PSGet_Rubrik', 'Rubrik' | Set-Content -Path $ManifestPath
        (Get-Content -Path $ManifestPath) -replace 'NewManifest', 'Rubrik' | Set-Content -Path $ManifestPath
        (Get-Content -Path $ManifestPath) -replace 'FunctionsToExport = ', 'FunctionsToExport = @(' | Set-Content -Path $ManifestPath -Force
        (Get-Content -Path $ManifestPath) -replace "$($FunctionList[-1])'", "$($FunctionList[-1])')" | Set-Content -Path $ManifestPath -Force
    }
    catch {
        throw $_
    }

    # Create new markdown and XML help files
    Write-Host "Building new function documentation" -ForegroundColor Yellow
    Import-Module -Name ".\src\$($env:APPVEYOR_PROJECT_NAME).psm1" -Force
    New-MarkdownHelp -Module Rubrik -OutputFolder '.\docs\commands\' -Force
    New-ExternalHelp -Path '.\docs\commands\' -OutputPath '.\Rubrik\en-US\' -Force
    . .\tests\docs.ps1
    Write-Host -Object ''

    # Publish the new version to the PowerShell Gallery
    try {
        # Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
        $PM = @{
            Path        = '.\Rubrik'
            NuGetApiKey = $env:NuGetApiKey
            ErrorAction = 'Stop'
        }
        Publish-Module @PM
        Write-Host "Rubrik PowerShell Module version $NewVersion published to the PowerShell Gallery." -ForegroundColor Cyan
    }
    Catch {
        # Sad panda; it broke
        Write-Warning "Publishing update $NewVersion to the PowerShell Gallery failed."
        throw $_
    }

    # Publish the new version back to master on GitHub
    Try {
        # Set up a path to the git.exe cmd, import posh-git to give us control over git, and then push changes to GitHub
        # Note that "update version" is included in the appveyor.yml file's "skip a build" regex to avoid a loop
        $env:Path += ";$env:ProgramFiles\Git\cmd"
        Import-Module posh-git -ErrorAction Stop
        git checkout master
        git add --all
        git status
        git commit -s -m "Update version to $NewVersion"
        git push origin master
        Write-Host "Rubrik PowerShell Module version $NewVersion published to GitHub." -ForegroundColor Cyan
    }
    Catch {
        Write-Warning "Publishing update $NewVersion to GitHub failed."
        throw $_
    }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $AuthHeader = "Basic {0}" -f [System.Convert]::ToBase64String([char[]]"$($env:APPVEYOR_REPO_NAME.split('/')[0])`:$($env:GitHubKey)")
    $ReleaseHeaders = @{
        "Authorization" = $AuthHeader
    }
    $ReleaseBody = @{
        "tag_name" = "v$PublishVersion"
        "name" = "v$PublishVersion"
        "body" = $PublishChangelog
    }
    
    $ReleaseParams = @{
        "Headers" = $ReleaseHeaders
        "Body" = ConvertTo-Json -InputObject $ReleaseBody
        "Uri" = "https://api.github.com/repos/$PublishRepo/releases"
        "Method" = "Post"
    }
    
    $ReleaseResult = Invoke-RestMethod @ReleaseParams
    
    if ($ReleaseResult.upload_url) {
        $UploadHeaders = @{
            "Authorization" = $AuthHeader
            "Content-Type" = "application/zip"
        }
        $UploadParams = @{
            "Headers" = $UploadHeaders
            "Uri" = $ReleaseResult.upload_url.split("{")[0] + "?name=$PublishZipName"
            "Method" = "Post"
            "InFile" = "out\$PublishZipName"
        }

        if ($Proxy) {
            $UploadParams += @{"Proxy" = "http://$Proxy"}
            $UploadParams += @{"ProxyUseDefaultCredentials" = $true}       
        }

        $UploadResult = Invoke-RestMethod @UploadParams
        if ($UploadResult.state -ne "uploaded") {
            Write-Output $UploadResult
            throw "There was a problem uploading."
        }
    } else {
        Write-Output $ReleaseResult
        throw "There was a problem releasing"
    }
}
