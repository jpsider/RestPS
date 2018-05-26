Function Get-RestAclList
{
    # This Function represents a way to Gather a List to Compare a Client Friendly Name to.
    # This is meant to be update to suit your specific needs. Such as:
    # Getting a list of names from Active Directory
    # Getting a list of names from a real Certificate Authority (ensuring they are not on the CRL)
    # Getting a list of names from a remote endpoint of a different Web Application
    $AclList = @("RestClient", "PowerShellClient", "Client", "DemoClient", "DemoClient.PowerShellDemo.io")
    $AclList
}