function Invoke-GetContext
{
    <#
	.DESCRIPTION
		This function retrieves the Data from the HTTP Listener.
	.EXAMPLE
        Invoke-GetContext
	.NOTES
        This will return a HTTPListenerContext object.
    #>
    $script:context = $listener.GetContext()
    $Request = $script:context.Request
    $Request
}