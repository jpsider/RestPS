function Get-RestCAList
{
    # This Function represents a way to Gather a List of accepted CA:s.
    # it uses the value from OID 2.5.29.14 of the CA Certificate
    
    $CAList = @('abvvdgetgsdsgfgs','sdghjrehgfjfxdhjkgmc')
    $CAList
}

function check-certificate
{
    #Set to true to enable certificate validation
    #$checkcertificate=$false
    $checkcertificate=$true
    $checkcertificate
}