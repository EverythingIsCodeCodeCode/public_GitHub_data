<#
2023-12-18 Monday 9:49a.
This script will show some data about how big a folder is.
https://woshub.com/powershell-get-folder-sizes/
https://stackoverflow.com/questions/12934106/counting-folders-with-powershell
https://stackoverflow.com/questions/14714284/powershell-count-items-in-a-folder-with-powershell
https://stackoverflow.com/questions/32252707/remove-blank-lines-in-powershell-output
https://devblogs.microsoft.com/powershell-community/determine-if-a-folder-exists/
https://ss64.com/ps/measure-command.html

#>

$folder = Read-Host -Prompt "Input path to folder and include the folder's name at the end of the path."
$stopwatch = [system.diagnostics.stopwatch]::StartNew()
If (Test-Path -Path $folder)
 {
$folderData = Get-ChildItem -Path $folder -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.LinkType -notmatch "HardLink"}
$folderNumber = (Get-ChildItem -Path $folder -Directory -Recurse -Force).Count
$fileNumber = (Get-ChildItem -Path $folder -File -Recurse -Force).Count
$tb = "{0:N2} Terabytes (TB)" -f (($folderData | Measure-Object -Property Length -Sum).Sum / 1Tb)
$gb = "{0:N2} Gigabytes (GB)" -f (($folderData | Measure-Object -Property Length -Sum).Sum / 1Gb)
$mb = "{0:N2} Megabytes (MB)" -f (($folderData | Measure-Object -Property Length -Sum).Sum / 1Mb)
$bytes = "{0:N0} Bytes (B)" -f (($folderData | Measure-Object -Property Length -Sum).Sum)

Write-Output -InputObject "Folder:  $folder"
Write-Output -InputObject "Subfolders:  $folderNumber"
Write-Output -InputObject "Files:  $fileNumber"
Write-Output -InputObject $tb
Write-Output -InputObject "$gb"
Write-Output -InputObject "$mb"
Write-Output -InputObject "$bytes"
 }
else {Write-Output "Folder not found."}
$stopwatch.Stop()
$time = $stopwatch.ElapsedMilliseconds
"Milliseconds Elapsed:  $time"
