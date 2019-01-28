---
external help file: ChangelogManagement-help.xml
Module Name: ChangelogManagement
online version: https://github.com/natescherer/ChangelogManagement
schema: 2.0.0
---

# New-Changelog

## SYNOPSIS
Creates a new, blank changelog in Keep a Changelog 1.0.0 format.

## SYNTAX

```
New-Changelog [[-Path] <String>] [-NoSemVer] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet creates a new, blank changelog in Keep a Changelog 1.0.0 format.

## EXAMPLES

### EXAMPLE 1
```
New-Changelog
```

Does not generate output, but creates a new changelog at .\CHANGELOG.md

### EXAMPLE 2
```
New-Changelog -Path project\CHANGELOG.md -NoSemVer
```

Does not generate output, but creates a new changelog at project\CHANGELOG.md, and excludes SemVer statement from the header.

## PARAMETERS

### -Path
The path to the output changelog file, if it is different than .\CHANGELOG.md

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

### -NoSemVer
Exclude the statement about Semantic Versioning from the changelog, if your project uses another
versioning scheme

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### This cmdlet does not accept pipeline input
## OUTPUTS

### This cmdlet does not generate output
## NOTES

## RELATED LINKS

[https://github.com/natescherer/ChangelogManagement](https://github.com/natescherer/ChangelogManagement)

