$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-StartListener function for $script:ModuleName" {
    function Write-Output {}
    function Get-ChildItem {}
    $guid = New-Guid
    It "Should return null when using Https." {
        $listener = [System.Net.HttpListener]::new()
        $listener.stop()
        $listener.Prefixes.Remove("https://+:8080/")
        $listener.Prefixes.Remove("http://+:8080/")
        Mock -CommandName 'Write-Output' -MockWith {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $ReturnData = @{Thumbprint = "EA2452F896F9EDA2F287A7894AB9922FFAF3A704"}
            return $ReturnData
        }
        Invoke-StartListener -SSLThumbprint EA2452F896F9EDA2F287A7894AB9922FFAF3A704 -Port 8080 -AppGuid $guid | Should not be $null
        Assert-MockCalled -CommandName 'Write-Output' -Times 1 -Exactly
    }
    It "Should return null when using Http." {
        $listener = $null
        $listener = [System.Net.HttpListener]::new()
        $listener.stop()
        $listener.Prefixes.Remove("https://+:8080/")
        $listener.Prefixes.Remove("http://+:8080/")
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-StartListener -Port 8081 | Should be $null
        Assert-MockCalled -CommandName 'Write-Output' -Times 2 -Exactly
    }
    It "Should Throw when something fails." {
        function Get-ChildItem {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            Throw "There was an error"
        }
        {Invoke-StartListener -Port 8081} | Should -Throw
        Assert-MockCalled -CommandName 'Write-Output' -Times 2 -Exactly
    }
    It "Should Throw when The SSL cert cannot be found." {
        function Get-ChildItem {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $null
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        {Invoke-StartListener -Port 8081 -SSLThumbprint NoCert -AppGuid $guid} | Should -Throw
    }
}