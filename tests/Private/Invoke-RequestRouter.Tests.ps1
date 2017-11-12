$script:ModuleName = 'RestPS'
$Routes = @(
    @{
        'RequestType'    = 'GET'
        'RequestURL'     = '/proc'
        'RequestCommand' = 'get-process | select-object ProcessName'
    }
)
Describe "Invoke-RequestRouter function for $moduleName" {
    It "Should return True" {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return '@{ProcessName=calc.exe}'
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" | Should Be $true
        Assert-MockCalled -CommandName 'Write-Output' -Times 2 -Exactly
    }
    It "Should return Invalid Command, if invoke expression fails." {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" | Should be "Invalid Command"
        Assert-MockCalled -CommandName 'Write-Output' -Times 4 -Exactly
    }
    It "Should return No Matching Routes, if the URL is invalid." {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/FakeURL" | Should be "No Matching Routes"
        Assert-MockCalled -CommandName 'Write-Output' -Times 6 -Exactly
    }
}