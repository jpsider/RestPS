<#
	.DESCRIPTION
		This script will return the body passed to the RestEndpoint.
	.EXAMPLE
        Invoke-GetProcess.ps1 -RequestArgs "Name=PowerShell&MainWindowTitle=RestPS"
	.NOTES
        This will return a json object
#>

param(
    $RequestArgs
)

if ($RequestArgs -like '*&*') {
    # Split the Argument Pairs by the '&' character
    $ArgumentPairs = $RequestArgs.split('&')
    $RequestObj = New-Object System.Object
    foreach ($ArgumentPair in $ArgumentPairs) {
        # Split the Pair data by the '=' character
        $Property, $Value = $ArgumentPair.split('=')
        $RequestObj | Add-Member -MemberType NoteProperty -Name $Property -value $Value
    }

    # Edit the Area below to utilize the Values of the new Request Object
    $ProcessName = $RequestObj.Name
    $WindowTitle = $RequestObj.MainWindowTitle
    if ($RequestObj.Name) {
        $Message = Get-Process -Name $ProcessName | Where-Object {$_.Name -like "*$ProcessName*"} | Select-Object ProcessName, Id, MainWindowTitle
    }
    else {
        $Message = Get-Process -Name $WindowTitle | Where-Object {$_.WindowTitle -like "*$WindowTitle*"} | Select-Object ProcessName, Id, MainWindowTitle
    }
}
else {
    $Property, $Value = $RequestArgs.split("=")
    #$Message = Get-Process -Name $ProcessName | Select-Object ProcessName, Id, MainWindowTitle
    if ($Property -eq 'pid')
    {
        Write-Verbose -Message "Lookup by pid"
        $Message = Get-Process -Id $Value | Select-Object ProcessName, Id, MainWindowTitle
    }
    else
    {
        Write-Verbose -Message "Lookup by name"
        $Message = Get-Process -Name $Value | Select-Object ProcessName, Id, MainWindowTitle
    }
}

return $Message