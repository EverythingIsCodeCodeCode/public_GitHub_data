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

This script's efficiency can be improved since some code is duplicated.

Having some challenges progressing in this script.
Making a note of what I know so far to help progress::
Future year.
Last Sunday of every month.
Last Wednesday of every month.
Each Singspiration date.

Use math to subtract.

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
$CurrentYear = (Get-Date).Year
$FutureYear = $CurrentYear + 1 # This is the line where you set next year (+ 1), two years from now (+ 2), or whatever you need at the time.
$EasterDateFutureYear = Get-DateOfEaster $FutureYear
# $EasterDateFutureYear = Get-DateOfEaster ((Get-Date).year+1)
$EasterYearFutureYear = $EasterDateFutureYear[0].Substring(0,4)
$EasterMonthFutureYear = $EasterDateFutureYear[0].Substring(5,2)
$EasterDayFutureYear = $EasterDateFutureYear[0].Substring(8,2)
$EasterNumberOfDaysInMonthFutureYear = [DateTime]::DaysInMonth($EasterYearFutureYear, $EasterMonthFutureYear)
$EasterMonthNumberOfSundaysCountFutureYear = 0
# Loop through each day of the month
for ($day = 1; $day -le $EasterNumberOfDaysInMonthFutureYear; $day++) {
    # Create a date object for the current day
    $currentDate = [DateTime]::new($EasterYearFutureYear, $EasterMonthFutureYear, $day)
    # Check if the day is a Sunday
    if ($currentDate.DayOfWeek -eq "Sunday") {
        # Increment the Sunday counter
        $EasterMonthNumberOfSundaysCountFutureYear++
    }
}
# Output the number of Sundays
# Write-Output "Number of Sundays in this month: $EasterMonthNumberOfSundaysCountFutureYear"
if ($EasterMonthNumberOfSundaysCountFutureYear -le 4) {
	$EasterMonthSkipSingspiration = 1 # The number of Sundays in Easter month in the future year is 4 or less so we won't have a Singspiration this month.
}
if ($EasterMonthNumberOfSundaysCountFutureYear -ge 5) {
	$EasterMonthSkipSingspiration = 0 # The number of Sundays in Easter month in the future year is 5 or more so we'll have to skip a Singspiration this month if Easter also takes place this same Sunday.
}

# Calculate the last Sunday of the month for the month of Easter in the future year::
$lastDay = New-Object -TypeName DateTime -ArgumentList $EasterYearFutureYear, $EasterMonthFutureYear, $EasterNumberOfDaysInMonthFutureYear
# Find the last Sunday
while ($lastDay.DayOfWeek -ne [DayOfWeek]::Sunday) {
	$lastDay = $lastDay.AddDays(-1)
}
# Write-Host "The last Sunday of $($EasterMonthFutureYear)/$EasterYearFutureYear is on day number $($lastDay.Day), which is $($lastDay.ToString('dddd, MMMM dd, yyyy'))."
$EasterFutureYearLastSundayInMonth = $($lastDay.Day)

