$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-DeployRestPS function for $moduleName" {
    function Write-Output {}
    function New-Item {}
    function Copy-Item {}
    function Test-Path {}
    function Get-ChildItem {}
    function Get-Module {}
    $RawReturn = @(
        @{
            FullName = 'c:\somePath\Somefile.ps1'
            Name     = 'SomeFile.ps1'
        }               
    )
    $ReturnJson = $RawReturn | ConvertTo-Json
    $ReturnData = $ReturnJson | convertfrom-json
    $RawReturn4 = @(
        @{
            path = 'c:\someModulePath'
        }               
    )
    $ReturnJson4 = $RawReturn4 | ConvertTo-Json
    $ReturnData4 = $ReturnJson4 | convertfrom-json
    It "Should not Throw If the Local Dir exists." {
        Mock -CommandName 'Test-Path' -MockWith {
            $true
        }
        Mock -CommandName 'Get-Module' -MockWith {
            return $ReturnData4
        }
        Mock -CommandName 'Get-ChildItem' -MockWith {
            return $ReturnData
        }
        Mock -CommandName 'Copy-Item' -MockWith {}
        Mock -CommandName 'New-Item' -MockWith {}
        Mock -CommandName 'Write-Output' -MockWith {}
        {Invoke-DeployRestPS -LocalDir c:\temp\someDir} | Should -Not -Throw
        Assert-MockCalled -CommandName 'Test-Path' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Copy-Item' -Times 6 -Exactly
        Assert-MockCalled -CommandName 'New-Item' -Times 0 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 6 -Exactly
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
        Assert-MockCalled -CommandName 'Copy-Item' -Times 12 -Exactly
        Assert-MockCalled -CommandName 'New-Item' -Times 8 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 12 -Exactly
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
        Assert-MockCalled -CommandName 'Copy-Item' -Times 13 -Exactly
        Assert-MockCalled -CommandName 'New-Item' -Times 8 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 13 -Exactly
    }
}