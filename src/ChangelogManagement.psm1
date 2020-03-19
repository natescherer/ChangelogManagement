if (Test-Path -Path "$PSScriptRoot\private") {
    $PrivateFiles = Get-ChildItem -Path "$PSScriptRoot\private\*.ps1"
    foreach ($PrivateFile in $PrivateFiles) {
        . $PrivateFile.FullName
    }
}

$FunctionsToExport = @()
$PublicFiles = Get-ChildItem -Path "$PSScriptRoot\public\*.ps1"
foreach ($PublicFile in $PublicFiles) {
    . $PublicFile.FullName
    $FunctionsToExport += [io.path]::GetFileNameWithoutExtension($PublicFile.FullName)
}

Export-ModuleMember -Function $FunctionsToExport