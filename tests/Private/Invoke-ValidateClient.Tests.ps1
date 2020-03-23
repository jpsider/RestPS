$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-ValidateClient function for $script:ModuleName" -Tags Build {
    $RestPSLocalRoot = "$here\..\"
    function Write-Log {}
    function Invoke-VerifyRootCA {}
    function Invoke-VerifySubject {}
    function Invoke-VerifyUserAuth {}
    function Invoke-VerifyBasicAuth {}
    function Get-ClientCertInfo {}
    It "Should return True if the Client is Validated." {
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-ClientCertInfo' -MockWith {}
        Mock -CommandName 'Invoke-VerifyRootCA' -MockWith {
            $true
        }
        Invoke-ValidateClient -VerificationType VerifyRootCA -RestPSLocalRoot "$RestPSLocalRoot" | Should be $true
        Assert-MockCalled -CommandName 'Write-Log' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyRootCA' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Get-ClientCertInfo' -Times 1 -Exactly
    }
    It "Should return True if the Client is Validated and verified." {
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-ClientCertInfo' -MockWith {}
        Mock -CommandName 'Invoke-VerifySubject' -MockWith {
            $true
        }
        Invoke-ValidateClient -VerificationType VerifySubject -RestPSLocalRoot "$RestPSLocalRoot" | Should be $true
        Assert-MockCalled -CommandName 'Write-Log' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifySubject' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Get-ClientCertInfo' -Times 2 -Exactly
    }
    It "Should return True if the Client is Validated, Verified and Authorized." {
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-ClientCertInfo' -MockWith {}
        Mock -CommandName 'Invoke-VerifyUserAuth' -MockWith {
            $true
        }
        Invoke-ValidateClient -VerificationType VerifyUserAuth -RestPSLocalRoot "$RestPSLocalRoot" | Should be $true
        Assert-MockCalled -CommandName 'Write-Log' -Times 6 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyUserAuth' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Get-ClientCertInfo' -Times 3 -Exactly
    }
    It "Should return True if the Client is Validated via basic auth." {
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyBasicAuth' -MockWith {
            $true
        }
        Invoke-ValidateClient -VerificationType VerifyBasicAuth -RestPSLocalRoot "$RestPSLocalRoot" | Should be $true
        Assert-MockCalled -CommandName 'Write-Log' -Times 7 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyBasicAuth' -Times 1 -Exactly
    }
    It "Should return false if the Client is Validated." {
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyRootCA' -MockWith {
            $false
        }
        Invoke-ValidateClient -VerificationType VerifyRootCA -RestPSLocalRoot "$RestPSLocalRoot" | Should be $false
        Assert-MockCalled -CommandName 'Write-Log' -Times 9 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyRootCA' -Times 2 -Exactly
    }
    It "Should return false if the Client is Validated and verified." {
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifySubject' -MockWith {
            $false
        }
        Invoke-ValidateClient -VerificationType VerifySubject -RestPSLocalRoot "$RestPSLocalRoot" | Should be $false
        Assert-MockCalled -CommandName 'Write-Log' -Times 11 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifySubject' -Times 2 -Exactly
    }
    It "Should return false if the Client is Validated, Verified and Authorized." {
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyUserAuth' -MockWith {
            $false
        }
        Invoke-ValidateClient -VerificationType VerifyUserAuth -RestPSLocalRoot "$RestPSLocalRoot" | Should be $false
        Assert-MockCalled -CommandName 'Write-Log' -Times 13 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyUserAuth' -Times 2 -Exactly
    }
    It "Should return false if the Client is not Validated via basic auth" {
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Invoke-VerifyBasicAuth' -MockWith {
            $false
        }
        Invoke-ValidateClient -VerificationType VerifyBasicAuth -RestPSLocalRoot "$RestPSLocalRoot" | Should be $false
        Assert-MockCalled -CommandName 'Write-Log' -Times 14 -Exactly
        Assert-MockCalled -CommandName 'Invoke-VerifyBasicAuth' -Times 2 -Exactly
    }
    It "Should return True, if no Verification Type is specified." {
        Mock -CommandName 'Write-Log' -MockWith {}
        Invoke-ValidateClient | Should be $true
        Assert-MockCalled -CommandName 'Write-Log' -Times 15 -Exactly
    }
}