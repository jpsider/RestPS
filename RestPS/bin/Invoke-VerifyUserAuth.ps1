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
            Write-Output "Advanced Authentication is Not currently supported. Free pass if you made it this far."
            $script:VerifyStatus = $true
        }
        else
        {
            Write-Output "Client Failed to Verify Identity."
            $script:VerifyStatus = $false
        }
    }
    else
    {
        Write-Output "No Client Certificate provided."
        $script:VerifyStatus = $false
    }
    $script:VerifyStatus
}