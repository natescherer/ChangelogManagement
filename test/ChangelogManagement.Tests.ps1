$global:ModuleName = Split-Path -Path ($PSCommandPath -replace '\.Tests\.ps1$','') -Leaf
$global:ModulePath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psm1"
$global:ModuleManifestPath = "$(Split-Path -Path $PSScriptRoot -Parent)\src\$ModuleName.psd1"
$global:NL = [System.Environment]::NewLine

$global:Today = (Get-Date -Format 'o').Split('T')[0]

Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name $ModulePath -Force -ErrorAction Stop

InModuleScope $ModuleName {
    Describe 'Module Manifest Tests' {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
            $? | Should -Be $true
        }
    }

    Describe "Get-ChangelogData" {
        BeforeAll {
            $TestPath = "TestDrive:\CHANGELOG.md"
            $SeedData = ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "### Added$NL" +
                "- Unreleased Addition 1$NL" +
                "- Unreleased Addition 2$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Unreleased Change 1$NL" +
                "- Unreleased Change 2$NL" +
                "$NL" +
                "### Deprecated$NL" +
                "- Unreleased Deprecation 1$NL" +
                "- Unreleased Deprecation 2$NL" +
                "$NL" +
                "### Removed$NL" +
                "- Unreleased Removal 1$NL" +
                "- Unreleased Removal 2$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Unreleased Fix 1$NL" +
                "- Unreleased Fix 2$NL" +
                "$NL" +
                "### Security$NL" +
                "- Unreleased Vulnerability 1$NL" +
                "- Unreleased Vulnerability 2$NL" +
                "$NL" +
                "## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Released Addition 1$NL" +
                "- Released Addition 2$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Released Change 1$NL" +
                "- Released Change 2$NL" +
                "$NL" +
                "### Deprecated$NL" +
                "- Released Deprecation 1$NL" +
                "- Released Deprecation 2$NL" +
                "$NL" +
                "### Removed$NL" +
                "- Released Removal 1$NL" +
                "- Released Removal 2$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Released Fix 1$NL" +
                "- Released Fix 2$NL" +
                "$NL" +
                "### Security$NL" +
                "- Released Vulnerability 1$NL" +
                "- Released Vulnerability 2$NL" +
                "$NL" +
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")

            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            $Data = Get-ChangelogData -Path $TestPath
        }

        It "Output.Header" {
            $Data.Header | Should -Be ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL")
        }
        Context "Output.Unreleased.Data" {
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
        It "Output.Unreleased.Link" {
            $Data.Unreleased.Link | Should -Be "https://github.com/testuser/testrepo/compare/v1.0.0..HEAD"
        }
        It "Output.Unreleased.RawData" {
            $Data.Unreleased.RawData | Should -Be ("## [Unreleased]$NL" +
                "### Added$NL" +
                "- Unreleased Addition 1$NL" +
                "- Unreleased Addition 2$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Unreleased Change 1$NL" +
                "- Unreleased Change 2$NL" +
                "$NL" +
                "### Deprecated$NL" +
                "- Unreleased Deprecation 1$NL" +
                "- Unreleased Deprecation 2$NL" +
                "$NL" +
                "### Removed$NL" +
                "- Unreleased Removal 1$NL" +
                "- Unreleased Removal 2$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Unreleased Fix 1$NL" +
                "- Unreleased Fix 2$NL" +
                "$NL" +
                "### Security$NL" +
                "- Unreleased Vulnerability 1$NL" +
                "- Unreleased Vulnerability 2$NL" +
                "$NL")
        }
        It "Output.Released.RawData" {
            $Data.Released.RawData | Should -Be @(("## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Released Addition 1$NL" +
                "- Released Addition 2$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Released Change 1$NL" +
                "- Released Change 2$NL" +
                "$NL" +
                "### Deprecated$NL" +
                "- Released Deprecation 1$NL" +
                "- Released Deprecation 2$NL" +
                "$NL" +
                "### Removed$NL" +
                "- Released Removal 1$NL" +
                "- Released Removal 2$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Released Fix 1$NL" +
                "- Released Fix 2$NL" +
                "$NL" +
                "### Security$NL" +
                "- Released Vulnerability 1$NL" +
                "- Released Vulnerability 2$NL" +
                "$NL"),
                ("## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL"))
        }
        It "Output.Released.Date" {
            $Data.Released.Date | Should -Be @((Get-Date "1/1/2001 12:00:00 AM"),
                (Get-Date "1/1/2000 12:00:00 AM"))
        }
        It "Output.Released.Version" {
            $Data.Released.Version | Should -Be @("1.1.0","1.0.0")
        }
        It "Output.Released.Link" {
            $Data.Released.Link | Should -Be @("https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0",
                "https://github.com/testuser/testrepo/tree/v1.0.0")
        }
        Context "Output.Released[0].Data" {
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
        Context "Output.Released[1].Data" {
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
        It "Output.Footer" {
            $Data.Footer | Should -Be ("[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        }
        It "Output.LastVersion" {
            $Data.LastVersion | Should -Be "1.1.0"
        }
        Context "Missing Unreleased Section" {
            BeforeAll {
                $TestPathNoUnreleased = "TestDrive:\CHANGELOGNOUNRELEASED.md"
                $SeedDataNoUnreleased = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "- Released Addition 2$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "- Released Change 2$NL" +
                    "$NL" +
                    "### Deprecated$NL" +
                    "- Released Deprecation 1$NL" +
                    "- Released Deprecation 2$NL" +
                    "$NL" +
                    "### Removed$NL" +
                    "- Released Removal 1$NL" +
                    "- Released Removal 2$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "- Released Fix 2$NL" +
                    "$NL" +
                    "### Security$NL" +
                    "- Released Vulnerability 1$NL" +
                    "- Released Vulnerability 2$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")

                Set-Content -Value $SeedDataNoUnreleased -Path $TestPathNoUnreleased -NoNewline
                $DataNoUnreleased = Get-ChangelogData -Path $TestPathNoUnreleased
            }
            It "Data.Unreleased" {
                $DataNoUnreleased.Unreleased | Should -BeNullOrEmpty
            }
        }
        It "Output.ReleaseNotes" {
            $Data.ReleaseNotes | Should -Be ("### Added$NL" +
                    "- Released Addition 1$NL" +
                    "- Released Addition 2$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "- Released Change 2$NL" +
                    "$NL" +
                    "### Deprecated$NL" +
                    "- Released Deprecation 1$NL" +
                    "- Released Deprecation 2$NL" +
                    "$NL" +
                    "### Removed$NL" +
                    "- Released Removal 1$NL" +
                    "- Released Removal 2$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "- Released Fix 2$NL" +
                    "$NL" +
                    "### Security$NL" +
                    "- Released Vulnerability 1$NL" +
                    "- Released Vulnerability 2")
        }
        Context "Different Newline Encodings" {
            It "Changelog with Linux/macOS Newlines" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog`n" +
                    "All notable changes to this project will be documented in this file.`n" +
                    "`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`n" +
                    "`n" +
                    "## [Unreleased]`n" +
                    "### Added`n" +
                    "- Unreleased Addition 1`n" +
                    "`n")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $Result = Get-ChangelogData -Path $TestPath

                $Result.Unreleased.Data.Added | Should -Be "Unreleased Addition 1"
            }
            It "Changelog with Windows Newlines" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog`r`n" +
                    "All notable changes to this project will be documented in this file.`r`n" +
                    "`r`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`r`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`r`n" +
                    "`r`n" +
                    "## [Unreleased]`r`n" +
                    "### Added`r`n" +
                    "- Unreleased Addition 1`r`n" +
                    "`r`n")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $Result = Get-ChangelogData -Path $TestPath

                $Result.Unreleased.Data.Added | Should -Be "Unreleased Addition 1"
            }
        }
    }

    Describe "Add-ChangelogData" {
        BeforeAll {
            $TestPath = "TestDrive:\CHANGELOG.md"
            $SeedData = ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "### Added$NL" +
                "- Unreleased Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Unreleased Change 1$NL" +
                "$NL" +
                "### Deprecated$NL" +
                "- Unreleased Deprecation 1$NL" +
                "$NL" +
                "### Removed$NL" +
                "- Unreleased Removal 1$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Unreleased Fix 1$NL" +
                "$NL" +
                "### Security$NL" +
                "- Unreleased Vulnerability 1$NL" +
                "$NL" +
                "## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Released Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Released Change 1$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Released Fix 1$NL" +
                "$NL" +
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            $SeedDataPartiallyPopulatedAdded = ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "### Added$NL" +
                "- Unreleased Addition 1$NL" +
                "$NL" +
                "## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Released Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Released Change 1$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Released Fix 1$NL" +
                "$NL" +
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            $SeedDataPartiallyPopulatedChanged = ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "### Changed$NL" +
                "- Unreleased Change 1$NL" +
                "$NL" +
                "## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Released Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Released Change 1$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Released Fix 1$NL" +
                "$NL" +
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            $SeedDataUnpopulated = ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "$NL" +
                "## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Released Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Released Change 1$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Released Fix 1$NL" +
                "$NL" +
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        }
        Context "Populated Source -Type" {
            It "Added" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Added" -Data "Unreleased Addition 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 2$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Unreleased Change 1$NL" +
                    "$NL" +
                    "### Deprecated$NL" +
                    "- Unreleased Deprecation 1$NL" +
                    "$NL" +
                    "### Removed$NL" +
                    "- Unreleased Removal 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Unreleased Fix 1$NL" +
                    "$NL" +
                    "### Security$NL" +
                    "- Unreleased Vulnerability 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Changed" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Changed" -Data "Unreleased Change 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Unreleased Change 2$NL" +
                    "- Unreleased Change 1$NL" +
                    "$NL" +
                    "### Deprecated$NL" +
                    "- Unreleased Deprecation 1$NL" +
                    "$NL" +
                    "### Removed$NL" +
                    "- Unreleased Removal 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Unreleased Fix 1$NL" +
                    "$NL" +
                    "### Security$NL" +
                    "- Unreleased Vulnerability 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Deprecated" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Deprecated" -Data "Unreleased Deprecation 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Unreleased Change 1$NL" +
                    "$NL" +
                    "### Deprecated$NL" +
                    "- Unreleased Deprecation 2$NL" +
                    "- Unreleased Deprecation 1$NL" +
                    "$NL" +
                    "### Removed$NL" +
                    "- Unreleased Removal 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Unreleased Fix 1$NL" +
                    "$NL" +
                    "### Security$NL" +
                    "- Unreleased Vulnerability 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Removed" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Removed" -Data "Unreleased Removal 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Unreleased Change 1$NL" +
                    "$NL" +
                    "### Deprecated$NL" +
                    "- Unreleased Deprecation 1$NL" +
                    "$NL" +
                    "### Removed$NL" +
                    "- Unreleased Removal 2$NL" +
                    "- Unreleased Removal 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Unreleased Fix 1$NL" +
                    "$NL" +
                    "### Security$NL" +
                    "- Unreleased Vulnerability 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Fixed" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Fixed" -Data "Unreleased Fix 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Unreleased Change 1$NL" +
                    "$NL" +
                    "### Deprecated$NL" +
                    "- Unreleased Deprecation 1$NL" +
                    "$NL" +
                    "### Removed$NL" +
                    "- Unreleased Removal 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Unreleased Fix 2$NL" +
                    "- Unreleased Fix 1$NL" +
                    "$NL" +
                    "### Security$NL" +
                    "- Unreleased Vulnerability 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Security" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Security" -Data "Unreleased Vulnerability 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Unreleased Change 1$NL" +
                    "$NL" +
                    "### Deprecated$NL" +
                    "- Unreleased Deprecation 1$NL" +
                    "$NL" +
                    "### Removed$NL" +
                    "- Unreleased Removal 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Unreleased Fix 1$NL" +
                    "$NL" +
                    "### Security$NL" +
                    "- Unreleased Vulnerability 2$NL" +
                    "- Unreleased Vulnerability 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
        }
        Context "Unpopulated Source -Type" {
            It "Added" {
                Set-Content -Value $SeedDataUnpopulated -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Added" -Data "Unreleased Addition 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Changed" {
                Set-Content -Value $SeedDataUnpopulated -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Changed" -Data "Unreleased Change 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Changed$NL" +
                    "- Unreleased Change 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Deprecated" {
                Set-Content -Value $SeedDataUnpopulated -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Deprecated" -Data "Unreleased Deprecation 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Deprecated$NL" +
                    "- Unreleased Deprecation 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Removed" {
                Set-Content -Value $SeedDataUnpopulated -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Removed" -Data "Unreleased Removal 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Removed$NL" +
                    "- Unreleased Removal 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Fixed" {
                Set-Content -Value $SeedDataUnpopulated -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Fixed" -Data "Unreleased Fix 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Fixed$NL" +
                    "- Unreleased Fix 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Security" {
                Set-Content -Value $SeedDataUnpopulated -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Security" -Data "Unreleased Vulnerability 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Security$NL" +
                    "- Unreleased Vulnerability 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
        }
        Context "Partially Populated Source -Type" {
            It "Added" {
                Set-Content -Value $SeedDataPartiallyPopulatedChanged -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Added" -Data "Unreleased Addition 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 2$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Unreleased Change 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Changed" {
                Set-Content -Value $SeedDataPartiallyPopulatedAdded -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Changed" -Data "Unreleased Change 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Unreleased Change 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Deprecated" {
                Set-Content -Value $SeedDataPartiallyPopulatedAdded -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Deprecated" -Data "Unreleased Deprecation 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Deprecated$NL" +
                    "- Unreleased Deprecation 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Removed" {
                Set-Content -Value $SeedDataPartiallyPopulatedAdded -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Removed" -Data "Unreleased Removal 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Removed$NL" +
                    "- Unreleased Removal 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Fixed" {
                Set-Content -Value $SeedDataPartiallyPopulatedAdded -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Fixed" -Data "Unreleased Fix 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Unreleased Fix 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Security" {
                Set-Content -Value $SeedDataPartiallyPopulatedAdded -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type "Security" -Data "Unreleased Vulnerability 2"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "### Security$NL" +
                    "- Unreleased Vulnerability 2$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Released Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Released Change 1$NL" +
                    "$NL" +
                    "### Fixed$NL" +
                    "- Released Fix 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
        }
        It "-OutputPath" {
            Set-Content -Value $SeedData -Path $TestPath -NoNewline
            $TestPath2 = "TestDrive:\CHANGELOG2.md"

            Add-ChangelogData -Path $TestPath -Type "Added" -Data "Unreleased Addition 2" -OutputPath $TestPath2

            $Result = Get-Content -Path $TestPath2 -Raw

            $Result | Should -Be ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "### Added$NL" +
                "- Unreleased Addition 2$NL" +
                "- Unreleased Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Unreleased Change 1$NL" +
                "$NL" +
                "### Deprecated$NL" +
                "- Unreleased Deprecation 1$NL" +
                "$NL" +
                "### Removed$NL" +
                "- Unreleased Removal 1$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Unreleased Fix 1$NL" +
                "$NL" +
                "### Security$NL" +
                "- Unreleased Vulnerability 1$NL" +
                "$NL" +
                "## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Released Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Released Change 1$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Released Fix 1$NL" +
                "$NL" +
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        }
        Context "Different Newline Encodings" {
            It "Changelog with Linux/macOS Newlines - Added" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog`n" +
                    "All notable changes to this project will be documented in this file.`n" +
                    "`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`n" +
                    "`n" +
                    "## [Unreleased]`n" +
                    "### Added`n" +
                    "- Unreleased Addition 1`n" +
                    "`n")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type Added -Data "Unreleased Addition 2"

                $Result = Get-Content -Path $TestPath -Raw

                $ExpectedResult = ("# Changelog`n" +
                    "All notable changes to this project will be documented in this file.`n" +
                    "`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`n" +
                    "`n" +
                    "## [Unreleased]`n" +
                    "### Added`n" +
                    "- Unreleased Addition 2`n" +
                    "- Unreleased Addition 1`n" +
                    "`n")

                $Result | Should -Be $ExpectedResult
            }
            It "Changelog with Linux/macOS Newlines - Changed" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog`n" +
                    "All notable changes to this project will be documented in this file.`n" +
                    "`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`n" +
                    "`n" +
                    "## [Unreleased]`n" +
                    "### Added`n" +
                    "- Unreleased Addition 1`n" +
                    "`n")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type Changed -Data "Unreleased Change 1"

                $Result = Get-Content -Path $TestPath -Raw

                $ExpectedResult = ("# Changelog`n" +
                    "All notable changes to this project will be documented in this file.`n" +
                    "`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`n" +
                    "`n" +
                    "## [Unreleased]`n" +
                    "### Added`n" +
                    "- Unreleased Addition 1`n" +
                    "`n" +
                    "### Changed`n" +
                    "- Unreleased Change 1`n" +
                    "`n")

                $Result | Should -Be $ExpectedResult
            }
            It "Changelog with Windows Newlines - Added" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog`r`n" +
                    "All notable changes to this project will be documented in this file.`r`n" +
                    "`r`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`r`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`r`n" +
                    "`r`n" +
                    "## [Unreleased]`r`n" +
                    "### Added`r`n" +
                    "- Unreleased Addition 1`r`n" +
                    "`r`n")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type Added -Data "Unreleased Addition 2"

                $Result = Get-Content -Path $TestPath -Raw

                $ExpectedResult = ("# Changelog`r`n" +
                    "All notable changes to this project will be documented in this file.`r`n" +
                    "`r`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`r`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`r`n" +
                    "`r`n" +
                    "## [Unreleased]`r`n" +
                    "### Added`r`n" +
                    "- Unreleased Addition 2`r`n" +
                    "- Unreleased Addition 1`r`n" +
                    "`r`n")

                $Result | Should -Be $ExpectedResult
            }
            It "Changelog with Windows Newlines - Changed" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog`r`n" +
                    "All notable changes to this project will be documented in this file.`r`n" +
                    "`r`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`r`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`r`n" +
                    "`r`n" +
                    "## [Unreleased]`r`n" +
                    "### Added`r`n" +
                    "- Unreleased Addition 1`r`n" +
                    "`r`n")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Add-ChangelogData -Path $TestPath -Type Changed -Data "Unreleased Change 1"

                $Result = Get-Content -Path $TestPath -Raw

                $ExpectedResult = ("# Changelog`r`n" +
                    "All notable changes to this project will be documented in this file.`r`n" +
                    "`r`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`r`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`r`n" +
                    "`r`n" +
                    "## [Unreleased]`r`n" +
                    "### Added`r`n" +
                    "- Unreleased Addition 1`r`n" +
                    "`r`n" +
                    "### Changed`r`n" +
                    "- Unreleased Change 1`r`n" +
                    "`r`n")

                $Result | Should -Be $ExpectedResult
            }
        }
    }

    Describe "New-Changelog" {
        It "No Parameters" {
            $TestPath = "TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath

            $Result = Get-Content -Path $TestPath -Raw

            $Result | Should -Be ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL")
        }
        It "-NoSemVer" {
            $TestPath = "TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath -NoSemVer
            $Result = Get-Content -Path $TestPath -Raw

            $Result | Should -Be ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL")
        }
        It "-NoInitialChange" {
            $TestPath = "TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath -NoInitialChange
            $Result = Get-Content -Path $TestPath -Raw

            $Result | Should -Be ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL")
        }
    }

    Describe "Update-Changelog" {
        Context "-LinkMode Automatic" {
            It "Missing -LinkPattern" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL")
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $UCSplat = @{
                    Path           = $TestPath
                    ReleaseVersion = "1.0.0"
                    LinkMode       = "Automatic"
                }
                { Update-Changelog @UCSplat } | Should  -Throw
            }
            It "First Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL")

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

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.0.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Second Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
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

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.1.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.1.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Third Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
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

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.2.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +,
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.2.0..HEAD$NL" +
                    "[1.2.0]: https://github.com/testuser/testrepo/compare/v1.1.0..v1.2.0$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
        }
        Context "-LinkMode Manual" {
            It "First Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -LinkMode Manual

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.0.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "[Unreleased]: ENTER-URL-HERE$NL" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
            It "Second Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: ENTER-URL-HERE$NL" +
                    "[1.0.0]: ENTER-URL-HERE")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.1.0" -LinkMode Manual

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.1.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: ENTER-URL-HERE$NL" +
                    "[1.1.0]: ENTER-URL-HERE$NL" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
            It "Third Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: ENTER-URL-HERE$NL" +
                    "[1.1.0]: ENTER-URL-HERE$NL" +
                    "[1.0.0]: ENTER-URL-HERE")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.2.0" -LinkMode Manual

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.2.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +,
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: ENTER-URL-HERE$NL" +
                    "[1.2.0]: ENTER-URL-HERE$NL" +
                    "[1.1.0]: ENTER-URL-HERE$NL" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
        }
        Context "-LinkMode None" {
            It "First Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "### Added$NL" +
                    "$NL" +
                    "- Unreleased Addition 1$NL")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -LinkMode None

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.0.0] - $Today$NL" +
                    "$NL" +
                    "### Added$NL" +
                    "$NL" +
                    "- Unreleased Addition 1$NL")
            }
            It "Second Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: ENTER-URL-HERE$NL" +
                    "[1.0.0]: ENTER-URL-HERE")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.1.0" -LinkMode None

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.1.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: ENTER-URL-HERE$NL" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
            It "Third Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: ENTER-URL-HERE$NL" +
                    "[1.1.0]: ENTER-URL-HERE$NL" +
                    "[1.0.0]: ENTER-URL-HERE")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.2.0" -LinkMode None

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.2.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +,
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: ENTER-URL-HERE$NL" +
                    "[1.1.0]: ENTER-URL-HERE$NL" +
                    "[1.0.0]: ENTER-URL-HERE")
            }
        }
        Context "-LinkMode GitHub" {
            BeforeAll {
                $env:GITHUB_REPOSITORY_BACKUP = $env:GITHUB_REPOSITORY
                $env:GITHUB_REPOSITORY = "testuser/testrepo"
            }
            It "First Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $UCSplat = @{
                    Path           = $TestPath
                    ReleaseVersion = "1.0.0"
                    LinkMode       = "GitHub"
                }
                Update-Changelog @UCSplat

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.0.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Second Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $UCSplat = @{
                    Path           = $TestPath
                    ReleaseVersion = "1.1.0"
                    LinkMode       = "GitHub"
                }

                Update-Changelog @UCSplat

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.1.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.1.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Third Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $UCSplat = @{
                    Path           = $TestPath
                    ReleaseVersion = "1.2.0"
                    LinkMode       = "GitHub"
                }

                Update-Changelog @UCSplat

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.2.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" + ,
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.2.0..HEAD$NL" +
                    "[1.2.0]: https://github.com/testuser/testrepo/compare/v1.1.0..v1.2.0$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            AfterAll {
                $env:GITHUB_REPOSITORY = $env:GITHUB_REPOSITORY_BACKUP
            }
        }
        Context "-LinkMode AzureDevOps" {
            BeforeAll {
                $env:SYSTEM_TASKDEFINITIONSURI = "https://dev.azure.com/testcompany/"
                $env:SYSTEM_TEAMPROJECT = "testproject"
                $env:BUILD_REPOSITORY_NAME = "testrepo"
            }
            It "First Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $UCSplat = @{
                    Path           = $TestPath
                    ReleaseVersion = "1.0.0"
                    LinkMode       = "AzureDevOps"
                }
                Update-Changelog @UCSplat

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.0.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "[Unreleased]: https://dev.azure.com/testcompany/testproject/_git/testrepo/branchCompare?baseVersion=GTv1.0.0&targetVersion=GBmain&_a=commits$NL" +
                    "[1.0.0]: https://dev.azure.com/testcompany/testproject/_git/testrepo?version=GTv1.0.0")
            }
            It "Second Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://dev.azure.com/testcompany/testproject/_git/testrepo/branchCompare?baseVersion=GTv1.0.0&targetVersion=GBmain&_a=commits$NL" +
                    "[1.0.0]: https://dev.azure.com/testcompany/testproject/_git/testrepo?version=GTv1.0.0")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $UCSplat = @{
                    Path           = $TestPath
                    ReleaseVersion = "1.1.0"
                    LinkMode       = "AzureDevOps"
                }

                Update-Changelog @UCSplat

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.1.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://dev.azure.com/testcompany/testproject/_git/testrepo/branchCompare?baseVersion=GTv1.1.0&targetVersion=GBmain&_a=commits$NL" +
                    "[1.1.0]: https://dev.azure.com/testcompany/testproject/_git/testrepo/branchCompare?baseVersion=GTv1.0.0&targetVersion=GTv1.1.0&_a=commits$NL" +
                    "[1.0.0]: https://dev.azure.com/testcompany/testproject/_git/testrepo?version=GTv1.0.0")
            }
            It "Third Release" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://dev.azure.com/testcompany/testproject/_git/testrepo/branchCompare?baseVersion=GTv1.1.0&targetVersion=GBmain&_a=commits$NL" +
                    "[1.1.0]: https://dev.azure.com/testcompany/testproject/_git/testrepo/branchCompare?baseVersion=GTv1.0.0&targetVersion=GTv1.1.0&_a=commits$NL" +
                    "[1.0.0]: https://dev.azure.com/testcompany/testproject/_git/testrepo?version=GTv1.0.0")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                $UCSplat = @{
                    Path           = $TestPath
                    ReleaseVersion = "1.2.0"
                    LinkMode       = "AzureDevOps"
                }

                Update-Changelog @UCSplat

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [Unreleased]$NL" +
                    "$NL" +
                    "## [1.2.0] - $Today$NL" +
                    "### Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" + ,
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[Unreleased]: https://dev.azure.com/testcompany/testproject/_git/testrepo/branchCompare?baseVersion=GTv1.2.0&targetVersion=GBmain&_a=commits$NL" +
                    "[1.2.0]: https://dev.azure.com/testcompany/testproject/_git/testrepo/branchCompare?baseVersion=GTv1.1.0&targetVersion=GTv1.2.0&_a=commits$NL" +
                    "[1.1.0]: https://dev.azure.com/testcompany/testproject/_git/testrepo/branchCompare?baseVersion=GTv1.0.0&targetVersion=GTv1.1.0&_a=commits$NL" +
                    "[1.0.0]: https://dev.azure.com/testcompany/testproject/_git/testrepo?version=GTv1.0.0")
            }
        }
        It "-OutputPath" {
            $TestPath = "TestDrive:\CHANGELOG.md"
            $TestPath2 = "TestDrive:\CHANGELOG2.md"

            $SeedData = ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "### Added$NL" +
                "- Unreleased Addition 1$NL")

            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -OutputPath $TestPath2 -LinkMode None

            $Result = Get-Content -Path $TestPath2 -Raw

            $Result | Should -Be ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "$NL" +
                "## [1.0.0] - $Today$NL" +
                "### Added$NL" +
                "- Unreleased Addition 1$NL")
        }
        It "No Changes" {
            $TestPath = "TestDrive:\CHANGELOG.md"

            $SeedData = ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL")

            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            { Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -LinkMode None } | Should -Throw
        }
        Context "Different Newline Encodings" {
            It "Changelog with Linux/macOS Newlines" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog`n" +
                    "All notable changes to this project will be documented in this file.`n" +
                    "`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`n" +
                    "`n" +
                    "## [Unreleased]`n" +
                    "### Added`n" +
                    "- Unreleased Addition 1`n" +
                    "`n")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -LinkMode None

                $Result = Get-Content -Path $TestPath -Raw

                $ExpectedResult = ("# Changelog`n" +
                    "All notable changes to this project will be documented in this file.`n" +
                    "`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`n" +
                    "`n" +
                    "## [Unreleased]`n" +
                    "`n" +
                    "## [1.0.0] - $Today`n" +
                    "### Added`n" +
                    "- Unreleased Addition 1`n" +
                    "`n")

                $Result | Should -Be $ExpectedResult
            }
            It "Changelog with Windows Newlines" {
                $TestPath = "TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog`r`n" +
                    "All notable changes to this project will be documented in this file.`r`n" +
                    "`r`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`r`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`r`n" +
                    "`r`n" +
                    "## [Unreleased]`r`n" +
                    "### Added`r`n" +
                    "- Unreleased Addition 1`r`n" +
                    "`r`n")

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0" -LinkMode None

                $Result = Get-Content -Path $TestPath -Raw

                $ExpectedResult = ("# Changelog`r`n" +
                    "All notable changes to this project will be documented in this file.`r`n" +
                    "`r`n" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),`r`n" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).`r`n" +
                    "`r`n" +
                    "## [Unreleased]`r`n" +
                    "`r`n" +
                    "## [1.0.0] - $Today`r`n" +
                    "### Added`r`n" +
                    "- Unreleased Addition 1`r`n" +
                    "`r`n")

                $Result | Should -Be $ExpectedResult
            }
        }
    }

    Describe "ConvertFrom-Changelog" {
        BeforeAll {
            $TestPath = "TestDrive:\CHANGELOG.md"

            $SeedData = ("# Changelog$NL" +
                "All notable changes to this project will be documented in this file.$NL" +
                "$NL" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                "$NL" +
                "## [Unreleased]$NL" +
                "### Added$NL" +
                "- Unreleased Addition 1$NL" +
                "$NL" +
                "## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Change 1$NL" +
                "$NL" +
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        }
        Context "-Format" {
            It "Release" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "Release"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("# Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Text" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "Text"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on Keep a Changelog (https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to Semantic Versioning (https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "[Unreleased]$NL" +
                    "Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "[1.1.0] - 2001-01-01$NL" +
                    "Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "[1.0.0] - 2000-01-01$NL" +
                    "Added$NL" +
                    "- Initial release")
            }
            It "TextRelease" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "TextRelease"

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("Changelog$NL" +
                    "All notable changes to this project will be documented in this file.$NL" +
                    "$NL" +
                    "The format is based on Keep a Changelog (https://keepachangelog.com/en/1.0.0/),$NL" +
                    "and this project adheres to Semantic Versioning (https://semver.org/spec/v2.0.0.html).$NL" +
                    "$NL" +
                    "[1.1.0] - 2001-01-01$NL" +
                    "Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "[1.0.0] - 2000-01-01$NL" +
                    "Added$NL" +
                    "- Initial release")
            }
        }
        Context "-NoHeader" {
            It "Release" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "Release" -NoHeader

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("## [1.1.0] - 2001-01-01$NL" +
                    "### Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "### Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "## [1.0.0] - 2000-01-01$NL" +
                    "### Added$NL" +
                    "- Initial release$NL" +
                    "$NL" +
                    "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                    "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
            }
            It "Text" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "Text" -NoHeader

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("[Unreleased]$NL" +
                    "Added$NL" +
                    "- Unreleased Addition 1$NL" +
                    "$NL" +
                    "[1.1.0] - 2001-01-01$NL" +
                    "Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "[1.0.0] - 2000-01-01$NL" +
                    "Added$NL" +
                    "- Initial release")
            }
            It "TextRelease" {
                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Convertfrom-Changelog -Path $TestPath -Format "TextRelease" -NoHeader

                $Result = Get-Content -Path $TestPath -Raw

                $Result | Should -Be ("[1.1.0] - 2001-01-01$NL" +
                    "Added$NL" +
                    "- Addition 1$NL" +
                    "$NL" +
                    "Changed$NL" +
                    "- Change 1$NL" +
                    "$NL" +
                    "[1.0.0] - 2000-01-01$NL" +
                    "Added$NL" +
                    "- Initial release")
            }
        }
        It "-OutputPath" {
            $TestPath2 = "TestDrive:\CHANGELOG2.md"

            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Convertfrom-Changelog -Path $TestPath -Format "Release" -NoHeader -OutputPath $TestPath2

            $Result = Get-Content -Path $TestPath2 -Raw

            $Result | Should -Be ("## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Change 1$NL" +
                "$NL" +
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        }
    }
}
