$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Start-RestPSListener function for $script:ModuleName" -Tags Build {
    function Invoke-StartListener {}
    function Invoke-GetContext {}
    function Invoke-StreamOutput {}
    function Invoke-GetBody {}
    function Invoke-AvailableRouteSet {}
    function Invoke-RequestRouter {}
    function Invoke-StopListener {}
    function Write-Log {}
    It "Should return False if -WhatIf is used." {
        Start-RestPSListener -WhatIf | Should -Be $false
    }
    It "Should return 'null' if the url is /EndPoint/Shutdown" {
        Mock -CommandName 'Invoke-StartListener' -MockWith {}
        Mock -CommandName 'Invoke-GetContext' -MockWith {
            $script:Request = @{
                'HttpMethod' = "Get"
                'RawUrl'     = "/EndPoint/Shutdown"
            }
            $script:Context = @{
                Response = @{
                    'ContentType' = "application/json"
                }
            }
            return $script:Request
        }
        Mock -CommandName 'Invoke-StreamOutput' -MockWith {}
        Mock -CommandName 'Invoke-GetBody' -MockWith {}
        Mock -CommandName 'Write-Log' -MockWith {}
        Start-RestPSListener | Should -Be $null
        
    }     
    It "Should return 'null' if a message is streamed back to requestor." {
        Mock -CommandName 'Invoke-StartListener' -MockWith {}
        Mock -CommandName 'Invoke-GetContext' -MockWith {
            $script:Request = @{
                'HttpMethod' = "Get"
                'RawUrl'     = "/proc"
            }
            $script:Context = @{
                Response = @{
                    'ContentType' = "application/json"
                }
            }
            return $script:Request
        }
        Mock -CommandName 'Invoke-RequestRouter' -MockWith {
            $script:result = "Some fake output"
            return $script:result
        }
        Mock -CommandName 'Invoke-StreamOutput' -MockWith {
            $script:Status = $false
        }
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-GetBody' -MockWith {}
        Start-RestPSListener -RoutesFilePath "FakePath" | Should -Be $null
    }
    It "Should return 'null' if a message is streamed back to requestor." {
        Mock -CommandName 'Invoke-StartListener' -MockWith {}
        Mock -CommandName 'Invoke-GetContext' -MockWith {
            $script:Request = @{
                'HttpMethod' = "Get"
                'RawUrl'     = "/proc"
            }
            $script:Context = @{
                Response = @{
                    'ContentType' = "application/json"
                }
            }
            return $script:Request
        }
        Mock -CommandName 'Invoke-RequestRouter' -MockWith {
            $script:result = "Some fake output"
            return $script:result
        }
        Mock -CommandName 'Invoke-StreamOutput' -MockWith {
            $script:Status = $false
        }
        Mock -CommandName 'Invoke-GetBody' -MockWith {}
        Mock -CommandName 'Write-Log' -MockWith {}
        Start-RestPSListener -RoutesFilePath "null" | Should -Be $null
    }
    It "Should return 'null' if a message is streamed back to requestor." {
        function Invoke-ValidateClient {}
        Mock -CommandName 'Invoke-ValidateClient' -MockWith {
            $false
        }
        Mock -CommandName 'Invoke-StartListener' -MockWith {}
        Mock -CommandName 'Invoke-GetContext' -MockWith {
            $script:Request = @{
                'HttpMethod' = "Get"
                'RawUrl'     = "/proc"
            }
            $script:Context = @{
                Response = @{
                    'ContentType' = "application/json"
                }
            }
            return $script:Request
        }
        Mock -CommandName 'Invoke-RequestRouter' -MockWith {
            $script:result = "Some fake output"
            return $script:result
        }
        Mock -CommandName 'Invoke-StreamOutput' -MockWith {
            $script:Status = $false
        }
        Mock -CommandName 'Invoke-GetBody' -MockWith {}
        Mock -CommandName 'Write-Log' -MockWith {}
        Start-RestPSListener -RoutesFilePath C:\temp\customRoutes.ps1 -VerificationType VerifyRootCA -SSLThumbprint $Thumb -AppGuid $Guid  | Should -Be $null
    }       
}