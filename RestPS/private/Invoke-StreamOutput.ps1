function Invoke-StreamOutput
{
    <#
	.DESCRIPTION
        This function will Stream output back to the Client.
	.EXAMPLE
        Invoke-StreamOutput
	.NOTES
        This will returns a stream of data. And compress data if needed.
    #>
    # Setup a placeholder to deliver a response
    $script:Response = $script:context.Response

    if ($null -eq $script:ResponseContentType)
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

    # Add header data to the response
    foreach ($head in $script:StatusHeaders.Keys)
    {
        $script:Response.AddHeader($head, $script:StatusHeaders[$head])
    }

    $responseByteArray = [byte[]][System.Text.Encoding]::UTF8.GetBytes("$message")
    try
    {
        if ($context.Request.Headers.Item('Accept-Encoding').Split(",").ToLowerInvariant() -contains "gzip")
        {
            # This part is strictly speaking not entirely RFC compliant.
            # it would need to handle qvalues as well:
            # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Encoding#:~:text=The%20Accept%2DEncoding%20request%20HTTP,the%20Content%2DEncoding%20response%20header.

            # Compress output
            # https://stackoverflow.com/questions/7438217/c-sharp-httplistener-response-gzipstream

            # compress responseByteArray and save back to responseByteArray
            $memoryStream = [System.IO.MemoryStream]::new()
            $gzipStream = [System.IO.Compression.GZipStream]::new($memoryStream, [System.IO.Compression.CompressionMode]::Compress, $true)
            $gzipStream.Write($responseByteArray, 0, $responseByteArray.Length)
            $gzipStream.Close()
            $responseByteArray = $memoryStream.ToArray()

            # Add some headers
            $Script:Response.SendChunked = $true
            $script:Response.AddHeader("Content-Encoding", "gzip");
        }
        else
        {
            # Do not compress output
        }
    }
    Catch
    {
        # Do not compress output
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        "Invoke-DeployRestPS: $ErrorMessage $FailedItem" | Out-Null
    }

    $script:Response.ContentLength64 = $responseByteArray.length
    $script:Response.OutputStream.Write($responseByteArray, 0, $responseByteArray.length)

    $script:Response.Close()
}
