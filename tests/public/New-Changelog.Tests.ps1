BeforeAll {
    $ProjectRoot = Split-Path $(Split-Path $PSScriptRoot -Parent) -Parent
    $ModuleName = $(Get-ChildItem -Path (Join-Path $ProjectRoot "src") -Filter "*.psm1").Name.Replace(".psm1", "")
    $ModulePath = Join-Path $(Join-Path $ProjectRoot "src") "$ModuleName.psm1"

    Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore
    Import-Module -Name $ModulePath -Force -ErrorAction Stop

    $NL = [System.Environment]::NewLine
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
