$script:ModuleName = 'RestPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-StartListener function for $script:ModuleName" -Tags Build {
    function Write-Log {}
    function Get-ChildItem {}
    function Write-Log {}
    $guid = New-Guid
    It "Should return null when using Https." {
        function Write-Log {}
        $listener = [System.Net.HttpListener]::new()
        $listener.stop()
        $listener.Prefixes.Remove("https://+:8083/")
        $listener.Prefixes.Remove("http://+:8083/")
        Mock -CommandName 'Write-Log' -MockWith {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $ReturnData = @{Thumbprint = "EA2452F896F9EDA2F287A7894AB9922FFAF3A704" }
            return $ReturnData
        }
        Invoke-StartListener -SSLThumbprint EA2452F896F9EDA2F287A7894AB9922FFAF3A704 -Port 8083 -AppGuid $guid | Should -not -Be $null
        Assert-MockCalled -CommandName 'Write-Log' -Times 1 -Exactly -Scope It
    }
    It "Should return null when using Http." {
        function Write-Log {}
        $listener = $null
        $listener = [System.Net.HttpListener]::new()
        $listener.stop()
        $listener.Prefixes.Remove("https://+:8083/")
        $listener.Prefixes.Remove("http://+:8083/")
        Mock -CommandName 'Write-Log' -MockWith {}
        Invoke-StartListener -Port 8081 | Should -Be $null
        Assert-MockCalled -CommandName 'Write-Log' -Times 1 -Scope It
    }
    It "Should Throw when something fails." {
        function Write-Log {}
        function Get-ChildItem {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            Throw "There was an error"
        }
        { Invoke-StartListener -Port 8081 } | Should -Throw
        Assert-MockCalled -CommandName 'Write-Log' -Times 0 -Scope It
    }
    It "Should Throw when The SSL cert cannot-Be found." {
        function Write-Log {}
        function Get-ChildItem {}
        Mock -CommandName 'Get-ChildItem' -MockWith {
            $null
        }
        Mock -CommandName 'Write-Log' -MockWith {}
        { Invoke-StartListener -Port 8081 -SSLThumbprint NoCert -AppGuid $guid } | Should -Throw
    }
}