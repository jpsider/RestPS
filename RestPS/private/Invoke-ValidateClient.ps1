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
        [ValidateSet("VerifyRootCA", "VerifySubject", "VerifyUserAuth")]
        [Parameter()][String]$VerificationType,
        [Parameter()][String]$RestPSLocalRoot = "c:\RestPS"
    )
    switch ($VerificationType)
    {
        "VerifyRootCA"
        {
            # Source the File
            . $RestPSLocalRoot\bin\Invoke-VerifyRootCA.ps1
            $script:VerifyStatus = Invoke-VerifyRootCA
        }

        "VerifySubject"
        {
            # Source the File
            . $RestPSLocalRoot\bin\Invoke-VerifySubject.ps1
            $script:VerifyStatus = Invoke-VerifySubject
        }

        "VerifyUserAuth"
        {
            # Source the File
            . $RestPSLocalRoot\bin\Invoke-VerifyUserAuth.ps1
            $script:VerifyStatus = Invoke-VerifyUserAuth
        }

        default
        {
            Write-Output "No Client Validation Selected."
            $script:VerifyStatus = $true
        }
    }
    $script:VerifyStatus
}