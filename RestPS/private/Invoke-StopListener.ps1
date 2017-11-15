function Invoke-StopListener
{
    param(
        [Parameter()][String]$Port = 8080
    ) 
    Write-Output "Stopping HTTP Listener on port: $Port ..."
    $listener.Stop()
}