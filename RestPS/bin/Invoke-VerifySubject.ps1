function Invoke-VerifySubject
{
    # Determine if a Client Cert exist in the Request.
    if ($null -ne $script:ClientCert)
    {
        # First, Validate that the RootCA matches.
        . $RestPSLocalRoot\bin\Invoke-VerifyRootCA.ps1
        $script:VerifyStatus = Invoke-VerifyRootCA
        if ($script:VerifyStatus -eq $true)
        {
            # Root CA Matched, Verifying the ACL list
            . $RestPSLocalRoot\bin\Get-RestAclList.ps1
            $RestACL = Get-RestAclList
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifySubject: ACL is:" $RestACL
            if ($null -ne $RestACL)
            {
                $RawSubject = $script:ClientCert.Subject
                $1, $script:Subject = $RawSubject.split("=")
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifySubject: Subject name is" $script:Subject
                if ($null -ne $script:Subject)
                {
                    if ($RestACL.contains($script:Subject))
                    {
                        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifySubject: Client access is Verified."
                        $script:VerifyStatus = $true
                    }
                    else
                    {
                        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifySubject: Client does not exist in ACL."
                        $script:VerifyStatus = $false
                    }
                }
                else
                {
                    Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifySubject: Client Subject Name does not exist."
                    $script:VerifyStatus = $false
                }
            }
            else
            {
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifySubject: No ACL list available."
                $script:VerifyStatus = $false
            }
        }
        else
        {
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifySubject: The Root CA did not match, Not attempting to Validate ACL List."
            $script:VerifyStatus = $false
        }
    }
    else
    {
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifySubject: No Client Certificate Received."
        $script:VerifyStatus = $false
    }
    $script:VerifyStatus
}