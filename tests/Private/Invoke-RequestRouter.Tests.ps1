$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

$Routes = @(
    @{
        'RequestType'    = 'GET'
        'RequestURL'     = '/proc'
        'RequestCommand' = 'get-process | select-object ProcessName'
    }
)
$Routes = $Routes
$RoutesFilePath = "Invoke-AvailableRouteSet"
Describe "Invoke-RequestRouter function for $moduleName" {
    It "Should return True" {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return 'True @{ProcessName=calc.exe}'
        }
        Mock -CommandName 'Set-Location' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" -RoutesFilePath $RoutesFilePath | Should Be $true
    }
    It "Should return Invalid Command, if invoke expression fails." {
        $Routes = @(
            @{
                'RequestType'    = 'GET'
                'RequestURL'     = '/proc'
                'RequestCommand' = 'C:\RestPS\endpoints\GET\Invoke-GetProcess.ps1'
            }
        )
        $Routes = $Routes
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Set-Location' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" -RoutesFilePath $RoutesFilePath | Should be "400 Invalid Command"
    }
    It "Should return No Matching Routes, if the URL is invalid." {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/FakeURL" -RoutesFilePath $RoutesFilePath | Should be "404 No Matching Routes"
    }
}