function Invoke-StartListener
{
    param(
        [Parameter(Mandatory = $true)][String]$Port,
        [Parameter()][String]$SSLThumbprint,
        [Parameter()][String]$AppGuid
    )
    if ($SSLThumbprint)
    {
        # SSL Thumbprint present, enabling SSL
        netsh http delete sslcert ipport=0.0.0.0:$Port
        netsh http add sslcert ipport=0.0.0.0:$Port certhash=$SSLThumbprint "appid={$AppGuid}"
        $Prefix = "https://"
    }
    else
    {
        # No SSL Thumbprint present
        $Prefix = "http://"
    }
    try
    {
        $listener.Prefixes.Add("$Prefix+:$Port/")
        $listener.Start()
        $Host.UI.RawUI.WindowTitle = "RestPS - $Prefix - Port: $Port"
        Write-Output "Starting: $Prefix Listener on Port: $Port"
    }
    catch
    {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName		
        Throw "Invoke-StartListener: $ErrorMessage $FailedItem"
    }
}