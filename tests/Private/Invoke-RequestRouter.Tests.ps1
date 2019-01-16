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
Function Import-RouteSet {}
Function Invoke-Expression {}
Describe "Invoke-RequestRouter function for $script:ModuleName" -Tags Build {
    It "Should return Invalid Command, if invoke expression fails." {
        Mock -CommandName 'Import-RouteSet' -MockWith {}
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
        Mock -CommandName 'Set-Location' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" -RoutesFilePath $RoutesFilePath | Should be $null
    }
    It "Should return No Matching Routes, if the URL is invalid." {
        Mock -CommandName 'Import-RouteSet' -MockWith {
            $Route = $null
        }
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/FakeURL" -RoutesFilePath $RoutesFilePath | Should be $null
    }
    It "Should return No Matching Routes, if the URL is invalid." {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/FakeURL" -RoutesFilePath $RoutesFilePath 
        $script:StatusDescription | Should be "Not Found"
    }
    It "Should return No Matching Routes, if the URL is invalid." {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/FakeURL" -RoutesFilePath $RoutesFilePath 
        $script:StatusCode | Should be 404
    }
    It "Should not be null, when routes are returned." {
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
        Mock -CommandName 'Set-Location' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/endpoint/routes" -RoutesFilePath $RoutesFilePath | Should not be $null
    }
    It "Should return True" {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return 'True @{ProcessName=calc.exe}'
        }
        Mock -CommandName 'Set-Location' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" -RoutesFilePath $RoutesFilePath | Should Be $true
    }
}