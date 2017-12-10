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
    Write-Output "Processing Request type: $RequestType on URL: $RequestURL Args: $RequestArgs"
    #Import the Endpoint Routes
    . $RoutesFilePath
    $Route = ($Routes | Where-Object {$_.RequestType -eq $RequestType -and $_.RequestURL -eq $RequestURL})

    if ($null -ne $Route)
    {
        # Process Request
        $RequestCommand = $Route.RequestCommand
        $Command = $RequestCommand + " " + $RequestArgs
        set-location $PSScriptRoot
        Write-Output "Attempting process Request type: $RequestType on URL: $RequestURL"
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
        $ErrorMessage = "No Matching Routes"
        Write-Output $ErrorMessage
        $script:result = $ErrorMessage
    }
    $script:result
}