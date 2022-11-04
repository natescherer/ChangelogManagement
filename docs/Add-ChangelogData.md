---
external help file: ChangelogManagement-help.xml
Module Name: ChangelogManagement
online version: https://github.com/natescherer/ChangelogManagement
schema: 2.0.0
---

# Add-ChangelogData

## SYNOPSIS
Adds an item to a changelog file in Keep a Changelog 1.0.0 format.

## SYNTAX

```
Add-ChangelogData [[-Path] <String>] [[-OutputPath] <String>] [-Type] <String> [-Data] <String>
 [<CommonParameters>]
```

## DESCRIPTION
This cmdlet adds new Added/Changed/Deprecated/Removed/Fixed/Security items to the Unreleased section of a
changelog in Keep a Changelog 1.0.0 format.

## EXAMPLES

### EXAMPLE 1
```
Add-ChangelogData -Type "Added" -Data "Spanish language translation"
Does not generate output, but adds a new Added change into changelog at  .\CHANGELOG.md.
```

### EXAMPLE 2
```
Add-ChangelogData -Type "Removed" -Data "TLS 1.0 support" -Path project\CHANGELOG.md
Does not generate output, but adds a new Security change into changelog at project\CHANGELOG.md.
```

## PARAMETERS

### -Path
The path to the source changelog file; defaults to .\CHANGELOG.md

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

### -OutputPath
The path to the output changelog file; defaults to the same path as the source file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Path
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Type of change to add to the changelog (Added, Changed, Deprecated, Removed, Fixed, or Security)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
The value of the change you are adding to the changelog

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### This cmdlet does not accept pipeline input.
## OUTPUTS

### This cmdlet does not generate output.
## NOTES

## RELATED LINKS

[https://github.com/natescherer/ChangelogManagement](https://github.com/natescherer/ChangelogManagement)

