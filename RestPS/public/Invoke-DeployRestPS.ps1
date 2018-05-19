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
            New-Item -Path "$LocalDir\bin" -ItemType Directory
            New-Item -Path "$LocalDir\endpoints" -ItemType Directory
            New-Item -Path "$LocalDir\endpoints\Logs" -ItemType Directory
            New-Item -Path "$LocalDir\endpoints\GET" -ItemType Directory
            New-Item -Path "$LocalDir\endpoints\POST" -ItemType Directory
            New-Item -Path "$LocalDir\endpoints\PUT" -ItemType Directory
            New-Item -Path "$LocalDir\endpoints\DELETE" -ItemType Directory
        }
        # Move Example files to the Local Directory
        $Source = (Split-Path -Path (Get-Module -ListAvailable RestPS).path)[0]
        $RoutesFileSource = $Source + "\endpoints\Invoke-AvailableRouteSet.ps1"
        Copy-Item -Path "$RoutesFileSource" -Destination $LocalDir\Endpoints -Confirm:$false -Force
        $EndpointVerbs = @("GET", "POST", "PUT", "DELETE")
        foreach ($Verb in $EndpointVerbs)
        {
            $EndpointSource = $Source + "\endpoints\$Verb\Invoke-GetProcess.ps1"
            Write-Output "Copying $EndpointSource to Desination $LocalDir\Endpoints\$Verb"
            Copy-Item -Path "$EndpointSource" -Destination $LocalDir\Endpoints\$Verb -Confirm:$false -Force
        }
        $BinFiles = Get-ChildItem -Path ($Source + "\bin") -File
        foreach ($file in $BinFiles)
        {
            $filePath = $file.FullName
            $filename = $file.Name
            Write-Output "Copying File $fileName to $localDir\bin"
            Copy-Item -Path "$filePath" -Destination $LocalDir\bin -Confirm:$false -Force
        }
    }
    catch
    {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName		
        Throw "Invoke-DeployRestPS: $ErrorMessage $FailedItem"
    }

}