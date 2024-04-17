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
$Minimum = 1
$Maximum = 10

# Create an array of numbers within the range
$NumberRange = $Minimum..$Maximum

# Shuffle the array to randomize the order
$ShuffledNumbers = $NumberRange | Get-Random -Count $NumberRange.Count

# Output the shuffled numbers
$ShuffledNumbers

# Variables for counting and controlling the loop
$CountUp = 0
$totalItems = $ShuffledNumbers.Count

$range = $Maximum - $Minimum
# Loop through and output the shuffled numbers one at a time:
foreach ($CurrentLoopItem in $ShuffledNumbers)
{
	# Print each number
	Write-Output "Number: " $CurrentLoopItem
	
	# Increment counter, no need for variable = variable + 1
    $CountUp++
	
	# Check if this is the last item, the foreach will take care of going through the array and exiting
	if ($CountUp -ne $totalItems)
	{
		Pause
	}
}