# Compare $EasterFutureYearLastSundayInMonth to $EasterDayFutureYear.
# If they're the same then skip Singspiration that month.
# If they're different then you can have Singspiration that month.
if ($EasterDayFutureYear -eq $EasterFutureYearLastSundayInMonth) {
	$SkipEasterSingspiration = 1 # Skip Singspiration this month because Easter takes place on the same Sunday.
}
if ($EasterDayFutureYear -ne $EasterFutureYearLastSundayInMonth) {
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
# Easter can only be in March or April so you can remove the Easter-related code from the other months. Done.


# Can you have Singspiration around Thanksgiving in the future year?::

# Get the number of days in November in the future year
$novemberDays = [DateTime]::DaysInMonth($FutureYear, 11)

# Find the date of Thanksgiving (last Thursday of November)
$thanksgivingDate = [DateTime]::new($FutureYear, 11, 1)
while ($thanksgivingDate.DayOfWeek -ne [DayOfWeek]::Thursday) {
    $thanksgivingDate = $thanksgivingDate.AddDays(1)
}
$thanksgivingDate = $thanksgivingDate.AddDays(21) # Move to the last Thursday. You can always add 21 days to the first Thursday in November to get the last Thursday in November which is always Thanksgiving day.

# Loop through each day after Thanksgiving in November in the future year to find if there is a Sunday after Thanksgiving
$sundayAfterThanksgiving = $false
for ($day = $thanksgivingDate.Day + 1; $day -le $novemberDays; $day++) {
    $date = [DateTime]::new($FutureYear, 11, $day)
    if ($date.DayOfWeek -eq [DayOfWeek]::Sunday) {
        $sundayAfterThanksgiving = $true
        break
    }
}

# Output the result. Is there a Sunday after Thanksgiving in November in the future year?
if ($sundayAfterThanksgiving) {
    # Write-Output "There is a Sunday after Thanksgiving in November $FutureYear so you can have Singspiration."
	$YouCanHaveSingspirationThanksgivingMonth = 1 # There is a Sunday after Thanksgiving in November in the future year so you can have Singspiration if there are 5 Sundays in the month.
} else {
    # Write-Output "There is no Sunday after Thanksgiving in November $FutureYear so skip Singspiration."
	$YouCanHaveSingspirationThanksgivingMonth = 0 # There is no Sunday after Thanksgiving in November in the future year so skip Singspiration.
}
# You have now figured out if there is a Sunday after Thanksgiving in November in the future year.
# You need to add this Thanksgiving logic below similar to Easter.


# $StartDate = Get-Date -Year $FutureYear -Month 01 -Day 01 # This gets the first day of the future year.
# $EndDate = Get-Date -Year $FutureYear -Month 12 -Day 31 # This gets the last day of the future year.
$Jan = Get-Date -Year $FutureYear -Month 1 # This gets January of the future year.
$Feb = Get-Date -Year $FutureYear -Month 2 # This gets February of the future year.
$Mar = Get-Date -Year $FutureYear -Month 3 # This gets March of the future year.
$Apr = Get-Date -Year $FutureYear -Month 4 # This gets April of the future year.
$May = Get-Date -Year $FutureYear -Month 5 # This gets May of the future year.
$Jun = Get-Date -Year $FutureYear -Month 6 # This gets June of the future year.
$Jul = Get-Date -Year $FutureYear -Month 7 # This gets July of the future year.
$Aug = Get-Date -Year $FutureYear -Month 8 # This gets August of the future year.
$Sep = Get-Date -Year $FutureYear -Month 9 # This gets September of the future year.
$Oct = Get-Date -Year $FutureYear -Month 10 # This gets October of the future year.
$Nov = Get-Date -Year $FutureYear -Month 11 # This gets November of the future year.
$Dec = Get-Date -Year $FutureYear -Month 12 # This gets December of the future year.
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
$NumberOfSundaysInFutureYear = 0
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
$NumberOfWednesdaysInJan = 0
$NumberOfWednesdaysInFeb = 0
$NumberOfWednesdaysInMar = 0
$NumberOfWednesdaysInApr = 0
$NumberOfWednesdaysInMay = 0
$NumberOfWednesdaysInJun = 0
$NumberOfWednesdaysInJul = 0
$NumberOfWednesdaysInAug = 0
$NumberOfWednesdaysInSep = 0
$NumberOfWednesdaysInOct = 0
$NumberOfWednesdaysInNov = 0
$NumberOfWednesdaysInDec = 0

# Loop through each day of the month in January in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInJan; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Jan.Year, $Jan.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJan++
		$NumberOfSundaysInFutureYear++
	}
	# Check if the day is a Wednesday
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInJan++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in January: $NumberOfSundaysInJan"

# Loop through each day of the month in February in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInFeb; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Feb.Year, $Feb.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInFeb++
		$NumberOfSundaysInFutureYear++
	}
	# Check if the day is a Wednesday
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInFeb++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in February: $NumberOfSundaysInFeb"

# Loop through each day of the month in March in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInMar; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Mar.Year, $Mar.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInMar++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInMar++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in March: $NumberOfSundaysInMar"

