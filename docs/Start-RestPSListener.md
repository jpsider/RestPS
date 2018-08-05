---
external help file: RestPS-help.xml
Module Name: RestPS
online version:
schema: 2.0.0
---

# Start-RestPSListener

## SYNOPSIS

## SYNTAX

```
Start-RestPSListener [[-RoutesFilePath] <String>] [[-RestPSLocalRoot] <String>] [[-Port] <String>]
 [[-SSLThumbprint] <String>] [[-AppGuid] <String>] [[-VerificationType] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Start a HTTP listener on a specified port.

## EXAMPLES

### EXAMPLE 1
```
Start-RestPSListener
```

### EXAMPLE 2
```
Start-RestPSListener -Port 8081
```

### EXAMPLE 3
```
Start-RestPSListener -Port 8081 -RoutesFilePath C:\temp\customRoutes.ps1
```

### EXAMPLE 4
```
Start-RestPSListener -RoutesFilePath C:\temp\customRoutes.ps1
```

### EXAMPLE 5
```
Start-RestPSListener -RoutesFilePath C:\temp\customRoutes.ps1 -VerificationType VerifyRootCA -SSLThumbprint $Thumb -AppGuid $Guid
```

## PARAMETERS

### -RoutesFilePath
A Custom Routes file can be specified, but is not required, default is included in the module.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Null
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestPSLocalRoot
A RestPSLocalRoot be specified, but is not required.
Default is c:\RestPS

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: C:\RestPS
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
A Port can be specified, but is not required, Default is 8080.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 8080
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSLThumbprint
A SSLThumbprint can be specified, but is not required.

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

### -AppGuid
A AppGuid can be specified, but is not required.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: ((New-Guid).Guid)
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerificationType
A VerificationType is optional - Accepted values are:
    -"VerifyRootCA": Verifies the Root CA of the Server and Client Cert Match.
    -"VerifySubject": Verifies the Root CA, and the Client is on a User provide ACL.
    -"VerifyUserAuth": Provides an option for Advanced Authentication, plus the RootCA,Subject Checks.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean

### System.Collections.Hashtable

### System.String

## NOTES
No notes at this time.

## RELATED LINKS
