function Invoke-RequestRouter
{
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
        $Command = $RequestCommand + " " + $RequestArgs
        set-location $PSScriptRoot
        $CommandReturn = Invoke-Expression -Command "$Command" -ErrorAction SilentlyContinue
        if ($null -eq $CommandReturn)
        {
            # Not a valid response
            $script:result = "Invalid Command"
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
        $script:result = "No Matching Routes"       
    }
    $script:result
}