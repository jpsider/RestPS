$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

describe "Get-ClientCertInfo function for $script:ModuleName" -Tags Build {
    It 'Should return Null' {
        class MockCertRequest
        {
            [string]GetClientCertificate()
            {
                return $true
            }
        }
        $script:request = New-Object MockCertRequest
        Get-ClientCertInfo | Should be $null
    }
}