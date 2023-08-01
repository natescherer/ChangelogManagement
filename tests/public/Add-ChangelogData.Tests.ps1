BeforeAll {
    $Separator = [IO.Path]::DirectorySeparatorChar
    . $PSCommandPath.Replace("$($Separator)tests$($Separator)", "$($Separator)src$($Separator)").Replace(".Tests.ps1", ".ps1")

    $NL = [System.Environment]::NewLine
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