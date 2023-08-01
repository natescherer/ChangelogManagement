BeforeAll {
    $ProjectRoot = Split-Path $(Split-Path $PSScriptRoot -Parent) -Parent
    $ModuleName = $(Get-ChildItem -Path (Join-Path $ProjectRoot "src") -Filter "*.psm1").Name.Replace(".psm1", "")
    $ModulePath = Join-Path $(Join-Path $ProjectRoot "src") "$ModuleName.psm1"

    Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
    Import-Module -Name $ModulePath -Force -ErrorAction Stop

    $NL = [System.Environment]::NewLine
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

            Remove-Item $TestPath
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

        Remove-Item $TestPath
        Remove-Item $TestPath2
    }
}