# Loop through each day of the month in April in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInApr; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Apr.Year, $Apr.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInApr++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInApr++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in April: $NumberOfSundaysInApr"

# Loop through each day of the month in May in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInMay; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($May.Year, $May.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInMay++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInMay++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in May: $NumberOfSundaysInMay"

# Loop through each day of the month in June in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInJun; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Jun.Year, $Jun.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJun++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInJun++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in June: $NumberOfSundaysInJun"

# Loop through each day of the month in July in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInJul; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Jul.Year, $Jul.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJul++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInJul++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in July: $NumberOfSundaysInJul"

# Loop through each day of the month in August in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInAug; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Aug.Year, $Aug.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInAug++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInAug++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in August: $NumberOfSundaysInAug"

# Loop through each day of the month in September in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInSep; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Sep.Year, $Sep.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInSep++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInSep++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in September: $NumberOfSundaysInSep"

# Loop through each day of the month in October in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInOct; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Oct.Year, $Oct.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInOct++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInOct++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in October: $NumberOfSundaysInOct"

# Loop through each day of the month in November in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInNov; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Nov.Year, $Nov.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInNov++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInNov++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in November: $NumberOfSundaysInNov"

# Loop through each day of the month in December in the future year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInDec; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($Dec.Year, $Dec.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInDec++
		$NumberOfSundaysInFutureYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInDec++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in December: $NumberOfSundaysInDec"

# You have now counted the number of Sundays in each month in the future year.

# See if each month has 4 or less Sundays or 5 or more Sundays to determine if you can have Singspiration that month.
# Remember Easter month (only March or April). $Jan.Month = $EasterMonthFutureYear & $YouCanHaveSingspirationEasterMonth = 1

