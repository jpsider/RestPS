$script:ModuleName = 'RestPS'
Describe "Start-RestPSListener function for $moduleName" {
    It "Should return False if -WhatIf is used." {
        Start-RestPSListener -WhatIf | Should be $false
    }
    It "Should return 'Listener Stopped' if the url is /EndPoint/Shutdown" {
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
        Mock -CommandName 'Write-Output' -MockWith {}
        Start-RestPSListener | Should be "Listener Stopped"
        Assert-MockCalled -CommandName 'Write-Output' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetContext' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StartListener' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StreamOutput' -Times 1 -Exactly
        
    }     
    It "Should return 'Listener Stopped' if a message is streamed back to requestor." {
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
        Start-RestPSListener -RoutesFilePath "FakePath" | Should be "Listener Stopped"
        Assert-MockCalled -CommandName 'Write-Output' -Times 6 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetContext' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StartListener' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StreamOutput' -Times 2 -Exactly        
        Assert-MockCalled -CommandName 'Invoke-RequestRouter' -Times 1 -Exactly        
        
    }
    It "Should return 'Listener Stopped' if a message is streamed back to requestor." {
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
        Start-RestPSListener -RoutesFilePath "null" | Should be "Listener Stopped"
        Assert-MockCalled -CommandName 'Write-Output' -Times 9 -Exactly
        Assert-MockCalled -CommandName 'Invoke-GetContext' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StartListener' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Invoke-StreamOutput' -Times 3 -Exactly        
        Assert-MockCalled -CommandName 'Invoke-RequestRouter' -Times 2 -Exactly        
        
    }       
}