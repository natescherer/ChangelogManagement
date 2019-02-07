$ModuleName = Split-Path -Path ($PSCommandPath -replace '\.Tests\.ps1$','') -Leaf
$ModulePath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psm1"
Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name $ModulePath -Force -ErrorAction Stop

InModuleScope $ModuleName {
    $Eol = [System.Environment]::NewLine
    $Today = (Get-Date -Format 'o').Split('T')[0]
    $ModuleName = Split-Path -Path ($PSCommandPath -replace '\.Tests\.ps1$','') -Leaf
    $ModuleManifestPath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psd1"

    Describe 'Module Manifest Tests' {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
            $? | Should -Be $true
        }
    }

    Describe "Get-ChangelogData" {
        $TestPath = "TestDrive:\CHANGELOG.md"
        $SeedData = ("# Changelog$Eol" +
            "All notable changes to this project will be documented in this file.$Eol" +
            "$Eol" +
            "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
            "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
            "$Eol" +
            "## [Unreleased]$Eol" +
            "### Added$Eol" +
            "- Unreleased Addition 1$Eol" +
            "- Unreleased Addition 2$Eol" +
            "$Eol" +
            "### Changed$Eol" +
            "- Unreleased Change 1$Eol" +
            "- Unreleased Change 2$Eol" +
            "$Eol" +
            "### Deprecated$Eol" +
            "- Unreleased Deprecation 1$Eol" +
            "- Unreleased Deprecation 2$Eol" +
            "$Eol" +
            "### Removed$Eol" +
            "- Unreleased Removal 1$Eol" +
            "- Unreleased Removal 2$Eol" +
            "$Eol" +
            "### Fixed$Eol" +
            "- Unreleased Fix 1$Eol" +
            "- Unreleased Fix 2$Eol" +
            "$Eol" +
            "### Security$Eol" +
            "- Unreleased Vulnerability 1$Eol" +
            "- Unreleased Vulnerability 2$Eol" +
            "$Eol" +
            "## [1.1.0] - 2001-01-01$Eol" +
            "### Added$Eol" +
            "- Released Addition 1$Eol" +
            "- Released Addition 2$Eol" +
            "$Eol" +
            "### Changed$Eol" +
            "- Released Change 1$Eol" +
            "- Released Change 2$Eol" +
            "$Eol" +
            "### Deprecated$Eol" +
            "- Released Deprecation 1$Eol" +
            "- Released Deprecation 2$Eol" +
            "$Eol" +
            "### Removed$Eol" +
            "- Released Removal 1$Eol" +
            "- Released Removal 2$Eol" +
            "$Eol" +
            "### Fixed$Eol" +
            "- Released Fix 1$Eol" +
            "- Released Fix 2$Eol" +
            "$Eol" +
            "### Security$Eol" +
            "- Released Vulnerability 1$Eol" +
            "- Released Vulnerability 2$Eol" +
            "$Eol" +
            "## [1.0.0] - 2000-01-01$Eol" +
            "### Added$Eol" +
            "- Initial release$Eol" +
            "$Eol" +
            "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
            "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
            "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")

        Set-Content -Value $SeedData -Path $TestPath -NoNewline

        $Data = Get-ChangelogData -Path $TestPath

        It "Return.Header" {
            $Data.Header | Should -Be ("# Changelog$Eol" +
                "All notable changes to this project will be documented in this file.$Eol" +
                "$Eol" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                "$Eol")
        }
        Context "Return.Unreleased.Data" {
            It ".Added" {
                $Data.Unreleased.Data.Added | Should -Be @("Unreleased Addition 1", "Unreleased Addition 2")
            }
            It ".Changed" {
                $Data.Unreleased.Data.Changed | Should -Be @("Unreleased Change 1", "Unreleased Change 2")
            }
            It ".Deprecated" {
                $Data.Unreleased.Data.Deprecated | Should -Be @("Unreleased Deprecation 1", "Unreleased Deprecation 2")
            }
            It ".Removed" {
                $Data.Unreleased.Data.Removed | Should -Be @("Unreleased Removal 1", "Unreleased Removal 2")
            }
            It ".Fixed" {
                $Data.Unreleased.Data.Fixed | Should -Be @("Unreleased Fix 1", "Unreleased Fix 2")
            }
            It ".Security" {
                $Data.Unreleased.Data.Security | Should -Be @("Unreleased Vulnerability 1", "Unreleased Vulnerability 2")
            }
        }
        It "Return.Unreleased.Link" {
            $Data.Unreleased.Link | Should -Be "https://github.com/testuser/testrepo/compare/v1.0.0..HEAD"
        }
        It "Return.Unreleased.RawData" {
            $Data.Unreleased.RawData | Should -Be ("## [Unreleased]$Eol" +
                "### Added$Eol" +
                "- Unreleased Addition 1$Eol" +
                "- Unreleased Addition 2$Eol" +
                "$Eol" +
                "### Changed$Eol" +
                "- Unreleased Change 1$Eol" +
                "- Unreleased Change 2$Eol" +
                "$Eol" +
                "### Deprecated$Eol" +
                "- Unreleased Deprecation 1$Eol" +
                "- Unreleased Deprecation 2$Eol" +
                "$Eol" +
                "### Removed$Eol" +
                "- Unreleased Removal 1$Eol" +
                "- Unreleased Removal 2$Eol" +
                "$Eol" +
                "### Fixed$Eol" +
                "- Unreleased Fix 1$Eol" +
                "- Unreleased Fix 2$Eol" +
                "$Eol" +
                "### Security$Eol" +
                "- Unreleased Vulnerability 1$Eol" +
                "- Unreleased Vulnerability 2$Eol" +
                "$Eol")
        }
        It "Return.Released.RawData" {
            $Data.Released.RawData | Should -Be @(("## [1.1.0] - 2001-01-01$Eol" +
                "### Added$Eol" +
                "- Released Addition 1$Eol" +
                "- Released Addition 2$Eol" +
                "$Eol" +
                "### Changed$Eol" +
                "- Released Change 1$Eol" +
                "- Released Change 2$Eol" +
                "$Eol" +
                "### Deprecated$Eol" +
                "- Released Deprecation 1$Eol" +
                "- Released Deprecation 2$Eol" +
                "$Eol" +
                "### Removed$Eol" +
                "- Released Removal 1$Eol" +
                "- Released Removal 2$Eol" +
                "$Eol" +
                "### Fixed$Eol" +
                "- Released Fix 1$Eol" +
                "- Released Fix 2$Eol" +
                "$Eol" +
                "### Security$Eol" +
                "- Released Vulnerability 1$Eol" +
                "- Released Vulnerability 2$Eol" +
                "$Eol"),
                ("## [1.0.0] - 2000-01-01$Eol" +
                "### Added$Eol" +
                "- Initial release$Eol" +
                "$Eol"))
        }
        It "Return.Released.Date" {
            $Data.Released.Date | Should -Be @((Get-Date "1/1/2001 12:00:00 AM"),
                (Get-Date "1/1/2000 12:00:00 AM"))
        }
        It "Return.Released.Version" {
            $Data.Released.Version | Should -Be @("1.1.0","1.0.0")
        }
        It "Return.Released.Link" {
            $Data.Released.Link | Should -Be @("https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0",
                "https://github.com/testuser/testrepo/tree/v1.0.0")
        }
        Context "Return.Released[0].Data" {
            It ".Added" {
                $Data.Released[0].Data.Added | Should -Be @("Released Addition 1", "Released Addition 2")
            }
            It ".Changed" {
                $Data.Released[0].Data.Changed | Should -Be @("Released Change 1", "Released Change 2")
            }
            It ".Deprecated" {
                $Data.Released[0].Data.Deprecated | Should -Be @("Released Deprecation 1", "Released Deprecation 2")
            }
            It ".Removed" {
                $Data.Released[0].Data.Removed | Should -Be @("Released Removal 1", "Released Removal 2")
            }
            It ".Fixed" {
                $Data.Released[0].Data.Fixed | Should -Be @("Released Fix 1", "Released Fix 2")
            }
            It ".Security" {
                $Data.Released[0].Data.Security | Should -Be @("Released Vulnerability 1", "Released Vulnerability 2")
            }
        }
        Context "Return.Released[1].Data" {
            It ".Added" {
                $Data.Released[1].Data.Added | Should -Be "Initial release"
            }
            It ".Changed" {
                $Data.Released[1].Data.Changed | Should -BeNullOrEmpty
            }
            It ".Deprecated" {
                $Data.Released[1].Data.Deprecated | Should -BeNullOrEmpty
            }
            It ".Removed" {
                $Data.Released[1].Data.Removed | Should -BeNullOrEmpty
            }
            It ".Fixed" {
                $Data.Released[1].Data.Fixed | Should -BeNullOrEmpty
            }
            It ".Security" {
                $Data.Released[1].Data.Security | Should -BeNullOrEmpty
            }
        }
        It "Return.Footer" {
            $Data.Footer | Should -Be ("[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        }
        It "Return.LastVersion" {
            $Data.LastVersion | Should -Be "1.1.0"
        }
    }

    Describe "Add-ChangelogData" {
        $TestPath = "TestDrive:\CHANGELOG.md"
        $SeedData = ("# Changelog$Eol" +
            "All notable changes to this project will be documented in this file.$Eol" +
            "$Eol" +
            "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
            "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
            "$Eol" +
            "## [Unreleased]$Eol" +
            "### Added$Eol" +
            "- Unreleased Addition 1$Eol" +
            "$Eol" +
            "### Changed$Eol" +
            "- Unreleased Change 1$Eol" +
            "$Eol" +
            "### Deprecated$Eol" +
            "- Unreleased Deprecation 1$Eol" +
            "$Eol" +
            "### Removed$Eol" +
            "- Unreleased Removal 1$Eol" +
            "$Eol" +
            "### Fixed$Eol" +
            "- Unreleased Fix 1$Eol" +
            "$Eol" +
            "### Security$Eol" +
            "- Unreleased Vulnerability 1$Eol" +
            "$Eol" +
            "## [1.1.0] - 2001-01-01$Eol" +
            "### Added$Eol" +
            "- Released Addition 1$Eol" +
            "$Eol" +
            "### Changed$Eol" +
            "- Released Change 1$Eol" +
            "$Eol" +
            "### Fixed$Eol" +
            "- Released Fix 1$Eol" +
            "$Eol" +
            "## [1.0.0] - 2000-01-01$Eol" +
            "### Added$Eol" +
            "- Initial release$Eol" +
            "$Eol" +
            "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
            "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
            "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        Context "-Type" {
            It "Added" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Added" -Data "Unreleased Addition 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 2$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Unreleased Change 1$Eol" +
                    "$Eol" +
                    "### Deprecated$Eol" +
                    "- Unreleased Deprecation 1$Eol" +
                    "$Eol" +
                    "### Removed$Eol" +
                    "- Unreleased Removal 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Unreleased Fix 1$Eol" +
                    "$Eol" +
                    "### Security$Eol" +
                    "- Unreleased Vulnerability 1$Eol" +
                    "$Eol" +
                    "## [1.1.0] - 2001-01-01$Eol" +
                    "### Added$Eol" +
                    "- Released Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Released Change 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Released Fix 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Changed" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Changed" -Data "Unreleased Change 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Unreleased Change 2$Eol" +
                    "- Unreleased Change 1$Eol" +
                    "$Eol" +
                    "### Deprecated$Eol" +
                    "- Unreleased Deprecation 1$Eol" +
                    "$Eol" +
                    "### Removed$Eol" +
                    "- Unreleased Removal 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Unreleased Fix 1$Eol" +
                    "$Eol" +
                    "### Security$Eol" +
                    "- Unreleased Vulnerability 1$Eol" +
                    "$Eol" +
                    "## [1.1.0] - 2001-01-01$Eol" +
                    "### Added$Eol" +
                    "- Released Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Released Change 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Released Fix 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Deprecated" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Deprecated" -Data "Unreleased Deprecation 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Unreleased Change 1$Eol" +
                    "$Eol" +
                    "### Deprecated$Eol" +
                    "- Unreleased Deprecation 2$Eol" +
                    "- Unreleased Deprecation 1$Eol" +
                    "$Eol" +
                    "### Removed$Eol" +
                    "- Unreleased Removal 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Unreleased Fix 1$Eol" +
                    "$Eol" +
                    "### Security$Eol" +
                    "- Unreleased Vulnerability 1$Eol" +
                    "$Eol" +
                    "## [1.1.0] - 2001-01-01$Eol" +
                    "### Added$Eol" +
                    "- Released Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Released Change 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Released Fix 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Removed" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Removed" -Data "Unreleased Removal 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Unreleased Change 1$Eol" +
                    "$Eol" +
                    "### Deprecated$Eol" +
                    "- Unreleased Deprecation 1$Eol" +
                    "$Eol" +
                    "### Removed$Eol" +
                    "- Unreleased Removal 2$Eol" +
                    "- Unreleased Removal 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Unreleased Fix 1$Eol" +
                    "$Eol" +
                    "### Security$Eol" +
                    "- Unreleased Vulnerability 1$Eol" +
                    "$Eol" +
                    "## [1.1.0] - 2001-01-01$Eol" +
                    "### Added$Eol" +
                    "- Released Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Released Change 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Released Fix 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Fixed" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Fixed" -Data "Unreleased Fix 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Unreleased Change 1$Eol" +
                    "$Eol" +
                    "### Deprecated$Eol" +
                    "- Unreleased Deprecation 1$Eol" +
                    "$Eol" +
                    "### Removed$Eol" +
                    "- Unreleased Removal 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Unreleased Fix 2$Eol" +
                    "- Unreleased Fix 1$Eol" +
                    "$Eol" +
                    "### Security$Eol" +
                    "- Unreleased Vulnerability 1$Eol" +
                    "$Eol" +
                    "## [1.1.0] - 2001-01-01$Eol" +
                    "### Added$Eol" +
                    "- Released Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Released Change 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Released Fix 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Security" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Security" -Data "Unreleased Vulnerability 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Unreleased Change 1$Eol" +
                    "$Eol" +
                    "### Deprecated$Eol" +
                    "- Unreleased Deprecation 1$Eol" +
                    "$Eol" +
                    "### Removed$Eol" +
                    "- Unreleased Removal 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Unreleased Fix 1$Eol" +
                    "$Eol" +
                    "### Security$Eol" +
                    "- Unreleased Vulnerability 2$Eol" +
                    "- Unreleased Vulnerability 1$Eol" +
                    "$Eol" +
                    "## [1.1.0] - 2001-01-01$Eol" +
                    "### Added$Eol" +
                    "- Released Addition 1$Eol" +
                    "$Eol" +
                    "### Changed$Eol" +
                    "- Released Change 1$Eol" +
                    "$Eol" +
                    "### Fixed$Eol" +
                    "- Released Fix 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
        }
        It "-OutputPath" {
            Set-Content -Value $SeedData -Path $TestPath -NoNewline
            $TestPath2 = "TestDrive:\CHANGELOG2.md"

            Add-ChangelogData -Path $TestPath -Type "Added" -Data "Unreleased Addition 2" -OutputPath $TestPath2

            $Result = Get-Content -Path $TestPath2 -Raw

            $Result | Should -Be ("# Changelog$Eol" +
                "All notable changes to this project will be documented in this file.$Eol" +
                "$Eol" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                "$Eol" +
                "## [Unreleased]$Eol" +
                "### Added$Eol" +
                "- Unreleased Addition 2$Eol" +
                "- Unreleased Addition 1$Eol" +
                "$Eol" +
                "### Changed$Eol" +
                "- Unreleased Change 1$Eol" +
                "$Eol" +
                "### Deprecated$Eol" +
                "- Unreleased Deprecation 1$Eol" +
                "$Eol" +
                "### Removed$Eol" +
                "- Unreleased Removal 1$Eol" +
                "$Eol" +
                "### Fixed$Eol" +
                "- Unreleased Fix 1$Eol" +
                "$Eol" +
                "### Security$Eol" +
                "- Unreleased Vulnerability 1$Eol" +
                "$Eol" +
                "## [1.1.0] - 2001-01-01$Eol" +
                "### Added$Eol" +
                "- Released Addition 1$Eol" +
                "$Eol" +
                "### Changed$Eol" +
                "- Released Change 1$Eol" +
                "$Eol" +
                "### Fixed$Eol" +
                "- Released Fix 1$Eol" +
                "$Eol" +
                "## [1.0.0] - 2000-01-01$Eol" +
                "### Added$Eol" +
                "- Initial release$Eol" +
                "$Eol" +
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        }
    }

    Describe "New-Changelog" {
        It "No Parameters" {
            $TestPath = "TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath

            $Result = Get-Content -Path $TestPath -Raw

            $Result | Should -Be ("# Changelog$Eol" +
                "All notable changes to this project will be documented in this file.$Eol" +
                "$Eol" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                "$Eol" +
                "## [Unreleased]$Eol")
        }
        It "-NoSemVer" {
            $TestPath = "TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath -NoSemVer
            $Result = Get-Content -Path $TestPath -Raw

            $Result | Should -Be ("# Changelog$Eol" +
                "All notable changes to this project will be documented in this file.$Eol" +
                "$Eol" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).$Eol" +
                "$Eol" +
                "## [Unreleased]$Eol")
        }
    }

    Describe "Update-Changelog" {
        Context "-LinkMode Automatic" {
            It "First Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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

                $UCSplat = @{
                    Path = $TestPath
                    ReleaseVersion = "1.0.0"
                    LinkMode = "Automatic"
                    LinkPattern   = @{
                        FirstRelease  = "https://github.com/testuser/testrepo/tree/v{CUR}"
                        NormalRelease = "https://github.com/testuser/testrepo/compare/v{PREV}..v{CUR}"
                        Unreleased    = "https://github.com/testuser/testrepo/compare/v{CUR}..HEAD"
                    }
                }
                Update-Changelog @UCSplat

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
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Second Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $UCSplat = @{
                    Path           = $TestPath
                    ReleaseVersion = "1.1.0"
                    LinkMode       = "Automatic"
                    LinkPattern   = @{
                        FirstRelease  = "https://github.com/testuser/testrepo/tree/v{CUR}"
                        NormalRelease = "https://github.com/testuser/testrepo/compare/v{PREV}..v{CUR}"
                        Unreleased    = "https://github.com/testuser/testrepo/compare/v{CUR}..HEAD"
                    }
                }

                Update-Changelog @UCSplat

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
                    "## [1.1.0] - $Today$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.1.0..HEAD$Eol" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Third Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $UCSplat = @{
                    Path           = $TestPath
                    ReleaseVersion = "1.2.0"
                    LinkMode       = "Automatic"
                    LinkPattern   = @{
                        FirstRelease  = "https://github.com/testuser/testrepo/tree/v{CUR}"
                        NormalRelease = "https://github.com/testuser/testrepo/compare/v{PREV}..v{CUR}"
                        Unreleased    = "https://github.com/testuser/testrepo/compare/v{CUR}..HEAD"
                    }
                }

                Update-Changelog @UCSplat

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
                    "## [1.2.0] - $Today$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
        }
        Context "-LinkMode Manual" {
            It "First Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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

                Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -LinkMode Manual

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
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "[Unreleased]: ENTER-URL-HERE$Eol" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
            It "Second Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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
                    "[Unreleased]: ENTER-URL-HERE$Eol" +
                    "[1.0.0]: ENTER-URL-HERE")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.1.0" -LinkMode Manual

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
                    "## [1.1.0] - $Today$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: ENTER-URL-HERE$Eol" +
                    "[1.1.0]: ENTER-URL-HERE$Eol" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
            It "Third Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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
                    "[Unreleased]: ENTER-URL-HERE$Eol" +
                    "[1.1.0]: ENTER-URL-HERE$Eol" +
                    "[1.0.0]: ENTER-URL-HERE")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.2.0" -LinkMode Manual

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
                    "## [1.2.0] - $Today$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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
                    "[Unreleased]: ENTER-URL-HERE$Eol" +
                    "[1.2.0]: ENTER-URL-HERE$Eol" +
                    "[1.1.0]: ENTER-URL-HERE$Eol" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
        }
        Context "-LinkMode None" {
            It "First Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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

                Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -LinkMode None

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
                    "- Unreleased Addition 1$Eol" +
                    "$Eol")
            }
            It "Second Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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
                    "[Unreleased]: ENTER-URL-HERE$Eol" +
                    "[1.0.0]: ENTER-URL-HERE")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.1.0" -LinkMode None

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
                    "## [1.1.0] - $Today$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "## [1.0.0] - 2000-01-01$Eol" +
                    "### Added$Eol" +
                    "- Initial release$Eol" +
                    "$Eol" +
                    "[Unreleased]: ENTER-URL-HERE$Eol" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
            It "Third Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "## [Unreleased]$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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
                    "[Unreleased]: ENTER-URL-HERE$Eol" +
                    "[1.1.0]: ENTER-URL-HERE$Eol" +
                    "[1.0.0]: ENTER-URL-HERE")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.2.0" -LinkMode None

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
                    "## [1.2.0] - $Today$Eol" +
                    "### Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
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
                    "[Unreleased]: ENTER-URL-HERE$Eol" +
                    "[1.1.0]: ENTER-URL-HERE$Eol" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
        }
        It "-OutputPath" {
            $TestPath = "TestDrive:\CHANGELOG.md"
            $TestPath2 = "TestDrive:\CHANGELOG2.md"

            $SeedData = ("# Changelog$Eol" +
                "All notable changes to this project will be documented in this file.$Eol" +
                "$Eol" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                "$Eol" +
                "## [Unreleased]$Eol" +
                "### Added$Eol" +
                "- Unreleased Addition 1$Eol" +
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

            Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -OutputPath $TestPath2 -LinkMode None

            $Result = Get-Content -Path $TestPath2 -Raw

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
                "- Unreleased Addition 1$Eol" +
                "$Eol")
        }
    }

    Describe "ConvertFrom-Changelog" {
        $TestPath = "TestDrive:\CHANGELOG.md"

        $SeedData = ("# Changelog$Eol" +
            "All notable changes to this project will be documented in this file.$Eol" +
            "$Eol" +
            "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
            "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
            "$Eol" +
            "## [Unreleased]$Eol" +
            "### Added$Eol" +
            "- Unreleased Addition 1$Eol" +
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
        Context "-Format" {
            It "Release" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "Release"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
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
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Text" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "Text"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on Keep a Changelog (https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to Semantic Versioning (https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "[Unreleased]$Eol" +
                    "Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "Changed$Eol" +
                    "$Eol" +
                    "Deprecated$Eol" +
                    "$Eol" +
                    "Removed$Eol" +
                    "$Eol" +
                    "Fixed$Eol" +
                    "$Eol" +
                    "Security$Eol" +
                    "$Eol" +
                    "[1.1.0] - 2001-01-01$Eol" +
                    "Added$Eol" +
                    "- Addition 1$Eol" +
                    "$Eol" +
                    "Changed$Eol" +
                    "- Change 1$Eol" +
                    "$Eol" +
                    "[1.0.0] - 2000-01-01$Eol" +
                    "Added$Eol" +
                    "- Initial release")
            }
            It "TextRelease" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "TextRelease"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("Changelog$Eol" +
                    "All notable changes to this project will be documented in this file.$Eol" +
                    "$Eol" +
                    "The format is based on Keep a Changelog (https://keepachangelog.com/en/1.0.0/),$Eol" +
                    "and this project adheres to Semantic Versioning (https://semver.org/spec/v2.0.0.html).$Eol" +
                    "$Eol" +
                    "[1.1.0] - 2001-01-01$Eol" +
                    "Added$Eol" +
                    "- Addition 1$Eol" +
                    "$Eol" +
                    "Changed$Eol" +
                    "- Change 1$Eol" +
                    "$Eol" +
                    "[1.0.0] - 2000-01-01$Eol" +
                    "Added$Eol" +
                    "- Initial release")
            }
        }
        Context "-NoHeader" {
            It "Release" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "Release" -NoHeader

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("## [1.1.0] - 2001-01-01$Eol" +
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
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Text" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "Text" -NoHeader

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("[Unreleased]$Eol" +
                    "Added$Eol" +
                    "- Unreleased Addition 1$Eol" +
                    "$Eol" +
                    "Changed$Eol" +
                    "$Eol" +
                    "Deprecated$Eol" +
                    "$Eol" +
                    "Removed$Eol" +
                    "$Eol" +
                    "Fixed$Eol" +
                    "$Eol" +
                    "Security$Eol" +
                    "$Eol" +
                    "[1.1.0] - 2001-01-01$Eol" +
                    "Added$Eol" +
                    "- Addition 1$Eol" +
                    "$Eol" +
                    "Changed$Eol" +
                    "- Change 1$Eol" +
                    "$Eol" +
                    "[1.0.0] - 2000-01-01$Eol" +
                    "Added$Eol" +
                    "- Initial release")
            }
            It "TextRelease" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "TextRelease" -NoHeader

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("[1.1.0] - 2001-01-01$Eol" +
                    "Added$Eol" +
                    "- Addition 1$Eol" +
                    "$Eol" +
                    "Changed$Eol" +
                    "- Change 1$Eol" +
                    "$Eol" +
                    "[1.0.0] - 2000-01-01$Eol" +
                    "Added$Eol" +
                    "- Initial release")
            }
        }
        It "-OutputPath" {
            $TestPath2 = "TestDrive:\CHANGELOG2.md"

            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Convertfrom-Changelog -Path $TestPath -Format "Release" -NoHeader -OutputPath $TestPath2

            $Result = Get-Content -Path $TestPath2 -Raw

            $Result | Should -Be ("## [1.1.0] - 2001-01-01$Eol" +
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
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        }
    }
}
