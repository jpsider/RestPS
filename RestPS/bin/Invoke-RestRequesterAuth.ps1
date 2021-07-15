function Invoke-RestRequesterAuth
{
    # IP Based Authentication
    . c:\restps\bin\Get-RestIPAuth.ps1
    $RestIPAuth = (Get-RestIPAuth).UserIP

    $RequesterIP = $script:Request.RemoteEndPoint

    if ($RestIPAuth -ne $null)
    {
        $RequesterIP, $RequesterPort = $RequesterIP -split (":")

        $RequesterStatus = $RestIPAuth | Where-Object {($_.IP -eq "$RequesterIP")}

        if(($RequesterStatus | Measure-Object).Count -eq 1)
        {
            $script:VerifyStatus = $true
        }
        else
        {
            $script:VerifyStatus = $false
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Invoke-RestRequesterAuth: Failed Invalid IP"
        }
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType TRACE -Message "Invoke-RestRequesterAuth: Valid IP"
    }
    $script:VerifyStatus
}
