function Invoke-AvailableRouteSet
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", '')]
    $script:Routes = @(
        @{
            'RequestType'    = 'GET'
            'RequestURL'     = '/proc'
            'RequestCommand' = 'get-process -ErrorAction SilentlyContinue | select-object ProcessName -ErrorAction SilentlyContinue'
        }
        @{
            'RequestType'    = 'GET'
            'RequestURL'     = '/process'
            'RequestCommand' = "C:\RestPS\endpoints\GET\Invoke-GetProcess.ps1"
        }
        @{
            'RequestType'    = 'PUT'
            'RequestURL'     = '/Service'
            'RequestCommand' = "C:\RestPS\endpoints\PUT\Invoke-GetProcess.ps1"
        }
        @{
            'RequestType'    = 'POST'
            'RequestURL'     = '/data'
            'RequestCommand' = "C:\RestPS\endpoints\POST\Invoke-GetProcess.ps1"
        }
        @{
            'RequestType'    = 'DELETE'
            'RequestURL'     = '/data'
            'RequestCommand' = "C:\RestPS\endpoints\DELETE\Invoke-GetProcess.ps1"
        }            
    )
}
Invoke-AvailableRouteSet