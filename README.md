# ChangelogManagement

[![Tests Windows PowerShell](https://raw.githubusercontent.com/gist/natescherer/aaaff94b47d7bf3029e61b95d6f4557c/raw/78c318d11859cc3601f79c54229f39d0f4d9466c/ChangelogManagement_TestResults_Windows_powershell.md_badge.svg)](https://gist.github.com/natescherer/aaaff94b47d7bf3029e61b95d6f4557c)
[![Tests Windows Pwsh](https://raw.githubusercontent.com/gist/natescherer/c77c8bb9fe0066f4488621a199ebedc5/raw/a1ac84cd380e76b8247de997761ec864b8443597/ChangelogManagement_TestResults_Windows_pwsh.md_badge.svg)](https://gist.github.com/natescherer/c77c8bb9fe0066f4488621a199ebedc5)
[![Tests Linux](https://raw.githubusercontent.com/gist/natescherer/e91fdb66a9fdd83c2d329a513d477cc9/raw/eaa3fc9500e82e5ad242af7ab54ae65fa8f6811d/ChangelogManagement_TestResults_Linux_pwsh.md_badge.svg)](https://gist.github.com/natescherer/e91fdb66a9fdd83c2d329a513d477cc9)
[![Tests macOS](https://raw.githubusercontent.com/gist/natescherer/120b8e0b4fa7a2a68ba69f7ddc2c5b0a/raw/fbab2c80e2a1f2f0311d07cbdf7934491eded948/ChangelogManagement_TestResults_macOS_pwsh.md_badge.svg)](https://gist.github.com/natescherer/120b8e0b4fa7a2a68ba69f7ddc2c5b0a)
[![codecov](https://codecov.io/gh/natescherer/ChangelogManagement/branch/main/graph/badge.svg?token=rXSOfdrmo2)](https://codecov.io/gh/natescherer/ChangelogManagement)
[![Open Issues](https://img.shields.io/github/issues-raw/natescherer/changelogmanagement.svg?logo=github)](https://github.com/natescherer/ChangelogManagement/issues)

ChangelogManagement is a PowerShell module for reading and manipulating changelog files in [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format.

The primary feature is automatic updating of changelogs at release time in a CI/CD workflow via Update-Changelog.

Other features include:

- Creating new changelog files via New-Changelog
- Adding data to changelog files via Add-ChangelogData
- Getting changelog contents (parsed into a PowerShell object) via Get-ChangelogData
- Converting changelogs into other formats via ConvertFrom-Changelog

## Getting Started

ChangelogManagement is designed to be cross-platform and fully compatible with Windows PowerShell 5.1 and PowerShell 7+ on Windows/Linux/macOS.

### Prerequisites

No prerequisites are required beyond having PowerShell installed.

### Installing

ChangelogManagement is listed in the PowerShell Gallery [here](https://www.powershellgallery.com/packages/ChangelogManagement), which means you can install on any internet-connected computer running PowerShell 5.1+ by running this command:

```PowerShell
Install-Module -Name ChangelogManagement
```

## Usage

### Examples

``` PowerShell
LinkPattern   = @{
    FirstRelease  = "https://github.com/testuser/testrepo/tree/v{CUR}"
    NormalRelease = "https://github.com/testuser/testrepo/compare/v{PREV}..v{CUR}"
    Unreleased    = "https://github.com/testuser/testrepo/compare/v{CUR}..HEAD"
}
Update-Changelog -ReleaseVersion 1.1.1 -LinkMode Automatic -LinkPattern $LinkPattern
```

- Does not generate output, but:
  - Takes all Unreleased changes in .\CHANGELOG.md and adds them to a new release tagged with ReleaseVersion and today's date.
  - Updates links according to LinkPattern.
  - Creates a new, blank Unreleased section.

``` PowerShell
New-Changelog
```

- Does not generate output, but creates a new changelog at .\CHANGELOG.md.

``` PowerShell
Add-ChangelogData -Type "Added" -Data "Spanish language translation"
```

- Does not generate output, but adds a new Added change into changelog at  .\CHANGELOG.md.

``` PowerShell
Get-ChangelogData
```

- Returns an object containing Header, Unreleased, Released, Footer, and LastVersion properties.

``` PowerShell
ConvertFrom-Changelog -Path .\CHANGELOG.md -Format Release -OutputPath docs\CHANGELOG.md
```

- Does not generate output, but creates a file at docs\CHANGELOG.md that is the same as the input with the Unreleased section removed.

### Documentation

For detailed documentation, [click here on GitHub](docs), see the docs folder in a release, or run Get-Help for the individual function in PowerShell.

## Questions/Comments

If you have questions, comments, etc, please enter a GitHub Issue with the "question" tag.

## Contributing/Bug Reporting

Contributions and bug reports are gladly accepted! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Building

Building is unnecessary, per se. The provided build YAML generates documentation files and metadata, then does the actual releasing and publishing. If modifying locally, you can simply use the updated .psd1/.psm1 files without running a build process.

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table></table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://allcontributors.org) specification.
Contributions of any kind are welcome!

## License

This project is licensed under The MIT License - see [LICENSE](LICENSE) for details.
