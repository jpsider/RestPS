$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-StopListener function for $script:ModuleName" -Tags Build {
    It "Should return null." {
        function Write-Log {}
        Mock -CommandName 'Write-Log' -MockWith {}
        $listener = [System.Net.HttpListener]::new()
        $listener = $listener
        Invoke-StopListener | Should -Be $null
    }
}