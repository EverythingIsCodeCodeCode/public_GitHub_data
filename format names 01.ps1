<#
2024-12-04 Wed. 1:04p.
you.com
Write a PowerShell script that takes a list of names that are formatted last name comma first name and outputs them as first name last name.

Here's a PowerShell script that takes a list of names formatted as "last name, first name" and outputs them in the "first name last name" format. This script reads from a text file containing the names and outputs the reformatted names to the console.
Instructions

    Create a Text File: Create a text file named names.txt and populate it with names in the format "last name, first name", one name per line.
    Update the Script: Change the $inputFilePath variable to the path where your names.txt file is located.
    Run the Script: Execute the script in PowerShell. It will read the names from the file, reformat them, and print the results to the console.

Example Input and Output
Input (names.txt):
Doe, John
Smith, Jane
Brown, Bob

Output:
John Doe
Jane Smith
Bob Brown

This script effectively handles the reformatting of names and provides feedback for any names that do not conform to the expected format. Enjoy using it!

#>

# Define the path to the input file
# $inputFilePath = "C:\path\to\your\names.txt"
$inputFilePath = "/Users/UserName/Downloads/names.txt"
# $inputFilePath = Get-Content -Path "/Users/UserName/Downloads/names.txt"

# Read the names from the file
$names = Get-Content $inputFilePath

# Process each name
foreach ($name in $names) {
    # Split the name into last and first parts
    # $parts = $name -split ', '# comma and space
	$parts = $name -split ','# comma
    
    # Check if the name is in the correct format
    if ($parts.Length -eq 2) {
        # Trim any extra spaces and format as "first name last name"
        $firstName = $parts[1].Trim()
        $lastName = $parts[0].Trim()
        $formattedName = "$firstName $lastName"
        
        # Output the formatted name
        Write-Output $formattedName
    } else {
        Write-Output "Invalid format: $name"
    }
}

