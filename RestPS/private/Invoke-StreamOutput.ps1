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
    # Process the Return data to send Json message back.
    $message = $script:result | ConvertTo-Json
    # Convert the data to UTF8 bytes
    [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes("$message")
    # Set length of response
    $script:Response.ContentLength64 = $buffer.length
    # Write response out and close
    $script:Response.OutputStream.Write($buffer, 0, $buffer.length)
    $script:Response.Close()
}