$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

describe "Invoke-GetBody function for $script:ModuleName" -Tags Build {
    It 'Should NOT return Null if the request has a body' {
        $data = @{
            HasEntityBody = $true
            InputStream   = "$here\$sut"
        }
        $ReturnJson = $data | ConvertTo-Json
        $script:Request = $ReturnJson | convertfrom-json
        Invoke-GetBody | Should not be $null
    }
    It 'Should return Null if the request has no body' {
        $data = @{
            HasEntityBody = $false
            InputStream   = "SomeText"
        }
        $ReturnJson = $data | ConvertTo-Json
        $script:Request = $ReturnJson | convertfrom-json
        Invoke-GetBody | Should be null
    }
}