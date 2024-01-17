<#
2023-10-04 Wed. 9:28a.
This is some stuff Sean has shown me.
#>


# This is probably the simplest use of the .IndexOf method that I've used.  Basically it shows me which number in a series my loop is on when processing a list.
$ports="2181","2888","3182"
foreach ($port in $ports) { $i = $ports.IndexOf($port) ; $i}

<#
2024-01-09 Tuesday 8:30a.
Here's one way that may be faster to show a folder's size than Get-ChildItem.
.Net/COM FileSystemObject method:
#>
$FSO = New-Object -ComObject Scripting.FileSystemObject -ErrorAction Stop
$folder = Get-Item -LiteralPath "C:\temp"
$FolderSize = $FSO.GetFolder($folder.FullName).Size
$FolderSizeBytes = "{0:N2}" -f ([int64]$FolderSize)
$FolderSizeMB = "{0:N2}" -f ([int64]$FolderSize / 1MB)
$FolderSizeGB = "{0:N2}" -f ([int64]$FolderSize / 1GB)

<#
2024-01-09 Tuesday 8:43a.
Here's one way that may be faster to show a folder's size than Get-ChildItem.
Robocopy Method:
#>
[regex]$BytesLineRegex = 'Bytes\s*:\s*(?<ByteCount>\d+)(?:\s+\d+){3}\s+(?<BytesFailed>\d+)\s+\d+'
[string]$FolderSize = Robocopy.exe $folder.FullName NULL /L /S /NJH /BYTES /FP /NC /TS /XJ /R:0 /W:0 /MT:16 | Select-Object -Last 4
$FolderSize -match "$BytesLineRegex" | Out-Null
$FolderSizeBytes = "{0:N2}" -f ([int64]$Matches.ByteCount)
$FolderSizeMB = "{0:N2}" -f ([int64]$Matches.ByteCount / 1MB)
$FolderSizeGB = "{0:N2}" -f ([int64]$Matches.ByteCount / 1GB)

#End of file.

