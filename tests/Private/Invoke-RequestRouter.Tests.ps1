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
$RoutesFilePath = "$env:systemdrive/RestPS/endpoints/routes.json"
$script:Body = "Fakedata"
Function Import-RouteSet { }
Function Invoke-Expression { }
Describe "Invoke-RequestRouter function for $script:ModuleName" -Tags Build {
    It "001 Should return Invalid Command, if invoke expression fails." {
        $RoutesFilePath = "$env:systemdrive/RestPS/endpoints/routes.json"

        Mock -CommandName 'Import-RouteSet' -MockWith { }
        $Routes = @(
            @{
                'RequestType'    = 'GET'
                'RequestURL'     = '/proc'
                'RequestCommand' = 'return 400 Invalid Command'
            }
        )
        $Routes = $Routes
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Set-Location' -MockWith { }
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" -RoutesFilePath $RoutesFilePath | Should -Be $null
    }
    It "002 Should return No Matching Routes, if the URL is invalid." {
        $RoutesFilePath = "$env:systemdrive/RestPS/endpoints/routes.json"
        Mock -CommandName 'Import-RouteSet' -MockWith {
            $Route = $null
        }
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/FakeURL" -RoutesFilePath $RoutesFilePath | Should -Be $null
    }
    It "Should return No Matching Routes, if the URL is invalid." {
        $RoutesFilePath = "$env:systemdrive/RestPS/endpoints/routes.json"
        Mock -CommandName 'Import-RouteSet' -MockWith { }
        $Routes = @(
            @{
                'RequestType'    = 'GET'
                'RequestURL'     = '/proc'
                'RequestCommand' = 'get-process | select-object ProcessName'
            }
        )
        $Routes = $Routes
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/FakeURL" -RoutesFilePath $RoutesFilePath 
        $script:StatusDescription | Should -Be "Not Found"
    }
    It "Should return No Matching Routes, if the URL is invalid." {
        $RoutesFilePath = "$env:systemdrive/RestPS/endpoints/routes.json"
        Mock -CommandName 'Import-RouteSet' -MockWith { }
        $Routes = @(
            @{
                'RequestType'    = 'GET'
                'RequestURL'     = '/proc'
                'RequestCommand' = 'get-process | select-object ProcessName'
            }
        )
        $Routes = $Routes
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/FakeURL" -RoutesFilePath $RoutesFilePath 
        $script:StatusCode | Should -Be 404
    }
    It "Should not-Be null, when routes are returned." {
        $RoutesFilePath = "$env:systemdrive/RestPS/endpoints/routes.json"
        Mock -CommandName 'Import-RouteSet' -MockWith { }
        $tempDir = (Get-Location).Path
        $RestPSLocalRoot = $tempDir + "\RestPS" 

        $Routes = @(
            @{
                'RequestType'    = 'GET'
                'RequestURL'     = '/endpoint/routes'
                'RequestCommand' = "$RestPSLocalRoot\EndPoints\GET\Invoke-GetRoutes.ps1"
            }
        )
        $Routes = $Routes
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Set-Location' -MockWith { }
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/endpoint/routes" -RoutesFilePath $RoutesFilePath | Should -not -Be $null
    }
    It "Should return True" {
        $RoutesFilePath = "$env:systemdrive/RestPS/endpoints/routes.json"
        Mock -CommandName 'Import-RouteSet' -MockWith { }
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return 'True @{ProcessName=calc.exe}'
        }
        Mock -CommandName 'Set-Location' -MockWith { }
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" -RoutesFilePath $RoutesFilePath | Should -Be $true
    }
}
