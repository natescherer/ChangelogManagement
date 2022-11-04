$Module = Get-ChildItem -Path $(Join-Path $env:GITHUB_WORKSPACE "src" "*.psm1")
$ModulePath = $Module.FullName
$ModuleName = $Module.BaseName

Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name $ModulePath -Force -ErrorAction Stop

Get-Module $ModuleName | Save-MarkdownHelp