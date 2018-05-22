function Invoke-RequestRouter
{
    <#
	.DESCRIPTION
		This function will attempt to run a Client specified command defined in the Endpoint Routes.
    .PARAMETER RequestType
        A RequestType is required.
    .PARAMETER RequestURL
        A RequestURL is is required
    .PARAMETER RequestArgs
        A RequestArgs is Optional.
    .PARAMETER RoutesFilePath
        A RoutesFilePath is Optional.
	.EXAMPLE
        Invoke-RequestRouter -RequestType GET -RequestURL /process
	.EXAMPLE
        Invoke-RequestRouter -RequestType GET -RequestURL /process -RoutesFilePath c:\RestPS\Invoke-AvailableRouteSet.ps1
	.EXAMPLE
        Invoke-RequestRouter -RequestType GET -RequestURL /process -RoutesFilePath c:\RestPS\Invoke-AvailableRouteSet.ps1 -RequestArgs foo=Bar&cash=Money
	.NOTES
        This will return output from the Endpoint Command/script.
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", '')]
    [OutputType([boolean])]
    [OutputType([Hashtable])]
    param(
        [Parameter(Mandatory = $true)][String]$RequestType,
        [Parameter(Mandatory = $true)][String]$RequestURL,
        [Parameter(Mandatory = $false)][String]$RequestArgs,
        [Parameter()][String]$RoutesFilePath
    )
    # Import Routes each pass, to include new routes.
    . $RoutesFilePath
    $Route = ($Routes | Where-Object {$_.RequestType -eq $RequestType -and $_.RequestURL -eq $RequestURL})

    if ($null -ne $Route)
    {
        # Process Request
        $RequestCommand = $Route.RequestCommand
        set-location $PSScriptRoot
        if ($RequestCommand -like "*.ps1")
        {
            # Execute Endpoint Script
            $CommandReturn = . $RequestCommand -RequestArgs $RequestArgs -Body $script:Body
        }
        else
        {
            # Execute Endpoint Command (No body allowed.)
            $Command = $RequestCommand + " " + $RequestArgs
            $CommandReturn = Invoke-Expression -Command "$Command" -ErrorAction SilentlyContinue
        }        
        
        if ($null -eq $CommandReturn)
        {
            # Not a valid response
            $script:result = "400 Invalid Command"
        }
        else
        {
            # Valid response
            $script:result = $CommandReturn
        }
    }
    else
    {
        # No matching Routes
        $script:result = "404 No Matching Routes"       
    }
    $script:result
}