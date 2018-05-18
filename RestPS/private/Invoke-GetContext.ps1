function Invoke-GetContext
{
    $script:context = $listener.GetContext()
    $Request = $script:context.Request
    $Request
}