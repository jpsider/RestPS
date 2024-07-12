function Invoke-VerifyCAList
{

  if ($null -ne $script:ClientCert){ 
    
    # Get the list over allowed CA:s
    $CaList=""
    Invoke-Expression (get-content -Path $RestPSLocalRoot\bin\Get-RestCAList.ps1 -raw)
    $CaList=Get-restCAList
	Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: CAList is: $CaList"
    
    if ($null -ne $CaList){
      
      #Get the value from the oid
      $LocalCAIdentifier = ($script:ClientCert.Extensions | Where-Object {$_.oid.value -eq "2.5.29.35"}).format(0)
      $LocalCAIdentifier=$LocalCAIdentifier.Substring($LocalCAIdentifier.IndexOf('=')+1)
      Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: $LocalCAIdentifier"
      
      if ($null -ne $LocalCAIdentifier){
      
        if ($CAList.contains($LocalCAIdentifier)){
          Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: CA is Verified."
          
          # Run the cert through test-certificate if check-certificate is enabled
          if(check-certificate -eq $true){
      
            if(Test-Certificate $script:ClientCert -ErrorAction SilentlyContinue -WarningAction SilentlyContinue){
              Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: certificate is Verified."
              $script:VerifyStatus = $true
              }
            else
              {
              Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: The Certificate is not valid."
              $script:VerifyStatus = $false
              }
            
            }
          else
            {
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: Skipping Certificate validation."
            $script:VerifyStatus = $true
            }  
               
          }
        Else{
          Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: CA is not allowed."
          $script:VerifyStatus = $false
          }

        }
      Else
        {
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: Client cert does not have a CA."
        }
        
      }
    Else
      {
      Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: No ACL list available."
      }
    
    }
  else
    {
    Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyCA: The Client did not present a certificate."
    }
 
  $script:VerifyStatus
}		  
		
