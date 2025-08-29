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
		$script:RawBody = New-Object System.IO.MemoryStream
		$script:Request.InputStream.CopyTo($script:RawBody)
		$script:RawBody.Position=0
        $Reader = New-Object System.IO.StreamReader @($script:RawBody, [System.Text.Encoding]::UTF8,$false,1024,$true)
        $script:Body = $Reader.ReadToEnd()
        $Reader.close()
		$script:RawBody.Position=0
        $script:Body
    }
    else
    {
        $script:Body = "null"
        $script:Body
    }
}