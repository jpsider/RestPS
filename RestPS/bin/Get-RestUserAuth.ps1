function Get-RestUserAuth
{
    # This Function represents a way to Gather a UserAuth String.
    #   This is meant to be updated to suit your specific needs. Such as:
    #     Getting a password Hash
    #     Getting a web Token
    #     Or any other way to validate User Authentication
    $UserAuth = @{
        UserData = @(
            @{
                UserName         = 'RestServer'
                SystemAuthString = 'abcd'
            },
            @{
                UserName         = 'client'
                SystemAuthString = '1234'
            },
            @{
                UserName         = 'DemoClient.PowerShellDemo.io'
                SystemAuthString = 'abcd1234'
            }
        )
    }
    $UserAuth
}