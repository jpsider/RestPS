$script:ModuleName = 'RestPS'

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