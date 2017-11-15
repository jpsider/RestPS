function Invoke-StreamOutput
{
    # Process the Return data to send Json message back.
    # Convert the data to UTF8 bytes
    $message = $script:result | ConvertTo-Json
    [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($message)
    # Set length of response
    $response.ContentLength64 = $buffer.length
    # Write response out and close
    $output = $response.OutputStream
    $output.Write($buffer, 0, $buffer.length)
    $output.Close()
}