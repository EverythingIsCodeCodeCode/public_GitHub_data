<#
2023-11-13 Mon. 9p.
This script will split files in a folder into new folders so that each folder contains the same number of files except the last folder.
This is useful for things like a folder of many audio files.  Some audio players only recognize up to a certain number of files in each folder.

rough draft of notes:
define variables
source folder
target folder to make new folders in
number of files in each new folder
name of new folders
numbering of new folders

main loop to check for files in target folder
do you just want one loop?  can this be done in a single loop?



Here's the three lines of PowerShell that helped me count the number of mp3 files in each folder as I was manually selecting them in Explorer & populating them since a lot of extra stuff came up & I didn't have time to spend troubleshooting scripting.  Maybe I'll have time later.

$a = Get-ChildItem -Path L:\chiptune016
$b = $a | Where-Object -Property Name -Like "*.mp3"
$b.Count



#>



#End of script.
