function Invoke-StreamOutput
{
    # Process the Return data to send Json message back.
    # Convert the data to UTF8 bytes
    $message = $script:result | ConvertTo-Json
    [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes("$message")
    # Set length of response
    $script:Response.ContentLength64 = $buffer.length
    # Write response out and close
    $script:Response.OutputStream.Write($buffer, 0, $buffer.length)
    $script:Response.Close()
}