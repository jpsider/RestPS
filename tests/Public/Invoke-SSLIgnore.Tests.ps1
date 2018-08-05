$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-SSLIgnore function for $moduleName" {
    It "Should Return true." {
        Invoke-SSLIgnore | Should be $true
    }
    It "Should Return true." {
        Mock -CommandName 'Add-Type' -MockWith {
            return $true
        }
        Invoke-SSLIgnore | Should be $true
    }
}