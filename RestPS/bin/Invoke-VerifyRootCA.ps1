function Invoke-VerifyRootCA {
    # Determine if a Client Cert exist in the Request.
    if ($null -ne $script:ClientCert) {
        # Determine if the SSLThumbprint for the Rest Endpoint was available.
        if ($null -ne $SSLThumbprint) {
            $LocalRestCert = Get-ChildItem -Path Cert:\LocalMachine -Recurse | Where-Object {$_.Thumbprint -eq "$SSLThumbprint"}
            if ($null -ne $LocalRestCert) {
                # Need to get the Authority Key Identifier
                $LocalCAIdentifier = ($LocalRestCert.Extensions | Where-Object {$_.oid.value -eq "2.5.29.35"}).RawData
                if ($null -ne $LocalCAIdentifier) {
                    $ClientCAIdentifier = ($script:ClientCert.Extensions | Where-Object {$_.oid.value -eq "2.5.29.35"}).RawData
                    if ($null -ne $ClientCAIdentifier) {
                        $CompareResult = Compare-Object -ReferenceObject $LocalCAIdentifier -DifferenceObject $ClientCAIdentifier
                        if ($null -eq $CompareResult) {
                            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyRootCA: Certificate Authorities Match. Client is Valid."
                            $script:VerifyStatus = $true
                        }
                        else {
                            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyRootCA: Certificate Authorities do not match."
                            $script:VerifyStatus = $false
                        }
                    }
                    else {
                        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyRootCA: Unable to Determine Client Certificate Authority Identifier."
                        $script:VerifyStatus = $false
                    }
                }
                else {
                    Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyRootCA: Unable to Determine Local Rest Certificate Authority Identifier."
                    $script:VerifyStatus = $false
                }
            }
            else {
                Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyRootCA: Unable to find Local Rest Certificate."
                $script:VerifyStatus = $false
            }
        }
        else {
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyRootCA: No Certificate Thumbprint Identified."
            $script:VerifyStatus = $false
        }
    }
    else {
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyRootCA: No Client Certificate Received."
        $script:VerifyStatus = $false
    }
    $script:VerifyStatus
}