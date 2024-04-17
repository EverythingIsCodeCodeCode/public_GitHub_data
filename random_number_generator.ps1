<#
2024-04-15 Monday 2:25p.
This script will generate random numbers from a given range without picking the same number twice.
Microsoft Bing Copilot AI chat helped generate this script.
Steven helped edit it.

In this script:
$Minimum and $Maximum represent the lower and upper bounds of the desired range.
We create an array of numbers using the range operator (..).
The Get-Random cmdlet shuffles the array to ensure non-repeating random numbers.
Finally, the shuffled numbers are displayed. Feel free to adjust the range as needed! 😊
#>

# Define the range (inclusive)
#$Minimum = 1
#Maximum = 10
Write-Output -InputObject ""
Write-Output -InputObject "This PowerShell script will ask you for the smallest and largest raffle ticket numbers then draw them at random."
Write-Output -InputObject ""
$Minimum = Read-Host -Prompt "What is the smallest ticket number?"
$Maximum = Read-Host -Prompt "What is the largest ticket number?"
Write-Output -InputObject ""

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

# Create an array of numbers within the range
$NumberRange = $Minimum..$Maximum

# Shuffle the array to randomize the order
$ShuffledNumbers = $NumberRange | Get-Random -Count $NumberRange.Count

# Output the shuffled numbers
Write-Output -InputObject "Here are the numbers in random order:"
$ShuffledNumbers

# Variables for counting and controlling the loop
$CountUp = 0
$totalItems = $ShuffledNumbers.Count
Write-Output -InputObject ""
Write-Output -InputObject "That's a total of $totalItems numbers."
Write-Output -InputObject ""
Write-Output -InputObject "Now, let's show them one at a time."
Write-Output -InputObject ""

$range = $Maximum - $Minimum
Pause
#clear # it removes the bulk output 
# Loop through and output the shuffled numbers one at a time:
foreach ($CurrentLoopItem in $ShuffledNumbers)
{
	# Print each number
	#Write-Output "Number: " $CurrentLoopItem
	Write-Output $CurrentLoopItem

	# Increment counter, no need for variable = variable + 1
    $CountUp++
	
	# Check if this is the last item, the foreach will take care of going through the array and exiting
	if ($CountUp -ne $totalItems)
	{
		Pause
	}
}

Write-Output -InputObject ""
Write-Output -InputObject "All done."
Write-Output -InputObject ""

