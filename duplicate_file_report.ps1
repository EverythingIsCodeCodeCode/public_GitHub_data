<#
2024-02-15 Thursday. 4p.  This doesn't work yet.
Given a path & folder name, this script will produce a report of duplicate file names found in it & its subfolders.
#>


$Date = Get-Date -UFormat %Y-%m-%d_%a_%I_%M_%S_%p # Get the current date/time so we can use it in the transcript.
$DateString = "C:\temp\"+"$Date"+"_duplicate_file_report_PowerShell_transcript.txt"
if ($PSVersionTable.Platform -eq "Unix") {
	$DateString = "/home/john/Documents/PowerShell_script_output/"+"$Date"+"_duplicate_file_report_PowerShell_transcript.txt"
}
Start-Transcript -Path $DateString
<#
Write-Output -InputObject "This script has been configured to run in Windows."
Write-Output -InputObject "It will produce a report of duplicate files."
Write-Output -InputObject "The report will be located in the C:\temp folder."
$folder = Read-Host -Prompt "Input path to folder and include the folder's name at the end of the path."
$stopwatch = [system.diagnostics.stopwatch]::StartNew()
If (Test-Path -Path $folder)
 {
$parentFolderData = Get-ChildItem -Path $folder -Attributes Archive,Compressed,Device,Directory,Encrypted,Hidden,IntegrityStream,Normal,NoScrubData,NotContentIndexed,Offline,ReadOnly,ReparsePoint,SparseFile,System,Temporary -Exclude *.* -Force -Verbose -ErrorAction SilentlyContinue | Where-Object { $PSLineItem.LinkType -notmatch "HardLink" -and $PSItem.PSIsContainer -eq $true }
 }
$parentFolderDataCount = $parentFolderData.count
Write-Output -InputObject "`n"
Write-Output -InputObject "Found $parentFolderDataCount subfolders."

foreach ($subFolder in $parentFolderData)
{
If (Test-Path -Path $subFolder)
 {
	$subStopwatch = [system.diagnostics.stopwatch]::StartNew()
	$folderData = Get-ChildItem -Path $subFolder -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.LinkType -notmatch "HardLink" }
	$folderNumber = (Get-ChildItem -Path $subFolder -Directory -Recurse -Force).Count
	$fileNumber = (Get-ChildItem -Path $subFolder -File -Recurse -Force).Count
	$tb = "{0:N2} Terabytes (TB)" -f (($folderData | Measure-Object -Property Length -Sum).Sum / 1Tb)
	$gb = "{0:N2} Gigabytes (GB)" -f (($folderData | Measure-Object -Property Length -Sum).Sum / 1Gb)
	$mb = "{0:N2} Megabytes (MB)" -f (($folderData | Measure-Object -Property Length -Sum).Sum / 1Mb)
	$kb = "{0:N2} Kilobytes (KB)" -f (($folderData | Measure-Object -Property Length -Sum).Sum / 1Kb)
	$bytes = "{0:N0} Bytes (B)" -f (($folderData | Measure-Object -Property Length -Sum).Sum)
	
	Write-Output -InputObject "`n"
	Write-Output -InputObject "Folder:  $subFolder"
	Write-Output -InputObject "Subfolders:  $folderNumber"
	Write-Output -InputObject "Files:  $fileNumber"
	Write-Output -InputObject "$tb"
	Write-Output -InputObject "$gb"
	Write-Output -InputObject "$mb"
	Write-Output -InputObject "$kb"
	Write-Output -InputObject "$bytes"

	$subStopwatch.Stop()
	$seconds = $subStopwatch.Elapsed
	$milliseconds = $subStopwatch.ElapsedMilliseconds
	"Milliseconds elapsed:  $milliseconds"
	"Hours:minutes:seconds: elapsed:  $seconds"
	# Write-Output -InputObject "`n"
 
 }
else {Write-Output "Folder not found:  $subFolder"}
}

Write-Output -InputObject "`n"
$stopwatch.Stop()
$seconds = $stopwatch.Elapsed
$milliseconds = $stopwatch.ElapsedMilliseconds
Write-Output -InputObject "Total time:"
"Milliseconds elapsed:  $milliseconds"
"Hours:minutes:seconds: elapsed:  $seconds"

Stop-Transcript



$Files = $Files2 = Get-ChildItem -Path C:\blah2 -Recurse -File -Force
foreach ($file in $Files)
{
$file.Name 
}



$Files = $Files2 = Get-ChildItem -Path C:\blah2 -Recurse -File -Force
ForEach-Object -InputObject $Files -Process {Write-Output -InputObject $Files.Name}
ForEach-Object -InputObject $Files -Process {If ($Files.Name -eq $Files2.Name) {Write-Output -InputObject $Files.Name}}
ForEach-Object -InputObject $Files -Process {$Files.Name -eq $Files2.Name -and $Files[$_] -ne $Files2[$_]}

