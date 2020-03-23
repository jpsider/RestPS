function Invoke-StopListener
{
    <#
	.DESCRIPTION
		This function will stop the specified Http(s) Listener.
    .PARAMETER Port
        A Port is Optional. Defaults to 8080.
	.EXAMPLE
        Invoke-StopListener -Port 8080
	.EXAMPLE
        Invoke-StopListener
	.NOTES
        This will return Null.
    #>
    param(
        [Parameter()][String]$Port = 8080
    )
    Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-StopListener: Stopping HTTP Listener on port: $Port ..."
    $listener.Stop()
}