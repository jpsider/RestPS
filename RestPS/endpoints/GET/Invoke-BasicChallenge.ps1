$myAuth = $script:Request.Headers['Authorization']
if ([string]::IsNullOrEmpty($myauth))
  {
    $script:StatusCode = 401
    $script:StatusDescription = 'Need authentication!'
    $script:StatusHeaders['WWW-Authenticate'] = 'Basic realm="My REST server"'
  }
  else
  {
    $mytype, $mycontent = $myAuth.split(' ')
    $mycontent = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($mycontent))
    $myuser, $mypass = $mycontent.split(':')
    $mydata = @{
        Type = $mytype
        User = $myuser
        Pass = $mypass
    }
    return $mydata
  }