function Invoke-DeployRestPS
{
    <#
	.DESCRIPTION
		This function will setup a local Endpoint directory structure.
    .PARAMETER LocalDir
        A LocalDir is Optional.
	.EXAMPLE
        Invoke-DeployRestPS -LocalDir c:\RestPS
	.NOTES
        This will return a boolean.
    #>
    [CmdletBinding()]
    [OutputType([boolean])]
    param(
        [string]$LocalDir = "c:\RestPS"
    )
    try
    {
        # Setup the local File directories
        if (Test-Path -Path "$LocalDir")
        {
            Write-Output "Directory: $LocalDir, exists."
        }
        else
        {
            Write-Output "Creating RestPS Directories."
            New-Item -Path "$LocalDir" -ItemType Directory
            New-Item -Path "$LocalDir\Endpoints" -ItemType Directory
            New-Item -Path "$LocalDir\Endpoints\Logs" -ItemType Directory
            New-Item -Path "$LocalDir\Endpoints\GET" -ItemType Directory
            New-Item -Path "$LocalDir\Endpoints\POST" -ItemType Directory
            New-Item -Path "$LocalDir\Endpoints\PUT" -ItemType Directory
            New-Item -Path "$LocalDir\Endpoints\DELETE" -ItemType Directory
        }
        # Move Example files to the Local Directory
        $Source = (Split-Path -Path (Get-Module -ListAvailable RestPS).path)
        $RoutesFileSource = $Source + "\endpoints\Invoke-AvailableRouteSet.ps1"
        Copy-Item -Path "$RoutesFileSource" -Destination $LocalDir\Endpoints -Confirm:$false -Force
        $EndpointVerbs = @("GET", "POST", "PUT", "DELETE")
        foreach ($Verb in $EndpointVerbs)
        {
            $EndpointSource = $Source + "\endpoints\$Verb\Invoke-GetProcess.ps1"
            Write-Output "Copying $EndpointSource to Desination $LocalDir\Endpoints\$Verb"
            Copy-Item -Path "$EndpointSource" -Destination $LocalDir\Endpoints\$Verb -Confirm:$false -Force
        }
    }
    catch
    {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName		
        Throw "Invoke-DeployRestPS: $ErrorMessage $FailedItem"
    }

}