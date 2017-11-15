$script:ModuleName = 'RestPS'
Describe "Invoke-StreamOutput function for $moduleName" {
    function Invoke-MockStreamOutput
    {
        return $true
    }
    Set-Alias Invoke-StreamOutput Invoke-MockStreamOutput -Scope Global
    It "Should return True." {
        Invoke-StreamOutput | Should be $true
    }
    Remove-Item Alias:\Invoke-StreamOutput
    Remove-Item Function:\Invoke-MockStreamOutput
}