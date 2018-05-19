function Invoke-AvailableRouteSet
{
    <#
	.DESCRIPTION
		This function defines the available Routes (Rest Methods and Commands/Scripts).
	.EXAMPLE
        Invoke-AvailableRouteSet
	.NOTES
        This will return null.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", '')]
    $script:Routes = @(
        @{
            'RequestType'    = 'GET'
            'RequestURL'     = '/proc'
            'RequestCommand' = 'get-process | select-object ProcessName -ErrorAction SilentlyContinue'
        }
        @{
            'RequestType'    = 'GET'
            'RequestURL'     = '/process'
            'RequestCommand' = "endpoints\GET\Invoke-GetProcess.ps1"
        }
        @{
            'RequestType'    = 'PUT'
            'RequestURL'     = '/Service'
            'RequestCommand' = "endpoints\PUT\Invoke-GetProcess.ps1"
        }
        @{
            'RequestType'    = 'POST'
            'RequestURL'     = '/data'
            'RequestCommand' = "endpoints\POST\Invoke-GetProcess.ps1"
        }
        @{
            'RequestType'    = 'DELETE'
            'RequestURL'     = '/data'
            'RequestCommand' = "endpoints\DELETE\Invoke-GetProcess.ps1"
        }            
    )
}