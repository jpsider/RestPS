$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

function Write-Log {}
function Invoke-VerifyRootCA {}
function Get-RestAclList {}
$tempDir = (pwd).Path
$RestPSLocalRoot = $tempDir + "\RestPS" 

Describe "Routes Variable function for $script:ModuleName" -Tags Build {
    It "Should Return false if no client certificate is found." {
        $script:ClientCert = $null
        Mock -CommandName 'Write-Log' -MockWith {}
        Invoke-VerifySubject | Should be $false
        Assert-MockCalled -CommandName 'Write-Log' -Times 1 -Exactly
    }
    It "Should Return False when Invoke-VerifyRootCA fails." {
        $script:ClientCert = @{Thumbprint = "123456789"}
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyRootCA' -MockWith {
            $false
        }
        Invoke-VerifySubject | Should be $false
        Assert-MockCalled -CommandName 'Write-Log' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyRootCA' -Times 1 -Exactly
    }
    It "Should Return False when The ACL list is empty." {
        $script:ClientCert = @{Thumbprint = "123456789"}
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyRootCA' -MockWith {
            $true
        }
        Mock -CommandName 'Get-RestAclList' -MockWith {
            $null
        }
        Invoke-VerifySubject | Should be $false
        Assert-MockCalled -CommandName 'Write-Log' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyRootCA' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Get-RestAclList' -Times 1 -Exactly
    }
    It "Should Return False If the user is not in the ACL List." {
        $RawReturn = @{
            Subject    = "cn=client"
            Thumbprint = "123456789"
            Extensions = @{
                oid = @{
                    value = '2.5.29.35'
                }
            }
        }               
        $ReturnJson = $RawReturn | ConvertTo-Json
        $script:ClientCert = $ReturnJson | convertfrom-json
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyRootCA' -MockWith {
            $true
        }
        Mock -CommandName 'Get-RestAclList' -MockWith {
            $AclList = @('RestServer', 'NOClient', 'DemoClient.PowerShellDemo.io')
            return $AclList
        }
        Invoke-VerifySubject | Should not be $null
        Assert-MockCalled -CommandName 'Write-Log' -Times 7 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyRootCA' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Get-RestAclList' -Times 2 -Exactly
    }
    It "Should Return False If the subject is not found." {
        $RawReturn = @{
            Subject    = ""
            Thumbprint = "123456789"
            Extensions = @{
                oid = @{
                    value = '2.5.29.35'
                }
            }
        }               
        $ReturnJson = $RawReturn | ConvertTo-Json
        $script:ClientCert = $ReturnJson | convertfrom-json
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyRootCA' -MockWith {
            $true
        }
        Mock -CommandName 'Get-RestAclList' -MockWith {
            $AclList = @('RestServer', 'NOClient', 'DemoClient.PowerShellDemo.io')
            return $AclList
        }
        Invoke-VerifySubject | Should not be $null
        Assert-MockCalled -CommandName 'Write-Log' -Times 10 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyRootCA' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Get-RestAclList' -Times 3 -Exactly
    }
    It "Should Return True if the user is on the ACL List ." {
        $RawReturn = @{
            Subject    = "cn=Client"
            Thumbprint = "123456789"
            Extensions = @{
                oid = @{
                    value = '2.5.29.35'
                }
            }
        }               
        $ReturnJson = $RawReturn | ConvertTo-Json
        $script:ClientCert = $ReturnJson | convertfrom-json
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyRootCA' -MockWith {
            $true
        }
        Mock -CommandName 'Get-RestAclList' -MockWith {
            $AclList = @('RestServer', 'Client', 'DemoClient.PowerShellDemo.io')
            return $AclList
        }
        Invoke-VerifySubject | Should be $true
        Assert-MockCalled -CommandName 'Write-Log' -Times 13 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyRootCA' -Times 5 -Exactly
        Assert-MockCalled -CommandName 'Get-RestAclList' -Times 4 -Exactly
    }
}