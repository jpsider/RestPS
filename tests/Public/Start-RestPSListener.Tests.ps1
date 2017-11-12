$script:ModuleName = 'RestPS'
Describe "Start-RestPSListener function for $moduleName" {
    It "Should return False if -WhatIf is used." {
        Start-RestPSListener -WhatIf | Should be $false
    }
}