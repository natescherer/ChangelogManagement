BeforeAll {
    $ProjectRoot = Split-Path $(Split-Path $PSScriptRoot -Parent) -Parent
    $ModuleName = $(Get-ChildItem -Path (Join-Path $ProjectRoot "src") -Filter "*.psm1").Name.Replace(".psm1", "")
    $ModulePath = Join-Path $(Join-Path $ProjectRoot "src") "$ModuleName.psm1"

    $NL = [System.Environment]::NewLine
    $Today = (Get-Date -Format 'o').Split('T')[0]
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
            { Update-Changelog @UCSplat } | Should -Throw -ExpectedMessage "-LinkPattern must be used when -LinkMode is set to Automatic"

            Remove-Item $TestPath
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
                LinkMode       = "Automatic"
                LinkPattern    = @{
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

            Remove-Item $TestPath
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
                LinkPattern    = @{
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

            Remove-Item $TestPath
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
                LinkPattern    = @{
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
                "$NL" + ,
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.2.0..HEAD$NL" +
                "[1.2.0]: https://github.com/testuser/testrepo/compare/v1.1.0..v1.2.0$NL" +
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0$NL" +
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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
                "$NL" + ,
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: ENTER-URL-HERE$NL" +
                "[1.2.0]: ENTER-URL-HERE$NL" +
                "[1.1.0]: ENTER-URL-HERE$NL" +
                "[1.0.0]: ENTER-URL-HERE")

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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
                "$NL" + ,
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: ENTER-URL-HERE$NL" +
                "[1.1.0]: ENTER-URL-HERE$NL" +
                "[1.0.0]: ENTER-URL-HERE")

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
        }
        AfterAll {
            $env:GITHUB_REPOSITORY = $env:GITHUB_REPOSITORY_BACKUP
        }
    }
    Context "-LinkMode AzureDevOps" {
        BeforeAll {
            $env:SYSTEM_TASKDEFINITIONSURI_BACKUP = $env:SYSTEM_TASKDEFINITIONSURI
            $env:SYSTEM_TASKDEFINITIONSURI = "https://dev.azure.com/testcompany/"
            $env:SYSTEM_TEAMPROJECT_BACKUP = $env:SYSTEM_TEAMPROJECT
            $env:SYSTEM_TEAMPROJECT = "testproject"
            $env:BUILD_REPOSITORY_NAME_BACKUP = $env:BUILD_REPOSITORY_NAME
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
        }
        AfterAll {
            $env:SYSTEM_TASKDEFINITIONSURI = $env:SYSTEM_TASKDEFINITIONSURI_BACKUP
            $env:SYSTEM_TEAMPROJECT = $env:SYSTEM_TEAMPROJECT_BACKUP
            $env:BUILD_REPOSITORY_NAME = $env:BUILD_REPOSITORY_NAME_BACKUP
        }
    }
    Context "-LinkMode GitHub, but wrong env" {
        BeforeAll{
            $env:GITHUB_REPOSITORY_BACKUP = $env:GITHUB_REPOSITORY
            $env:GITHUB_REPOSITORY = $null
        }
        It "Throw" {
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
            { Update-Changelog @UCSplat } | Should -Throw -ExpectedMessage "You must be running in GitHub Actions to use GitHub LinkMode"

            Remove-Item $TestPath
        }
        AfterAll {
            $env:GITHUB_REPOSITORY = $env:GITHUB_REPOSITORY_BACKUP
        }
    }
    Context "-LinkMode AzureDevOps, but wrong env" {
        BeforeAll {
            $env:SYSTEM_TASKDEFINITIONSURI_BACKUP = $env:SYSTEM_TASKDEFINITIONSURI
            $env:SYSTEM_TASKDEFINITIONSURI = $null
            $env:SYSTEM_TEAMPROJECT_BACKUP = $env:SYSTEM_TEAMPROJECT
            $env:SYSTEM_TEAMPROJECT = $null
            $env:BUILD_REPOSITORY_NAME_BACKUP = $env:BUILD_REPOSITORY_NAME
            $env:BUILD_REPOSITORY_NAME = $null
        }
        It "Throw" {
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
            { Update-Changelog @UCSplat } | Should -Throw -ExpectedMessage "You must be running in Azure Pipelines to use AzureDevOps LinkMode"

            Remove-Item $TestPath
        }
        AfterAll {
            $env:SYSTEM_TASKDEFINITIONSURI = $env:SYSTEM_TASKDEFINITIONSURI_BACKUP
            $env:SYSTEM_TEAMPROJECT = $env:SYSTEM_TEAMPROJECT_BACKUP
            $env:BUILD_REPOSITORY_NAME = $env:BUILD_REPOSITORY_NAME_BACKUP
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

        Remove-Item $TestPath
        Remove-Item $TestPath2
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

        Remove-Item $TestPath
    }
    Context "Custom Path Value" {
        It "First Release" {
            $TestDir = "TestDrive:\TestDir"
            New-Item -ItemType Directory -Path $TestDir
            $TestPath = "TestDrive:\TestDir\CUSTOM_CHANGELOG.md"

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
                "- Special Unreleased Addition 1$NL")
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
                "- Special Unreleased Addition 1$NL")

            Remove-Item $TestPath
            Remove-Item $TestDir
        }
        It "Second Release" {
            $TestDir = "TestDrive:\TestDir"
            New-Item -ItemType Directory -Path $TestDir
            $TestPath = "TestDrive:\TestDir\CUSTOM_CHANGELOG.md"

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


            Remove-Item $TestPath
            Remove-Item $TestDir
        }
        It "Third Release" {
            $TestDir = "TestDrive:\TestDir"
            New-Item -ItemType Directory -Path $TestDir
            $TestPath = "TestDrive:\TestDir\CUSTOM_CHANGELOG.md"

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
                "$NL" + ,
                "## [1.0.0] - 2000-01-01$NL" +
                "### Added$NL" +
                "- Initial release$NL" +
                "$NL" +
                "[Unreleased]: ENTER-URL-HERE$NL" +
                "[1.1.0]: ENTER-URL-HERE$NL" +
                "[1.0.0]: ENTER-URL-HERE")

            Remove-Item $TestPath
            Remove-Item $TestDir
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
        }
    }
}