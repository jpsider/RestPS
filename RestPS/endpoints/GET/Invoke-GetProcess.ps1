$SingleProcess = $args[0]

if ($SingleProcess -ne "")
{
    $Message = Get-Process -Name $SingleProcess -ErrorAction SilentlyContinue | Select-Object ProcessName -ErrorAction SilentlyContinue
}
else
{
    $Message = Get-Process -ErrorAction SilentlyContinue | Select-Object ProcessName -ErrorAction SilentlyContinue
}
return $Message