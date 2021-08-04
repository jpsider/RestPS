function Invoke-ValidateIP
{
    <#
    .DESCRIPTION
        This function provides several way to validate or authenticate a client base on acceptable IP's.
    .PARAMETER VerifyClientIP
        A VerifyClientIP is optional - Accepted values are:$false or $true
    .EXAMPLE
        Invoke-ValidateIP -VerifyClientIP $true -RestPSLocalRoot c:\RestPS
    .NOTES
        This will return a boolean.
    #>
    [CmdletBinding()]
    [OutputType([boolean])]
    param(
        [Parameter()][Bool]$VerifyClientIP
    )
    if ($VerifyClientIP -eq $true)
    {
        . c:\restps\bin\Get-RestIPAuth.ps1
        $RestIPAuth = (Get-RestIPAuth).UserIP
        $RequesterIP = $script:Request.RemoteEndPoint
        if ($null -ne $RestIPAuth)
        {
            $RequesterIP, $RequesterPort = $RequesterIP -split (":")
            $RequesterStatus = $RestIPAuth | Where-Object {($_.IP -eq "$RequesterIP")}
            if (($RequesterStatus | Measure-Object).Count -eq 1)
            {
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateIP: Valid Client IP"
                $script:VerifyStatus = $true
            }
            else
            {
                $script:VerifyStatus = $false
            }
        }
        else
        {
            $script:VerifyStatus = $false
        }
    }
    $script:VerifyStatus
}
