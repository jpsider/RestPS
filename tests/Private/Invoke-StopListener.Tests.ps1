$script:ModuleName = 'RestPS'
Describe "Invoke-StopListener function for $moduleName" {
    function Invoke-MockStopListener
    {
        return $true
    }
    Set-Alias Invoke-StopListener Invoke-MockStopListener -Scope Global
    It "Should return True." {
        Invoke-StopListener | Should be $true
    }
    Remove-Item Alias:\Invoke-StopListener
    Remove-Item Function:\Invoke-MockStopListener
}