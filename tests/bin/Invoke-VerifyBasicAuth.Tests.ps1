$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

function Write-Log {}
function Get-RestUserAuth {}
$tempDir = (pwd).Path
$RestPSLocalRoot = $tempDir + "\RestPS" 

Describe "Routes Variable function for $script:ModuleName" -Tags Build {
    It "Should Return false if No User data is returned from Get-RestUserAuth function." {
        function Write-Log {}
        function Get-RestUserAuth {}
        $tempDir = (pwd).Path
        $RestPSLocalRoot = $tempDir + "\RestPS" 
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-RestUserAuth' -MockWith {
            $RawReturn = @{
                UserData = $null
            }               
            $ReturnJson = $RawReturn | ConvertTo-Json
            $UserAuth = $ReturnJson | convertfrom-json
            return $UserAuth
        }
        Invoke-VerifyBasicAuth | Should -Be $false
    }
}