function Start-RestPSListener
{
    <#
	.DESCRIPTION
		Start a HTTP listener on a specified port.
	.EXAMPLE
        Start-Listener
    .EXAMPLE
        Start-Listener -Port 8081
    .EXAMPLE
        Start-Listener -Port 8081 -RoutesFilePath C:\temp\customRoutes.ps1
    .EXAMPLE
        Start-Listener -RoutesFilePath C:\temp\customRoutes.ps1
    .PARAMETER Port
        A Port can be specified, but is not required, Default is 8080.
    .PARAMETER RoutesFilePath
        A Custom Routes file can be specified, but is not required, default is included in the module.
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
        [Parameter()][String]$RoutesFilePath = "null",
        [Parameter()][String]$Port = 8080
    )    
    # No pre-task
    $script:Status = $true
    if ($pscmdlet.ShouldProcess("Starting HTTP Listener."))
    { 
        $script:listener = New-Object System.Net.HttpListener
        Invoke-StartListener -Port $Port
        # Run until you send a GET request to /end
        Do
        {
            # Capture requests as they come in (not Asyncronous)
            $script:Request = Invoke-GetContext

            # Request Handler Data
            $RequestType = $Request.HttpMethod
            $RawRequestURL = $Request.RawUrl
            $RequestURL, $RequestArgs = $RawRequestURL.split("?")

            # Setup a placeholder to deliver a response
            $script:response = $context.Response
            $result = $null
        
            # Break from loop if GET request sent to /shutdown
            if ($RequestURL -match '/EndPoint/Shutdown$')
            {
                Write-Output "Received Request to shutdown Endpoint."
                $script:result = "Shutting down ReST Endpoint."
                $script:Status = $false
            }
            else
            {
                # Attempt to process the Request.
                Write-Output "Processing RequestType: $RequestType URL: $RequestURL Args: $RequestArgs"
                if ($RoutesFilePath -eq "null")
                {
                    $RoutesFilePath = "Invoke-AvailableRouteSet"
                }
                $script:result = Invoke-RequestRouter -RequestType $RequestType -RequestURL $RequestURL -RoutesFilePath $RoutesFilePath -RequestArgs $RequestArgs
            }
            # Convert the returned data to JSON and set the HTTP content type to JSON
            Write-Output "The result is $script:result"
            $script:response.ContentType = 'application/json'
            # Stream the output back to requestor.
            Invoke-StreamOutput
        } while ($script:Status -eq $true)
        #Terminate the listener
        Invoke-StopListener -Port $Port
        return "Listener Stopped"
    } 
    else
    {
        # -WhatIf was used.
        return $false
    }         
}