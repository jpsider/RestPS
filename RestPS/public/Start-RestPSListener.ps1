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
    param(
        [Parameter()][String]$Port = 8080
    )    
    # No pre-task
    $Status = $true
    if ($pscmdlet.ShouldProcess("Starting HTTP Listener."))
    { 
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add("http://+:$Port/") 
        $listener.Start()
        Write-Output "Starting HTTP Listener on Port: $Port"
        # Run until you send a GET request to /end
        Do
        {
            # Capture requests as they come in (not Asyncronous)
            $context = $listener.GetContext()     
        
            # Request Data Handler
            $Request = $Context.Request
            $RequestType = $Request.HttpMethod
            $RequestURL = $Request.RawUrl
        
            # Setup a place to deliver a response
            $response = $context.Response
            $result = $null
        
            # Break from loop if GET request sent to /end
            if ($RequestURL -match '/shutdown$')
            {
                Write-Output "Received Request to shutdown Endpoint."
                $result = "Shutting down ReST Endpoint."
                $Status = $false
            }
            else
            {
                # Attempt to process the Request.
                Write-Output "Processing RequestType: $RequestType URL: $RequestURL"
                $result = Invoke-RequestRouter -RequestType $RequestType -RequestURL $RequestURL
            }
            # Convert the returned data to JSON and set the HTTP content type to JSON
            $message = $result | ConvertTo-Json
            $response.ContentType = 'application/json'
            # Convert the data to UTF8 bytes
            [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($message)
            # Set length of response
            $response.ContentLength64 = $buffer.length
            # Write response out and close
            $output = $response.OutputStream
            $output.Write($buffer, 0, $buffer.length)
            $output.Close()
        } while ($Status -eq $true)
        #Terminate the listener
        Write-Output "Stopping HTTP Listener on port: $Port ..."
        $listener.Stop()
    } 
    else
    {
        # -WhatIf was used.
        return $false
    }         
}