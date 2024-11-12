<#
2024-09-09 Monday 10:50a.
This script comes from this website & works for network shares too:
https://stackoverflow.com/questions/12697259/how-do-i-find-files-with-a-path-length-greater-than-260-characters-in-windows
#>
$pathToScan = "C:\path\to\long\stuff"  # The path to scan with the lengths for (sub-directories will be scanned as well).
$outputFilePath = "C:\temp\PathLengths_path_to_long_stuff.txt" # This must be a file in a directory that exists and does not require admin rights to write to.

$writeToConsoleAsWell = $false   # Writing to the console will be much slower.  Set to $true if you want that.

# Open a new file stream (nice and fast) and write all the paths and their lengths to it.
$outputFileDirectory = Split-Path $outputFilePath -Parent
if (!(Test-Path $outputFileDirectory)) { New-Item $outputFileDirectory -ItemType Directory }
$stream = New-Object System.IO.StreamWriter($outputFilePath, $false)
Get-ChildItem -Path $pathToScan -Recurse -Force | Select-Object -Property FullName, @{Name="FullNameLength";Expression={($_.FullName.Length)}} | Sort-Object -Property FullNameLength -Descending | ForEach-Object {
    $filePath = $_.FullName
    $length = $_.FullNameLength
    $string = "$length : $filePath"
     
    # Write to the Console.
    if ($writeToConsoleAsWell) { Write-Host $string }
  
    #Write to the file.
    $stream.WriteLine($string)
}
$stream.Close()
