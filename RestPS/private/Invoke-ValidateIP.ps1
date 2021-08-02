function Invoke-ValidateIP
{
    <#
    .DESCRIPTION
        This function provides several way to validate or authenticate a client base on acceptable IP's.
    .PARAMETER VerifyInputIP
        A VerifyInputIP is optional - Accepted values are:$false or $true
            
    .PARAMETER RestPSLocalRoot
        The RestPSLocalRoot is also optional, and defaults to "C:\RestPS"
    .EXAMPLE
        Invoke-ValidateIP -VerifyInputIP $true -RestPSLocalRoot c:\RestPS
    .NOTES
        This will return a boolean.
    #>
    [CmdletBinding()]
    [OutputType([boolean])]
    param(
        [Parameter()][String]$RestPSLocalRoot = "c:\RestPS",
        [Parameter()][String]$VerifyInputIP
    )

    if($VerifyInputIP -eq $true)
    {
        . c:\restps\bin\Get-RestIPAuth.ps1
        $RestIPAuth = (Get-RestIPAuth).UserIP

        $RequesterIP = $script:Request.RemoteEndPoint
        
        if ($null -ne $RestIPAuth)
        {
            $RequesterIP, $RequesterPort = $RequesterIP -split (":")

            $RequesterStatus = $RestIPAuth | Where-Object {($_.IP -eq "$RequesterIP")}

            if(($RequesterStatus | Measure-Object).Count -eq 1)
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