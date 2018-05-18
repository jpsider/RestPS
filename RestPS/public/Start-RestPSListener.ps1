function Start-RestPSListener
{
    <#
	.DESCRIPTION
        Start a HTTP listener on a specified port.
    .PARAMETER Port
        A Port can be specified, but is not required, Default is 8080.
    .PARAMETER SSLThumbprint
        A SSLThumbprint can be specified, but is not required.
    .PARAMETER AppGuid
        A AppGuid can be specified, but is not required.
    .PARAMETER RoutesFilePath
        A Custom Routes file can be specified, but is not required, default is included in the module.
	.EXAMPLE
        Start-RestPSListener
    .EXAMPLE
        Start-RestPSListener -Port 8081
    .EXAMPLE
        Start-RestPSListener -Port 8081 -RoutesFilePath C:\temp\customRoutes.ps1
    .EXAMPLE
        Start-RestPSListener -RoutesFilePath C:\temp\customRoutes.ps1
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
        [Parameter()][String]$Port = 8080,
        [Parameter()][String]$SSLThumbprint,
        [Parameter()][String]$AppGuid = ((New-Guid).Guid)
    )    
    # No pre-task
    $script:Status = $true
    if ($pscmdlet.ShouldProcess("Starting HTTP Listener."))
    { 
        $script:listener = New-Object System.Net.HttpListener
        Invoke-StartListener -Port $Port -SSLThumbPrint $SSLThumbprint -AppGuid $AppGuid
        # Run until you send a GET request to /end
        Do
        {
            # Capture requests as they come in (not Asyncronous)
            $script:Request = Invoke-GetContext
            $script:result = $null

            # Request Handler Data
            $RequestType = $Request.HttpMethod
            $RawRequestURL = $Request.RawUrl
            $RequestURL, $RequestArgs = $RawRequestURL.split("?")

            # Break from loop if GET request sent to /shutdown
            if ($RequestURL -match '/EndPoint/Shutdown$')
            {
                Write-Output "Received Request to shutdown Endpoint."
                $script:result = "Shutting down ReST Endpoint."
                $script:Status = $false
                $script:HttpCode = 200
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

            # Setup a placeholder to deliver a response
            $script:Response = $script:context.Response
            # Convert the returned data to JSON and set the HTTP content type to JSON
            $script:Response.ContentType = 'application/json'
            $script:Response.StatusCode = 200
            # Stream the output back to requestor.
            Invoke-StreamOutput
        } while ($script:Status -eq $true)
        #Terminate the listener
        Invoke-StopListener -Port $Port
        Write-Output "Listener Stopped"
    } 
    else
    {
        # -WhatIf was used.
        return $false
    }         
}