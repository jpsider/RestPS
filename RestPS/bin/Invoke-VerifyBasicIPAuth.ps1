function Invoke-VerifyBasicIPAuth
{
    # Basic Authentication
    . $RestPSLocalRoot\bin\Get-RestUserAuth.ps1
    $RestUserAuth = (Get-RestUserAuth).UserData
    
    . $RestPSLocalRoot\bin\Get-RestIPAuth.ps1
    $RestIPAuth = (Get-RestIPAuth).UserIP

    if ($null -ne $RestUserAuth)
    {
        # Get the AuthString from Client Headers
        $ClientHeaders = $script:Request.Headers
        $ClientHeadersAuth = $ClientHeaders.GetValues("Authorization")
        $RequesterIP = $script:Request.RemoteEndPoint
        $AuthType, $AuthString = $ClientHeadersAuth.split(" ")
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicIPAuth: Auth type is: $AuthType, AuthString is: $AuthString"
    
        if ($null -ne $AuthString)
        {
            # Decode the Authorization header
            $DecodedAuthString = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($AuthString))
            
            $RequesterIP, $RequesterPort = $RequesterIP -split (":")
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicIPAuth: Client IP: $RequesterIP"

            # Split the decoded auth string, and compare to the $RestUserAuth array
            $RequestUserName, $RequestPass = $DecodedAuthString -split (":")
            $AllowedUser = $RestUserAuth | Where-Object {($_.UserName -eq "$RequestUserName") -And ($_.SystemAuthString -eq "$RequestPass")}
            $RequesterStatus = $RestIPAuth | Where-Object {($_.IP -eq "$RequesterIP")}

            if (($RequesterStatus | Measure-Object).Count -eq 1)
            {
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicIPAuth: Client IP Authorization is Verified."
                if (($AllowedUser | Measure-Object).Count -eq 1) {
                    Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicIPAuth: Client Authorization type: $AuthType is Verified."
                    $script:VerifyStatus = $true
                }
                else
                {
                    Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicIPAuth: Client did not pass Authorization type: $AuthType."
                    $script:VerifyStatus = $false
                }
            }
            else
            {
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicIPAuth: Client did not pass IP Authorization."
                $script:VerifyStatus = $false
            }
        }
        else
        {
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicIPAuth: No Authorization String found."
            $script:VerifyStatus = $false
        }
    }
    else
    {
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicIPAuth: No Authorization data available."
        $script:VerifyStatus = $false
    }
    $script:VerifyStatus
}
