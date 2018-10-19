# ChangelogManagement

![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/github/natescherer/ChangelogManagement?svg=true&branch=master)

ChangelogManagement is a PowerShell module designed for easy manipulation of Changelog files in [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format.
Features include:

- Creating new changelog files via New-Changelog
- Adding new changes to changelog files via Add-ChangelogData
- Getting changelog contents (parsed into a PowerShell object) via Get-ChangelogData
- Updating changelogs at release time via Update-Changelog
- Converting changelogs into other formats via Convertfrom-Changelog

## Getting Started

ChangelogManagement is designed to be cross-platform and fully compatible with Windows PowerShell 3+ and PowerShell Core 6+.

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

Examples Here

### Documentation

For detailed documentation, [click here on GitHub][HelpMarkdown], see the docs folder in a release, or run Get-Help for the individual function in PowerShell.

[HelpMarkdown]: ../v1.1.0/docs

## Questions/Comments

If you have questions, comments, etc, please enter a GitHub Issue with the "question" tag.

## Contributing/Bug Reporting

Contributions and bug reports are gladly accepted! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Building

## Authors

**Nate Scherer** - *Initial work* - [natescherer](https://github.com/natescherer)

## License

This project is licensed under The MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgements

[Username](URL) - What you're thanking them for
