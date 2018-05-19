function Get-ClientCertInfo
{
    <#
	.DESCRIPTION
		This function Collect Information on a Client Certificate.
	.EXAMPLE
        Get-ClientCertInfo
	.NOTES
        This will return null.
    #>
    $script:ClientCert = $script:Request.GetClientCertificate()
    $script:SubjectName = $script:ClientCert.Subject
}