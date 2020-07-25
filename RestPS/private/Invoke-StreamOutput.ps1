function Invoke-StreamOutput
{
    <#
	.DESCRIPTION
        This function will Stream output back to the Client.
	.EXAMPLE
        Invoke-StreamOutput
	.NOTES
        This will returns a stream of data.
    #>

    # Setup a placeholder to deliver a response
    $script:Response = $script:context.Response

    if($null -eq $script:ResponseContentType)
    {
        # If a response content type hasn't been defined in RestPSRoutes.json then default to JSON
        $script:Response.ContentType = 'application/json'
        
        # Process the Return data to send Json message back.
        $message = $script:result | ConvertTo-Json
    }
    else
    {
        # Set the content type to that defined in RestPSRoutes.json (e.g. text/plain)   
        $script:Response.ContentType = $script:ResponseContentType

        # Process the return data to send back as plain text
        $message = $script:result
    }
   
    $script:Response.StatusCode = $script:StatusCode
    $script:Response.StatusDescription = $script:StatusDescription
   
    # Convert the data to UTF8 bytes
    [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes("$message")
    # Set length of response
    $script:Response.ContentLength64 = $buffer.length
    # Write response out and close
    $script:Response.OutputStream.Write($buffer, 0, $buffer.length)
    $script:Response.Close()
}