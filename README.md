# ChangelogManagement

[![Tests Windows PowerShell](https://natescherer.github.io/ChangelogManagement/testreports/Windows_powershell/Windows_powershell_badge.svg)](https://natescherer.github.io/ChangelogManagement/testreports/Windows_powershell/Windows_powershell.html)
[![Tests Windows Pwsh](https://natescherer.github.io/ChangelogManagement/testreports/Windows_pwsh/Windows_pwsh_badge.svg)](https://natescherer.github.io/ChangelogManagement/testreports/Windows_pwsh/Windows_pwsh.html)
[![Tests Linux](https://natescherer.github.io/ChangelogManagement/testreports/Linux_pwsh/Linux_pwsh_badge.svg)](https://natescherer.github.io/ChangelogManagement/testreports/Linux_pwsh/Linux_pwsh.html)
[![Tests macOS](https://natescherer.github.io/ChangelogManagement/testreports/macOS_pwsh/macOS_pwsh_badge.svg)](https://natescherer.github.io/ChangelogManagement/testreports/macOS_pwsh/macOS_pwsh.html)
[![codecov](https://codecov.io/gh/natescherer/ChangelogManagement/branch/main/graph/badge.svg?token=rXSOfdrmo2)](https://codecov.io/gh/natescherer/ChangelogManagement)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

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
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/natescherer01/"><img src="https://avatars.githubusercontent.com/u/376408?v=4?s=100" width="100px;" alt="Nate Scherer"/><br /><sub><b>Nate Scherer</b></sub></a><br /><a href="https://github.com/natescherer/ChangelogManagement/commits?author=natescherer" title="Code">💻</a> <a href="https://github.com/natescherer/ChangelogManagement/commits?author=natescherer" title="Documentation">📖</a> <a href="#infra-natescherer" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jcharlesworthuk"><img src="https://avatars.githubusercontent.com/u/9157892?v=4?s=100" width="100px;" alt="James Charlesworth"/><br /><sub><b>James Charlesworth</b></sub></a><br /><a href="https://github.com/natescherer/ChangelogManagement/commits?author=jcharlesworthuk" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://gaelcolas.com/"><img src="https://avatars.githubusercontent.com/u/8962101?v=4?s=100" width="100px;" alt="Gael"/><br /><sub><b>Gael</b></sub></a><br /><a href="https://github.com/natescherer/ChangelogManagement/commits?author=gaelcolas" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://se.linkedin.com/in/johanljunggren"><img src="https://avatars.githubusercontent.com/u/7189721?v=4?s=100" width="100px;" alt="Johan Ljunggren"/><br /><sub><b>Johan Ljunggren</b></sub></a><br /><a href="https://github.com/natescherer/ChangelogManagement/commits?author=johlju" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://allcontributors.org) specification.
Contributions of any kind are welcome!

## License

This project is licensed under The MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgements

[![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=flat-square)](https://cloudsmith.com)

Package repository hosting is graciously provided by Cloudsmith.
