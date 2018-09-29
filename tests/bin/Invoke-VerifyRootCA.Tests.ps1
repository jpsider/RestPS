$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

function Get-ChildItem {}
function Write-Output {}

Describe "Invoke-VerifyRootCA Variable function for $script:ModuleName" {
    It "Should Return false if no client certificate is found." {
        $script:ClientCert = $null
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-VerifyRootCA | Should be $false
        Assert-MockCalled -CommandName 'Write-Output' -Times 1 -Exactly
    }
    It "Should Return False if no Server Thumbprint is found." {
        $script:ClientCert = @{Thumbprint = "123456789"}
        Mock -CommandName 'Write-Output' -MockWith {}
        $SSLThumbPrint = $null
        Invoke-VerifyRootCA | Should be $false
        Assert-MockCalled -CommandName 'Write-Output' -Times 2 -Exactly
    }
    It "Should Return False if the local cert with the thumbprint cannot be found." {
        $SSLThumbPrint = "123456"
        $script:ClientCert = @{Thumbprint = "123456789"}
        Mock -CommandName 'Write-Output' -MockWith {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $ReturnData = $null
            return $ReturnData
        }
        Invoke-VerifyRootCA | Should be $false
        Assert-MockCalled -CommandName 'Get-ChildItem' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 3 -Exactly
    }
    It "Should Return False if the Server Cert Identifier cannot be found." {
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
        Mock -CommandName 'Write-Output' -MockWith {}
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
        Invoke-VerifyRootCA | Should be $false
        Assert-MockCalled -CommandName 'Get-ChildItem' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 4 -Exactly
    }
    It "Should Return False if the Client Cert Identifier cannot be found." {
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
        Mock -CommandName 'Write-Output' -MockWith {}
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
        Invoke-VerifyRootCA | Should be $false
        Assert-MockCalled -CommandName 'Get-ChildItem' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 5 -Exactly
    }
    It "Should Return False if the Certificate Identifiers do not match." {
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
        Mock -CommandName 'Write-Output' -MockWith {}
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
        Invoke-VerifyRootCA | Should be $false
        Assert-MockCalled -CommandName 'Get-ChildItem' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 6 -Exactly
    }
    It "Should Return True, when the Identifiers match." {
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
        Mock -CommandName 'Write-Output' -MockWith {}
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
        Invoke-VerifyRootCA | Should be $true
        Assert-MockCalled -CommandName 'Get-ChildItem' -Times 5 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 7 -Exactly
    }
}