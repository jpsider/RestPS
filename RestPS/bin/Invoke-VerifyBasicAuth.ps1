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

			# Split the decoded auth string, and compare to the $RestUserAuth array
			$RequestUserName, $RequestPass = $DecodedAuthString -split (":")
			$AllowedUser = $RestUserAuth | Where-Object {($_.UserName -eq "$RequestUserName") -And ($_.SystemAuthString -eq "$RequestPass")}

			if (($AllowedUser | Measure-Object).Count -eq 1) {
				Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicAuth: Client Authorization type: $AuthType is Verified."
				$script:VerifyStatus = $true
			}
			else
			{
				Write-Log -LogFile $Logfile -LogLevel $logLevel -MsgType INFO -Message "Invoke-VerifyBasicAuth: Client did not pass Authorization type: $AuthType."
				$script:VerifyStatus = $false
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