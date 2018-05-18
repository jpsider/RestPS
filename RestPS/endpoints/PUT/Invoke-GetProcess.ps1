$SingleProcess = $args[0]

if ($SingleProcess -ne "")
{
    $Message = Get-Process -Name $SingleProcess | Select-Object ProcessName -ErrorAction SilentlyContinue
}
else
{
    $Message = Get-Process | Select-Object ProcessName -ErrorAction SilentlyContinue
}
return $Message