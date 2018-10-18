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

    function Get-ContentWithBlankLinesAsString {
        param([string]$Path)

        [System.Collections.ArrayList]$ResultArrayList = Get-Content $Path

        if ($ResultArrayList[-1] -eq "") {
            $ResultArrayList[-1] = $Eol
        }

        $ResultArrayList -join $Eol
    }

    Describe 'Module Manifest Tests' {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty
            $? | Should -Be $true
        }
    }

    Describe "Get-ChangelogData" {
        $TestPath="TestDrive:\CHANGELOG.md"
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

        It "Header" {
            $Data.Header | Should -Be ("# Changelog$Eol" +
                "All notable changes to this project will be documented in this file.$Eol" +
                "$Eol" +
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol" +
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol" +
                "$Eol")
        }
        Context "Unreleased.Data" {
            It "Added" {
                $Data.Unreleased.Data.Added | Should -Be @("Unreleased Addition 1", "Unreleased Addition 2")
            }
            It "Changed" {
                $Data.Unreleased.Data.Changed | Should -Be @("Unreleased Change 1", "Unreleased Change 2")
            }
            It "Deprecated" {
                $Data.Unreleased.Data.Deprecated | Should -Be @("Unreleased Deprecation 1", "Unreleased Deprecation 2")
            }
            It "Removed" {
                $Data.Unreleased.Data.Removed | Should -Be @("Unreleased Removal 1", "Unreleased Removal 2")
            }
            It "Fixed" {
                $Data.Unreleased.Data.Fixed | Should -Be @("Unreleased Fix 1", "Unreleased Fix 2")
            }
            It "Security" {
                $Data.Unreleased.Data.Security | Should -Be @("Unreleased Vulnerability 1", "Unreleased Vulnerability 2")
            }
        }
        It "Unreleased.Link" {
            $Data.Unreleased.Link | Should -Be "https://github.com/testuser/testrepo/compare/v1.0.0..HEAD"
        }
        It "Unreleased.RawData" {
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
        It "Released.RawData" {
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
        It "Released.Date" {
            $Data.Released.Date | Should -Be @((Get-Date "1/1/2001 12:00:00 AM"),
                (Get-Date "1/1/2000 12:00:00 AM"))
        }
        It "Released.Version" {
            $Data.Released.Version | Should -Be @("1.1.0","1.0.0")
        }
        It "Released.Link" {
            $Data.Released.Link | Should -Be @("https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0",
                "https://github.com/testuser/testrepo/tree/v1.0.0")
        }
        Context "Released[0].Data" {
            It "Added" {
                $Data.Released[0].Data.Added | Should -Be @("Released Addition 1", "Released Addition 2")
            }
            It "Changed" {
                $Data.Released[0].Data.Changed | Should -Be @("Released Change 1", "Released Change 2")
            }
            It "Deprecated" {
                $Data.Released[0].Data.Deprecated | Should -Be @("Released Deprecation 1", "Released Deprecation 2")
            }
            It "Removed" {
                $Data.Released[0].Data.Removed | Should -Be @("Released Removal 1", "Released Removal 2")
            }
            It "Fixed" {
                $Data.Released[0].Data.Fixed | Should -Be @("Released Fix 1", "Released Fix 2")
            }
            It "Security" {
                $Data.Released[0].Data.Security | Should -Be @("Released Vulnerability 1", "Released Vulnerability 2")
            }
        }
        Context "Released[1].Data" {
            It "Added" {
                $Data.Released[1].Data.Added | Should -Be "Initial release"
            }
            It "Changed" {
                $Data.Released[1].Data.Changed | Should -BeNullOrEmpty
            }
            It "Deprecated" {
                $Data.Released[1].Data.Deprecated | Should -BeNullOrEmpty
            }
            It "Removed" {
                $Data.Released[1].Data.Removed | Should -BeNullOrEmpty
            }
            It "Fixed" {
                $Data.Released[1].Data.Fixed | Should -BeNullOrEmpty
            }
            It "Security" {
                $Data.Released[1].Data.Security | Should -BeNullOrEmpty
            }
        }
        It "Footer" {
            $Data.Footer | Should -Be ("[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$Eol" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
        }
        It "LastVersion" {
            $Data.LastVersion | Should -Be "1.1.0"
        }
    }

    Describe "Add-ChangelogData" {
        $TestPath="TestDrive:\CHANGELOG.md"
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
        It "Added" {
            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Throw

            $Result = Get-ContentWithBlankLinesAsString -Path $TestPath
        }
        It "Changed" {
            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Throw

            $Result = Get-ContentWithBlankLinesAsString -Path $TestPath
        }
        It "Deprecated" {
            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Throw

            $Result = Get-ContentWithBlankLinesAsString -Path $TestPath
        }
        It "Removed" {
            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Throw

            $Result = Get-ContentWithBlankLinesAsString -Path $TestPath
        }
        It "Fixed" {
            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Throw

            $Result = Get-ContentWithBlankLinesAsString -Path $TestPath
        }
        It "Security" {
            Set-Content -Value $SeedData -Path $TestPath -NoNewline

            Throw

            $Result = Get-ContentWithBlankLinesAsString -Path $TestPath
        }
    }

    Describe "New-Changelog" {
        It "No Parameters" {
            $TestPath="TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath

            $Result = Get-ContentWithBlankLinesAsString -Path $TestPath

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
                "$Eol")
        }
        It "-NoSemVer" {
            $TestPath="TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath -NoSemVer
            $Result = Get-ContentWithBlankLinesAsString -Path $TestPath

            $Result | Should -Be ("# Changelog$Eol" +
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
                "$Eol")
        }
    }

    Describe "Update-Changelog" {
        Context "Mandatory Parameters" {
            It "First Release" {
                $TestPath="TestDrive:\CHANGELOG.md"
                New-Changelog -Path $TestPath

                Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0"

                $Result = Get-ContentWithBlankLinesAsString -Path $TestPath

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
                    "$Eol" +
                    "[Unreleased]: https://REPLACE-DOMAIN.com/REPLACE-USERNAME/REPLACE-REPONAME/compare/1.0.0..HEAD$Eol" +
                    "[1.0.0]: https://REPLACE-DOMAIN.com/REPLACE-USERNAME/REPLACE-REPONAME/tree/1.0.0")
            }
            It "Second Release" {
                $TestPath="TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
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

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.1.0"

                $Result = Get-ContentWithBlankLinesAsString -Path $TestPath

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
                $TestPath="TestDrive:\CHANGELOG.md"

                $SeedData = ("# Changelog$Eol" +
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

                Set-Content -Value $SeedData -Path $TestPath -NoNewline

                Update-Changelog -Path $TestPath -ReleaseVersion "1.2.0"

                $Result = Get-ContentWithBlankLinesAsString -Path $TestPath

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
    }
}