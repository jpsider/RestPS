$script:ModuleName = 'RestPS'
Describe "Invoke-StartListener function for $moduleName" {
    function Invoke-MockStartListener
    {
        return $true
    }
    Set-Alias Invoke-StartListener Invoke-MockStartListener -Scope Global
    It "Should return True." {
        Invoke-StartListener | Should be $true
    }
    Remove-Item Alias:\Invoke-StartListener
    Remove-Item Function:\Invoke-MockStartListener
}