function Invoke-VerifyUserAuth
{
    # Determine if a Client Cert exist in the Request.
    if ($null -ne $ClientCert)
    {
        # First, Validate that the RootCA matches & Client is on ACL.
        . $RestPSLocalRoot\bin\Invoke-VerifySubject.ps1
        $script:VerifyStatus = Invoke-VerifySubject
        if ($script:VerifyStatus -eq $true)
        {
            # Advanced Authentication
            . $RestPSLocalRoot\bin\Get-RestUserAuth.ps1
            $RestUserAuth = (Get-RestUserAuth).UserData

            if ($null -ne $RestUserAuth)
            {
                # Get the System AuthString for the Client Request
                $UserToCheck = $script:Subject
                $SystemAuthString = ($RestUserAuth | Where-Object { $_.UserName -eq "$UserToCheck" }).SystemAuthString

                # Get the AuthString from Client Headers
                $ClientHeaders = $script:Request.Headers
                $ClientHeadersAuth = $ClientHeaders.GetValues("Authorization")
                $AuthType, $AuthString = $ClientHeadersAuth.split(" ")
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyUserAuth: Auth type is: $AuthType, AuthString is: $AuthString"

                if ($null -ne $AuthString)
                {
                    if ($SystemAuthString -eq $AuthString)
                    {
                        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyUserAuth: Client Authorization type: $AuthType is Verified."
                        $script:VerifyStatus = $true
                    }
                    else
                    {
                        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyUserAuth: Client did not pass Authorization type: $AuthType."
                        $script:VerifyStatus = $false
                    }
                }
                else
                {
                    Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyUserAuth: No Authorization String found."
                    $script:VerifyStatus = $false
                }
            }
            else
            {
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyUserAuth: No Authorization data available."
                $script:VerifyStatus = $false
            }
        }
        else
        {
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyUserAuth: Client Failed to Verify Identity."
            $script:VerifyStatus = $false
        }
    }
    else
    {
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyUserAuth: No Client Certificate provided."
        $script:VerifyStatus = $false
    }
    $script:VerifyStatus
}