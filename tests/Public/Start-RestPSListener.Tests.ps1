$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Start-RestPSListener function for $moduleName" {
    function Invoke-StartListener {}
    function Invoke-GetContext {}
    function Invoke-StreamOutput {}
    function Write-Output {}
    function Invoke-GetBody {}
	function Invoke-AvailableRouteSet {}
	function Invoke-RequestRouter {}
	function Invoke-StopListener {}
    It "Should return False if -WhatIf is used." {
        Start-RestPSListener -WhatIf | Should be $false
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
        Mock -CommandName 'Write-Output' -MockWith {}
        Start-RestPSListener | Should be $null
        Assert-MockCalled -CommandName 'Write-Output' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetContext' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetBody' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StartListener' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StreamOutput' -Times 1 -Exactly
        
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
        Mock -CommandName 'Write-Output' -MockWith {}
        Mock -CommandName 'Invoke-GetBody' -MockWith {}
        Start-RestPSListener -RoutesFilePath "FakePath" | Should be $null
        Assert-MockCalled -CommandName 'Write-Output' -Times 6 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetContext' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetBody' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StartListener' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StreamOutput' -Times 2 -Exactly        
        Assert-MockCalled -CommandName 'Invoke-RequestRouter' -Times 1 -Exactly        
        
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
        Mock -CommandName 'Write-Output' -MockWith {}
        Start-RestPSListener -RoutesFilePath "null" | Should be $null
        Assert-MockCalled -CommandName 'Write-Output' -Times 9 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetContext' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetBody' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StartListener' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StreamOutput' -Times 3 -Exactly        
        Assert-MockCalled -CommandName 'Invoke-RequestRouter' -Times 2 -Exactly        
        
    }
    It "Should return 'null' if a message is streamed back to requestor." {
        function Invoke-ValidateClient {}
        function Get-ClientCertInfo {}
        Mock -CommandName 'Get-ClientCertInfo' -MockWith {}
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
        Mock -CommandName 'Write-Output' -MockWith {}
        Start-RestPSListener -RoutesFilePath C:\temp\customRoutes.ps1 -VerificationType VerifyRootCA -SSLThumbprint $Thumb -AppGuid $Guid  | Should be $null
        Assert-MockCalled -CommandName 'Write-Output' -Times 12 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetContext' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetBody' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StartListener' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StreamOutput' -Times 4 -Exactly        
        Assert-MockCalled -CommandName 'Invoke-RequestRouter' -Times 2 -Exactly        
        
    }       
}