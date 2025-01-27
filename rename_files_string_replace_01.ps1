<#
2025-01-27 Monday 3:11p.
you.com
prompt: Write a PowerShell script that renames all files in a folder, keeping their original file names, and pattern-matching a string to remove or replace it in each filename.
answer:
PowerShell Script for Renaming Files
Here's a PowerShell script that renames all files in a specified folder by removing or replacing a specific string in their filenames. This script uses the Get-ChildItem cmdlet to retrieve the files and the Rename-Item cmdlet to rename them.

# Define the folder path and the string to replace
$folderPath = "C:\Path\To\Your\Folder"
$oldString = "old"
$newString = "new"

# Get all files in the specified folder
Get-ChildItem -Path $folderPath | ForEach-Object {
    # Create the new file name by replacing the old string with the new string
    $newFileName = $_.Name -replace $oldString, $newString
    
    # Rename the file
    Rename-Item -Path $_.FullName -NewName $newFileName
}

Explanation of the Script

    Folder Path: Change the $folderPath variable to the path of the folder containing the files you want to rename.
    String Replacement: The $oldString variable holds the string you want to remove or replace, while $newString holds the string you want to use as a replacement.
    Get-ChildItem: This cmdlet retrieves all files in the specified folder.
    ForEach-Object: This cmdlet processes each file individually.
    -replace Operator: This operator is used to replace occurrences of $oldString with $newString in the filename.
    Rename-Item: This cmdlet renames the file with the new filename.

Usage

    Open PowerShell.
    Copy and paste the script into the PowerShell window.
    Modify the $folderPath, $oldString, and $newString variables as needed.
    Run the script to rename the files in the specified folder.

This script is a simple yet effective way to batch rename files based on a specific pattern, leveraging the capabilities of PowerShell.

My extra notes:
Caution - this script currently doesn't output what files it renamed nor does it provide an undo function!

#>

# Define the folder path and the string to replace
$folderPath = "C:\temp"
$oldString = "bbbccc"
$newString = "" # Leave "" to delete the part of the file's name found in the $oldString variable.

# Get all files in the specified folder
Get-ChildItem -Path $folderPath | ForEach-Object {
    # Create the new file name by replacing the old string with the new string
    $newFileName = $_.Name -replace $oldString, $newString
    
    # Rename the file
    Rename-Item -Path $_.FullName -NewName $newFileName -ErrorAction SilentlyContinue
}

