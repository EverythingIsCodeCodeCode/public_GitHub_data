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
	$EasterMonthSkipSingspiration = 1 # The number of Sundays in Easter month next year is 4 or less so we won't have a Singspiration this month.
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





# Get the current date
$today = Get-Date

# Get the first day of the next month
$nextMonth = $today.AddMonths(1).AddDays(-$today.Day + 1)
# $nextMonth = $today.AddMonths(1) # I'm not here yet. I'm still coding up above.

# Calculate the last day of the current month
$lastDayOfMonth = $nextMonth.AddDays(-1)

# Calculate the number of days to subtract to get to the last Sunday
$daysToSubtract = $lastDayOfMonth.DayOfWeek - 0
# Why am I doing this previous line? This shows the printed day of the week of the last day of the month.

# Get the date of the last Sunday of the month
$lastSunday = $lastDayOfMonth.AddDays(-$daysToSubtract)

# Output the result
# $lastSunday




$StartDate = Get-Date -Year ((Get-Date).year+1) -Month 01 -Day 01 # This gets the first day of next year.
$EndDate = Get-Date -Year ((Get-Date).year+1) -Month 12 -Day 31 # This gets the last day of next year.
$Jan = Get-Date -Year ((Get-Date).year+1) -Month 1 # This gets January next year.
$Feb = Get-Date -Year ((Get-Date).year+1) -Month 2 # This gets February next year.
$Mar = Get-Date -Year ((Get-Date).year+1) -Month 3 # This gets March next year.
$Apr = Get-Date -Year ((Get-Date).year+1) -Month 4 # This gets April next year.
$May = Get-Date -Year ((Get-Date).year+1) -Month 5 # This gets May next year.
$Jun = Get-Date -Year ((Get-Date).year+1) -Month 6 # This gets June next year.
$Jul = Get-Date -Year ((Get-Date).year+1) -Month 7 # This gets July next year.
$Aug = Get-Date -Year ((Get-Date).year+1) -Month 8 # This gets August next year.
$Sep = Get-Date -Year ((Get-Date).year+1) -Month 9 # This gets September next year.
$Oct = Get-Date -Year ((Get-Date).year+1) -Month 10 # This gets October next year.
$Nov = Get-Date -Year ((Get-Date).year+1) -Month 11 # This gets November next year.
$Dec = Get-Date -Year ((Get-Date).year+1) -Month 12 # This gets December next year.
$NumberOfDaysInJan = [DateTime]::DaysInMonth($Jan.Year, $Jan.Month)
$NumberOfDaysInFeb = [DateTime]::DaysInMonth($Feb.Year, $Feb.Month)
$NumberOfDaysInMar = [DateTime]::DaysInMonth($Mar.Year, $Mar.Month)
$NumberOfDaysInApr = [DateTime]::DaysInMonth($Apr.Year, $Apr.Month)
$NumberOfDaysInMay = [DateTime]::DaysInMonth($May.Year, $May.Month)
$NumberOfDaysInJun = [DateTime]::DaysInMonth($Jun.Year, $Jun.Month)
$NumberOfDaysInJul = [DateTime]::DaysInMonth($Jul.Year, $Jul.Month)
$NumberOfDaysInAug = [DateTime]::DaysInMonth($Aug.Year, $Aug.Month)
$NumberOfDaysInSep = [DateTime]::DaysInMonth($Sep.Year, $Sep.Month)
$NumberOfDaysInOct = [DateTime]::DaysInMonth($Oct.Year, $Oct.Month)
$NumberOfDaysInNov = [DateTime]::DaysInMonth($Nov.Year, $Nov.Month)
$NumberOfDaysInDec = [DateTime]::DaysInMonth($Dec.Year, $Dec.Month)
$NumberOfSundaysInJan = 0
$NumberOfSundaysInFeb = 0
$NumberOfSundaysInMar = 0
$NumberOfSundaysInApr = 0
$NumberOfSundaysInMay = 0
$NumberOfSundaysInJun = 0
$NumberOfSundaysInJul = 0
$NumberOfSundaysInAug = 0
$NumberOfSundaysInSep = 0
$NumberOfSundaysInOct = 0
$NumberOfSundaysInNov = 0
$NumberOfSundaysInDec = 0

# Loop through each day of the month in January next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInJan; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Jan.Year, $Jan.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJan++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in January: $NumberOfSundaysInJan"

# Loop through each day of the month in February next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInFeb; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Feb.Year, $Feb.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInFeb++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in February: $NumberOfSundaysInFeb"

# Loop through each day of the month in March next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInMar; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Mar.Year, $Mar.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInMar++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in March: $NumberOfSundaysInMar"

# Loop through each day of the month in April next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInApr; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Apr.Year, $Apr.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInApr++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in April: $NumberOfSundaysInApr"

# Loop through each day of the month in May next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInMay; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($May.Year, $May.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInMay++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in May: $NumberOfSundaysInMay"

# Loop through each day of the month in June next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInJun; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Jun.Year, $Jun.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJun++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in June: $NumberOfSundaysInJun"

# Loop through each day of the month in July next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInJul; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Jul.Year, $Jul.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJul++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in July: $NumberOfSundaysInJul"

# Loop through each day of the month in August next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInAug; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Aug.Year, $Aug.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInAug++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in August: $NumberOfSundaysInAug"