if ($NumberOfSundaysInJan -le 4) {
	$SingspirationJan = 0 # The number of Sundays in January in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJan -ge 5) {
	$SingspirationJan = 1 # The number of Sundays in January in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInFeb -le 4) {
	$SingspirationFeb = 0 # The number of Sundays in February in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInFeb -ge 5) {
	$SingspirationFeb = 1 # The number of Sundays in February in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInMar -le 4) {
	$SingspirationMar = 0 # The number of Sundays in March in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInMar -ge 5) {
	$SingspirationMar = 1 # The number of Sundays in March in the future year is 5 or more so we'll have Singspiration this month.
	if ($Mar.Month -eq $EasterMonthFutureYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationMar = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationMar = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInApr -le 4) {
	$SingspirationApr = 0 # The number of Sundays in April in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInApr -ge 5) {
	$SingspirationApr = 1 # The number of Sundays in April in the future year is 5 or more so we'll have Singspiration this month.
	if ($Apr.Month -eq $EasterMonthFutureYear) {
		if ($YouCanHaveSingspirationEasterMonth -eq 1) {
			$SingspirationApr = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonth -eq 0) {
			$SingspirationApr = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInMay -le 4) {
	$SingspirationMay = 0 # The number of Sundays in May in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInMay -ge 5) {
	$SingspirationMay = 1 # The number of Sundays in May in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJun -le 4) {
	$SingspirationJun = 0 # The number of Sundays in June in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJun -ge 5) {
	$SingspirationJun = 1 # The number of Sundays in June in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJul -le 4) {
	$SingspirationJul = 0 # The number of Sundays in July in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJul -ge 5) {
	$SingspirationJul = 1 # The number of Sundays in July in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInAug -le 4) {
	$SingspirationAug = 0 # The number of Sundays in August in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInAug -ge 5) {
	$SingspirationAug = 1 # The number of Sundays in August in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInSep -le 4) {
	$SingspirationSep = 0 # The number of Sundays in September in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInSep -ge 5) {
	$SingspirationSep = 1 # The number of Sundays in September in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInOct -le 4) {
	$SingspirationOct = 0 # The number of Sundays in October in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInOct -ge 5) {
	$SingspirationOct = 1 # The number of Sundays in October in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInNov -le 4) {
	$SingspirationNov = 0 # The number of Sundays in November in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInNov -ge 5) {
	$SingspirationNov = 1 # The number of Sundays in November in the future year is 5 or more so we'll have Singspiration this month.
	if ($Nov.Month -eq $EasterMonthFutureYear) {
		if ($YouCanHaveSingspirationThanksgivingMonth -eq 1) {
			$SingspirationNov = 1 # Have Singspiration this month. Thanksgiving is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationThanksgivingMonth -eq 0) {
			$SingspirationNov = 0 # Skip Singspiration this month. Thanksgiving is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInDec -le 4) {
	$SingspirationDec = 0 # The number of Sundays in December in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInDec -ge 5) {
	# $SingspirationDec = 1 # The number of Sundays in December in the future year is 5 or more so we'll have Singspiration this month.
	$SingspirationDec = 0 # Ok, we're currently going to skip Singspiration in December because we're normally spending time with our other families during Christmas & New Year's.
}

# You have now figured out if you can have Singspiration each month in the future year.

$NumberOfSingspirationsFutureYear = 0
if ($SingspirationJan -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationFeb -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationMar -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationApr -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationMay -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationJun -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationJul -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationAug -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationSep -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationOct -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationNov -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}
if ($SingspirationDec -eq 1) {$NumberOfSingspirationsFutureYear = $NumberOfSingspirationsFutureYear + 1}

Write-Host "There are $NumberOfSingspirationsFutureYear Singspirations in $FutureYear."


# The function below gets the last Sunday of every month next year; each one in its own variable.
# Get the current year and calculate the next year
# $currentYear = (Get-Date).Year
# $nextYear = $currentYear + 1

# Function to get the last Sunday of a given month and year
function Get-LastSunday {
    param (
        [int]$year,
        [int]$month
    )
    # Get the number of days in the month
    $daysInMonth = [DateTime]::DaysInMonth($year, $month)
    # Create a date object for the last day of the month
    $lastDay = [DateTime]::new($year, $month, $daysInMonth)
    # Find the last Sunday
    while ($lastDay.DayOfWeek -ne [DayOfWeek]::Sunday) {
        $lastDay = $lastDay.AddDays(-1)
    }
    return $lastDay
}

# Function to get the last Wednesday of a given month and year
function Get-LastWednesday {
    param (
        [int]$year,
        [int]$month
    )
    # Get the number of days in the month
    $daysInMonth = [DateTime]::DaysInMonth($year, $month)
    # Create a date object for the last day of the month
    $lastDay = [DateTime]::new($year, $month, $daysInMonth)
    # Find the last Sunday
    while ($lastDay.DayOfWeek -ne [DayOfWeek]::Wednesday) {
        $lastDay = $lastDay.AddDays(-1)
    }
    return $lastDay
}

# Store the last Sunday of each month in separate variables
$lastSundayJan = Get-LastSunday -year $FutureYear -month 1
$lastSundayFeb = Get-LastSunday -year $FutureYear -month 2
$lastSundayMar = Get-LastSunday -year $FutureYear -month 3
$lastSundayApr = Get-LastSunday -year $FutureYear -month 4
$lastSundayMay = Get-LastSunday -year $FutureYear -month 5
$lastSundayJun = Get-LastSunday -year $FutureYear -month 6
$lastSundayJul = Get-LastSunday -year $FutureYear -month 7
$lastSundayAug = Get-LastSunday -year $FutureYear -month 8
$lastSundaySep = Get-LastSunday -year $FutureYear -month 9
$lastSundayOct = Get-LastSunday -year $FutureYear -month 10
$lastSundayNov = Get-LastSunday -year $FutureYear -month 11
$lastSundayDec = Get-LastSunday -year $FutureYear -month 12

# Store the last Wednesday of each month in separate variables
$lastWednesdayJan = Get-LastWednesday -year $FutureYear -month 1
$lastWednesdayFeb = Get-LastWednesday -year $FutureYear -month 2
$lastWednesdayMar = Get-LastWednesday -year $FutureYear -month 3
$lastWednesdayApr = Get-LastWednesday -year $FutureYear -month 4
$lastWednesdayMay = Get-LastWednesday -year $FutureYear -month 5
$lastWednesdayJun = Get-LastWednesday -year $FutureYear -month 6
$lastWednesdayJul = Get-LastWednesday -year $FutureYear -month 7
$lastWednesdayAug = Get-LastWednesday -year $FutureYear -month 8
$lastWednesdaySep = Get-LastWednesday -year $FutureYear -month 9
$lastWednesdayOct = Get-LastWednesday -year $FutureYear -month 10
$lastWednesdayNov = Get-LastWednesday -year $FutureYear -month 11
$lastWednesdayDec = Get-LastWednesday -year $FutureYear -month 12

<#
# Output the results
Write-Output "The last Sunday of January $FutureYear is $($lastSundayJan.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of January $FutureYear is $($lastWednesdayJan.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of February $FutureYear is $($lastSundayFeb.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of February $FutureYear is $($lastWednesdayFeb.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of March $FutureYear is $($lastSundayMar.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of March $FutureYear is $($lastWednesdayMar.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of April $FutureYear is $($lastSundayApr.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of April $FutureYear is $($lastWednesdayApr.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of May $FutureYear is $($lastSundayMay.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of May $FutureYear is $($lastWednesdayMay.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of June $FutureYear is $($lastSundayJun.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of June $FutureYear is $($lastWednesdayJun.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of July $FutureYear is $($lastSundayJul.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of July $FutureYear is $($lastWednesdayJul.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of August $FutureYear is $($lastSundayAug.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of August $FutureYear is $($lastWednesdayAug.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of September $FutureYear is $($lastSundaySep.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of September $FutureYear is $($lastWednesdaySep.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of October $FutureYear is $($lastSundayOct.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of October $FutureYear is $($lastWednesdayOct.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of November $FutureYear is $($lastSundayNov.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of November $FutureYear is $($lastWednesdayNov.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of December $FutureYear is $($lastSundayDec.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of December $FutureYear is $($lastWednesdayDec.ToString('yyyy-MM-dd'))."
#>

$FutureJanuary = Get-Date -Year $FutureYear -Month 1 -UFormat %B

# Output to host if you're going to have Singspiration each month in the future year.

if ($SingspirationJan -eq 1) {Write-Host -ForegroundColor Green "$FutureJanuary $($lastSundayJan.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationJan -eq 0) {Write-Host -ForegroundColor DarkRed "$FutureJanuary $($lastSundayJan.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationFeb -eq 1) {Write-Host -ForegroundColor Green "February $($lastSundayFeb.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationFeb -eq 0) {Write-Host -ForegroundColor DarkRed "February $($lastSundayFeb.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationMar -eq 1) {Write-Host -ForegroundColor Green "March $($lastSundayMar.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationMar -eq 0) {Write-Host -ForegroundColor DarkRed "March $($lastSundayMar.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationApr -eq 1) {Write-Host -ForegroundColor Green "April $($lastSundayApr.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationApr -eq 0) {Write-Host -ForegroundColor DarkRed "April $($lastSundayApr.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationMay -eq 1) {Write-Host -ForegroundColor Green "May $($lastSundayMay.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationMay -eq 0) {Write-Host -ForegroundColor DarkRed "May $($lastSundayMay.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationJun -eq 1) {Write-Host -ForegroundColor Green "June $($lastSundayJun.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationJun -eq 0) {Write-Host -ForegroundColor DarkRed "June $($lastSundayJun.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationJul -eq 1) {Write-Host -ForegroundColor Green "July $($lastSundayJul.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationJul -eq 0) {Write-Host -ForegroundColor DarkRed "July $($lastSundayJul.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationAug -eq 1) {Write-Host -ForegroundColor Green "August $($lastSundayAug.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationAug -eq 0) {Write-Host -ForegroundColor DarkRed "August $($lastSundayAug.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationSep -eq 1) {Write-Host -ForegroundColor Green "September $($lastSundaySep.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationSep -eq 0) {Write-Host -ForegroundColor DarkRed "September $($lastSundaySep.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationOct -eq 1) {Write-Host -ForegroundColor Green "October $($lastSundayOct.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationOct -eq 0) {Write-Host -ForegroundColor DarkRed "October $($lastSundayOct.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationNov -eq 1) {Write-Host -ForegroundColor Green "November $($lastSundayNov.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationNov -eq 0) {Write-Host -ForegroundColor DarkRed "November $($lastSundayNov.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationDec -eq 1) {Write-Host -ForegroundColor Green "December $($lastSundayDec.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationDec -eq 0) {Write-Host -ForegroundColor DarkRed "December $($lastSundayDec.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}

# Then you'll have to work on a report for every Sunday morning, Sunday evening, & Wednesday evening so you know how many Sundays/Wednesdays are left to sign up for the next upcoming Singspiration; calculating in the lead time you need to coordinate everything.
# You may need to calculate the first Singspiration 2 years from now too so you can get the number of Sundays/Wednesdays left to sign up after the last one next year.

<#
Remember, you need approximately 2 weeks to comfortability process everything before Singspiration::
sa - can signup for current event
sp - can signup for next event
wp - can signup for next event
sa - can signup for next event
sp - can signup for next event
wp - can signup for next event
sa - can signup for next event
sp - event takes place
#>

if ($SingspirationJan -eq 1) {
	# See if you can do the subtraction math here for the nummber of services left to sign up for each Singspiration.
	# I'm guessing that it may be a complete report to just work backward to the beginning of the future year or the previous Singspiration in the future year being calculated.
	$lastSundayJan # This is the Singspiration date.
	$lastSundayJan.AddDays(-4) # Sunday PM event minus 4 days = Wednesday PM.
	# you are here
}










# Function to generate an array of all days in a given year
function Get-AllDaysInYear {
    param (
        [int]$Year
    )
    $startDate = Get-Date -Year $Year -Month 1 -Day 1
    $endDate = Get-Date -Year $Year -Month 12 -Day 31
    $allDays = @()

    while ($startDate -le $endDate) {
        $allDays += $startDate
        $startDate = $startDate.AddDays(1)
    }

    return $allDays
}

# Specify the year (e.g., next year)
#$year = (Get-Date).Year + 1

# Get all days of the specified year
$daysOfYear = Get-AllDaysInYear -Year $FutureYear

# Output the result
#Write-Output "All days in $FutureYear`:"
#$daysOfYear










# You added to the loops above to include the number of Wednesdays in each month so you may not need this function.
# The function below gets all Sundays and Wednesdays of each month next year; each one in its own variable.

# Get the current year and calculate the next year
$currentYear = (Get-Date).Year
$nextYear = $currentYear + 1

# Function to get all Sundays and Wednesdays of a given month and year
function Get-SundaysAndWednesdays {
    param (
        [int]$year,
        [int]$month
    )
    $daysInMonth = [DateTime]::DaysInMonth($year, $month)
    $sundays = @()
    $wednesdays = @()
    for ($day = 1; $day -le $daysInMonth; $day++) {
        $date = [DateTime]::new($year, $month, $day)
        if ($date.DayOfWeek -eq [DayOfWeek]::Sunday) {
            $sundays += $date
        }
        if ($date.DayOfWeek -eq [DayOfWeek]::Wednesday) {
            $wednesdays += $date
        }
    }
    return @{Sundays = $sundays; Wednesdays = $wednesdays}
}

# Store the Sundays and Wednesdays of each month in separate variables
$datesJan = Get-SundaysAndWednesdays -year $nextYear -month 1
$sundaysJan = $datesJan.Sundays
$wednesdaysJan = $datesJan.Wednesdays

$datesFeb = Get-SundaysAndWednesdays -year $nextYear -month 2
$sundaysFeb = $datesFeb.Sundays
$wednesdaysFeb = $datesFeb.Wednesdays

$datesMar = Get-SundaysAndWednesdays -year $nextYear -month 3
$sundaysMar = $datesMar.Sundays
$wednesdaysMar = $datesMar.Wednesdays

$datesApr = Get-SundaysAndWednesdays -year $nextYear -month 4
$sundaysApr = $datesApr.Sundays
$wednesdaysApr = $datesApr.Wednesdays

$datesMay = Get-SundaysAndWednesdays -year $nextYear -month 5
$sundaysMay = $datesMay.Sundays
$wednesdaysMay = $datesMay.Wednesdays

$datesJun = Get-SundaysAndWednesdays -year $nextYear -month 6
$sundaysJun = $datesJun.Sundays
$wednesdaysJun = $datesJun.Wednesdays

$datesJul = Get-SundaysAndWednesdays -year $nextYear -month 7
$sundaysJul = $datesJul.Sundays
$wednesdaysJul = $datesJul.Wednesdays

$datesAug = Get-SundaysAndWednesdays -year $nextYear -month 8
$sundaysAug = $datesAug.Sundays
$wednesdaysAug = $datesAug.Wednesdays

$datesSep = Get-SundaysAndWednesdays -year $nextYear -month 9
$sundaysSep = $datesSep.Sundays
$wednesdaysSep = $datesSep.Wednesdays

$datesOct = Get-SundaysAndWednesdays -year $nextYear -month 10
$sundaysOct = $datesOct.Sundays
$wednesdaysOct = $datesOct.Wednesdays

$datesNov = Get-SundaysAndWednesdays -year $nextYear -month 11
$sundaysNov = $datesNov.Sundays
$wednesdaysNov = $datesNov.Wednesdays

$datesDec = Get-SundaysAndWednesdays -year $nextYear -month 12
$sundaysDec = $datesDec.Sundays
$wednesdaysDec = $datesDec.Wednesdays

<#
# Output the results
Write-Output "Sundays in January ${nextYear}: $($sundaysJan -join ', ')"
Write-Output "Wednesdays in January ${nextYear}: $($wednesdaysJan -join ', ')"
Write-Output "Sundays in February ${nextYear}: $($sundaysFeb -join ', ')"
Write-Output "Wednesdays in February ${nextYear}: $($wednesdaysFeb -join ', ')"
Write-Output "Sundays in March ${nextYear}: $($sundaysMar -join ', ')"
Write-Output "Wednesdays in March ${nextYear}: $($wednesdaysMar -join ', ')"
Write-Output "Sundays in April ${nextYear}: $($sundaysApr -join ', ')"
Write-Output "Wednesdays in April ${nextYear}: $($wednesdaysApr -join ', ')"
Write-Output "Sundays in May ${nextYear}: $($sundaysMay -join ', ')"
Write-Output "Wednesdays in May ${nextYear}: $($wednesdaysMay -join ', ')"
Write-Output "Sundays in June ${nextYear}: $($sundaysJun -join ', ')"
Write-Output "Wednesdays in June ${nextYear}: $($wednesdaysJun -join ', ')"
Write-Output "Sundays in July ${nextYear}: $($sundaysJul -join ', ')"
Write-Output "Wednesdays in July ${nextYear}: $($wednesdaysJul -join ', ')"
Write-Output "Sundays in August ${nextYear}: $($sundaysAug -join ', ')"
Write-Output "Wednesdays in August ${nextYear}: $($wednesdaysAug -join ', ')"
Write-Output "Sundays in September ${nextYear}: $($sundaysSep -join ', ')"
Write-Output "Wednesdays in September ${nextYear}: $($wednesdaysSep -join ', ')"
Write-Output "Sundays in October ${nextYear}: $($sundaysOct -join ', ')"
Write-Output "Wednesdays in October ${nextYear}: $($wednesdaysOct -join ', ')"
Write-Output "Sundays in November ${nextYear}: $($sundaysNov -join ', ')"
Write-Output "Wednesdays in November ${nextYear}: $($wednesdaysNov -join ', ')"
Write-Output "Sundays in December ${nextYear}: $($sundaysDec -join ', ')"
Write-Output "Wednesdays in December ${nextYear}: $($wednesdaysDec -join ', ')"
#>








