function Start-RestPSListener
{
    <#
    .DESCRIPTION
        Start a HTTP listener on a specified port.
    .PARAMETER Port
        A Port can be specified, but is not required, Default is 8080.
    .PARAMETER SSLThumbprint
        A SSLThumbprint can be specified, but is not required.
    .PARAMETER RestPSLocalRoot
        A RestPSLocalRoot be specified, but is not required. Default is c:\RestPS
    .PARAMETER AppGuid
        A AppGuid can be specified, but is not required.
    .PARAMETER VerificationType
        A VerificationType is optional - Accepted values are:
            -"VerifyRootCA": Verifies the Root CA of the Server and Client Cert Match.
             -"VerifyCA": Verifies the CA of the Client Cert is in a trusted list. Can also verify that the cert is valid and trusted by the server OS
            -"VerifySubject": Verifies the Root CA, and the Client is on a User provide ACL.
            -"VerifySubject": Verifies the Root CA, and the Client is on a User provide ACL.
            -"VerifyUserAuth": Provides an option for Advanced Authentication, plus the RootCA,Subject Checks.
            -"VerifyBasicAuth": Provides an option for Basic Authentication.
    .PARAMETER RoutesFilePath
        A Custom Routes file can be specified, but is not required, default is included in the module.
    .PARAMETER Logfile
        Full path to a logfile for RestPS messages to be written to.
    .PARAMETER LogLevel
        Level of verbosity of logging for the runtime environment. Default is 'INFO' See PowerLumber Module for details.
    .PARAMETER VerifyClientIP
        Validate client IP authorization. (Default=$false) to enable set $true
    .EXAMPLE
        Start-RestPSListener
    .EXAMPLE
        Start-RestPSListener -Port 8081
    .EXAMPLE
        Start-RestPSListener -Port 8081 -Logfile "c:\RestPS\RestPS.log" -LogLevel TRACE
    .EXAMPLE
        Start-RestPSListener -Port 8081 -Logfile "c:\RestPS\RestPS.log" -LogLevel INFO
    .EXAMPLE
        Start-RestPSListener -Port 8081 -RoutesFilePath $env:SystemDrive/RestPS/temp/customRoutes.ps1
    .EXAMPLE
        Start-RestPSListener -RoutesFilePath $env:SystemDrive/RestPS/customRoutes.ps1
    .EXAMPLE
        Start-RestPSListener -RoutesFilePath $env:SystemDrive/RestPS/customRoutes.ps1 -VerificationType VerifyRootCA -SSLThumbprint $Thumb -AppGuid $Guid
    .NOTES
        No notes at this time.
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [OutputType([boolean])]
    [OutputType([Hashtable])]
    [OutputType([String])]
    param(
        [Parameter()][String]$RoutesFilePath = "$env:SystemDrive/RestPS/endpoints/RestPSRoutes.json",
        [Parameter()][String]$RestPSLocalRoot = "$env:SystemDrive/RestPS",
        [Parameter()][String]$Port = 8080,
        [Parameter()][String]$SSLThumbprint="none",
        [Parameter()][String]$AppGuid = ((New-Guid).Guid),
        [ValidateSet("VerifyRootCA", "VerifySubject", "VerifyUserAuth", "VerifyBasicAuth","VerifyCA")]
        [Parameter()][String]$VerificationType,
        [Parameter()][String]$Logfile = "$env:SystemDrive/RestPS/RestPS.log",
        [ValidateSet("ALL", "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL", "CONSOLEONLY", "OFF")]
        [Parameter()][String]$LogLevel = "INFO",
        [Parameter()][Bool]$VerifyClientIP = $false
    )
    # Set a few Flags
    $script:Status = $true
    $script:ValidateClient = $true
    if ($pscmdlet.ShouldProcess("Starting .Net.HttpListener."))
    {
        $script:listener = New-Object System.Net.HttpListener
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Calling Invoke-StartListener"
        Invoke-StartListener -Port $Port -SSLThumbPrint $SSLThumbprint -AppGuid $AppGuid
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Finished Calling Invoke-StartListener"
        # Run until you send a GET request to an endpoint, that will set $script:status to $false
        Do
        {
            # Capture requests as they come in (not Asyncronous)
            # Routes can be configured to be Asyncronous in Nature.
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Captured incoming request"
            $script:Request = Invoke-GetContext
            $script:ProcessRequest = $true
            $script:result = $null

            # Perform Client Verification if SSLThumbprint is present and a Verification Method is specified.
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Determining VerificationType: '$VerificationType'"
            if ($VerificationType -ne "" -or $VerifyClientIP -eq $true)
            {
                # Validate client IP authorization.
                if ($VerifyClientIP -eq $true)
                {
                    # Start validation of client IP's.
                    if ($VerificationType -eq "")
                    {
                        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Executing Invoke-ValidateIP Validate IP only"
                        $script:ProcessRequest = (Invoke-ValidateIP -RestPSLocalRoot $RestPSLocalRoot -VerifyClientIP $VerifyClientIP)
                    }
                    # Validate client IP's and VerificationType.
                    else
                    {
                        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Executing Invoke-ValidateIP Validate IP before Authentication"
                        $script:ProcessRequest = (Invoke-ValidateIP -RestPSLocalRoot $RestPSLocalRoot -VerifyClientIP $VerifyClientIP)
                        # Determine if client IP validation was successful then start validation of VerificationType.
                        if ($script:ProcessRequest -eq $true)
                        {
                            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Executing Invoke-ValidateIP Validate Authentication Type"
                            $script:ProcessRequest = (Invoke-ValidateClient -VerificationType $VerificationType -RestPSLocalRoot $RestPSLocalRoot)
                        }
                    }
                }
                else
                {
                    # Validate only verification type.
                    Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Executing Invoke-ValidateClient"
                    $script:ProcessRequest = (Invoke-ValidateClient -VerificationType $VerificationType -RestPSLocalRoot $RestPSLocalRoot)
                }
            }
            else
            {
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: NOT Executing Invoke-ValidateClient"
                $script:ProcessRequest = $true
            }

            # Determine if a Body was sent with the Client request
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Executing Invoke-GetBody"
            $script:Body = Invoke-GetBody

            # Request Handler Data
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Determining Method and URL"
            $RequestType = $script:Request.HttpMethod
            $RawRequestURL = $script:Request.RawUrl
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Start-RestPSListener: New Request - Method: $RequestType URL: $RawRequestURL"
            # Specific args will need to be parsed in the Route commands/scripts Added the ,2.
            $RequestURL, $RequestArgs = $RawRequestURL.split("?", 2)

            if ($script:ProcessRequest -eq $true)
            {
                # Attempt to process the Request.
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Start-RestPSListener: Processing RequestType: $RequestType URL: $RequestURL Args: $RequestArgs"
                $script:result = Invoke-RequestRouter -RequestType "$RequestType" -RequestURL "$RequestURL" -RoutesFilePath "$RoutesFilePath" -RequestArgs "$RequestArgs"
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Start-RestPSListener: Finished request. StatusCode: $script:StatusCode StatusDesc: $Script:StatusDescription"
            }
            else
            {
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Start-RestPSListener: Unauthorized (401) NOT Processing RequestType: $RequestType URL: $RequestURL Args: $RequestArgs"
                $script:StatusDescription = "Unauthorized"
                $script:StatusCode = 401
            }
            # Stream the output back to requestor.
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Streaming response back to requestor."
            Invoke-StreamOutput
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Streaming response is complete."
        } while ($script:Status -eq $true)
        #Terminate the listener
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Stopping Listener."
        Invoke-StopListener -Port $Port
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Start-RestPSListener: Listener Stopped."
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
