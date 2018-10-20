$ModuleName = "ChangelogManagement"
$ModulePath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psm1"
Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name $ModulePath -Force -ErrorAction Stop

InModuleScope $ModuleName {
    $Eol = [System.Environment]::NewLine
    $Today = (Get-Date -Format 'o').Split('T')[0]
    $ModuleName = "ChangelogManagement"
    $ModuleManifestPath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psd1"

    Describe 'Verify Appveyor Update-Changelog' {
        It "Test 1" {
            $TestPath = "TestDrive:\CHANGELOG.md"

            $SeedData = ("# Changelog$Eol" +
                "All notable changes to this project will be documented in this file.$Eol" +
                "$Eol" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                "$Eol" +
                "## [Unreleased]$Eol" +
                "### Added$Eol" +
                "- Get-ChangelogData cmdlet$Eol" +
                "- Add-ChangelogData cmdlet$Eol" +
                "- New-Changelog cmdlet$Eol" +
                "- Update-Changelog cmdlet$Eol" +
                "- Convertfrom-Changelog cmdlet$Eol" +
                "$Eol" +
                "### Changed$Eol" +
                "$Eol" +
                "### Deprecated$Eol" +
                "$Eol" +
                "### Removed$Eol" +
                "$Eol" +
                "### Fixed$Eol" +
                "$Eol" +
                "### Security$Eol" +
                "$Eol")

            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -LinkBase "https://github.com/natescherer/ChangelogManagement" -ReleasePrefix "v"

            $Result = Get-Content -Path $TestPath -Raw

            $Result | Should -Be ("# Changelog$Eol" +
                "All notable changes to this project will be documented in this file.$Eol" +
                "$Eol" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                "$Eol" +
                "## [Unreleased]$Eol" +
                "### Added$Eol" +
                "$Eol" +
                "### Changed$Eol" +
                "$Eol" +
                "### Deprecated$Eol" +
                "$Eol" +
                "### Removed$Eol" +
                "$Eol" +
                "### Fixed$Eol" +
                "$Eol" +
                "### Security$Eol" +
                "$Eol" +
                "## [1.0.0] - $Today$Eol" +
                "### Added$Eol" +
                "- Get-ChangelogData cmdlet$Eol" +
                "- Add-ChangelogData cmdlet$Eol" +
                "- New-Changelog cmdlet$Eol" +
                "- Update-Changelog cmdlet$Eol" +
                "- Convertfrom-Changelog cmdlet$Eol" +
                "$Eol" +
                "[Unreleased]: https://github.com/natescherer/ChangelogManagement/compare/v1.0.0..HEAD$Eol" +
                "[1.0.0]: https://github.com/natescherer/ChangelogManagement/tree/v1.0.0")
        }
    }
}