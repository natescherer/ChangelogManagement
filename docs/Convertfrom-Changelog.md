# Convertfrom-Changelog

## SYNOPSIS
Takes a changelog in Keep a Changelog 1.0.0 format and converts it to another format.

## SYNTAX

```
Convertfrom-Changelog [[-Path] <String>] [[-OutputPath] <String>] [-Format] <String> [-NoHeader]
 [<CommonParameters>]
```

## DESCRIPTION
This cmdlet converts a changelog file using Keep a Changelog 1.0.0 format into one of several other formats.
Valid formats are Release (same as input, but with the Unreleased section removed), Text
(markdown and links removed), and TextRelease (Unreleased section, markdown, and links removed).

## EXAMPLES

### EXAMPLE 1
```
Convertfrom-Changelog -Path .\CHANGELOG.md -Format Release -OutputPath docs\CHANGELOG.md
```

(Does not generate output, but creates a file at docs\CHANGELOG.md that is the same as the input with the Unreleased section removed)

### EXAMPLE 2
```
Convertfrom-Changelog -Path .\CHANGELOG.md -Format Text -OutputPath CHANGELOG.txt
```

(Does not generate output, but creates a file at CHANGELOG.txt that has header, markdown, and links removed)

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

### -OutputPath
The path to the output changelog file, if it is different than than the source path

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

### -Format
Format to convert changelog into.
Valid values are Release (same as input, but with the Unreleased
section removed), Text (markdown and links removed), and TextRelease (Unreleased section, markdown, and
links removed).

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

### -NoHeader
Exclude header from output

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

