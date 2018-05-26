Param(
    $RequestArgs,
    $Body
)


if ($RequestArgs -ne "")
{
    $Message = Get-Process -Name $RequestArgs -ErrorAction SilentlyContinue | Select-Object ProcessName,ID,MainWindowTitle -ErrorAction SilentlyContinue
}
else
{
    $Message = Get-Process -ErrorAction SilentlyContinue | Select-Object ProcessName -ErrorAction SilentlyContinue
}
return $Message