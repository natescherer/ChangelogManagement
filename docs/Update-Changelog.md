---
external help file: ChangelogManagement-help.xml
Module Name: ChangelogManagement
online version: https://github.com/natescherer/ChangelogManagement
schema: 2.0.0
---

# Update-Changelog

## SYNOPSIS
Takes all unreleased changes listed in changelog, adds them to a new version,
and makes a new, blank Unreleased section.

## SYNTAX

```
Update-Changelog [-ReleaseVersion] <String> [[-Path] <String>] [[-OutputPath] <String>] [-LinkMode] <String>
 [[-LinkPattern] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet automates the updating of changelogs in Keep a Changelog 1.0.0 format at release time.
It
takes all changes in the Unreleased section, adds them to a new section with a version number you specify,
then makes a new, blank Unreleased section.

## EXAMPLES

### EXAMPLE 1
```
Update-Changelog -ReleaseVersion 1.1.1 -LinkMode Automatic -LinkPattern @{FirstRelease="https://github.com/testuser/testrepo/tree/v{CUR}";NormalRelease="https://github.com/testuser/testrepo/compare/v{PREV}..v{CUR}";Unreleased="https://github.com/testuser/testrepo/compare/v{CUR}..HEAD"}
```

Does not generate output, but:
1.
Takes all Unreleased changes in .\CHANGELOG.md and adds them to a new release tagged with ReleaseVersion and today's date.
2.
Updates links according to LinkPattern.
3.
Creates a new, blank Unreleased section

## PARAMETERS

### -ReleaseVersion
Version number for the new release

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path to the source changelog file; defaults to .\CHANGELOG.md

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: CHANGELOG.md
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
The path to the output changelog file; defaults to the source file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Path
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinkMode
Mode used for adding links at the bottom of the Changelog for new versions.
Can either be Automatic
(adding based pattern provided via -LinkPattern), Manual (adding placeholders which
will need manually updated), or None (not adding links).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinkPattern
Pattern used for adding links at the bottom of the Changelog when -LinkMode is set to Automatic.
This
is a hashtable that defines the format for the three possible types of links needed: FirstRelease, NormalRelease,
and Unreleased.
The current version in the patterns should be replaced with {CUR} and the previous
version with {PREV}.
See examples for details on format of hashtable.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### This cmdlet does not accept pipeline input.
## OUTPUTS

### This cmdlet does not generate output except in the event of an error or notice.
## NOTES

## RELATED LINKS

[https://github.com/natescherer/ChangelogManagement](https://github.com/natescherer/ChangelogManagement)

