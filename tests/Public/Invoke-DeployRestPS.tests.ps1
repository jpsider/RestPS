$script:ModuleName = 'RestPS'

Describe "Invoke-DeployRestPS function for $moduleName" {
    function Write-Output {}
    function New-Item {}
    function Copy-Item {}
    function Test-Path {}
    It "Should not Throw If the Local Dir exists." {
        Mock -CommandName 'Test-Path' -MockWith {
            $true
        }
        Mock -CommandName 'Copy-Item' -MockWith {}
        Mock -CommandName 'New-Item' -MockWith {}
        Mock -CommandName 'Write-Output' -MockWith {}
        {Invoke-DeployRestPS -LocalDir c:\temp\someDir} | Should -Not -Throw
        Assert-MockCalled -CommandName 'Test-Path' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Copy-Item' -Times 5 -Exactly
        Assert-MockCalled -CommandName 'New-Item' -Times 0 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 5 -Exactly
    }
    It "Should not Throw if the Local Dir does not exist." {
        Mock -CommandName 'Test-Path' -MockWith {
            $false
        }
        Mock -CommandName 'Copy-Item' -MockWith {}
        Mock -CommandName 'New-Item' -MockWith {}
        Mock -CommandName 'Write-Output' -MockWith {}
        {Invoke-DeployRestPS -LocalDir c:\temp\someDir} | Should -Not -Throw
        Assert-MockCalled -CommandName 'Test-Path' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Copy-Item' -Times 10 -Exactly
        Assert-MockCalled -CommandName 'New-Item' -Times 7 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 10 -Exactly
    }
    It "Should Throw if the CopyItem fails." {
        Mock -CommandName 'Test-Path' -MockWith {
            $true
        }
        Mock -CommandName 'Copy-Item' -MockWith {
            Throw "Copy Failed"
        }
        Mock -CommandName 'New-Item' -MockWith {}
        Mock -CommandName 'Write-Output' -MockWith {}
        {Invoke-DeployRestPS -LocalDir c:\temp\someDir} | Should -Throw
        Assert-MockCalled -CommandName 'Test-Path' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Copy-Item' -Times 11 -Exactly
        Assert-MockCalled -CommandName 'New-Item' -Times 7 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 11 -Exactly
    }
}