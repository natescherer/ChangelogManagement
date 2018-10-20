# Update-Changelog

## SYNOPSIS
Takes all unreleased changes listed in a Keep a Changelog 1.0.0 changelog, adds them to a new version,
and makes a new, blankUnreleased section.

## SYNTAX

```
Update-Changelog [-ReleaseVersion] <String> [[-Path] <String>] [[-OutputPath] <String>]
 [[-ReleasePrefix] <String>] [[-LinkMode] <String>] [[-LinkBase] <String>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet automates the updating of changelogs in Keep a Changelog 1.0.0 format at release time.
It
takes all changes in the Unreleased section, adds them to a new section with a version number you specify,
then makes a new, blank Unreleased section.

## EXAMPLES

### EXAMPLE 1
```
Update-Changelog -ReleaseVersion 1.1.1
```

(Does not generate output, but creates a new release in .\CHANGELOG.md from all existing Unreleased changes, tagging it with ReleaseVersion and today's date.)

### EXAMPLE 2
```
Update-Changelog -ReleaseVersion 1.1.1 -Path project\CHANGELOG.md -OutputPath TempChangelog.md
```

(Does not generate output, but updates changelog at project\CHANGELOG.md, writing changes to .\TempChangelog.md)

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
The path to the source changelog file, if it is different than .\CHANGELOG.md

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
The path to the output changelog file, if it is different than than the source path

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

### -ReleasePrefix
Prefix used before version number in source control compare links (i.e.
the "v" in v1.0.0).
Defaults to
"v" for GitHub and "" for other platforms.
Only applies if LinkMode is Automatic.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinkMode
Mode used for adding links at the bottom of the Changelog for new versions.
Can either be Automatic
(adding based on existing links with GitHub/GitLab type compares), Manual (adding placeholders which
will need manually updated), or None (not adding links).
Defaults to Automatic.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Automatic
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinkBase
Mode used for adding links at the bottom of the Changelog for new versions.
Can either be Automatic
(adding based on existing links with GitHub/GitLab type compares), Manual (adding placeholders which
will need manually updated), or None (not adding links).
Defaults to Automatic.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Https://REPLACE-DOMAIN.com/REPLACE-USERNAME/REPLACE-REPONAME
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### This cmdlet does not accept pipeline input
## OUTPUTS

### This cmdlet does not generate output except in the event of an error or notice
## NOTES

## RELATED LINKS

[https://github.com/natescherer/ChangelogManagement](https://github.com/natescherer/ChangelogManagement)

