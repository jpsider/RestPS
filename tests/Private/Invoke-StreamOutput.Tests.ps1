$script:ModuleName = 'RestPS'
Describe "Invoke-StreamOutput function for $moduleName" {
    It "Should return True." {
        Invoke-StreamOutput | Should be $true
    }
}