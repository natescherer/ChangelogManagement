---
external help file: ChangelogManagement-help.xml
Module Name: ChangelogManagement
online version: https://github.com/natescherer/ChangelogManagement
schema: 2.0.0
---

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

Returns an object containing Header, Unreleased, Released, Footer, and LastVersion properties.

## PARAMETERS

### -Path
Path to the changelog; defaults to ".\CHANGELOG.md"

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

### This cmdlet does not accept pipeline input.
## OUTPUTS

### This cmdlet outputs a PSCustomObject containing the changelog data.
## NOTES

## RELATED LINKS

[https://github.com/natescherer/ChangelogManagement](https://github.com/natescherer/ChangelogManagement)

