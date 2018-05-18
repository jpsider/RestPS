$script:ModuleName = 'RestPS'
Describe "Invoke-StopListener function for $moduleName" {
    $listener = [System.Net.HttpListener]::new()
    function Write-Output {}
    Mock -CommandName 'Write-Output' -MockWith {}
    It "Should return null." {
        Invoke-StopListener | Should be $null
        Assert-MockCalled -CommandName 'Write-Output' -Times 1 -Exactly
    }
}