# Loop through each day of the month in September next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInSep; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Sep.Year, $Sep.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInSep++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in September: $NumberOfSundaysInSep"

# Loop through each day of the month in October next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInOct; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Oct.Year, $Oct.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInOct++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in October: $NumberOfSundaysInOct"

# Loop through each day of the month in November next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInNov; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Nov.Year, $Nov.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInNov++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in November: $NumberOfSundaysInNov"

# Loop through each day of the month in December next year & count the number of Sundays.
for ($day = 1; $day -le $NumberOfDaysInDec; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Dec.Year, $Dec.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInDec++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in December: $NumberOfSundaysInDec"

# You have now counted the number of Sundays in each month next year.

# See if each month has 4 or less Sundays or 5 or more Sundays to determine if you can have Singspiration that month.
# Remember Easter month. $Jan.Month = $EasterMonthNextYear & $YouCanHaveSingspirationEasterMonth = 1

if ($NumberOfSundaysInJan -le 4) {
	$SingspirationJan = 0 # The number of Sundays in January next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJan -ge 5) {
	$SingspirationJan = 1 # The number of Sundays in January next year is 5 or more so we'll have Singspiration this month.
	if ($Jan.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationJan = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationJan = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInFeb -le 4) {
	$SingspirationFeb = 0 # The number of Sundays in February next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInFeb -ge 5) {
	$SingspirationFeb = 1 # The number of Sundays in February next year is 5 or more so we'll have Singspiration this month.
	if ($Feb.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationFeb = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationFeb = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInMar -le 4) {
	$SingspirationMar = 0 # The number of Sundays in March next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInMar -ge 5) {
	$SingspirationMar = 1 # The number of Sundays in March next year is 5 or more so we'll have Singspiration this month.
	if ($Mar.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationMar = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationMar = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInApr -le 4) {
	$SingspirationApr = 0 # The number of Sundays in April next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInApr -ge 5) {
	$SingspirationApr = 1 # The number of Sundays in April next year is 5 or more so we'll have Singspiration this month.
	if ($Apr.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationApr = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationApr = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInMay -le 4) {
	$SingspirationMay = 0 # The number of Sundays in May next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInMay -ge 5) {
	$SingspirationMay = 1 # The number of Sundays in May next year is 5 or more so we'll have Singspiration this month.
	if ($May.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationMay = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationMay = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInJun -le 4) {
	$SingspirationJun = 0 # The number of Sundays in June next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJun -ge 5) {
	$SingspirationJun = 1 # The number of Sundays in June next year is 5 or more so we'll have Singspiration this month.
	if ($Jun.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationJun = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationJun = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInJul -le 4) {
	$SingspirationJul = 0 # The number of Sundays in July next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJul -ge 5) {
	$SingspirationJul = 1 # The number of Sundays in July next year is 5 or more so we'll have Singspiration this month.
	if ($Jul.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationJul = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationJul = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInAug -le 4) {
	$SingspirationAug = 0 # The number of Sundays in August next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInAug -ge 5) {
	$SingspirationAug = 1 # The number of Sundays in August next year is 5 or more so we'll have Singspiration this month.
	if ($Aug.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationAug = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationAug = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInSep -le 4) {
	$SingspirationSep = 0 # The number of Sundays in September next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInSep -ge 5) {
	$SingspirationSep = 1 # The number of Sundays in September next year is 5 or more so we'll have Singspiration this month.
	if ($Sep.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationSep = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationSep = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInOct -le 4) {
	$SingspirationOct = 0 # The number of Sundays in October next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInOct -ge 5) {
	$SingspirationOct = 1 # The number of Sundays in October next year is 5 or more so we'll have Singspiration this month.
	if ($Oct.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationOct = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationOct = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInNov -le 4) {
	$SingspirationNov = 0 # The number of Sundays in November next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInNov -ge 5) {
	$SingspirationNov = 1 # The number of Sundays in November next year is 5 or more so we'll have Singspiration this month.
	if ($Nov.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationNov = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationNov = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInDec -le 4) {
	$SingspirationDec = 0 # The number of Sundays in December next year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInDec -ge 5) {
	$SingspirationDec = 1 # The number of Sundays in December next year is 5 or more so we'll have Singspiration this month.
	if ($Dec.Month -eq $EasterMonthNextYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationDec = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationDec = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

# You have now figured out if you can have Singspiration each month next year.

# You are here.
# Output to host if you're going to have Singspiration each month next year.
# Then you'll have to work on a report for every Sunday morning, Sunday evening, & Wednesday evening so you know how many Sundays/Wednesdays are left to sign up for the next upcoming Singspiration; calculating in the lead time you need to coordinate everything.
# You may need to calculate the first Singspiration 2 years from from now too so you can get the number of Sundays/Wednesdays left to sign up after the last one next year.
$SingspirationJan
$SingspirationFeb
$SingspirationMar
$SingspirationApr
$SingspirationMay
$SingspirationJun
$SingspirationJul
$SingspirationAug
$SingspirationSep
$SingspirationOct
$SingspirationNov
$SingspirationDec





# You need to double-check the math & value of the variables below since you previously suspected one or more of them might be incorrect.

$EasterDate = ""

While ($StartDate -lt $EndDate) # This starts a while loop for the year.
{

	$StartDate = $StartDate.AddDays(1)
}

