$Eol = [System.Environment]::NewLine

$Today = (Get-Date -Format 'o').Split('T')[0]
$ModuleManifestName = 'ChangelogManagement.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

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
        $Result = Get-Content $TestPath

        $Result | Should Be(@("# Changelog",
            "All notable changes to this project will be documented in this file.",
            "",
            "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),",
            "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).",
            "",
            "## [Unreleased]",
            "### Added",
            "### Changed",
            "### Deprecated",
            "### Removed",
            "### Fixed",
            "### Security"))
    }
    It "-NoSemVer" {
        $TestPath="TestDrive:\CHANGELOG.md"
        New-Changelog -Path $TestPath -NoSemVer
        $Result = Get-Content $TestPath

        $Result | Should Be(@("# Changelog",
            "All notable changes to this project will be documented in this file.",
            "",
            "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).",
            "",
            "## [Unreleased]",
            "### Added",
            "### Changed",
            "### Deprecated",
            "### Removed",
            "### Fixed",
            "### Security"))
    }
}

Describe "Update-Changelog" {
    Context "Mandatory Parameters" {
        It "First Release" {
            $TestPath="TestDrive:\CHANGELOG.md"
            New-Changelog -Path $TestPath

            Update-Changelog -Path $TestPath -ReleaseVersion "1.0.0"

            $Result = Get-Content $TestPath

            $Result | Should Be(@("# Changelog",
                "All notable changes to this project will be documented in this file.",
                "",
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),",
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).",
                "",
                "## [Unreleased]",
                "### Added",
                "### Changed",
                "### Deprecated",
                "### Removed",
                "### Fixed",
                "### Security",
                "",
                "## [1.0.0] - $Today",
                "",
                "[Unreleased]: https://REPLACE-DOMAIN.com/REPLACE-USERNAME/REPLACE-REPONAME/compare/1.0.0..HEAD",
                "[1.0.0]: https://REPLACE-DOMAIN.com/REPLACE-USERNAME/REPLACE-REPONAME/tree/1.0.0"))
        }
        It "Second Release" {
            $TestPath="TestDrive:\CHANGELOG.md"

            $SourceFile = @("# Changelog$Eol",
                "All notable changes to this project will be documented in this file.$Eol",
                "$Eol",
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),$Eol",
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).$Eol",
                "$Eol",
                "## [Unreleased]$Eol",
                "### Added$Eol",
                "### Changed$Eol",
                "### Deprecated$Eol",
                "### Removed$Eol",
                "### Fixed$Eol",
                "### Security$Eol",
                "$Eol",
                "## [1.0.0] - 2000-01-01$Eol",
                "### Added$Eol",
                "- Initial release$Eol",
                "$Eol",
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.0.0..HEAD$Eol",
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0")

            Set-Content -Value $SourceFile -Path $TestPath -NoNewline

            Update-Changelog -Path $TestPath -ReleaseVersion "1.1.0"

            $Result = Get-Content $TestPath

            $Result | Should Be(@("# Changelog",
                "All notable changes to this project will be documented in this file.",
                "",
                "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),",
                "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).",
                "",
                "## [Unreleased]",
                "### Added",
                "### Changed",
                "### Deprecated",
                "### Removed",
                "### Fixed",
                "### Security",
                "",
                "## [1.1.0] - $Today",
                "",
                "## [1.0.0] - 2000-01-01",
                "### Added",
                "- Initial release",
                "",
                "[Unreleased]: https://github.com/testuser/testrepo/compare/v1.1.0..HEAD",
                "[1.1.0]: https://github.com/testuser/testrepo/compare/v1.0.0..v1.1.0",
                "[1.0.0]: https://github.com/testuser/testrepo/tree/v1.0.0"))
        }
    }
}