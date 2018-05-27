Function Get-RestAclList
{
    # This Function represents a way to Gather a List to Compare a Client Subject/CN Name.
    #   This is meant to be updated to suit your specific needs. Such as:
    #   Getting a list of names from Active Directory
    #   Getting a list of names from a real Certificate Authority 
    #     (or ensuring they are not on the Certificate revokation list)
    #   Getting a list of names from a remote endpoint of a different Web Application
    $AclList = @("RestServer", "Client", "DemoClient.PowerShellDemo.io")
    $AclList
}