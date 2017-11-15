function Start-RestPSListener
{
    <#
	.DESCRIPTION
		Start a HTTP listener on a specified port.
	.EXAMPLE
        Start-Listener -Port 8081
    .EXAMPLE
        Start-Listener
    .PARAMETER Port
        A Port can be specified, but is not required, Default is 8080.
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
            $RequestURL = $Request.RawUrl
        
            # Setup a placeholder to deliver a response
            $script:response = $context.Response
            $result = $null
        
            # Break from loop if GET request sent to /shutdown
            if ($RequestURL -match '/shutdown$')
            {
                Write-Output "Received Request to shutdown Endpoint."
                $script:result = "Shutting down ReST Endpoint."
                $script:Status = $false
            }
            else
            {
                # Attempt to process the Request.
                Write-Output "Processing RequestType: $RequestType URL: $RequestURL"
                $script:result = Invoke-RequestRouter -RequestType $RequestType -RequestURL $RequestURL
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