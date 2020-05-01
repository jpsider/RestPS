function Invoke-VerifyBasicAuth
{
	# Basic Authentication
	. $RestPSLocalRoot\bin\Get-RestUserAuth.ps1
	$RestUserAuth = (Get-RestUserAuth).UserData

	if ($null -ne $RestUserAuth)
	{
        
        	# Get the AuthString from Client Headers
        	$ClientHeaders = $script:Request.Headers
        	$ClientHeadersAuth = $ClientHeaders.GetValues("Authorization")
        	$AuthType, $AuthString = $ClientHeadersAuth.split(" ")
        	Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicAuth: Auth type is: $AuthType, AuthString is: $AuthString"

 			if ($null -ne $AuthString)
			{

				# Decode the Authorization header
				$DecodedAuthString = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($AuthString))

				# Compare the decoded authorisation header to the user record in $RestUserAuth one by one
				foreach ($AllowedUser in $RestUserAuth) {	
					$AllowedUserName = $AllowedUser.UserName
					$AllowedUserPassword = $AllowedUser.SystemAuthString

					if ($DecodedAuthString -eq $AllowedUserName + ":" + $AllowedUserPassword)
	 				{
						Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicAuth: Client Authorization type: $AuthType is Verified."
						$script:VerifyStatus = $true
						Break
					}
					else
					{
						$script:VerifyStatus = $false
					}		
				}

			    # Checked all user records in $RestUserAuth and no record match
			    If ($script:VerifyStatus -eq $false) {
					Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicAuth: Client did not pass Authorization type: $AuthType."
            	}
	    
        }
        else
        {
            Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicAuth: No Authorization String found."
            $script:VerifyStatus = $false
        }
    }
    else
    {
        Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicAuth: No Authorization data available."
        $script:VerifyStatus = $false
    }
    $script:VerifyStatus
}