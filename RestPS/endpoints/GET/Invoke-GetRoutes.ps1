<#
    .DESCRIPTION
	This script will return the available routes for the Rest Endpoint.
    .EXAMPLE
        Invoke-GetRoutes.ps1
    .NOTES
        This will return a json object
#>
[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", '')]
param(
    $RequestArgs
)

Import-RouteSet -RoutesFilePath $RoutesFilePath
$TempRoutes = $script:Routes | ConvertTo-Json

$Message = $TempRoutes | ConvertFrom-Json
return $Message