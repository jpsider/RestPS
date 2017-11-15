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
            'RequestCommand' = "$PSScriptRoot\..\endpoints\GET\Invoke-GetProcess.ps1"
        }
        @{
            'RequestType'    = 'PUT'
            'RequestURL'     = '/Service'
            'RequestCommand' = "$PSScriptRoot\..\endpoints\PUT\Invoke-GetProcess.ps1"
        }
        @{
            'RequestType'    = 'POST'
            'RequestURL'     = '/data'
            'RequestCommand' = "$PSScriptRoot\..\endpoints\POST\Invoke-GetProcess.ps1"
        }
        @{
            'RequestType'    = 'DELETE'
            'RequestURL'     = '/data'
            'RequestCommand' = "$PSScriptRoot\..\endpoints\DELETE\Invoke-GetProcess.ps1"
        }            
    )
}