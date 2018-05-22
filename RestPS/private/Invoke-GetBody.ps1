function Invoke-GetBody
{
    <#
	.DESCRIPTION
		This function retrieves the Data from the HTTP Listener Body property.
	.EXAMPLE
        Invoke-GetBody
	.NOTES
        This will return a Body object.
    #>
    if ($script:Request.HasEntityBody)
    {
        $script:RawBody = $script:Request.InputStream
        $Reader = New-Object System.IO.StreamReader @($script:RawBody, [System.Text.Encoding]::UTF8)
        $script:Body = $Reader.ReadToEnd()
        $Reader.close()
        $script:Body
    }
    else
    {
        $script:Body = "null"
        $script:Body
    }
}