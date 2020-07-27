$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

describe "Invoke-GetContext function for $script:ModuleName" -Tags Build {
    It 'Should return Null if a Context exists' {
        class MockGetContext
        {
            [string]GetContext()
            {
                $data = @{
                    Request = $true
                }
                $ReturnJson = $data | ConvertTo-Json
                $FinalData = $ReturnJson | convertfrom-json
                return $FinalData
            }
        }
        $listener = New-Object MockGetContext
        Invoke-GetContext | Should -Be $null
    }
}