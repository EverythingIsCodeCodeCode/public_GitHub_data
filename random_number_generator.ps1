<#
2024-04-15 Monday 2:25p.
This script will generate random numbers from a given range without picking the same number twice.
Microsoft Bing Copilot AI chat helped generate this script.

In this script:
$Minimum and $Maximum represent the lower and upper bounds of the desired range.
We create an array of numbers using the range operator (..).
The Get-Random cmdlet shuffles the array to ensure non-repeating random numbers.
Finally, the shuffled numbers are displayed. Feel free to adjust the range as needed! 😊
#>

# Define the range (inclusive)
$Minimum = 1
$Maximum = 10

# Create an array of numbers within the range
$NumberRange = $Minimum..$Maximum

# Shuffle the array to randomize the order
$ShuffledNumbers = $NumberRange | Get-Random -Count $NumberRange.Count

# Output the shuffled numbers
$ShuffledNumbers

# Output the shuffled numbers one at a time:
$CountUp = 0
$range = $Maximum - $Minimum
foreach ($currentItemName in $ShuffledNumbers)
{
	Write-Output -InputObject $ShuffledNumbers[$CountUp]
	# [void][System.Console]::ReadKey($FALSE)
	Pause
	$CountUp = $CountUp + 1
	If ($CountUp -gt ($range + 1)){Exit-PSHostProcess}
}

# You still need to get the script to display the last number in the loop after pressing Enter the final time.
