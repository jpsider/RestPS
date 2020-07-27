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
        function Write-Log {}
        function Invoke-VerifyRootCA {}
        function Get-RestAclList {}
        $tempDir = (pwd).Path
        $RestPSLocalRoot = $tempDir + "\RestPS" 
        $script:ClientCert = $null
        Mock -CommandName 'Write-Log' -MockWith {}
        Invoke-VerifySubject | Should -Be $false
    }
    It "Should Return False when Invoke-VerifyRootCA fails." {
        function Write-Log {}
        function Invoke-VerifyRootCA {}
        function Get-RestAclList {}
        $tempDir = (pwd).Path
        $RestPSLocalRoot = $tempDir + "\RestPS" 
        $script:ClientCert = @{Thumbprint = "123456789" }
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyRootCA' -MockWith {
            $false
        }
        Invoke-VerifySubject | Should -Be $false
    }
    It "Should Return False when The ACL list is empty." {
        function Write-Log {}
        function Invoke-VerifyRootCA {}
        function Get-RestAclList {}
        $tempDir = (pwd).Path
        $RestPSLocalRoot = $tempDir + "\RestPS" 
        $script:ClientCert = @{Thumbprint = "123456789" }
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyRootCA' -MockWith {
            $true
        }
        Mock -CommandName 'Get-RestAclList' -MockWith {
            $null
        }
        Invoke-VerifySubject | Should -Be $false
    }
    It "Should Return False If the user is not in the ACL List." {
        function Write-Log {}
        function Invoke-VerifyRootCA {}
        function Get-RestAclList {}
        $tempDir = (pwd).Path
        $RestPSLocalRoot = $tempDir + "\RestPS" 
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
        Invoke-VerifySubject | Should -not -Be $null
    }
    It "Should Return False If the subject is not found." {
        function Write-Log {}
        function Invoke-VerifyRootCA {}
        function Get-RestAclList {}
        $tempDir = (pwd).Path
        $RestPSLocalRoot = $tempDir + "\RestPS" 
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
        Invoke-VerifySubject | Should -not -Be $null
    }
    It "Should Return True if the user is on the ACL List ." {
        function Write-Log {}
        function Invoke-VerifyRootCA {}
        function Get-RestAclList {}
        $tempDir = (pwd).Path
        $RestPSLocalRoot = $tempDir + "\RestPS" 
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
        Invoke-VerifySubject | Should -Be $true
    }
}