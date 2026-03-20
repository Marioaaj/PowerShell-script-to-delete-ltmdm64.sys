#This script was disgned to close a process on a computer

Get-Process | Where-Object { $_.ProcessName -like "*DSTART*" } | Stop-Process -Force