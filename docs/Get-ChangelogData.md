# Get-ChangelogData

## SYNOPSIS
Takes a changelog in Keep a Changelog 1.0.0 format and parses the data into a PowerShell object.

## SYNTAX

```
Get-ChangelogData [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet parses the data in a changelog file using Keep a Changelog 1.0.0 format into a PowerShell object.

## EXAMPLES

### EXAMPLE 1
```
Get-ChangelogData
```

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

## PARAMETERS

### -Path
Path to the changelog.
Defaults to ".\CHANGELOG.md".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: CHANGELOG.md
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### This cmdlet does not accept pipeline input
## OUTPUTS

### This cmdlet outputs a PSCustomObject containing the changelog data.
## NOTES

## RELATED LINKS

[https://github.com/natescherer/ChangelogManagement](https://github.com/natescherer/ChangelogManagement)

