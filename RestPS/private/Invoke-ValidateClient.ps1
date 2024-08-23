function Invoke-ValidateClient
{
    <#
    .DESCRIPTION
        This function provides several way to validate or authenticate a client. A client
        could be a user or a computer.
    .PARAMETER VerificationType
        A VerificationType is optional - Accepted values are:
            -"VerifyRootCA": Verifies the Root CA of the Server and Client Cert Match.
	     -"VerifyCA": Verifies the CA of the Client Cert is in a trusted list. Can also verify that the cert is valid and trusted by the server OS
            -"VerifySubject": Verifies the Root CA, and the Client is on a User provide ACL.
            -"VerifyUserAuth": Provides an option for Advanced Authentication, plus the RootCA,Subject Checks.
	    -"VerifyBasicAuth": Provides an option for Basic Authentication.
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
        [ValidateSet("VerifyRootCA", "VerifySubject", "VerifyUserAuth","VerifyBasicAuth","VerifyCA")]
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

        "VerifyCA"
		{
            # Source the File
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-ValidateClient: Validating Basic Auth"
            . $RestPSLocalRoot\bin\Invoke-VerifyCa.ps1
            $script:VerifyStatus = Invoke-VerifyCAList
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