$Files = $Files2 = Get-ChildItem -Path C:\blah2 -Recurse -File -Force
Where-Object -InputObject $Files -FilterScript {If ($Files.Name -eq $Files2.Name) {Write-Output -InputObject $Files.Name} }

$Files = $Files2 = Get-ChildItem -Path C:\blah2 -Recurse -File -Force
$TotalFiles = $Files.Count
$CurrentFile = 0
foreach ($file in $Files)
{
if ($file.Name -eq $Files[0..$Files.Count].Name) {Write-Output -InputObject $file.FullName}
$CurrentFile = $CurentFile + 1
}

$Files = Get-ChildItem -Path C:\blah2; Where-Object -InputObject $Files -Like "$_.Name"     



#Loop in a loop with troubleshooting debug output. files, file start count, stop count - looks like I had to ... no solution yet

$Files = Get-ChildItem -Path C:\blah2 -Recurse -File -Force; Write-Output -InputObject "Line 102 - Output of initial Files variable:"; Write-Output -InputObject $Files
$FileStartCountOuterLoop = 0; Write-Output -InputObject "Line 103 - Output of initial FileStartCountOuterLoop variable:"; Write-Output -InputObject $FileStartCountOuterLoop
$FileCurrentCountOuterLoop = 0; Write-Output -InputObject "Line 104 - Output of initial FileCurrentCountOuterLoop variable:"; Write-Output -InputObject $FileCurrentCountOuterLoop
$FileStopCountOuterLoop = $Files.Count; Write-Output -InputObject "Line 105 - Output of initial FileStopCountOuterLoop variable:"; Write-Output -InputObject $FileStopCountOuterLoop
$FileStartCountInnerLoop = 0; Write-Output -InputObject "Line 106 - Output of initial FileStartCountInnerLoop variable:"; Write-Output -InputObject $FileStartCountInnerLoop
$FileCurrentCountInnerLoop = 0; Write-Output -InputObject "Line 107 - Output of initial FileCurrentCountInnerLoop variable:"; Write-Output -InputObject $FileCurrentCountInnerLoop
$FileStopCountInnerLoop = $Files.Count; Write-Output -InputObject "Line 108 - Output of initial FileStopCountInnerLoop variable:"; Write-Output -InputObject $FileStopCountInnerLoop

while ($FileCurrentCountOuterLoop -ne $FileStopCountOuterLoop)
{
Write-Output -InputObject "Line 112 - Value of FileCurrentCountOuterLoop variable inside the outer while loop:"; Write-Output -InputObject $FileCurrentCountOuterLoop
Write-Output -InputObject "Line 113 - Value of FileStopCountOuterLoop variable inside the outer while loop:"; Write-Output -InputObject $FileStopCountOuterLoop
 $CurrentFile = $Files[$FileCurrentCountOuterLoop]; Write-Output -InputObject "Line 114 - Value of CurrentFile variable inside the outer while loop:"; Write-Output -InputObject $CurrentFile

 while ($FileCurrentCountInnerLoop -ne $FileStopCountInnerLoop)
 {
 Write-Output -InputObject "Line 118 - Value of FileCurrentCountInnerLoop variable inside the inner while loop:"; Write-Output -InputObject $FileCurrentCountInnerLoop
 Write-Output -InputObject "Line 119 - About to compare these two files & values:"; Write-Output -InputObject $CurrentFile.Name; Write-Output -InputObject $Files[$FileCurrentCountInnerLoop].Name; Write-Output -InputObject "Value of FileCurrentCountOuterLoop:"; Write-Output -InputObject $FileCurrentCountOuterLoop; Write-Output -InputObject "Value of FileCurrentCountInnerLoop:"; Write-Output -InputObject $FileCurrentCountInnerLoop
  if ($CurrentFile.Name -eq $Files[$FileCurrentCountInnerLoop].Name -and $FileCurrentCountOuterLoop -ne $FileCurrentCountInnerLoop)
  {
   Write-Output -InputObject "Line 122 - Found duplicate file:"
   Write-Output -InputObject $Files[$FileCurrentCountInnerLoop].FullName# Write-Output -InputObject $CurrentFile.FullName
  }
  Write-Output -InputObject "Line 125 - Value of FileCurrentCountInnerLoop variable outside the inner while loop before incrementing:"; Write-Output -InputObject $FileCurrentCountInnerLoop  
 $FileCurrentCountInnerLoop = $FileCurrentCountInnerLoop + 1; Write-Output -InputObject "Line 126 - Value of FileCurrentCountInnerLoop variable outside the inner while loop after incrementing:"; Write-Output -InputObject $FileCurrentCountInnerLoop
 }
 Write-Output -InputObject "Line 128 - Value of FileCurrentCountInnerLoop variable outside the inner while loop before setting to zero:"; Write-Output -InputObject $FileCurrentCountInnerLoop
 $FileCurrentCountInnerLoop = 0; Write-Output -InputObject "Line 129 - Value of FileCurrentCountInnerLoop variable outside the inner while loop after setting to zero:"; Write-Output -InputObject $FileCurrentCountInnerLoop
 Write-Output -InputObject "Line 130 - Value of FileCurrentCountOuterLoop variable at the end of the outer while loop before incrementing:"; Write-Output -InputObject $FileCurrentCountOuterLoop
 $FileCurrentCountOuterLoop = $FileCurrentCountOuterLoop + 1; Write-Output -InputObject "Line 131 - Value of FileCurrentCountOuterLoop variable at the end of the outer while loop after incrementing:"; Write-Output -InputObject $FileCurrentCountOuterLoop
}
Stop-Transcript
#>



