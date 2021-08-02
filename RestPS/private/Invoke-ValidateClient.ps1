function Invoke-ValidateClient
{
    <#
    .DESCRIPTION
        This function provides several way to validate or authenticate a client. A client
        could be a user or a computer.
    .PARAMETER VerificationType
        A VerificationType is optional - Accepted values are:
            -"VerifyRootCA": Verifies the Root CA of the Server and Client Cert Match.
            -"VerifySubject": Verifies the Root CA, and the Client is on a User provide ACL.
            -"VerifyUserAuth": Provides an option for Advanced Authentication, plus the RootCA,Subject Checks.
    .PARAMETER RestPSLocalRoot
        The RestPSLocalRoot is also optional, and defaults to "C:\RestPS"
    .EXAMPLE
        Invoke-ValidateClient -VerificationType VerifyRootCA -RestPSLocalRoot c:\RestPS
    .NOTES
        This will return a boolean.
    #>
    [CmdletBinding()]
    [OutputType([boolean])]
    param(
        [ValidateSet("VerifyRootCA", "VerifySubject", "VerifyUserAuth","VerifyBasicAuth")]
        [Parameter()][String]$VerificationType,
        [Parameter()][String]$RestPSLocalRoot = "c:\RestPS"
    )
    switch ($VerificationType)
    {
        "VerifyRootCA"
        {
            # Source the File
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateClient: Gathering Client Cert Info"
            Get-ClientCertInfo
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateClient: Validating Client CN: $script:SubjectName"
            . $RestPSLocalRoot\bin\Invoke-VerifyRootCA.ps1
            $script:VerifyStatus = Invoke-VerifyRootCA
        }

        "VerifySubject"
        {
            # Source the File
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateClient: Gathering Client Cert Info"
            Get-ClientCertInfo
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateClient: Validating Client CN: $script:SubjectName"
            . $RestPSLocalRoot\bin\Invoke-VerifySubject.ps1
            $script:VerifyStatus = Invoke-VerifySubject
        }

        "VerifyUserAuth"
        {
            # Source the File
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateClient: Gathering Client Cert Info"
            Get-ClientCertInfo
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateClient: Validating Client CN: $script:SubjectName"
            . $RestPSLocalRoot\bin\Invoke-VerifyUserAuth.ps1
            $script:VerifyStatus = Invoke-VerifyUserAuth
        }

        "VerifyBasicAuth"
        {
            # Source the File
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateClient: Validating Basic Auth"
            . $RestPSLocalRoot\bin\Invoke-VerifyBasicAuth.ps1
            $script:VerifyStatus = Invoke-VerifyBasicAuth
        }

        default
        {
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateClient: No Client Validation Selected."
            $script:VerifyStatus = $true
        }
    }
    $script:VerifyStatus
}
