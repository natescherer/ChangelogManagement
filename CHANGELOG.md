# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Get-ChangelogData now always outputs a PSCustomObject for the Unreleased property when there is an Unreleased section header in the changelog. The PSCustomObject property RawData will contain the Unreleased header and any change type headers that exist. The properties Added, Changed, Deprecated, Removed, Fixed, and Security will be null if there are no corresponding change type under the Unreleased section header.

### Fixed

- Get-ChangelogData will now return null for the property Unreleased if there are no Unreleased section header in the changelog.

## [3.0.0] - 2022-11-04
### Added
- New LinkModes 'GitHub' and 'AzureDevOps' on Update-Changelog which remove the need to manually specify a LinkPattern
- New property 'ReleaseNotes' returned by Get-ChangelogData containing a formatted version of the changes from the most recent released version

### Changed
- BREAKING CHANGE: New-Changelog now populates an initial change 'Added: Initial release'. This can be overridden to match previous behavior via the new '-NoInitialChange' parameter
- BREAKING CHANGE: Get-ChangelogData's Output.Unreleased is now null if there are no unreleased changes to match the behavior of Output.Released
- BREAKING CHANGE: Minimum supported PowerShell raised to 5.1 instead of 5.0
- Module structure changed to use dot-sourcing
- Build/test/deploy switched from Azure DevOps to GitHub Actions

### Fixed
- Add-ChangelogData now detects type of newline used in file rather than assuming it matches [System.Environment]::NewLine
- Update-Changelog now detects type of newline used in file rather than assuming it matches [System.Environment]::NewLine
- Get-ChangelogData now detects type of newline used in file rather than assuming it matches [System.Environment]::NewLine

## [2.1.4] - 2020-02-05
### Fixed
- Newline matching in regex updated to work properly on Linux [#11](https://github.com/natescherer/ChangelogManagement/issues/11)

## [2.1.3] - 2019-03-06
### Fixed
- Capitalization on ConvertFrom-Changelog now matches verb specifications
- Handling of missing Unreleased section in changelog file

## [2.1.2] - 2019-02-13
### Fixed
- Broken links and badly formatted text in module metadata

## [2.1.1] - 2019-02-11
### Fixed
- Inaccurate parameter documentation corrected
- Update-Changelog ReleaseVersion validation no longer forces SemVer format

## [2.1.0] - 2019-02-08
### Added
- Support for macOS

### Changed
- Building/releasing/testing changed from AppVeyor to Azure Pipelines

### Fixed
- Version comparison check in Update-Changelog required .NET System.Version; check has been removed to support any versioning scheme
- Unreleased sections now match specification in that they only contain headers for types of changes that exist

## [2.0.0] - 2019-01-28
### Changed
- Update-Changelog -LinkMode Automatic now uses a -LinkPattern parameter (replacing -LinkBase and -ReleasePrefix) which can support any VCS

## [1.0.0] - 2018-10-20
### Added
- Get-ChangelogData cmdlet
- Add-ChangelogData cmdlet
- New-Changelog cmdlet
- Update-Changelog cmdlet
- Convertfrom-Changelog cmdlet

[Unreleased]: https://github.com/natescherer/ChangelogManagement/compare/v3.0.0..HEAD
[3.0.0]: https://github.com/natescherer/ChangelogManagement/compare/v2.1.4..v3.0.0
[2.1.4]: /compare/v2.1.3..v2.1.4
[2.1.3]: https://github.com/natescherer/ChangelogManagement/compare/v2.1.2..v2.1.3
[2.1.2]: https://github.com/natescherer/ChangelogManagement/compare/v2.1.1..v2.1.2
[2.1.1]: https://github.com/natescherer/ChangelogManagement/compare/v2.1.0..v2.1.1
[2.1.0]: https://github.com/natescherer/ChangelogManagement/compare/v2.0.0..v2.1.0
[2.0.0]: https://github.com/natescherer/ChangelogManagement/compare/v1.0.0..v2.0.0
[1.0.0]: https://github.com/natescherer/ChangelogManagement/tree/v1.0.0
