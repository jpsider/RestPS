$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"


#describe "Invoke-StreamOutput function for $script:ModuleName" -Tags Build {
#describe "Invoke-StreamOutput function for $script:ModuleName" {
#    It 'Should return Null if output is streamed' {
#        Invoke-StreamOutput | Should be $null
#    }
#}