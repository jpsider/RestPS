function Invoke-AvailableRouteSet
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", '')]
    $script:Routes = @(
        @{
            'RequestType'    = 'GET'
            'RequestURL'     = '/proc'
            'RequestCommand' = 'get-process | select-object ProcessName'
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