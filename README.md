# ChangelogManagement

[![Build Status](https://dev.azure.com/natescherer/ChangelogManagement/_apis/build/status/natescherer.ChangelogManagement?branchName=master)](https://dev.azure.com/natescherer/ChangelogManagement/_build/latest?definitionId=1&branchName=master)

ChangelogManagement is a PowerShell module for reading and manipulating changelog files in [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format.

The primary feature is automatic updating of changelogs at release time in a CI/CD workflow via Update-Changelog.

Other features include:

- Creating new changelog files via New-Changelog
- Adding data to changelog files via Add-ChangelogData
- Getting changelog contents (parsed into a PowerShell object) via Get-ChangelogData
- Converting changelogs into other formats via Convertfrom-Changelog

## Getting Started

ChangelogManagement is designed to be cross-platform and fully compatible with Windows PowerShell 5.0+ and PowerShell Core 6.0+.

### Prerequisites

No prerequisites are required beyond having PowerShell installed.

### Installing

ChangelogManagement is listed in the PowerShell Gallery [here](https://www.powershellgallery.com/packages/ChangelogManagement), which means you can install on any internet-connected computer running PowerShell 5+ by running this command:

```PowerShell
Install-Module -Name ChangelogManagement
```

If you'd prefer to install manually, follow these instructions:

1. Download the latest release from [releases](../../releases).
1. Extract it, then run the following to install

    ```PowerShell
    Install-Module -Path EXTRACTION-PATH-HERE\ChangelogManagement
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
Convertfrom-Changelog -Path .\CHANGELOG.md -Format Release -OutputPath docs\CHANGELOG.md
```

- Does not generate output, but creates a file at docs\CHANGELOG.md that is the same as the input with the Unreleased section removed.

### Documentation

For detailed documentation, [click here on GitHub][DocsDir], see the docs folder in a release, or run Get-Help for the individual function in PowerShell.

[DocsDir]: ../v1.0.0/docs/

## Questions/Comments

If you have questions, comments, etc, please enter a GitHub Issue with the "question" tag.

## Contributing/Bug Reporting

Contributions and bug reports are gladly accepted! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Building

If you fork into your own repository, you can build through Appveyor by updating the environment section at the top of [appveyor.yml](appveyor.yml).

Local builds can be done via Invoke-Build.

## Authors

**Nate Scherer** - *Initial work* - [natescherer](https://github.com/natescherer)

## License

This project is licensed under The MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgements

[oliverlachlan](https://github.com/olivierlacan/keep-a-changelog) - For creating the Keep a Changelog format
