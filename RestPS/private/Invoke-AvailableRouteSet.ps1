[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", '')]
$Routes = @(
    @{
        'RequestType'    = 'GET'
        'RequestURL'     = '/proc'
        'RequestCommand' = 'get-process | select-object ProcessName'
    }
    @{
        'RequestType'    = 'GET'
        'RequestURL'     = '/process'
        'RequestCommand' = "$PSScriptRoot\GET\Invoke-GetProcess.ps1"
    }
    @{
        'RequestType'    = 'PUT'
        'RequestURL'     = '/Service'
        'RequestCommand' = "$PSScriptRoot\PUT\Invoke-GetProcess.ps1"
    }
    @{
        'RequestType'    = 'POST'
        'RequestURL'     = '/data'
        'RequestCommand' = "$PSScriptRoot\POST\Invoke-GetProcess.ps1"
    }
    @{
        'RequestType'    = 'DELETE'
        'RequestURL'     = '/data'
        'RequestCommand' = "$PSScriptRoot\DELETE\Invoke-GetProcess.ps1"
    }            
)