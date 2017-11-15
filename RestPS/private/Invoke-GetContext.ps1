function Invoke-GetContext
{
    $script:context = $listener.GetContext()
    $Request = $Context.Request
    return $Request
}