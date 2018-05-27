<#
	.DESCRIPTION
		This script will return the body passed to the RestEndpoint.
	.EXAMPLE
        Invoke-GetProcess.ps1 -RequestArgs "Name=PowerShell&MainWindowTitle=RestPS"
	.NOTES
        This will return a json object
#>

param(
    $RequestArgs,
    $Body
)

if ($RequestArgs -like "*&*")
{
    $ArgumentPairs = $RequestArgs.split("&")

    $Property0, $Value0 = $ArgumentPairs[0].split("=")
    $Property1, $Value1 = $ArgumentPairs[1].split("=")
    if ($Property0 -eq "Name")
    {
        $Message = Get-Process -Name $Value0 | Where-Object {$_.($Property1) -like "*$Value1*"} | Select-Object ProcessName, Id, MainWindowTitle
    }
    else
    {
        $Message = Get-Process -Name $Value1 | Where-Object {$_.($Property0) -like "*$Value0*"} | Select-Object ProcessName, Id, MainWindowTitle
    }
}
else
{
    $Property, $Value = $RequestArgs.split("=")
    $Message = Get-Process -Name $Value | Select-Object ProcessName, Id, MainWindowTitle
}


return $Message