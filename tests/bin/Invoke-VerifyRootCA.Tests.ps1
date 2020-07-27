$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

function Get-ChildItem {}
function Write-Log {}

Describe "Invoke-VerifyRootCA Variable function for $script:ModuleName" -Tags Build {
    It "Should Return false if no client certificate is found." {
        function Get-ChildItem {}
        function Write-Log {}   
        $script:ClientCert = $null
        Mock -CommandName 'Write-Log' -MockWith {}
        Invoke-VerifyRootCA | Should -Be $false
    }
    It "Should Return False if no Server Thumbprint is found." {
        function Get-ChildItem {}
        function Write-Log {}   
        $script:ClientCert = @{Thumbprint = "123456789" }
        Mock -CommandName 'Write-Log' -MockWith {}
        $SSLThumbPrint = $null
        Invoke-VerifyRootCA | Should -Be $false
    }
    It "Should Return False if the local cert with the thumbprint cannot -Be found." {
        function Get-ChildItem {}
        function Write-Log {}   
        $SSLThumbPrint = "123456"
        $script:ClientCert = @{Thumbprint = "123456789" }
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $ReturnData = $null
            return $ReturnData
        }
        Invoke-VerifyRootCA | Should -Be $false
    }
    It "Should Return False if the Server Cert Identifier cannot -Be found." {
        function Get-ChildItem {}
        function Write-Log {}   
        $RawReturn = @{
            Thumbprint = "123456789"
            Extensions = @{
                RawData = '8675309'
                oid     = @{
                    value = '2.5.29.35'
                }
            }
        }               
        $ReturnJson = $RawReturn | ConvertTo-Json
        $script:ClientCert = $ReturnJson | convertfrom-json
        $SSLThumbPrint = "123456789"
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $RawReturn = @{
                ThumbPrint = "123456789"
                Extensions = @{
                    oid = @{
                        value = '2.5.29.35'
                    }
                }
            }               
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Invoke-VerifyRootCA | Should -Be $false
    }
    It "Should Return False if the Client Cert Identifier cannot -Be found." {
        function Get-ChildItem {}
        function Write-Log {}   
        $RawReturn = @{
            Thumbprint = "123456789"
            Extensions = @{
                oid = @{
                    value = '2.5.29.35'
                }
            }
        }               
        $ReturnJson = $RawReturn | ConvertTo-Json
        $script:ClientCert = $ReturnJson | convertfrom-json
        $SSLThumbPrint = "123456789"
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $RawReturn = @{
                ThumbPrint = "123456789"
                Extensions = @{
                    RawData = '8675309'
                    oid     = @{
                        value = '2.5.29.35'
                    }
                }
            }               
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Invoke-VerifyRootCA | Should -Be $false
    }
    It "Should Return False if the Certificate Identifiers do not match." {
        function Get-ChildItem {}
        function Write-Log {}   
        $RawReturn = @{
            Thumbprint = "123456789"
            Extensions = @{
                RawData = '90210'
                oid     = @{
                    value = '2.5.29.35'
                }
            }
        }               
        $ReturnJson = $RawReturn | ConvertTo-Json
        $script:ClientCert = $ReturnJson | convertfrom-json
        $SSLThumbPrint = "123456789"
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $RawReturn = @{
                ThumbPrint = "123456789"
                Extensions = @{
                    RawData = '8675309'
                    oid     = @{
                        value = '2.5.29.35'
                    }
                }
            }               
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Invoke-VerifyRootCA | Should -Be $false
    }
    It "Should Return True, when the Identifiers match." {
        function Get-ChildItem {}
        function Write-Log {}   
        $RawReturn = @{
            Thumbprint = "123456789"
            Extensions = @{
                RawData = '8675309'
                oid     = @{
                    value = '2.5.29.35'
                }
            }
        }               
        $ReturnJson = $RawReturn | ConvertTo-Json
        $script:ClientCert = $ReturnJson | convertfrom-json
        $SSLThumbPrint = "123456789"
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $RawReturn = @{
                ThumbPrint = "123456789"
                Extensions = @{
                    RawData = '8675309'
                    oid     = @{
                        value = '2.5.29.35'
                    }
                }
            }               
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Invoke-VerifyRootCA | Should -Be $true
    }
}