$SingleProcess = $args[0]

if ($SingleProcess -ne "")
{
    $Message = Get-Process -Name $SingleProcess | Select-Object ProcessName
}
else
{
    $Message = Get-Process | Select-Object ProcessName
}
return $Message