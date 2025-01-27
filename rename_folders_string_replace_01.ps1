<#
2024-01-27 Monday 3:44p.
you.com
prompt: Write a PowerShell script that renames all folders in a folder, keeping their original folder names, and pattern-matching a string to remove or replace it in each folder name.
answer:
PowerShell Script for Renaming Folders
Here's a PowerShell script that renames all folders in a specified directory by removing or replacing a specific string pattern in their names. This script uses the Rename-Item cmdlet to perform the renaming operation.


# Define the path to the directory containing the folders
$directoryPath = "C:\Path\To\Your\Folder"

# Define the string to find and the string to replace it with
$findString = "oldString"
$replaceString = "newString"

# Get all folders in the specified directory
$folders = Get-ChildItem -Path $directoryPath -Directory

# Loop through each folder and rename it
foreach ($folder in $folders) {
    # Create the new folder name by replacing the specified string
    $newFolderName = $folder.Name -replace [regex]::Escape($findString), $replaceString
    
    # Rename the folder if the new name is different
    if ($newFolderName -ne $folder.Name) {
        Rename-Item -Path $folder.FullName -NewName $newFolderName
    }
}


Explanation of the Script

    Directory Path: Set the $directoryPath variable to the path where your folders are located.
    Find and Replace Strings: Specify the strings you want to find and replace with $findString#### PowerShell Script to Rename Folders

Here's a PowerShell script that renames all folders in a directory, keeping their original folder names, and pattern-matching a string to remove or replace it in each folder name:


$folderPath = "C:\path\to\your\folders"
$patternToReplace = "pattern_to_remove_or_replace"
$replacementText = "new_text_to_replace_with"

Get-ChildItem -Path $folderPath -Directory | ForEach-Object {
    $oldFolderName = $_.Name
    $newFolderName = $oldFolderName -replace $patternToReplace, $replacementText
    Rename-Item -Path $_.FullName -NewName $newFolderName
    Write-Host "Renamed folder: $oldFolderName to $newFolderName"
}


Here's how the script works:

    Set the folder path: Specify the path to the folder containing the folders you want to rename in the $folderPath variable.
    Define the pattern to replace: Set the $patternToReplace variable to the pattern you want to remove or replace in the folder names.
    Specify the replacement text: Set the $replacementText variable to the new text you want to replace the pattern with.
    Iterate through the folders: The script uses Get-ChildItem to get all the directories (folders) in the specified $folderPath, and then iterates through them using ForEach-Object.
    Rename the folders: For each folder, the script retrieves the original folder name ($oldFolderName), applies the pattern replacement to get the new folder name ($newFolderName), and then uses Rename-Item to rename the folder.
    Display the renamed folders: The script outputs a message for each folder that was renamed.

Note: Make sure to replace "C:\path\to\your\folders" with the actual path to the folder containing the folders you want to rename, and "pattern_to_remove_or_replace" and "new_text_to_replace_with" with the appropriate values for your use case. This script uses the Rename-Item cmdlet to rename the folders, which is the recommended way to rename items in PowerShell, as it is both faster and more reliable than using the Rename() method on file objects. The script also demonstrates how to use regular expressions to perform pattern matching and replacement on the folder names.


My extra notes:
Caution - this script currently doesn't output what folders it renamed nor does it provide an undo function!
This script comes with no warranty nor support - run at your own risk.

#>


# Define the path to the directory containing the folders
$directoryPath = "C:\temp"

# Define the string to find and the string to replace it with
$findString = "bbbccc"
$replaceString = "" # Leave "" to delete the part of the folder's name found in the $findString variable.

# Get all folders in the specified directory
$folders = Get-ChildItem -Path $directoryPath -Directory

# Loop through each folder and rename it
foreach ($folder in $folders) {
    # Create the new folder name by replacing the specified string
    $newFolderName = $folder.Name -replace [regex]::Escape($findString), $replaceString
    
    # Rename the folder if the new name is different
    if ($newFolderName -ne $folder.Name) {
        Rename-Item -Path $folder.FullName -NewName $newFolderName
    }
}

