$script:ModuleName = 'RestPS'
Describe "Invoke-GetContext function for $moduleName" {
    function Invoke-MockGetContext
    {
        return $true
    }
    Set-Alias Invoke-GetContext Invoke-MockGetContext -Scope Global
    It "Should return True." {
        Invoke-GetContext | Should be $true
    }
    Remove-Item Alias:\Invoke-GetContext
    Remove-Item Function:\Invoke-MockGetContext
}