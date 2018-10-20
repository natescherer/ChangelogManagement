# ChangelogManagement

![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/github/natescherer/ChangelogManagement?svg=true&branch=master)

ChangelogManagement is a PowerShell module designed for easy manipulation of Changelog files in [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format.

The primary feature is automatic updating of changelogs at release time as part of build/release scripts via the Update-Changelog cmdlet. (i.e. Automating the process of moving Unreleased changes into a new release tagged with today's date and a version number supplied via a parameter.)

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

Installation via Install-Module coming soon

1. Download the latest release from [releases](../../releases).
1. Extract it, then run the following to install

    ```PowerShell
    Install-Module -Path EXTRACTION-PATH-HERE\ChangelogManagement
    ```

## Usage

### Examples

```PowerShell
Update-Changelog -ReleaseVersion 1.1.1


(Does not generate output, but creates a new release in .\CHANGELOG.md from all existing Unreleased changes, tagging it with ReleaseVersion and today's date.)
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

[DocsDir]: ../v1.0.0/doc/

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
