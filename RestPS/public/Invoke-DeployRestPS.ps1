function Invoke-DeployRestPS
{
    <#
	.DESCRIPTION
		This function will setup a local Endpoint directory structure.
    .PARAMETER LocalDir
        A LocalDir is Optional.
    .PARAMETER SourceDir
        An install directory of the Module, if Get-Module will not find it, is Optional.
    .PARAMETER Logfile
        Full path to a logfile for RestPS messages to be written to.
    .EXAMPLE
        Invoke-DeployRestPS -LocalDir $env:SystemDrive/RestPS
    .NOTES
        This will return a boolean.
    #>
    [CmdletBinding()]
    [OutputType([boolean])]
    param(
        [string]$LocalDir = "$env:SystemDrive/RestPS",
        [string]$SourceDir = (Split-Path -Path (Get-Module -ListAvailable RestPS | Sort-Object -Property Version -Descending | Select-Object -First 1).path),
	[String]$Logfile = "$env:SystemDrive/RestPS/RestPS.log"
    )
    try
    {
        # Setup the local File directories
        if (Test-Path -Path "$LocalDir")
        {
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-DeployRestPS: Directory: $localDir, exists."
        }
        else
        {
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-DeployRestPS: Creating RestPS Directories."
            New-Item -Path "$LocalDir" -ItemType Directory
            New-Item -Path "$LocalDir/bin" -ItemType Directory
            New-Item -Path "$LocalDir/endpoints" -ItemType Directory
            New-Item -Path "$LocalDir/endpoints/Logs" -ItemType Directory
            New-Item -Path "$LocalDir/endpoints/GET" -ItemType Directory
            New-Item -Path "$LocalDir/endpoints/POST" -ItemType Directory
            New-Item -Path "$LocalDir/endpoints/PUT" -ItemType Directory
            New-Item -Path "$LocalDir/endpoints/DELETE" -ItemType Directory
        }
        # Move Example files to the Local Directory
        $RoutesFileSource = $SourceDir + "/endpoints/RestPSRoutes.json"
        Copy-Item -Path "$RoutesFileSource" -Destination "$LocalDir/endpoints" -Confirm:$false -Force
        $GetRoutesFileSource = $SourceDir + "/endpoints/GET/Invoke-GetRoutes.ps1"
        Copy-Item -Path $GetRoutesFileSource -Destination "$LocalDir/endpoints/GET" -Confirm:$false -Force
        $EndpointVerbs = @("GET", "POST", "PUT", "DELETE")
        foreach ($Verb in $EndpointVerbs)
        {
            $endpointsource = $SourceDir + "/endpoints/$Verb/Invoke-GetProcess.ps1"
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-DeployRestPS: Copying $endpointsource to Desination $LocalDir/endpoints/$Verb"
            Copy-Item -Path "$endpointsource" -Destination "$LocalDir/endpoints/$Verb" -Confirm:$false -Force
        }
        $BinFiles = Get-ChildItem -Path ($SourceDir + "/bin") -File
        foreach ($file in $BinFiles)
        {
            $filePath = $file.FullName
            $filename = $file.Name
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-DeployRestPS: Copying File $fileName to $localDir/bin"
            Copy-Item -Path "$filePath" -Destination "$LocalDir/bin" -Confirm:$false -Force
        }
    }
    catch
    {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Throw "Invoke-DeployRestPS: $ErrorMessage $FailedItem"
    }
}
