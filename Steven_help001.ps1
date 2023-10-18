<#
2023-10-18 Wed. 12:57p.
Some code helps from Steven :D !
This function determines the OS it's running on.
#>

function Copy-RemoteFiles {
    param (
        [string]$SourceFolder,
        [string]$TemplateFile,
        [string]$NewFile,
        [string]$DestinationFolder
    )

    if (Test-Path "/home") {
        # Remote machine is Linux
        $PathSeparator = "/"
    }
    elseif (Test-Path "/Users") {
        # Remote machine is macOS
        $PathSeparator = "/"
    }
    elseif (Test-Path "C:\Users") {
        # Remote machine is Windows
        $PathSeparator = "\"
    }
    else {
        Write-Error "Could not determine the remote operating system."
        return
    }

    $SourcePath = "$SourceFolder$PathSeparator$TemplateFile"
    $DestinationPath = "$DestinationFolder$PathSeparator$NewFile"

    Copy-Item $SourcePath $DestinationPath

    Write-Output "Files copied successfully from $SourcePath to $DestinationPath."
}

# Example usage
Copy-RemoteFiles -SourceFolder "/Users/Some/Folder" -TemplateFile "a.txt" -NewFile "b.txt" -DestinationFolder "/Users/Some/Path" 

