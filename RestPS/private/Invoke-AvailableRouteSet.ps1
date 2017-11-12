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
        'RequestCommand' = '.\GET\Invoke-GetProcess.ps1'
    }
    @{
        'RequestType'    = 'PUT'
        'RequestURL'     = '/Service'
        'RequestCommand' = '.\PUT\Invoke-GetProcess.ps1'
    }
    @{
        'RequestType'    = 'POST'
        'RequestURL'     = '/data'
        'RequestCommand' = '.\POST\Invoke-GetProcess.ps1'
    }
    @{
        'RequestType'    = 'DELETE'
        'RequestURL'     = '/data'
        'RequestCommand' = '.\DELETE\Invoke-GetProcess.ps1'
    }            
)