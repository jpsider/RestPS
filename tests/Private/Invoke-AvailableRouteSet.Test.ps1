$script:ModuleName = 'RestPS'

Describe "Routes Variable function for $moduleName" {
    It "Should Return true." {
        Invoke-AvailableRouteSet | Should be $true
    }
}