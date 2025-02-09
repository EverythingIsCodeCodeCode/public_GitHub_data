<#
2024-12-01sp.
This script will help with figuring out Singspiration dates which usually take place on the 5th Sunday night at 6p in a given month.

You may need to figure out how many days are in each month in addition to counting the number of Sundays in each month.
You need to figure out if Easter takes place the same time as Singspiration so you can skip the Singspiration.
Is there a way to get all the Easter dates from somewhere or just load them in manually?
https://www.timeanddate.com/calendar/determining-easter-date.html
We've only had 1 Singspiration in December in 2013 so we may just skip Singspiration in December because of Christmas & New Years.

Count the number of weeks for any given service until the next Singspiration.
Count the number of weeks remaining to signup for the next Singspiration.

Remember, you need approximately 2 weeks to comfortability process everything before Singspiration::
sa - can signup for current event
sp - can signup for next event
wp - can signup for next event
sa - can signup for next event
sp - can signup for next event
wp - can signup for next event
sa - can signup for next event
sp - event takes place

Might borrow code that gets church services for next year.

https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-date?view=powershell-7.3
https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings?view=netframework-4.8
https://ss64.com/ps/syntax-easter.html
#>

# Import variables using dot sourcing:
. .\gitignore_data\variables.ps1
# List variables:
# Ok, no variables to use/list just yet.


Function Get-DateOfEaster {
	param (
	   [int]$Year,
	   [int]$GregorianStart = 1752
	)
	# Reads a Year and returns the date of Easter Sunday.
	
	# For Easter dates prior to 1926 the start of the Gregorian calendar needs to be considered.
	# Different countries adopted the Gregorian calendar on different dates.
	# France, Spain, Portugal = 1582
	# Netherlands = 1583
	# Switzerland = 1584
	# UK + colonies = 1752
	# Turkey = 1926
	
	# Setting $GregorianStart > $Year, will return Easter on the Julian calendar.
	
	[int]$GoldenNo = $Year % 19 #modulus
	
	If ($Year -gt $GregorianStart) {
	   [int]$Century = [math]::floor($Year / 100)
	   [int]$intK = [math]::floor(($Century - 17) / 25)
	   [int]$intI = $Century - [math]::floor(($Century / 4))
	   [int]$intI = $intI - [math]::floor((($Century - $intK) / 3)) + 19 * $GoldenNo + 15
	   [int]$intI = $intI % 30
	   
	   [int]$intN1 = $intI - [math]::floor(($intI / 28)) 
	   
	   [int]$intN21 = [math]::floor(($intI / 28))
	   [int]$intN22 = [math]::floor((29 / ($intI + 1)))
	   [int]$intN23 = [math]::floor(((21 - $GoldenNo) / 11))
	   [int]$intI = $intN1 * (1 - $intN21 * $intN22 * $intN23)
	   
	   [int]$intJ = $Year + [math]::floor(($Year / 4)) + $intI
	   [int]$intJ = $intJ + 2 - $Century + [math]::floor(($Century / 4))
	   [int]$intJ = $intJ % 7
	   $Cal = 'Gregorian'
	} Else {
	   [int]$intI = ((19 * $GoldenNo) + 15) % 30
	   [int]$intJ = ($Year + [math]::floor(($Year / 4)) + $intI) % 7
	   $Cal = 'Julian'
	}
	 
	   [int]$intL = $intI - $intJ
	   [int]$Month = 3 + [math]::floor((($intL + 40) / 44))
	   [int]$Day = $intL + 28 - 31 * [math]::floor(($Month / 4))
	   "$Year-0$Month-$Day ($Cal)"
	   $DateTime = New-Object DateTime $Year, $Month, ($Day), 0, 0, 0, ([DateTimeKind]::Utc)
	   Return $DateTime
	}

<#
	" Examples:"
	$Easter = Get-DateOfEaster 2025
	"$Easter"
	$Easter = Get-DateOfEaster 1590 1752
	"$Easter"
