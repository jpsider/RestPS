function Import-RouteSet
{
    <#
	.DESCRIPTION
		This function imports the specified routes file.
    .PARAMETER RoutesFilePath
        Provide a valid path to a .json file
    .EXAMPLE
        Invoke-AvailableRouteSet -RoutesFilePath $env:systemdrive/RestPS/endpoints/routes.json
	.NOTES
        This will return null.
    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]

    param(
        [Parameter(Mandatory = $true)][String]$RoutesFilePath
    )

    if (Test-Path -Path $RoutesFilePath)
    {
        $script:Routes = Get-Content -Raw $RoutesFilePath | ConvertFrom-Json
    }
    else
    {
        Throw "Import-RouteSet - Could not validate Path $RoutesFilePath"
    }
}