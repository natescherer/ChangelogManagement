BeforeAll {
    $ProjectRoot = Split-Path $(Split-Path $PSScriptRoot -Parent) -Parent
    $ModuleName = $(Get-ChildItem -Path (Join-Path $ProjectRoot "src") -Filter "*.psm1").Name.Replace(".psm1", "")
    $ModulePath = Join-Path $(Join-Path $ProjectRoot "src") "$ModuleName.psm1"

    Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
    Import-Module -Name $ModulePath -Force -ErrorAction Stop

    $NL = [System.Environment]::NewLine
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
            "$NL" +
            "### Changed$NL" +
            "- Unreleased Change 1$NL" +
            "- Unreleased Change 2$NL" +
            "$NL" +
            "### Deprecated$NL" +
            "- Unreleased Deprecation 1$NL" +
            "- Unreleased Deprecation 2$NL" +
            "- Unreleased Deprecation 3$NL" +
            "$NL" +
            "### Removed$NL" +
            "- Unreleased Removal 1$NL" +
            "- Unreleased Removal 2$NL" +
            "- Unreleased Removal 3$NL" +
            "- Unreleased Removal 4$NL" +
            "$NL" +
            "### Fixed$NL" +
            "- Unreleased Fix 1$NL" +
            "- Unreleased Fix 2$NL" +
            "- Unreleased Fix 3$NL" +
            "- Unreleased Fix 4$NL" +
            "- Unreleased Fix 5$NL" +
            "$NL" +
            "### Security$NL" +
            "- Unreleased Vulnerability 1$NL" +
            "- Unreleased Vulnerability 2$NL" +
            "- Unreleased Vulnerability 3$NL" +
            "- Unreleased Vulnerability 4$NL" +
            "- Unreleased Vulnerability 5$NL" +
            "- Unreleased Vulnerability 6$NL" +
            "$NL" +
            "## [1.1.0] - 2001-01-01$NL" +
            "### Added$NL" +
            "- Released Addition 1$NL" +
            "$NL" +
            "### Changed$NL" +
            "- Released Change 1$NL" +
            "- Released Change 2$NL" +
            "$NL" +
            "### Deprecated$NL" +
            "- Released Deprecation 1$NL" +
            "- Released Deprecation 2$NL" +
            "- Released Deprecation 3$NL" +
            "$NL" +
            "### Removed$NL" +
            "- Released Removal 1$NL" +
            "- Released Removal 2$NL" +
            "- Released Removal 3$NL" +
            "- Released Removal 4$NL" +
            "$NL" +
            "### Fixed$NL" +
            "- Released Fix 1$NL" +
            "- Released Fix 2$NL" +
            "- Released Fix 3$NL" +
            "- Released Fix 4$NL" +
            "- Released Fix 5$NL" +
            "$NL" +
            "### Security$NL" +
            "- Released Vulnerability 1$NL" +
            "- Released Vulnerability 2$NL" +
            "- Released Vulnerability 3$NL" +
            "- Released Vulnerability 4$NL" +
            "- Released Vulnerability 5$NL" +
            "- Released Vulnerability 6$NL" +
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
        It "Added" {
            $Data.Unreleased.Data.Added | Should -Be @("Unreleased Addition 1")
        }
        It "Changed" {
            $Data.Unreleased.Data.Changed | Should -Be @("Unreleased Change 1", "Unreleased Change 2")
        }
        It "Deprecated" {
            $Data.Unreleased.Data.Deprecated | Should -Be @("Unreleased Deprecation 1", "Unreleased Deprecation 2", "Unreleased Deprecation 3")
        }
        It "Removed" {
            $Data.Unreleased.Data.Removed | Should -Be @("Unreleased Removal 1", "Unreleased Removal 2", "Unreleased Removal 3", "Unreleased Removal 4")
        }
        It "Fixed" {
            $Data.Unreleased.Data.Fixed | Should -Be @("Unreleased Fix 1", "Unreleased Fix 2", "Unreleased Fix 3", "Unreleased Fix 4", "Unreleased Fix 5")
        }
        It "Security" {
            $Data.Unreleased.Data.Security | Should -Be @("Unreleased Vulnerability 1", "Unreleased Vulnerability 2", "Unreleased Vulnerability 3", "Unreleased Vulnerability 4", "Unreleased Vulnerability 5", "Unreleased Vulnerability 6")
        }
    }
    It "Output.Unreleased.Link" {
        $Data.Unreleased.Link | Should -Be "https://github.com/testuser/testrepo/compare/v1.0.0..HEAD"
    }
    It "Output.Unreleased.RawData" {
        $Data.Unreleased.RawData | Should -Be ("## [Unreleased]$NL" +
            "### Added$NL" +
            "- Unreleased Addition 1$NL" +
            "$NL" +
            "### Changed$NL" +
            "- Unreleased Change 1$NL" +
            "- Unreleased Change 2$NL" +
            "$NL" +
            "### Deprecated$NL" +
            "- Unreleased Deprecation 1$NL" +
            "- Unreleased Deprecation 2$NL" +
            "- Unreleased Deprecation 3$NL" +
            "$NL" +
            "### Removed$NL" +
            "- Unreleased Removal 1$NL" +
            "- Unreleased Removal 2$NL" +
            "- Unreleased Removal 3$NL" +
            "- Unreleased Removal 4$NL" +
            "$NL" +
            "### Fixed$NL" +
            "- Unreleased Fix 1$NL" +
            "- Unreleased Fix 2$NL" +
            "- Unreleased Fix 3$NL" +
            "- Unreleased Fix 4$NL" +
            "- Unreleased Fix 5$NL" +
            "$NL" +
            "### Security$NL" +
            "- Unreleased Vulnerability 1$NL" +
            "- Unreleased Vulnerability 2$NL" +
            "- Unreleased Vulnerability 3$NL" +
            "- Unreleased Vulnerability 4$NL" +
            "- Unreleased Vulnerability 5$NL" +
            "- Unreleased Vulnerability 6$NL" +
            "$NL")
    }
    It "Output.Unreleased.ChangeCount" {
        $Data.Unreleased.ChangeCount | Should -Be 21
    }
    It "Output.Released.RawData" {
        $Data.Released.RawData | Should -Be @(("## [1.1.0] - 2001-01-01$NL" +
                "### Added$NL" +
                "- Released Addition 1$NL" +
                "$NL" +
                "### Changed$NL" +
                "- Released Change 1$NL" +
                "- Released Change 2$NL" +
                "$NL" +
                "### Deprecated$NL" +
                "- Released Deprecation 1$NL" +
                "- Released Deprecation 2$NL" +
                "- Released Deprecation 3$NL" +
                "$NL" +
                "### Removed$NL" +
                "- Released Removal 1$NL" +
                "- Released Removal 2$NL" +
                "- Released Removal 3$NL" +
                "- Released Removal 4$NL" +
                "$NL" +
                "### Fixed$NL" +
                "- Released Fix 1$NL" +
                "- Released Fix 2$NL" +
                "- Released Fix 3$NL" +
                "- Released Fix 4$NL" +
                "- Released Fix 5$NL" +
                "$NL" +
                "### Security$NL" +
                "- Released Vulnerability 1$NL" +
                "- Released Vulnerability 2$NL" +
                "- Released Vulnerability 3$NL" +
                "- Released Vulnerability 4$NL" +
                "- Released Vulnerability 5$NL" +
                "- Released Vulnerability 6$NL" +
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
        $Data.Released.Version | Should -Be @("1.1.0", "1.0.0")
    }
    It "Output.Released.Link" {
        $Data.Released.Link | Should -Be @("https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0",
            "https://github.com/testuser/testrepo/tree/v1.0.0")
    }
    Context "Output.Released[0].Data" {
        It "Added" {
            $Data.Released[0].Data.Added | Should -Be @("Released Addition 1")
        }
        It "Changed" {
            $Data.Released[0].Data.Changed | Should -Be @("Released Change 1", "Released Change 2")
        }
        It "Deprecated" {
            $Data.Released[0].Data.Deprecated | Should -Be @("Released Deprecation 1", "Released Deprecation 2", "Released Deprecation 3")
        }
        It "Removed" {
            $Data.Released[0].Data.Removed | Should -Be @("Released Removal 1", "Released Removal 2", "Released Removal 3", "Released Removal 4")
        }
        It "Fixed" {
            $Data.Released[0].Data.Fixed | Should -Be @("Released Fix 1", "Released Fix 2", "Released Fix 3", "Released Fix 4", "Released Fix 5")
        }
        It "Security" {
            $Data.Released[0].Data.Security | Should -Be @("Released Vulnerability 1", "Released Vulnerability 2", "Released Vulnerability 3", "Released Vulnerability 4", "Released Vulnerability 5", "Released Vulnerability 6")
        }
    }
    It "Output.Released[0].ChangeCount" {
        $Data.Released[0].ChangeCount | Should -Be 21
    }
    Context "Output.Released[1].Data" {
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
    It "Output.Released[1].ChangeCount" {
        $Data.Released[1].ChangeCount | Should -Be 1
    }
    It "Output.Footer" {
        $Data.Footer | Should -Be ("[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$NL" +
            "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
            "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")
    }
    It "Output.LastVersion" {
        $Data.LastVersion | Should -Be "1.1.0"
    }
    It "Output.ReleaseNotes" {
        $Data.ReleaseNotes | Should -Be ("### Added$NL" +
            "- Released Addition 1$NL" +
            "$NL" +
            "### Changed$NL" +
            "- Released Change 1$NL" +
            "- Released Change 2$NL" +
            "$NL" +
            "### Deprecated$NL" +
            "- Released Deprecation 1$NL" +
            "- Released Deprecation 2$NL" +
            "- Released Deprecation 3$NL" +
            "$NL" +
            "### Removed$NL" +
            "- Released Removal 1$NL" +
            "- Released Removal 2$NL" +
            "- Released Removal 3$NL" +
            "- Released Removal 4$NL" +
            "$NL" +
            "### Fixed$NL" +
            "- Released Fix 1$NL" +
            "- Released Fix 2$NL" +
            "- Released Fix 3$NL" +
            "- Released Fix 4$NL" +
            "- Released Fix 5$NL" +
            "$NL" +
            "### Security$NL" +
            "- Released Vulnerability 1$NL" +
            "- Released Vulnerability 2$NL" +
            "- Released Vulnerability 3$NL" +
            "- Released Vulnerability 4$NL" +
            "- Released Vulnerability 5$NL" +
            "- Released Vulnerability 6")
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
    Context "Empty Unreleased Section" {
        BeforeAll {
            $TestPathEmptyUnreleased = "TestDrive:\CHANGELOGEMPTYUNRELEASED.md"
            $SeedDataEmptyUnreleased = ("# Changelog$NL" +
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

            Set-Content -Value $SeedDataEmptyUnreleased -Path $TestPathEmptyUnreleased -NoNewline
            $DataEmptyUnreleased = Get-ChangelogData -Path $TestPathEmptyUnreleased
        }
        It "Data.Unreleased" {
            $DataEmptyUnreleased.Unreleased | Should -Not -BeNullOrEmpty
        }
        It "Data.Unreleased.ChangeCount" {
            $DataEmptyUnreleased.Unreleased.ChangeCount | Should -Be 0
        }
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