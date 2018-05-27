<#
    .DESCRIPTION
        This script will return the specified data to the Client.
    .EXAMPLE
        Invoke-GetProcess.ps1 -Body $Body
    .NOTES
    	This will return data
#>

param(
    $RequestArgs,
    $Body
)

$newbody = $body | ConvertFrom-Json

$ProcessName = $newbody.Name
$MainWindowTitle = $newbody.MainWindowTitle

$Message = Get-Process -Name $ProcessName | Where-Object { $_.MainWindowTitle -like "*$MainWindowTitle*" } | Select-Object ProcessName, Id, MainWindowTitle

return $Message