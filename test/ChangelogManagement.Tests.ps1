$ModuleName = Split-Path -Path ($PSCommandPath -replace '\.Tests\.ps1$','') -Leaf
$ModulePath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psm1"
Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name $ModulePath -Force -ErrorAction Stop

InModuleScope $ModuleName {
    $Eol = [System.Environment]::NewLine
    $Today = (Get-Date -Format 'o').Split('T')[0]
    $ModuleName = Split-Path -Path ($PSCommandPath -replace '\.Tests\.ps1$','') -Leaf
    $ModulePath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psm1"
    $ModuleManifestPath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psd1"

    Describe 'Module Manifest Tests' {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
            $? | Should Be $true
        }
    }

    Describe "New-Changelog" {
        It "No Parameters" {
            $TestPath="TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath
            [System.Collections.ArrayList]$ResultArrayList = (Get-Content $TestPath)
            if ($ResultArrayList[-1] -eq "") {
                $ResultArrayList[-1] = $Eol
            }
            $Result = $ResultArrayList -join $Eol

            $Result | Should Be(("# Changelog$Eol" +
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
                "$Eol"))
        }
        It "-NoSemVer" {
            $TestPath="TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath -NoSemVer
            [System.Collections.ArrayList]$ResultArrayList = (Get-Content $TestPath)
            if ($ResultArrayList[-1] -eq "") {
                $ResultArrayList[-1] = $Eol
            }
            $Result = $ResultArrayList -join $Eol

            $Result | Should Be(("# Changelog$Eol" +
                "All notable changes to this project will be documented in this file.$Eol" +
                "$Eol" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).$Eol" +
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
                "$Eol"))
        }
    }

    Describe "Update-Changelog" {
        Context "Mandatory Parameters" {
            It "First Release" {
                $TestPath="TestDrive:\CHANGELOG.md"
                New-Changelog -Path $TestPath

                Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0"

                [System.Collections.ArrayList]$ResultArrayList = (Get-Content $TestPath)
                if ($ResultArrayList[-1] -eq "") {
                    $ResultArrayList[-1] = $Eol
                }
                $Result = $ResultArrayList -join $Eol

                $Result | Should Be(("# Changelog$Eol" +
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
                    "$Eol" +
                    "[Unreleased]: https://REPLACE-DOMAIN.com/REPLACE-USERNAME/REPLACE-REPONAME/compare/1.0.0..HEAD$Eol" +
                    "[1.0.0]: https://REPLACE-DOMAIN.com/REPLACE-USERNAME/REPLACE-REPONAME/tree/1.0.0"))
            }
            It "Second Release" {
                $TestPath="TestDrive:\CHANGELOG.md"

                $SourceFile = ("# Changelog$Eol" +
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
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")

                Set-Content -Value $SourceFile -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.1.0"

                [System.Collections.ArrayList]$ResultArrayList = (Get-Content $TestPath)
                if ($ResultArrayList[-1] -eq "") {
                    $ResultArrayList[-1] = $Eol
                }
                $Result = $ResultArrayList -join $Eol

                $Result | Should Be(("# Changelog$Eol" +
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
                    "## [1.1.0] - $Today$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.1.0..HEAD$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0"))
            }
            It "Third Release" {
                $TestPath="TestDrive:\CHANGELOG.md"

                $SourceFile = ("# Changelog$Eol" +
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
                    "## [1.1.0] - 2001-01-01$Eol" +
                    "### Added$Eol" +
                    "- Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Change 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")

                Set-Content -Value $SourceFile -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.2.0"

                [System.Collections.ArrayList]$ResultArrayList = (Get-Content $TestPath)
                if ($ResultArrayList[-1] -eq "") {
                    $ResultArrayList[-1] = $Eol
                }
                $Result = $ResultArrayList -join $Eol

                $Result | Should Be(("# Changelog$Eol" +
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
                    "## [1.2.0] - $Today$Eol" +
                    "$Eol" +
                    "## [1.1.0] - 2001-01-01$Eol" +
                    "### Added$Eol" +
                    "- Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Change 1$Eol" +
                    "$Eol" +,
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.2.0..HEAD$Eol" +
                    "[1.2.0]: https://github.com/testuser/testrepo/compare/v1.1.0..v1.2.0$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0"))
            }
        }
    }
}