#>
$EasterDateNextYear = Get-DateOfEaster ((Get-Date).year+1)
$EasterYearNextYear = $EasterDateNextYear[0].Substring(0,4)
$EasterMonthNextYear = $EasterDateNextYear[0].Substring(5,2)
$EasterDayNextYear = $EasterDateNextYear[0].Substring(8,2)
$EasterNumberOfDaysInMonthNextYear = [DateTime]::DaysInMonth($EasterYearNextYear, $EasterMonthNextYear)
$EasterMonthNumberOfSundaysCountNextYear = 0
# Loop through each day of the month
for ($day = 1; $day -le $EasterNumberOfDaysInMonthNextYear; $day++) {
    # Create a date object for the current day
    $currentDate = [DateTime]::new($EasterYearNextYear, $EasterMonthNextYear, $day)
    # Check if the day is a Sunday
    if ($currentDate.DayOfWeek -eq "Sunday") {
        # Increment the Sunday counter
        $EasterMonthNumberOfSundaysCountNextYear++
    }
}
# Output the number of Sundays
# Write-Output "Number of Sundays in this month: $EasterMonthNumberOfSundaysCountNextYear"
if ($EasterMonthNumberOfSundaysCountNextYear -le 4) {
	$EasterMonthSkipSingspiration = 1 # The number of Sundays in Easter month next year is 4 or less so we won't have to skip a Singspiration this month.
}
if ($EasterMonthNumberOfSundaysCountNextYear -ge 5) {
	$EasterMonthSkipSingspiration = 0 # The number of Sundays in Easter month next year is 5 or more so we'll have to skip a Singspiration this month if Easter also takes place this same Sunday.
}

# Calculate the last Sunday of the month for the month of Easter next year::
$lastDay = New-Object -TypeName DateTime -ArgumentList $EasterYearNextYear, $EasterMonthNextYear, $EasterNumberOfDaysInMonthNextYear
# Find the last Sunday
while ($lastDay.DayOfWeek -ne [DayOfWeek]::Sunday) {
	$lastDay = $lastDay.AddDays(-1)
}
# Write-Host "The last Sunday of $($EasterMonthNextYear)/$EasterYearNextYear is on day number $($lastDay.Day), which is $($lastDay.ToString('dddd, MMMM dd, yyyy'))."
$EasterNextYearLastSundayInMonth = $($lastDay.Day)

# Compare $EasterNextYearLastSundayInMonth to $EasterDayNextYear.
# If they're the same then skip Singspiration that month.
# If they're different then you can have Singspiration that month.
if ($EasterDayNextYear -eq $EasterNextYearLastSundayInMonth) {
	$SkipEasterSingspiration = 1 # Skip Singspiration this month because Easter takes place on the same Sunday.
}
if ($EasterDayNextYear -ne $EasterNextYearLastSundayInMonth) {
	$SkipEasterSingspiration = 0 # Have Singspiration this month because Easter takes place on a different Sunday.
	# If $EasterMonthSkipSingspiration = 0
}

if ($SkipEasterSingspiration -ne $EasterMonthSkipSingspiration) {
	$YouCanHaveSingspirationEasterMonth = 0 # Skip Singspiration this month. Either because Easter month has 4 or less Sundays and/or Easter takes place on the last Sunday of the month.
}

if ($SkipEasterSingspiration -eq $EasterMonthSkipSingspiration) {
	$YouCanHaveSingspirationEasterMonth = 1 # Have Singspiration this month. Easter month has 5 or more Sundays and Easter doesn't take place on the last Sunday of the month.
}
# You have now figured out if you can have Singspiration Easter month.




# You are here.
# You need to double-check the math & value of the variables below since you previously suspected one or more of them might be incorrect.

# Get the current date
$today = Get-Date

# Get the first day of the next month
$nextMonth = $today.AddMonths(1).AddDays(-$today.Day + 1)
# $nextMonth = $today.AddMonths(1) # I'm not here yet. I'm still coding up above.

# Calculate the last day of the current month
$lastDayOfMonth = $nextMonth.AddDays(-1)

# Calculate the number of days to subtract to get to the last Sunday
$daysToSubtract = $lastDayOfMonth.DayOfWeek - 0

# Get the date of the last Sunday of the month
$lastSunday = $lastDayOfMonth.AddDays(-$daysToSubtract)

# Output the result
$lastSunday





$StartDate = Get-Date -Year ((Get-Date).year+1) -Month 01 -Day 01 # This gets the first day of next year.
$EndDate = Get-Date -Year ((Get-Date).year+1) -Month 12 -Day 31 # This gets the last day of next year.
$Jan = Get-Date -Year ((Get-Date).year+1) -Month 1 # This gets January next year.
$EasterDate = ""

While ($StartDate -lt $EndDate) # This starts a while loop for the year.
{

	$StartDate = $StartDate.AddDays(1)
}

