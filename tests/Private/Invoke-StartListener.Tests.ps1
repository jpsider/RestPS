$script:ModuleName = 'RestPS'
Describe "Invoke-StartListener function for $moduleName" {
    function Write-Output {}
    $guid = New-Guid
    It "Should return null when using Https." {
        $listener = [System.Net.HttpListener]::new()
        $listener.stop()
        $listener.Prefixes.Remove("https://+:8080/")
        $listener.Prefixes.Remove("http://+:8080/")
        Mock -CommandName 'Write-Output' -MockWith {}
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
        $listener = $null
        $listener = [System.Net.HttpListener]::new()
        $listener.stop()
        $listener.Prefixes.Remove("https://+:8080/")
        $listener.Prefixes.Remove("http://+:8080/")
        Mock -CommandName 'Write-Output' -MockWith {
            Throw "There was an error"
        }
        {Invoke-StartListener -Port 8081} | Should -Throw
        Assert-MockCalled -CommandName 'Write-Output' -Times 2 -Exactly
    }
}