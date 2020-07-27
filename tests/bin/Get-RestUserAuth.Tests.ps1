$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Routes Variable function for $script:ModuleName" -Tags Build {
    It "Should Return true." {
        Get-RestUserAuth | Should -not -Be $null
    }
}