# $Files = Get-ChildItem -Path C:\blah2 -Recurse -File -Force
if ($PSVersionTable.Platform -eq "Unix") {$Files = Get-ChildItem -Path /home/john/Documents/PowerShell_script_output/Practice_files/ -Recurse -File -Force}
$FileStartCountOuterLoop = 0
$FileCurrentCountOuterLoop = 0
$FileStopCountOuterLoop = $Files.Count
$FileStartCountInnerLoop = 0
$FileCurrentCountInnerLoop = 0
$FileStopCountInnerLoop = $Files.Count

if ($PSVersionTable.Platform -eq "Unix" -and -not(Test-Path -Path "/home/john/Documents/PowerShell_script_output/duplicate_file_report_scratch_paper.txt")){
New-Item -Path "/home/john/Documents/PowerShell_script_output" -Name "duplicate_file_report.txt" -ItemType File -Value "duplicate_file_report_scratch_paper.txt"
}

while ($FileCurrentCountOuterLoop -ne $FileStopCountOuterLoop)
{
 $CurrentFile = $Files[$FileCurrentCountOuterLoop]

 while ($FileCurrentCountInnerLoop -ne $FileStopCountInnerLoop)
 {
 
  if ($CurrentFile.Name -eq $Files[$FileCurrentCountInnerLoop].Name -and $FileCurrentCountOuterLoop -ne $FileCurrentCountInnerLoop)
  {
    
	<#
	# Now you need a log file & you need to check its lines for this value before deciding to add to it.
	if (Test-Path -Path "/home/john/Documents/PowerShell_script_output/duplicate_file_report_scratch_paper.txt"){
		$File = Get-Content -Path "/home/john/Documents/PowerShell_script_output/duplicate_file_report_scratch_paper.txt"
		$EntryAlreadyExists = "False"
		foreach ($line in $File){
			if ($CurrentFile.FullName -eq $line){
				$EntryAlreadyExists = "True"
			}
		if ($EntryAlreadyExists -eq "False" -and $PSVersionTable.Platform -eq "Unix") {Out-File -InputObject $CurrentFile.FullName -FilePath /home/john/Documents/PowerShell_script_output/duplicate_file_report_scratch_paper.txt -Append
			Write-Output -InputObject $CurrentFile.FullName
			}
		}
	}
	#>

	# Out-File -InputObject $CurrentFile.FullName -FilePath C:\temp\duplicate_file_report.txt -Append
	if ($PSVersionTable.Platform -eq "Unix") {Out-File -InputObject $CurrentFile.FullName -FilePath /home/john/Documents/PowerShell_script_output/duplicate_file_report_scratch_paper.txt -Append}
	# Write-Output -InputObject $Files[$FileCurrentCountInnerLoop].FullName
    Write-Output -InputObject $CurrentFile.FullName
  }
   $FileCurrentCountInnerLoop = $FileCurrentCountInnerLoop + 1
 }
 
 $FileCurrentCountInnerLoop = 0
 $FileCurrentCountOuterLoop = $FileCurrentCountOuterLoop + 1
}

# This part of the script that cleans up the log file was written by Microsoft Bing Copilot.
# It showed me I was missing a hash table & the Hashtable.ContainsKey(Object) Method; neither of which I know how to do yet.
# Specify the path to your input file
if ($PSVersionTable.Platform -eq "Unix") {$filePath = "/home/john/Documents/PowerShell_script_output/duplicate_file_report.txt"}

# Read the content of the file and store it in an array
$lines = Get-Content -Path $filePath

# Create a hash table to track unique lines
$uniqueLines = @{}

# Iterate through each line
foreach ($line in $lines) {
    # Check if the line is already in the hash table
    if (-not $uniqueLines.ContainsKey($line)) {
        # Add the line to the hash table
        $uniqueLines[$line] = $true
        # Output the unique line
        Write-Output $line
		if ($PSVersionTable.Platform -eq "Unix") {Out-File -InputObject $line -FilePath /home/john/Documents/PowerShell_script_output/duplicate_file_report.txt -Append}
    }
}

# Clean up
$uniqueLines.Clear()



Stop-Transcript


