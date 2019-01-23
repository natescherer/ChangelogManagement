# ChangelogManagement

![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/github/natescherer/ChangelogManagement?svg=true&branch=master)

ChangelogManagement is a PowerShell module for working with of Changelog files in [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format.

The primary feature is automatic updating of changelogs at release time in a CI/CD workflow via Update-Changelog cmdlet.

Other features include:

- Creating new changelog files via New-Changelog
- Adding new changes to changelog files via Add-ChangelogData
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

```PowerShell
LinkPattern   = @{
    FirstRelease  = "https://github.com/testuser/testrepo/tree/v{CUR}"
    NormalRelease = "https://github.com/testuser/testrepo/compare/v{PREV}..v{CUR}"
    Unreleased    = "https://github.com/testuser/testrepo/compare/v{CUR}..HEAD"
}
Update-Changelog -ReleaseVersion 1.1.1 -LinkMode Automatic -LinkPattern $LinkPattern


(Does not generate output, but creates a new release in .\CHANGELOG.md from all existing Unreleased changes, tagging it with ReleaseVersion, today's date, and updating links according to LinkPattern.)
```

```PowerShell
New-Changelog

(Does not generate output, but creates a new changelog at .\CHANGELOG.md)
```

```PowerShell
Add-ChangelogData -Type "Added" -Data "Spanish language translation"

(Does not generate output, but adds a new Added change into changelog at  .\CHANGELOG.md)
```

```PowerShell
Get-ChangelogData


Header      : # Changelog
      All notable changes to this project will be documented in this file.

      The format is based on \[Keep a Changelog\](https://keepachangelog.com/en/1.0.0/),
      and this project adheres to \[Semantic Versioning\](https://semver.org/spec/v2.0.0.html).


Unreleased  : @{RawData=## \[Unreleased\]
            ### Added

            ### Changed

            ### Deprecated

            ### Removed

            ### Fixed

            ### Security

            ; Link=https://github.com/user/project/compare/1.0.0..HEAD; Data=}
Released    : {@{RawData=## \[1.0.0\] - 2018-10-19
            ### Added
            - Initial release

            ; Date=10/19/2018 12:00:00 AM; Version=1.0.0; Link=https://github.com/user/project/tree/1.0.0; Data=}}
Footer      : \[Unreleased\]: https://github.com/user/project/compare/1.0.0..HEAD
            \[1.0.0\]: https://github.com/user/project/tree/1.0.0
LastVersion : 1.0.0
```

```PowerShell
Convertfrom-Changelog -Path .\CHANGELOG.md -Format Release -OutputPath docs\CHANGELOG.md


(Does not generate output, but creates a file at docs\CHANGELOG.md that is the same as the input with the Unreleased section removed)
```

### Documentation

For detailed documentation, [click here on GitHub][DocsDir], see the docs folder in a release, or run Get-Help for the individual function in PowerShell.

[DocsDir]: ../v1.0.0/docs/

## Questions/Comments

If you have questions, comments, etc, please enter a GitHub Issue with the "question" tag.

## Contributing/Bug Reporting

Contributions and bug reports are gladly accepted! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Building

If you fork into your own repo, you can build through Appveyor by updating the environment section at the top of [appveyor.yml](appveyor.yml).

Local builds can be done via Invoke-Build with the following modules installed:

- InvokeBuild
- platyPs
- MarkdownToHtml

## Authors

**Nate Scherer** - *Initial work* - [natescherer](https://github.com/natescherer)

## License

This project is licensed under The MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgements

[oliverlachlan](https://github.com/olivierlacan/keep-a-changelog) - For creating the Keep a Changelog format
