$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Imports Endpoint routes for $script:ModuleName" -Tags Build {
    function Test-Path {}
    function Get-Content {}
    It "Should not be null." {
        Mock -CommandName 'Test-Path' -MockWith {
            return $true
        }
        Mock -CommandName 'Get-Content' -MockWith {
            $data = @(
                @{
                    'RequestType'    = 'GET'
                    'RequestURL'     = '/proc'
                    'RequestCommand' = 'Get-Process -ErrorAction SilentlyContinue | Select-Object -PropertyName ProcessName -ErrorAction SilentlyContinue'
                }
                @{
                    'RequestType'    = 'GET'
                    'RequestURL'     = '/endpoint/status'
                    'RequestCommand' = 'return 1'
                }
            )
            $JsonData = $data | ConvertTo-Json
            return $JsonData
        }
        
        Import-RouteSet -RoutesFilePath '$env:systemdrive/RestPS/endpoints/routes.json' | Should be $null
        Assert-MockCalled -CommandName 'Test-Path' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Get-Content' -Times 1 -Exactly
    }
    It "Should not throw." {
        Mock -CommandName 'Test-Path' -MockWith {
            return $true
        }
        Mock -CommandName 'Get-Content' -MockWith {
            $data = @(
                @{
                    'RequestType'    = 'GET'
                    'RequestURL'     = '/proc'
                    'RequestCommand' = 'Get-Process -ErrorAction SilentlyContinue | Select-Object -PropertyName ProcessName -ErrorAction SilentlyContinue'
                }
                @{
                    'RequestType'    = 'GET'
                    'RequestURL'     = '/endpoint/status'
                    'RequestCommand' = 'return 1'
                }
            )
            $JsonData = $data | ConvertTo-Json
            return $JsonData
        }
        {Import-RouteSet -RoutesFilePath '$env:systemdrive/RestPS/endpoints/routes.json'} | Should not Throw
        Assert-MockCalled -CommandName 'Test-Path' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Get-Content' -Times 2 -Exactly
    }
    It "Should throw if the path is not valid." {
        Mock -CommandName 'Test-Path' -MockWith {
            return $false
        }
        Mock -CommandName 'Get-Content' -MockWith {}
        {Import-RouteSet -RoutesFilePath '$env:systemdrive/RestPS/endpoints/routes.json'} | Should Throw
        Assert-MockCalled -CommandName 'Test-Path' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Get-Content' -Times 2 -Exactly
    }
}