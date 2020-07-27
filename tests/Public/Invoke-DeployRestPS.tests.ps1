$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-DeployRestPS function for $script:ModuleName" -Tags Build {
    #It "Should not Throw If the Local Dir exists." {
    #    function Write-Log {}
    #    function New-Item {}
    #    function Copy-Item {}
    #    function Test-Path {}
    #    function Get-ChildItem {}
    #    function Get-Module {}
    #    $RawReturn = @(
    #        @{
    #            FullName = '$env:systemdrive/RestPS/endpoints/routes.json'
    #            Name     = 'SomeFile.ps1'
    #        }               
    #    )
    #    $ReturnJson = $RawReturn | ConvertTo-Json
    #    $ReturnData = $ReturnJson | convertfrom-json
    #
    #
    #    Mock -CommandName 'Test-Path' -MockWith {
    #        $true
    #    }
    #    Mock -CommandName 'Get-Module' -MockWith {
    #        $RawReturn4 = @(
    #            @{
    #                Path    = 'c:\someModulePath'
    #                Version = "1.0"
    #            }               
    #        )
    #        $ReturnJson4 = $RawReturn4 | ConvertTo-Json
    #        $ReturnData4 = $ReturnJson4 | convertfrom-json
    #        return $ReturnData4
    #    }
    #    Mock -CommandName 'Get-ChildItem' -MockWith {
    #        return $ReturnData
    #    }
    #    Mock -CommandName 'Copy-Item' -MockWith {}
    #    Mock -CommandName 'New-Item' -MockWith {}
    #    Mock -CommandName 'Write-Log' -MockWith {}
    #    { Invoke-DeployRestPS -LocalDir c:\temp\someDir } | Should -Not -Throw
    #}
    #It "Should not Throw if the Local Dir does not exist." {
    #    function Write-Log {}
    #    function New-Item {}
    #    function Copy-Item {}
    #    function Test-Path {}
    #    function Get-ChildItem {}
    #    function Get-Module {}
    #    $RawReturn = @(
    #        @{
    #            FullName = '$env:systemdrive/RestPS/endpoints/routes.json'
    #            Name     = 'SomeFile.ps1'
    #        }               
    #    )
    #    $ReturnJson = $RawReturn | ConvertTo-Json
    #    $ReturnData = $ReturnJson | convertfrom-json
    #    $RawReturn4 = @(
    #        @{
    #            path = 'c:\someModulePath'
    #        }               
    #    )
    #    $ReturnJson4 = $RawReturn4 | ConvertTo-Json
    #    $ReturnData4 = $ReturnJson4 | convertfrom-json
    #
    #    Mock -CommandName 'Test-Path' -MockWith {
    #        $false
    #    }
    #    Mock -CommandName 'Copy-Item' -MockWith {}
    #    Mock -CommandName 'New-Item' -MockWith {}
    #    Mock -CommandName 'Write-Log' -MockWith {}
    #    { Invoke-DeployRestPS -LocalDir c:\temp\someDir } | Should -Not -Throw
    #}
    It "Should Throw if the CopyItem fails." {
        function Write-Log {}
        function New-Item {}
        function Copy-Item {}
        function Test-Path {}
        function Get-ChildItem {}
        function Get-Module {}
        $RawReturn = @(
            @{
                FullName = '$env:systemdrive/RestPS/endpoints/routes.json'
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
        Mock -CommandName 'Test-Path' -MockWith {
            $true
        }
        Mock -CommandName 'Copy-Item' -MockWith {
            Throw "Copy Failed"
        }
        Mock -CommandName 'New-Item' -MockWith {}
        Mock -CommandName 'Write-Log' -MockWith {}
        { Invoke-DeployRestPS -LocalDir c:\temp\someDir } | Should -Throw
    }
}