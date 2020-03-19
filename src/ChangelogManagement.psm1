$PrivateFiles = Get-ChildItem -Path $PSScriptRoot\Private\*.ps1
foreach ($PrivateFile in $PrivateFiles) {
    . $PrivateFile.FullName
}

$FunctionsToExport = @()
$PublicFiles = Get-ChildItem -Path $PSScriptRoot\Public\*.ps1
foreach ($PublicFile in $PublicFiles) {
    . $PublicFile.FullName
    $FunctionsToExport += [io.path]::GetFileNameWithoutExtension($PublicFile.FullName)
}

Export-ModuleMember -Function $FunctionsToExport