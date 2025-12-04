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

Need to incorporate "PreviousYear" & "YearAfter" into loops for reporting.

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
$PreviousYear = $FutureYear - 1 # This is the year before the year you are calculating.
$YearAfter = $FutureYear + 1 # This is the year after the year you are calculating.
# $EasterDateFutureYear = Get-DateOfEaster ((Get-Date).year+1)
$EasterDateFutureYear = Get-DateOfEaster $FutureYear
$EasterDatePreviousYear = Get-DateOfEaster $PreviousYear
$EasterDateYearAfter = Get-DateOfEaster $YearAfter

$EasterYearFutureYear = $EasterDateFutureYear[0].Substring(0,4)
$EasterMonthFutureYear = $EasterDateFutureYear[0].Substring(5,2)
$EasterDayFutureYear = $EasterDateFutureYear[0].Substring(8,2)
$EasterNumberOfDaysInMonthFutureYear = [DateTime]::DaysInMonth($EasterYearFutureYear, $EasterMonthFutureYear)
$EasterMonthNumberOfSundaysCountFutureYear = 0

$EasterYearPreviousYear = $EasterDatePreviousYear[0].Substring(0,4)
$EasterMonthPreviousYear = $EasterDatePreviousYear[0].Substring(5,2)
$EasterDayPreviousYear = $EasterDatePreviousYear[0].Substring(8,2)
$EasterNumberOfDaysInMonthPreviousYear = [DateTime]::DaysInMonth($EasterYearPreviousYear, $EasterMonthPreviousYear)
$EasterMonthNumberOfSundaysCountPreviousYear = 0

$EasterYearYearAfter = $EasterDateYearAfter[0].Substring(0,4)
$EasterMonthYearAfter = $EasterDateYearAfter[0].Substring(5,2)
$EasterDayYearAfter = $EasterDateYearAfter[0].Substring(8,2)
$EasterNumberOfDaysInMonthYearAfter = [DateTime]::DaysInMonth($EasterYearYearAfter, $EasterMonthYearAfter)
$EasterMonthNumberOfSundaysCountYearAfter = 0

# Loop through each day of the month - figuring out the number of Sundays in the month of Easter for Future Year:
for ($day = 1; $day -le $EasterNumberOfDaysInMonthFutureYear; $day++) {
    # Create a date object for the current day
    $currentDate = [DateTime]::new($EasterYearFutureYear, $EasterMonthFutureYear, $day)
    # Check if the day is a Sunday
    if ($currentDate.DayOfWeek -eq "Sunday") {
        # Increment the Sunday counter
        $EasterMonthNumberOfSundaysCountFutureYear++
    }
}

# Loop through each day of the month - figuring out the number of Sundays in the month of Easter for Previous Year:
for ($day = 1; $day -le $EasterNumberOfDaysInMonthPreviousYear; $day++) {
    # Create a date object for the current day
    $currentDate = [DateTime]::new($EasterYearPreviousYear, $EasterMonthPreviousYear, $day)
    # Check if the day is a Sunday
    if ($currentDate.DayOfWeek -eq "Sunday") {
        # Increment the Sunday counter
        $EasterMonthNumberOfSundaysCountPreviousYear++
    }
}

# Loop through each day of the month - figuring out the number of Sundays in the month of Easter for the Year After:
for ($day = 1; $day -le $EasterNumberOfDaysInMonthYearAfter; $day++) {
    # Create a date object for the current day
    $currentDate = [DateTime]::new($EasterYearYearAfter, $EasterMonthYearAfter, $day)
    # Check if the day is a Sunday
    if ($currentDate.DayOfWeek -eq "Sunday") {
        # Increment the Sunday counter
        $EasterMonthNumberOfSundaysCountYearAfter++
    }
}

# Output the number of Sundays - Future Year:
# Write-Output "Number of Sundays in this month: $EasterMonthNumberOfSundaysCountFutureYear"
if ($EasterMonthNumberOfSundaysCountFutureYear -le 4) {
	$EasterMonthSkipSingspiration = 1 # The number of Sundays in Easter month in the Future Year is 4 or less so we won't have a Singspiration this month.
}
if ($EasterMonthNumberOfSundaysCountFutureYear -ge 5) {
	$EasterMonthSkipSingspiration = 0 # The number of Sundays in Easter month in the Future Year is 5 or more so we'll have to skip a Singspiration this month if Easter also takes place this same Sunday.
}

# Output the number of Sundays - Previous Year:
# Write-Output "Number of Sundays in this month: $EasterMonthNumberOfSundaysCountPreviousYear"
if ($EasterMonthNumberOfSundaysCountPreviousYear -le 4) {
	$EasterMonthSkipSingspirationPreviousYear = 1 # The number of Sundays in Easter month in the Previous Year is 4 or less so we won't have a Singspiration this month.
}
if ($EasterMonthNumberOfSundaysCountPreviousYear -ge 5) {
	$EasterMonthSkipSingspirationPreviousYear = 0 # The number of Sundays in Easter month in the Previous Year is 5 or more so we'll have to skip a Singspiration this month if Easter also takes place this same Sunday.
}

# Output the number of Sundays - Year After:
# Write-Output "Number of Sundays in this month: $EasterMonthNumberOfSundaysCountYearAfter"
if ($EasterMonthNumberOfSundaysCountYearAfter -le 4) {
	$EasterMonthSkipSingspirationYearAfter = 1 # The number of Sundays in Easter month in the Year After is 4 or less so we won't have a Singspiration this month.
}
if ($EasterMonthNumberOfSundaysCountYearAfter -ge 5) {
	$EasterMonthSkipSingspirationYearAfter = 0 # The number of Sundays in Easter month in the Year After is 5 or more so we'll have to skip a Singspiration this month if Easter also takes place this same Sunday.
}

# Calculate the last Sunday of the month for the month of Easter in the future year::
$lastDay = New-Object -TypeName DateTime -ArgumentList $EasterYearFutureYear, $EasterMonthFutureYear, $EasterNumberOfDaysInMonthFutureYear
# Find the last Sunday
while ($lastDay.DayOfWeek -ne [DayOfWeek]::Sunday) {
	$lastDay = $lastDay.AddDays(-1)
}
# Write-Host "The last Sunday of $($EasterMonthFutureYear)/$EasterYearFutureYear is on day number $($lastDay.Day), which is $($lastDay.ToString('dddd, MMMM dd, yyyy'))."
$EasterFutureYearLastSundayInMonth = $($lastDay.Day)

# Calculate the last Sunday of the month for the month of Easter in the Previous Year::
$lastDay = New-Object -TypeName DateTime -ArgumentList $EasterYearPreviousYear, $EasterMonthPreviousYear, $EasterNumberOfDaysInMonthPreviousYear
# Find the last Sunday
while ($lastDay.DayOfWeek -ne [DayOfWeek]::Sunday) {
	$lastDay = $lastDay.AddDays(-1)
}
# Write-Host "The last Sunday of $($EasterMonthPreviousYear)/$EasterYearPreviousYear is on day number $($lastDay.Day), which is $($lastDay.ToString('dddd, MMMM dd, yyyy'))."
$EasterPreviousYearLastSundayInMonth = $($lastDay.Day)

# Calculate the last Sunday of the month for the month of Easter in the Year After::
$lastDay = New-Object -TypeName DateTime -ArgumentList $EasterYearYearAfter, $EasterMonthYearAfter, $EasterNumberOfDaysInMonthYearAfter
# Find the last Sunday
while ($lastDay.DayOfWeek -ne [DayOfWeek]::Sunday) {
	$lastDay = $lastDay.AddDays(-1)
}
# Write-Host "The last Sunday of $($EasterMonthYearAfter)/$EasterYearYearAfter is on day number $($lastDay.Day), which is $($lastDay.ToString('dddd, MMMM dd, yyyy'))."
$EasterYearAfterLastSundayInMonth = $($lastDay.Day)

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

# Compare $EasterPreviousYearLastSundayInMonth to $EasterDayPreviousYear.
# If they're the same then skip Singspiration that month.
# If they're different then you can have Singspiration that month.
if ($EasterDayPreviousYear -eq $EasterPreviousYearLastSundayInMonth) {
	$SkipEasterSingspirationPreviousYear = 1 # Skip Singspiration this month because Easter takes place on the same Sunday.
}
if ($EasterDayPreviousYear -ne $EasterPreviousYearLastSundayInMonth) {
	$SkipEasterSingspirationPreviousYear = 0 # Have Singspiration this month because Easter takes place on a different Sunday.
	# If $EasterMonthSkipSingspirationPreviousYear = 0
}

# Compare $EasterYearAfterLastSundayInMonth to $EasterDayYearAfter.
# If they're the same then skip Singspiration that month.
# If they're different then you can have Singspiration that month.
if ($EasterDayYearAfter -eq $EasterYearAfterLastSundayInMonth) {
	$SkipEasterSingspirationYearAfter = 1 # Skip Singspiration this month because Easter takes place on the same Sunday.
}
if ($EasterDayYearAfter -ne $EasterYearAfterLastSundayInMonth) {
	$SkipEasterSingspirationYearAfter = 0 # Have Singspiration this month because Easter takes place on a different Sunday.
	# If $EasterMonthSkipSingspirationYearAfter = 0
}

if ($SkipEasterSingspiration -ne $EasterMonthSkipSingspiration) {
	$YouCanHaveSingspirationEasterMonth = 0 # Skip Singspiration this month. Either because Easter month has 4 or less Sundays and/or Easter takes place on the last Sunday of the month.
}

if ($SkipEasterSingspiration -eq $EasterMonthSkipSingspiration) {
	$YouCanHaveSingspirationEasterMonth = 1 # Have Singspiration this month. Easter month has 5 or more Sundays and Easter doesn't take place on the last Sunday of the month.
}
# You have now figured out if you can have Singspiration Easter month.
# Easter can only be in March or April so you can remove the Easter-related code from the other months. Done.

if ($SkipEasterSingspirationPreviousYear -ne $EasterMonthSkipSingspirationPreviousYear) {
	$YouCanHaveSingspirationEasterMonthPreviousYear = 0 # Skip Singspiration this month. Either because Easter month has 4 or less Sundays and/or Easter takes place on the last Sunday of the month.
}

if ($SkipEasterSingspirationPreviousYear -eq $EasterMonthSkipSingspirationPreviousYear) {
	$YouCanHaveSingspirationEasterMonthPreviousYear = 1 # Have Singspiration this month. Easter month has 5 or more Sundays and Easter doesn't take place on the last Sunday of the month.
}
# You have now figured out if you can have Singspiration Easter month.
# Easter can only be in March or April so you can remove the Easter-related code from the other months. Done.

if ($SkipEasterSingspirationYearAfter -ne $EasterMonthSkipSingspirationYearAfter) {
	$YouCanHaveSingspirationEasterMonthYearAfter = 0 # Skip Singspiration this month. Either because Easter month has 4 or less Sundays and/or Easter takes place on the last Sunday of the month.
}

if ($SkipEasterSingspirationYearAfter -eq $EasterMonthSkipSingspirationYearAfter) {
	$YouCanHaveSingspirationEasterMonthYearAfter = 1 # Have Singspiration this month. Easter month has 5 or more Sundays and Easter doesn't take place on the last Sunday of the month.
}
# You have now figured out if you can have Singspiration Easter month.
# Easter can only be in March or April so you can remove the Easter-related code from the other months. Done.

# Can you have Singspiration around Thanksgiving in the future year?::

# Get the number of days in November in the future year
$novemberDays = [DateTime]::DaysInMonth($FutureYear, 11)

# Get the number of days in November in the Previous Year
$novemberDaysPreviousYear = [DateTime]::DaysInMonth($PreviousYear, 11)

# Get the number of days in November in the Year After
$novemberDaysYearAfter = [DateTime]::DaysInMonth($YearAfter, 11)

# Find the date of Thanksgiving (last Thursday of November)
$thanksgivingDate = [DateTime]::new($FutureYear, 11, 1)
while ($thanksgivingDate.DayOfWeek -ne [DayOfWeek]::Thursday) {
    $thanksgivingDate = $thanksgivingDate.AddDays(1)
}
$thanksgivingDate = $thanksgivingDate.AddDays(21) # Move to the last Thursday. You can always add 21 days to the first Thursday in November to get the last Thursday in November which is always Thanksgiving day.

# Find the date of Thanksgiving (last Thursday of November)
$thanksgivingDatePreviousYear = [DateTime]::new($PreviousYear, 11, 1)
while ($thanksgivingDatePreviousYear.DayOfWeek -ne [DayOfWeek]::Thursday) {
    $thanksgivingDatePreviousYear = $thanksgivingDatePreviousYear.AddDays(1)
}
$thanksgivingDatePreviousYear = $thanksgivingDatePreviousYear.AddDays(21) # Move to the last Thursday. You can always add 21 days to the first Thursday in November to get the last Thursday in November which is always Thanksgiving day.

# Find the date of Thanksgiving (last Thursday of November)
$thanksgivingDateYearAfter = [DateTime]::new($YearAfter, 11, 1)
while ($thanksgivingDateYearAfter.DayOfWeek -ne [DayOfWeek]::Thursday) {
    $thanksgivingDateYearAfter = $thanksgivingDateYearAfter.AddDays(1)
}
$thanksgivingDateYearAfter = $thanksgivingDateYearAfter.AddDays(21) # Move to the last Thursday. You can always add 21 days to the first Thursday in November to get the last Thursday in November which is always Thanksgiving day.

# Loop through each day after Thanksgiving in November in the future year to find if there is a Sunday after Thanksgiving
$sundayAfterThanksgiving = $false
for ($day = $thanksgivingDate.Day + 1; $day -le $novemberDays; $day++) {
    $date = [DateTime]::new($FutureYear, 11, $day)
    if ($date.DayOfWeek -eq [DayOfWeek]::Sunday) {
        $sundayAfterThanksgiving = $true
        break
    }
}

# Loop through each day after Thanksgiving in November in the Previous Year to find if there is a Sunday after Thanksgiving
$sundayAfterThanksgivingPreviousYear = $false
for ($day = $thanksgivingDatePreviousYear.Day + 1; $day -le $novemberDaysPreviousYear; $day++) {
    $date = [DateTime]::new($PreviousYear, 11, $day)
    if ($date.DayOfWeek -eq [DayOfWeek]::Sunday) {
        $sundayAfterThanksgivingPreviousYear = $true
        break
    }
}

# Loop through each day after Thanksgiving in November in the Year After to find if there is a Sunday after Thanksgiving
$sundayAfterThanksgivingYearAfter = $false
for ($day = $thanksgivingDateYearAfter.Day + 1; $day -le $novemberDaysYearAfter; $day++) {
    $date = [DateTime]::new($YearAfter, 11, $day)
    if ($date.DayOfWeek -eq [DayOfWeek]::Sunday) {
        $sundayAfterThanksgivingYearAfter = $true
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

# Output the result. Is there a Sunday after Thanksgiving in November in the Previous Year?
if ($sundayAfterThanksgivingPreviousYear) {
    # Write-Output "There is a Sunday after Thanksgiving in November $PreviousYear so you can have Singspiration."
	$YouCanHaveSingspirationThanksgivingMonthPreviousYear = 1 # There is a Sunday after Thanksgiving in November in the Previous Year so you can have Singspiration if there are 5 Sundays in the month.
} else {
    # Write-Output "There is no Sunday after Thanksgiving in November $PreviousYear so skip Singspiration."
	$YouCanHaveSingspirationThanksgivingMonthPreviousYear = 0 # There is no Sunday after Thanksgiving in November in the Previous Year so skip Singspiration.
}
# You have now figured out if there is a Sunday after Thanksgiving in November in the Previous Year.
# You need to add this Thanksgiving logic below similar to Easter.

# Output the result. Is there a Sunday after Thanksgiving in November in the Year After?
if ($sundayAfterThanksgivingYearAfter) {
    # Write-Output "There is a Sunday after Thanksgiving in November $YearAfter so you can have Singspiration."
	$YouCanHaveSingspirationThanksgivingMonthYearAfter = 1 # There is a Sunday after Thanksgiving in November in the Year After so you can have Singspiration if there are 5 Sundays in the month.
} else {
    # Write-Output "There is no Sunday after Thanksgiving in November $YearAfter so skip Singspiration."
	$YouCanHaveSingspirationThanksgivingMonthYearAfter = 0 # There is no Sunday after Thanksgiving in November in the Year After so skip Singspiration.
}
# You have now figured out if there is a Sunday after Thanksgiving in November in the Year After.
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

# $StartDatePreviousYear = Get-Date -Year $PreviousYear -Month 01 -Day 01 # This gets the first day of the Previous Year.
# $EndDatePreviousYear = Get-Date -Year $PreviousYear -Month 12 -Day 31 # This gets the last day of the Previous Year.
$JanPreviousYear = Get-Date -Year $PreviousYear -Month 1 # This gets January of the Previous Year.
$FebPreviousYear = Get-Date -Year $PreviousYear -Month 2 # This gets February of the Previous Year.
$MarPreviousYear = Get-Date -Year $PreviousYear -Month 3 # This gets March of the Previous Year.
$AprPreviousYear = Get-Date -Year $PreviousYear -Month 4 # This gets April of the Previous Year.
$MayPreviousYear = Get-Date -Year $PreviousYear -Month 5 # This gets May of the Previous Year.
$JunPreviousYear = Get-Date -Year $PreviousYear -Month 6 # This gets June of the Previous Year.
$JulPreviousYear = Get-Date -Year $PreviousYear -Month 7 # This gets July of the Previous Year.
$AugPreviousYear = Get-Date -Year $PreviousYear -Month 8 # This gets August of the Previous Year.
$SepPreviousYear = Get-Date -Year $PreviousYear -Month 9 # This gets September of the Previous Year.
$OctPreviousYear = Get-Date -Year $PreviousYear -Month 10 # This gets October of the Previous Year.
$NovPreviousYear = Get-Date -Year $PreviousYear -Month 11 # This gets November of the Previous Year.
$DecPreviousYear = Get-Date -Year $PreviousYear -Month 12 # This gets December of the Previous Year.
$NumberOfDaysInJanPreviousYear = [DateTime]::DaysInMonth($JanPreviousYear.Year, $JanPreviousYear.Month)
$NumberOfDaysInFebPreviousYear = [DateTime]::DaysInMonth($FebPreviousYear.Year, $FebPreviousYear.Month)
$NumberOfDaysInMarPreviousYear = [DateTime]::DaysInMonth($MarPreviousYear.Year, $MarPreviousYear.Month)
$NumberOfDaysInAprPreviousYear = [DateTime]::DaysInMonth($AprPreviousYear.Year, $AprPreviousYear.Month)
$NumberOfDaysInMayPreviousYear = [DateTime]::DaysInMonth($MayPreviousYear.Year, $MayPreviousYear.Month)
$NumberOfDaysInJunPreviousYear = [DateTime]::DaysInMonth($JunPreviousYear.Year, $JunPreviousYear.Month)
$NumberOfDaysInJulPreviousYear = [DateTime]::DaysInMonth($JulPreviousYear.Year, $JulPreviousYear.Month)
$NumberOfDaysInAugPreviousYear = [DateTime]::DaysInMonth($AugPreviousYear.Year, $AugPreviousYear.Month)
$NumberOfDaysInSepPreviousYear = [DateTime]::DaysInMonth($SepPreviousYear.Year, $SepPreviousYear.Month)
$NumberOfDaysInOctPreviousYear = [DateTime]::DaysInMonth($OctPreviousYear.Year, $OctPreviousYear.Month)
$NumberOfDaysInNovPreviousYear = [DateTime]::DaysInMonth($NovPreviousYear.Year, $NovPreviousYear.Month)
$NumberOfDaysInDecPreviousYear = [DateTime]::DaysInMonth($DecPreviousYear.Year, $DecPreviousYear.Month)
$NumberOfSundaysInPreviousYear = 0
$NumberOfSundaysInJanPreviousYear = 0
$NumberOfSundaysInFebPreviousYear = 0
$NumberOfSundaysInMarPreviousYear = 0
$NumberOfSundaysInAprPreviousYear = 0
$NumberOfSundaysInMayPreviousYear = 0
$NumberOfSundaysInJunPreviousYear = 0
$NumberOfSundaysInJulPreviousYear = 0
$NumberOfSundaysInAugPreviousYear = 0
$NumberOfSundaysInSepPreviousYear = 0
$NumberOfSundaysInOctPreviousYear = 0
$NumberOfSundaysInNovPreviousYear = 0
$NumberOfSundaysInDecPreviousYear = 0
$NumberOfWednesdaysInJanPreviousYear = 0
$NumberOfWednesdaysInFebPreviousYear = 0
$NumberOfWednesdaysInMarPreviousYear = 0
$NumberOfWednesdaysInAprPreviousYear = 0
$NumberOfWednesdaysInMayPreviousYear = 0
$NumberOfWednesdaysInJunPreviousYear = 0
$NumberOfWednesdaysInJulPreviousYear = 0
$NumberOfWednesdaysInAugPreviousYear = 0
$NumberOfWednesdaysInSepPreviousYear = 0
$NumberOfWednesdaysInOctPreviousYear = 0
$NumberOfWednesdaysInNovPreviousYear = 0
$NumberOfWednesdaysInDecPreviousYear = 0

# $StartDate = Get-Date -Year $YearAfter -Month 01 -Day 01 # This gets the first day of the Year After.
# $EndDate = Get-Date -Year $YearAfter -Month 12 -Day 31 # This gets the last day of the Year After.
$JanYearAfter = Get-Date -Year $YearAfter -Month 1 # This gets January of the Year After.
$FebYearAfter = Get-Date -Year $YearAfter -Month 2 # This gets February of the Year After.
$MarYearAfter = Get-Date -Year $YearAfter -Month 3 # This gets March of the Year After.
$AprYearAfter = Get-Date -Year $YearAfter -Month 4 # This gets April of the Year After.
$MayYearAfter = Get-Date -Year $YearAfter -Month 5 # This gets May of the Year After.
$JunYearAfter = Get-Date -Year $YearAfter -Month 6 # This gets June of the Year After.
$JulYearAfter = Get-Date -Year $YearAfter -Month 7 # This gets July of the Year After.
$AugYearAfter = Get-Date -Year $YearAfter -Month 8 # This gets August of the Year After.
$SepYearAfter = Get-Date -Year $YearAfter -Month 9 # This gets September of the Year After.
$OctYearAfter = Get-Date -Year $YearAfter -Month 10 # This gets October of the Year After.
$NovYearAfter = Get-Date -Year $YearAfter -Month 11 # This gets November of the Year After.
$DecYearAfter = Get-Date -Year $YearAfter -Month 12 # This gets December of the Year After.
$NumberOfDaysInJanYearAfter = [DateTime]::DaysInMonth($JanYearAfter.Year, $JanYearAfter.Month)
$NumberOfDaysInFebYearAfter = [DateTime]::DaysInMonth($FebYearAfter.Year, $FebYearAfter.Month)
$NumberOfDaysInMarYearAfter = [DateTime]::DaysInMonth($MarYearAfter.Year, $MarYearAfter.Month)
$NumberOfDaysInAprYearAfter = [DateTime]::DaysInMonth($AprYearAfter.Year, $AprYearAfter.Month)
$NumberOfDaysInMayYearAfter = [DateTime]::DaysInMonth($MayYearAfter.Year, $MayYearAfter.Month)
$NumberOfDaysInJunYearAfter = [DateTime]::DaysInMonth($JunYearAfter.Year, $JunYearAfter.Month)
$NumberOfDaysInJulYearAfter = [DateTime]::DaysInMonth($JulYearAfter.Year, $JulYearAfter.Month)
$NumberOfDaysInAugYearAfter = [DateTime]::DaysInMonth($AugYearAfter.Year, $AugYearAfter.Month)
$NumberOfDaysInSepYearAfter = [DateTime]::DaysInMonth($SepYearAfter.Year, $SepYearAfter.Month)
$NumberOfDaysInOctYearAfter = [DateTime]::DaysInMonth($OctYearAfter.Year, $OctYearAfter.Month)
$NumberOfDaysInNovYearAfter = [DateTime]::DaysInMonth($NovYearAfter.Year, $NovYearAfter.Month)
$NumberOfDaysInDecYearAfter = [DateTime]::DaysInMonth($DecYearAfter.Year, $DecYearAfter.Month)
$NumberOfSundaysInYearAfter = 0
$NumberOfSundaysInJanYearAfter = 0
$NumberOfSundaysInFebYearAfter = 0
$NumberOfSundaysInMarYearAfter = 0
$NumberOfSundaysInAprYearAfter = 0
$NumberOfSundaysInMayYearAfter = 0
$NumberOfSundaysInJunYearAfter = 0
$NumberOfSundaysInJulYearAfter = 0
$NumberOfSundaysInAugYearAfter = 0
$NumberOfSundaysInSepYearAfter = 0
$NumberOfSundaysInOctYearAfter = 0
$NumberOfSundaysInNovYearAfter = 0
$NumberOfSundaysInDecYearAfter = 0
$NumberOfWednesdaysInJanYearAfter = 0
$NumberOfWednesdaysInFebYearAfter = 0
$NumberOfWednesdaysInMarYearAfter = 0
$NumberOfWednesdaysInAprYearAfter = 0
$NumberOfWednesdaysInMayYearAfter = 0
$NumberOfWednesdaysInJunYearAfter = 0
$NumberOfWednesdaysInJulYearAfter = 0
$NumberOfWednesdaysInAugYearAfter = 0
$NumberOfWednesdaysInSepYearAfter = 0
$NumberOfWednesdaysInOctYearAfter = 0
$NumberOfWednesdaysInNovYearAfter = 0
$NumberOfWednesdaysInDecYearAfter = 0

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

# Loop through each day of the month in January in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInJanPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($JanPreviousYear.Year, $JanPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJanPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	# Check if the day is a Wednesday
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInJanPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in January Previous Year: $NumberOfSundaysInJanPreviousYear"

# Loop through each day of the month in January in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInJanYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($JanYearAfter.Year, $JanYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJanYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	# Check if the day is a Wednesday
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInJanYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in January Year After: $NumberOfSundaysInJanYearAfter"

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

# Loop through each day of the month in February in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInFebPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($FebPreviousYear.Year, $FebPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInFebPreviousYear++
		$NumberOfSundaysInFutureYearPreviousYear++
	}
	# Check if the day is a Wednesday
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInFebPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in February Previous Year: $NumberOfSundaysInFebPreviousYear"

# Loop through each day of the month in February in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInFebYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($FebYearAfter.Year, $FebYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInFebYearAfter++
		$NumberOfSundaysInFutureYearYearAfter++
	}
	# Check if the day is a Wednesday
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInFebYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in February Year After: $NumberOfSundaysInFebYearAfter"

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

# Loop through each day of the month in March in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInMarPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($MarPreviousYear.Year, $MarPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInMarPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInMarPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in March Previous Year: $NumberOfSundaysInMarPreviousYear"

# Loop through each day of the month in March in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInMarYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($MarYearAfter.Year, $MarYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInMarYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInMarYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in March Year After: $NumberOfSundaysInMarYearAfter"

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

# Loop through each day of the month in April in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInAprPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($AprPreviousYear.Year, $AprPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInAprPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInAprPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in April Previous Year: $NumberOfSundaysInAprPreviousYear"

# Loop through each day of the month in April in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInAprYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($AprYearAfter.Year, $AprYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInAprYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInAprYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in April Year After: $NumberOfSundaysInAprYearAfter"

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

# Loop through each day of the month in May in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInMayPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($MayPreviousYear.Year, $MayPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInMayPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInMayPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in May Previous Year: $NumberOfSundaysInMayPreviousYear"

# Loop through each day of the month in May in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInMayYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($MayYearAfter.Year, $MayYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInMayYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInMayYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in May Year After: $NumberOfSundaysInMayYearAfter"

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

# Loop through each day of the month in June in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInJunPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($JunPreviousYear.Year, $JunPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJunPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInJunPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in June Previous Year: $NumberOfSundaysInJunPreviousYear"

# Loop through each day of the month in June in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInJunYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($JunYearAfter.Year, $JunYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJunYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInJunYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in June Year After: $NumberOfSundaysInJunYearAfter"

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

# Loop through each day of the month in July in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInJulPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($JulPreviousYear.Year, $JulPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJulPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInJulPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in July Previous Year: $NumberOfSundaysInJulPreviousYear"

# Loop through each day of the month in July in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInJulYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($JulYearAfter.Year, $JulYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInJulYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInJulYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in July Year After: $NumberOfSundaysInJulYearAfter"

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

# Loop through each day of the month in August in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInAugPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($AugPreviousYear.Year, $AugPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInAugPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInAugPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in August Previous Year: $NumberOfSundaysInAugPreviousYear"

# Loop through each day of the month in August in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInAugYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($AugYearAfter.Year, $AugYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInAugYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInAugYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in August Year After: $NumberOfSundaysInAugYearAfter"

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

# Loop through each day of the month in September in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInSepPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($SepPreviousYear.Year, $SepPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInSepPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInSepPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in September Previous Year: $NumberOfSundaysInSepPreviousYear"

# Loop through each day of the month in September in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInSepYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($SepYearAfter.Year, $SepYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInSepYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInSepYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in September Year After: $NumberOfSundaysInSepYearAfter"

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

# Loop through each day of the month in October in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInOctPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($OctPreviousYear.Year, $OctPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInOctPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInOctPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in October Previous Year: $NumberOfSundaysInOctPreviousYear"

# Loop through each day of the month in October in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInOctYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($OctYearAfter.Year, $OctYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInOctYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInOctYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in October Year After: $NumberOfSundaysInOctYearAfter"

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

# Loop through each day of the month in November in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInNovPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($NovPreviousYear.Year, $NovPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInNovPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInNovPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in November Previous Year: $NumberOfSundaysInNovPreviousYear"

# Loop through each day of the month in November in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInNovYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($NovYearAfter.Year, $NovYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInNovYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInNovYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in November Year After: $NumberOfSundaysInNovYearAfter"

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

# Loop through each day of the month in December in the Previous Year & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInDecPreviousYear; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($DecPreviousYear.Year, $DecPreviousYear.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInDecPreviousYear++
		$NumberOfSundaysInPreviousYear++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInDecPreviousYear++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in December Previous Year: $NumberOfSundaysInDecPreviousYear"

# Loop through each day of the month in December in the Year After & count the number of Sundays & Wednesdays.
for ($day = 1; $day -le $NumberOfDaysInDecYearAfter; $day++) {
	# Create a date object for the current day
	$currentDate = [DateTime]::new($DecYearAfter.Year, $DecYearAfter.Month, $day)
	# Check if the day is a Sunday
	if ($currentDate.DayOfWeek -eq "Sunday") {
		# Increment the Sunday counter
		$NumberOfSundaysInDecYearAfter++
		$NumberOfSundaysInYearAfter++
	}
	if ($currentDate.DayOfWeek -eq "Wednesday") {
		# Increment the Sunday counter
		$NumberOfWednesdaysInDecYearAfter++
	}
}
# Output the number of Sundays:
# Write-Output "Number of Sundays in December Year After: $NumberOfSundaysInDecYearAfter"

# You have now counted the number of Sundays & Wednesdays in each month in the future year.
# You have now counted the number of Sundays & Wednesdays in each month in the Previous Year.
# You have now counted the number of Sundays & Wednesdays in each month in the Year After.

# See if each month has 4 or less Sundays or 5 or more Sundays to determine if you can have Singspiration that month.
# Remember Easter month (only March or April). $Jan.Month = $EasterMonthFutureYear & $YouCanHaveSingspirationEasterMonth = 1
# Remember Easter month (only March or April). $Jan.Month = $EasterMonthPreviousYear & $YouCanHaveSingspirationEasterMonthPreviousYear = 1
# Remember Easter month (only March or April). $Jan.Month = $EasterMonthYearAfter & $YouCanHaveSingspirationEasterMonthYearAfter = 1

if ($NumberOfSundaysInJan -le 4) {
	$SingspirationJan = 0 # The number of Sundays in January in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJan -ge 5) {
	$SingspirationJan = 1 # The number of Sundays in January in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJanPreviousYear -le 4) {
	$SingspirationJanPreviousYear = 0 # The number of Sundays in January in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJanPreviousYear -ge 5) {
	$SingspirationJanPreviousYear = 1 # The number of Sundays in January in the Previous Year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJanYearAfter -le 4) {
	$SingspirationJanYearAfter = 0 # The number of Sundays in January in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJanYearAfter -ge 5) {
	$SingspirationJanYearAfter = 1 # The number of Sundays in January in the Year After is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInFeb -le 4) {
	$SingspirationFeb = 0 # The number of Sundays in February in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInFeb -ge 5) {
	$SingspirationFeb = 1 # The number of Sundays in February in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInFebPreviousYear -le 4) {
	$SingspirationFebPreviousYear = 0 # The number of Sundays in February in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInFebPreviousYear -ge 5) {
	$SingspirationFebPreviousYear = 1 # The number of Sundays in February in the Previous Year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInFebYearAfter -le 4) {
	$SingspirationFebYearAfter = 0 # The number of Sundays in February in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInFebYearAfter -ge 5) {
	$SingspirationFebYearAfter = 1 # The number of Sundays in February in the Year After is 5 or more so we'll have Singspiration this month.
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

if ($NumberOfSundaysInMarPreviousYear -le 4) {
	$SingspirationMarPreviousYear = 0 # The number of Sundays in March in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInMarPreviousYear -ge 5) {
	$SingspirationMarPreviousYear = 1 # The number of Sundays in March in the Previous Year is 5 or more so we'll have Singspiration this month.
	if ($MarPreviousYear.Month -eq $EasterMonthPreviousYear) {
		if ($YouCanHaveSingspirationEasterMonthPreviousYear -eq 1) {
			$SingspirationMarPreviousYear = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonthPreviousYear -eq 0) {
			$SingspirationMarPreviousYear = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInMarYearAfter -le 4) {
	$SingspirationMarYearAfter = 0 # The number of Sundays in March in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInMarYearAfter -ge 5) {
	$SingspirationMarYearAfter = 1 # The number of Sundays in March in the Year After is 5 or more so we'll have Singspiration this month.
	if ($MarYearAfter.Month -eq $EasterMonthYearAfter) {
		if ($YouCanHaveSingspirationEasterMonthYearAfter -eq 1) {
			$SingspirationMarYearAfter = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonthYearAfter -eq 0) {
			$SingspirationMarYearAfter = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
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

if ($NumberOfSundaysInAprPreviousYear -le 4) {
	$SingspirationAprPreviousYear = 0 # The number of Sundays in April in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInAprPreviousYear -ge 5) {
	$SingspirationAprPreviousYear = 1 # The number of Sundays in April in the Previous Year is 5 or more so we'll have Singspiration this month.
	if ($AprPreviousYear.Month -eq $EasterMonthFutureYearPreviousYear) {
		if ($YouCanHaveSingspirationEasterMonthPreviousYear -eq 1) {
			$SingspirationAprPreviousYear = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonthPreviousYear -eq 0) {
			$SingspirationAprPreviousYear = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInAprYearAfter -le 4) {
	$SingspirationAprYearAfter = 0 # The number of Sundays in April in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInAprYearAfter -ge 5) {
	$SingspirationAprYearAfter = 1 # The number of Sundays in April in the Year After is 5 or more so we'll have Singspiration this month.
	if ($AprYearAfter.Month -eq $EasterMonthFutureYearYearAfter) {
		if ($YouCanHaveSingspirationEasterMonthYearAfter -eq 1) {
			$SingspirationAprYearAfter = 1 # Have Singspiration this month. Easter is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationEasterMonthYearAfter -eq 0) {
			$SingspirationAprYearAfter = 0 # Skip Singspiration this month. Easter is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInMay -le 4) {
	$SingspirationMay = 0 # The number of Sundays in May in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInMay -ge 5) {
	$SingspirationMay = 1 # The number of Sundays in May in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInMayPreviousYear -le 4) {
	$SingspirationMayPreviousYear = 0 # The number of Sundays in May in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInMayPreviousYear -ge 5) {
	$SingspirationMayPreviousYear = 1 # The number of Sundays in May in the Previous Year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInMayYearAfter -le 4) {
	$SingspirationMayYearAfter = 0 # The number of Sundays in May in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInMayYearAfter -ge 5) {
	$SingspirationMayYearAfter = 1 # The number of Sundays in May in the Year After is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJun -le 4) {
	$SingspirationJun = 0 # The number of Sundays in June in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJun -ge 5) {
	$SingspirationJun = 1 # The number of Sundays in June in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJunPreviousYear -le 4) {
	$SingspirationJunPreviousYear = 0 # The number of Sundays in June in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJunPreviousYear -ge 5) {
	$SingspirationJunPreviousYear = 1 # The number of Sundays in June in the Previous Year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJunYearAfter -le 4) {
	$SingspirationJunYearAfter = 0 # The number of Sundays in June in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJunYearAfter -ge 5) {
	$SingspirationJunYearAfter = 1 # The number of Sundays in June in the Year After is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJul -le 4) {
	$SingspirationJul = 0 # The number of Sundays in July in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJul -ge 5) {
	$SingspirationJul = 1 # The number of Sundays in July in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJulPreviousYear -le 4) {
	$SingspirationJulPreviousYear = 0 # The number of Sundays in July in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJulPreviousYear -ge 5) {
	$SingspirationJulPreviousYear = 1 # The number of Sundays in July in the Previous Year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInJulYearAfter -le 4) {
	$SingspirationJulYearAfter = 0 # The number of Sundays in July in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInJulYearAfter -ge 5) {
	$SingspirationJulYearAfter = 1 # The number of Sundays in July in the Year After is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInAug -le 4) {
	$SingspirationAug = 0 # The number of Sundays in August in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInAug -ge 5) {
	# $SingspirationAug = 1 # The number of Sundays in August in the future year is 5 or more so we'll have Singspiration this month.
	$SingspirationAug = 0 # Ok, we're currently going to skip Singspiration in August because we're normally spending time with our other families during the Sunday night before Labor Day.
}

if ($NumberOfSundaysInAugPreviousYear -le 4) {
	$SingspirationAugPreviousYear = 0 # The number of Sundays in August in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInAugPreviousYear -ge 5) {
	# $SingspirationAugPreviousYear = 1 # The number of Sundays in August in the Previous Year is 5 or more so we'll have Singspiration this month.
	$SingspirationAugPreviousYear = 0 # Ok, we're currently going to skip Singspiration in August because we're normally spending time with our other families during the Sunday night before Labor Day.
}

if ($NumberOfSundaysInAugYearAfter -le 4) {
	$SingspirationAugYearAfter = 0 # The number of Sundays in August in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInAugYearAfter -ge 5) {
	# $SingspirationAugYearAfter = 1 # The number of Sundays in August in the Year After is 5 or more so we'll have Singspiration this month.
	$SingspirationAugYearAfter = 0 # Ok, we're currently going to skip Singspiration in August because we're normally spending time with our other families during the Sunday night before Labor Day.
}

if ($NumberOfSundaysInSep -le 4) {
	$SingspirationSep = 0 # The number of Sundays in September in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInSep -ge 5) {
	$SingspirationSep = 1 # The number of Sundays in September in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInSepPreviousYear -le 4) {
	$SingspirationSepPreviousYear = 0 # The number of Sundays in September in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInSepPreviousYear -ge 5) {
	$SingspirationSepPreviousYear = 1 # The number of Sundays in September in the Previous Year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInSepYearAfter -le 4) {
	$SingspirationSepYearAfter = 0 # The number of Sundays in September in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInSepYearAfter -ge 5) {
	$SingspirationSepYearAfter = 1 # The number of Sundays in September in the Year After is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInOct -le 4) {
	$SingspirationOct = 0 # The number of Sundays in October in the future year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInOct -ge 5) {
	$SingspirationOct = 1 # The number of Sundays in October in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInOctPreviousYear -le 4) {
	$SingspirationOctPreviousYear = 0 # The number of Sundays in October in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInOctPreviousYear -ge 5) {
	$SingspirationOctPreviousYear = 1 # The number of Sundays in October in the Previous Year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInOctYearAfter -le 4) {
	$SingspirationOctYearAfter = 0 # The number of Sundays in October in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInOctYearAfter -ge 5) {
	$SingspirationOctYearAfter = 1 # The number of Sundays in October in the Year After is 5 or more so we'll have Singspiration this month.
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

if ($NumberOfSundaysInNovPreviousYear -le 4) {
	$SingspirationNovPreviousYear = 0 # The number of Sundays in November in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInNovPreviousYear -ge 5) {
	$SingspirationNovPreviousYear = 1 # The number of Sundays in November in the Previous Year is 5 or more so we'll have Singspiration this month.
	if ($NovPreviousYear.Month -eq $EasterMonthPreviousYear) {
		if ($YouCanHaveSingspirationThanksgivingMonthPreviousYear -eq 1) {
			$SingspirationNovPreviousYear = 1 # Have Singspiration this month. Thanksgiving is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationThanksgivingMonthPreviousYear -eq 0) {
			$SingspirationNovPreviousYear = 0 # Skip Singspiration this month. Thanksgiving is this month & it's on the last Sunday.
		}
	}
}

if ($NumberOfSundaysInNovYearAfter -le 4) {
	$SingspirationNovYearAfter = 0 # The number of Sundays in November in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInNovYearAfter -ge 5) {
	$SingspirationNovYearAfter = 1 # The number of Sundays in November in the Year After is 5 or more so we'll have Singspiration this month.
	if ($NovYearAfter.Month -eq $EasterMonthYearAfter) {
		if ($YouCanHaveSingspirationThanksgivingMonthYearAfter -eq 1) {
			$SingspirationNovYearAfter = 1 # Have Singspiration this month. Thanksgiving is this month & it's not on the last Sunday.
		}
		if ($YouCanHaveSingspirationThanksgivingMonthYearAfter -eq 0) {
			$SingspirationNovYearAfter = 0 # Skip Singspiration this month. Thanksgiving is this month & it's on the last Sunday.
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

if ($NumberOfSundaysInDecPreviousYear -le 4) {
	$SingspirationDecPreviousYear = 0 # The number of Sundays in December in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInDecPreviousYear -ge 5) {
	# $SingspirationDecPreviousYear = 1 # The number of Sundays in December in the Previous Year is 5 or more so we'll have Singspiration this month.
	$SingspirationDecPreviousYear = 0 # Ok, we're currently going to skip Singspiration in December because we're normally spending time with our other families during Christmas & New Year's.
}

if ($NumberOfSundaysInDecYearAfter -le 4) {
	$SingspirationDecYearAfter = 0 # The number of Sundays in December in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInDecYearAfter -ge 5) {
	# $SingspirationDecYearAfter = 1 # The number of Sundays in December in the Year After is 5 or more so we'll have Singspiration this month.
	$SingspirationDecYearAfter = 0 # Ok, we're currently going to skip Singspiration in December because we're normally spending time with our other families during Christmas & New Year's.
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

$NumberOfSingspirationsPreviousYear = 0
if ($SingspirationJanPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationFebPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationMarPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationAprPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationMayPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationJunPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationJulPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationAugPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationSepPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationOctPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationNovPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}
if ($SingspirationDecPreviousYear -eq 1) {$NumberOfSingspirationsPreviousYear = $NumberOfSingspirationsPreviousYear + 1}

$NumberOfSingspirationsYearAfter = 0
if ($SingspirationJanYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationFebYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationMarYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationAprYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationMayYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationJunYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationJulYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationAugYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationSepYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationOctYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationNovYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}
if ($SingspirationDecYearAfter -eq 1) {$NumberOfSingspirationsYearAfter = $NumberOfSingspirationsYearAfter + 1}

Write-Host "There are $NumberOfSingspirationsFutureYear Singspirations in $FutureYear."

Write-Host "There are $NumberOfSingspirationsPreviousYear Singspirations in $PreviousYear."

Write-Host "There are $NumberOfSingspirationsYearAfter Singspirations in $YearAfter."

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

# Store the last Sunday of each month Previous Year in separate variables
$lastSundayJanPreviousYear = Get-LastSunday -year $PreviousYear -month 1
$lastSundayFebPreviousYear = Get-LastSunday -year $PreviousYear -month 2
$lastSundayMarPreviousYear = Get-LastSunday -year $PreviousYear -month 3
$lastSundayAprPreviousYear = Get-LastSunday -year $PreviousYear -month 4
$lastSundayMayPreviousYear = Get-LastSunday -year $PreviousYear -month 5
$lastSundayJunPreviousYear = Get-LastSunday -year $PreviousYear -month 6
$lastSundayJulPreviousYear = Get-LastSunday -year $PreviousYear -month 7
$lastSundayAugPreviousYear = Get-LastSunday -year $PreviousYear -month 8
$lastSundaySepPreviousYear = Get-LastSunday -year $PreviousYear -month 9
$lastSundayOctPreviousYear = Get-LastSunday -year $PreviousYear -month 10
$lastSundayNovPreviousYear = Get-LastSunday -year $PreviousYear -month 11
$lastSundayDecPreviousYear = Get-LastSunday -year $PreviousYear -month 12

# Store the last Sunday of each month Year After in separate variables
$lastSundayJanYearAfter = Get-LastSunday -year $YearAfter -month 1
$lastSundayFebYearAfter = Get-LastSunday -year $YearAfter -month 2
$lastSundayMarYearAfter = Get-LastSunday -year $YearAfter -month 3
$lastSundayAprYearAfter = Get-LastSunday -year $YearAfter -month 4
$lastSundayMayYearAfter = Get-LastSunday -year $YearAfter -month 5
$lastSundayJunYearAfter = Get-LastSunday -year $YearAfter -month 6
$lastSundayJulYearAfter = Get-LastSunday -year $YearAfter -month 7
$lastSundayAugYearAfter = Get-LastSunday -year $YearAfter -month 8
$lastSundaySepYearAfter = Get-LastSunday -year $YearAfter -month 9
$lastSundayOctYearAfter = Get-LastSunday -year $YearAfter -month 10
$lastSundayNovYearAfter = Get-LastSunday -year $YearAfter -month 11
$lastSundayDecYearAfter = Get-LastSunday -year $YearAfter -month 12

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

# Store the last Wednesday of each month Previous Year in separate variables
$lastWednesdayJanPreviousYear = Get-LastWednesday -year $PreviousYear -month 1
$lastWednesdayFebPreviousYear = Get-LastWednesday -year $PreviousYear -month 2
$lastWednesdayMarPreviousYear = Get-LastWednesday -year $PreviousYear -month 3
$lastWednesdayAprPreviousYear = Get-LastWednesday -year $PreviousYear -month 4
$lastWednesdayMayPreviousYear = Get-LastWednesday -year $PreviousYear -month 5
$lastWednesdayJunPreviousYear = Get-LastWednesday -year $PreviousYear -month 6
$lastWednesdayJulPreviousYear = Get-LastWednesday -year $PreviousYear -month 7
$lastWednesdayAugPreviousYear = Get-LastWednesday -year $PreviousYear -month 8
$lastWednesdaySepPreviousYear = Get-LastWednesday -year $PreviousYear -month 9
$lastWednesdayOctPreviousYear = Get-LastWednesday -year $PreviousYear -month 10
$lastWednesdayNovPreviousYear = Get-LastWednesday -year $PreviousYear -month 11
$lastWednesdayDecPreviousYear = Get-LastWednesday -year $PreviousYear -month 12

# Store the last Wednesday of each month Year After in separate variables
$lastWednesdayJanYearAfter = Get-LastWednesday -year $YearAfter -month 1
$lastWednesdayFebYearAfter = Get-LastWednesday -year $YearAfter -month 2
$lastWednesdayMarYearAfter = Get-LastWednesday -year $YearAfter -month 3
$lastWednesdayAprYearAfter = Get-LastWednesday -year $YearAfter -month 4
$lastWednesdayMayYearAfter = Get-LastWednesday -year $YearAfter -month 5
$lastWednesdayJunYearAfter = Get-LastWednesday -year $YearAfter -month 6
$lastWednesdayJulYearAfter = Get-LastWednesday -year $YearAfter -month 7
$lastWednesdayAugYearAfter = Get-LastWednesday -year $YearAfter -month 8
$lastWednesdaySepYearAfter = Get-LastWednesday -year $YearAfter -month 9
$lastWednesdayOctYearAfter = Get-LastWednesday -year $YearAfter -month 10
$lastWednesdayNovYearAfter = Get-LastWednesday -year $YearAfter -month 11
$lastWednesdayDecYearAfter = Get-LastWednesday -year $YearAfter -month 12

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

Write-Output "The last Sunday of January $PreviousYear is $($lastSundayJanPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of January $PreviousYear is $($lastWednesdayJanPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of February $PreviousYear is $($lastSundayFebPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of February $PreviousYear is $($lastWednesdayFebPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of March $PreviousYear is $($lastSundayMarPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of March $PreviousYear is $($lastWednesdayMarPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of April $PreviousYear is $($lastSundayAprPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of April $PreviousYear is $($lastWednesdayAprPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of May $PreviousYear is $($lastSundayMayPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of May $PreviousYear is $($lastWednesdayMayPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of June $PreviousYear is $($lastSundayJunPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of June $PreviousYear is $($lastWednesdayJunPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of July $PreviousYear is $($lastSundayJulPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of July $PreviousYear is $($lastWednesdayJulPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of August $PreviousYear is $($lastSundayAugPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of August $PreviousYear is $($lastWednesdayAugPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of September $PreviousYear is $($lastSundaySepPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of September $PreviousYear is $($lastWednesdaySepPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of October $PreviousYear is $($lastSundayOctPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of October $PreviousYear is $($lastWednesdayOctPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of November $PreviousYear is $($lastSundayNovPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of November $PreviousYear is $($lastWednesdayNovPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of December $PreviousYear is $($lastSundayDecPreviousYear.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of December $PreviousYear is $($lastWednesdayDecPreviousYear.ToString('yyyy-MM-dd'))."

Write-Output "The last Sunday of January $YearAfter is $($lastSundayJanYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of January $YearAfter is $($lastWednesdayJanYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of February $YearAfter is $($lastSundayFebYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of February $YearAfter is $($lastWednesdayFebYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of March $YearAfter is $($lastSundayMarYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of March $YearAfter is $($lastWednesdayMarYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of April $YearAfter is $($lastSundayAprYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of April $YearAfter is $($lastWednesdayAprYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of May $YearAfter is $($lastSundayMayYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of May $YearAfter is $($lastWednesdayMayYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of June $YearAfter is $($lastSundayJunYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of June $YearAfter is $($lastWednesdayJunYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of July $YearAfter is $($lastSundayJulYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of July $YearAfter is $($lastWednesdayJulYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of August $YearAfter is $($lastSundayAugYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of August $YearAfter is $($lastWednesdayAugYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of September $YearAfter is $($lastSundaySepYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of September $YearAfter is $($lastWednesdaySepYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of October $YearAfter is $($lastSundayOctYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of October $YearAfter is $($lastWednesdayOctYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of November $YearAfter is $($lastSundayNovYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of November $YearAfter is $($lastWednesdayNovYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Sunday of December $YearAfter is $($lastSundayDecYearAfter.ToString('yyyy-MM-dd'))."
Write-Output "The last Wednesday of December $YearAfter is $($lastWednesdayDecYearAfter.ToString('yyyy-MM-dd'))."
#>

$FutureJanuary = Get-Date -Year $FutureYear -Month 1 -UFormat %B
$PreviousYearJanuary = Get-Date -Year $PreviousYear -Month 1 -UFormat %B
$YearAfterJanuary = Get-Date -Year $YearAfter -Month 1 -UFormat %B

# Output to host if you're going to have Singspiration each month in the Previous Year.
Write-Host ""
Write-Host "Previous Year Singspiration Schedule:"
if ($SingspirationJanPreviousYear -eq 1) {Write-Host -ForegroundColor Green "$PreviousYearJanuary $($lastSundayJanPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationJanPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "$PreviousYearJanuary $($lastSundayJanPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationFebPreviousYear -eq 1) {Write-Host -ForegroundColor Green "February $($lastSundayFebPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationFebPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "February $($lastSundayFebPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationMarPreviousYear -eq 1) {Write-Host -ForegroundColor Green "March $($lastSundayMarPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationMarPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "March $($lastSundayMarPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationAprPreviousYear -eq 1) {Write-Host -ForegroundColor Green "April $($lastSundayAprPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationAprPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "April $($lastSundayAprPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationMayPreviousYear -eq 1) {Write-Host -ForegroundColor Green "May $($lastSundayMayPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationMayPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "May $($lastSundayMayPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationJunPreviousYear -eq 1) {Write-Host -ForegroundColor Green "June $($lastSundayJunPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationJunPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "June $($lastSundayJunPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationJulPreviousYear -eq 1) {Write-Host -ForegroundColor Green "July $($lastSundayJulPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationJulPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "July $($lastSundayJulPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationAugPreviousYear -eq 1) {Write-Host -ForegroundColor Green "August $($lastSundayAugPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationAugPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "August $($lastSundayAugPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationSepPreviousYear -eq 1) {Write-Host -ForegroundColor Green "September $($lastSundaySepPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationSepPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "September $($lastSundaySepPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationOctPreviousYear -eq 1) {Write-Host -ForegroundColor Green "October $($lastSundayOctPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationOctPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "October $($lastSundayOctPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationNovPreviousYear -eq 1) {Write-Host -ForegroundColor Green "November $($lastSundayNovPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationNovPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "November $($lastSundayNovPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationDecPreviousYear -eq 1) {Write-Host -ForegroundColor Green "December $($lastSundayDecPreviousYear.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationDecPreviousYear -eq 0) {Write-Host -ForegroundColor DarkRed "December $($lastSundayDecPreviousYear.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}

# Output to host if you're going to have Singspiration each month in the future year.
Write-Host ""
Write-Host "Future Year Singspiration Schedule:"
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

# Output to host if you're going to have Singspiration each month in the Year After.
Write-Host ""
Write-Host "Year After Singspiration Schedule:"
if ($SingspirationJanYearAfter -eq 1) {Write-Host -ForegroundColor Green "$YearAfterJanuary $($lastSundayJanYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationJanYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "$YearAfterJanuary $($lastSundayJanYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationFebYearAfter -eq 1) {Write-Host -ForegroundColor Green "February $($lastSundayFebYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationFebYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "February $($lastSundayFebYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationMarYearAfter -eq 1) {Write-Host -ForegroundColor Green "March $($lastSundayMarYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationMarYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "March $($lastSundayMarYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationAprYearAfter -eq 1) {Write-Host -ForegroundColor Green "April $($lastSundayAprYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationAprYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "April $($lastSundayAprYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationMayYearAfter -eq 1) {Write-Host -ForegroundColor Green "May $($lastSundayMayYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationMayYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "May $($lastSundayMayYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationJunYearAfter -eq 1) {Write-Host -ForegroundColor Green "June $($lastSundayJunYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationJunYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "June $($lastSundayJunYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationJulYearAfter -eq 1) {Write-Host -ForegroundColor Green "July $($lastSundayJulYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationJulYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "July $($lastSundayJulYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationAugYearAfter -eq 1) {Write-Host -ForegroundColor Green "August $($lastSundayAugYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationAugYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "August $($lastSundayAugYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationSepYearAfter -eq 1) {Write-Host -ForegroundColor Green "September $($lastSundaySepYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationSepYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "September $($lastSundaySepYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationOctYearAfter -eq 1) {Write-Host -ForegroundColor Green "October $($lastSundayOctYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationOctYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "October $($lastSundayOctYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationNovYearAfter -eq 1) {Write-Host -ForegroundColor Green "November $($lastSundayNovYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationNovYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "November $($lastSundayNovYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}
if ($SingspirationDecYearAfter -eq 1) {Write-Host -ForegroundColor Green "December $($lastSundayDecYearAfter.ToString('yyyy-MM-dd'))sp: Have Singspiration."}
if ($SingspirationDecYearAfter -eq 0) {Write-Host -ForegroundColor DarkRed "December $($lastSundayDecYearAfter.ToString('yyyy-MM-dd'))sp: Skip Singspiration."}

# Then you'll have to work on a report for every Sunday morning, Sunday evening, & Wednesday evening so you know how many Sundays/Wednesdays are left to sign up for the next upcoming Singspiration; calculating in the lead time you need to coordinate everything.
# You may need to calculate the first Singspiration 2 years from now too so you can get the number of Sundays/Wednesdays left to sign up after the last one next year. Ok, I think I've completed this line in the code below.

<#
Remember, you need approximately 2 weeks to comfortability process everything before Singspiration::
$var - 14 days = sa - can signup for current event
$var - 14 days = sp - can signup for next event
$var - 11 days = wp - can signup for next event
$var - 07 days = sa - can signup for next event
$var - 07 days = sp - can signup for next event
$var - 04 days = wp - can signup for next event
$var - 00 days = sa - can signup for next event
$var = sp - event takes place - can signup for next event
#>

# You are here (& testing things below) - adding $PreviousYear & $YearAfter to the code.

if ($SingspirationJanPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayJanPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJanPreviousYearMinus04DaysWP = $lastSundayJanPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayJanPreviousYearMinus07DaysSA = $lastSundayJanPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJanPreviousYearMinus07DaysSP = $lastSundayJanPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJanPreviousYearMinus11DaysWP = $lastSundayJanPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayJanPreviousYearMinus14DaysSA = $lastSundayJanPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayJanPreviousYearMinus14DaysSP = $lastSundayJanPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationFebPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayFebPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayFebPreviousYearMinus04DaysWP = $lastSundayFebPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayFebPreviousYearMinus07DaysSA = $lastSundayFebPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayFebPreviousYearMinus07DaysSP = $lastSundayFebPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayFebPreviousYearMinus11DaysWP = $lastSundayFebPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayFebPreviousYearMinus14DaysSA = $lastSundayFebPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayFebPreviousYearMinus14DaysSP = $lastSundayFebPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationMarPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayMarPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayMarPreviousYearMinus04DaysWP = $lastSundayMarPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayMarPreviousYearMinus07DaysSA = $lastSundayMarPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMarPreviousYearMinus07DaysSP = $lastSundayMarPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMarPreviousYearMinus11DaysWP = $lastSundayMarPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayMarPreviousYearMinus14DaysSA = $lastSundayMarPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayMarPreviousYearMinus14DaysSP = $lastSundayMarPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationAprPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayAprPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayAprPreviousYearMinus04DaysWP = $lastSundayAprPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayAprPreviousYearMinus07DaysSA = $lastSundayAprPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAprPreviousYearMinus07DaysSP = $lastSundayAprPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAprPreviousYearMinus11DaysWP = $lastSundayAprPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayAprPreviousYearMinus14DaysSA = $lastSundayAprPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayAprPreviousYearMinus14DaysSP = $lastSundayAprPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationMayPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayMayPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayMayPreviousYearMinus04DaysWP = $lastSundayMayPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayMayPreviousYearMinus07DaysSA = $lastSundayMayPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMayPreviousYearMinus07DaysSP = $lastSundayMayPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMayPreviousYearMinus11DaysWP = $lastSundayMayPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayMayPreviousYearMinus14DaysSA = $lastSundayMayPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayMayPreviousYearMinus14DaysSP = $lastSundayMayPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationJunPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayJunPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJunPreviousYearMinus04DaysWP = $lastSundayJunPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayJunPreviousYearMinus07DaysSA = $lastSundayJunPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJunPreviousYearMinus07DaysSP = $lastSundayJunPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJunPreviousYearMinus11DaysWP = $lastSundayJunPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayJunPreviousYearMinus14DaysSA = $lastSundayJunPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayJunPreviousYearMinus14DaysSP = $lastSundayJunPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationJulPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayJulPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJulPreviousYearMinus04DaysWP = $lastSundayJulPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayJulPreviousYearMinus07DaysSA = $lastSundayJulPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJulPreviousYearMinus07DaysSP = $lastSundayJulPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJulPreviousYearMinus11DaysWP = $lastSundayJulPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayJulPreviousYearMinus14DaysSA = $lastSundayJulPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayJulPreviousYearMinus14DaysSP = $lastSundayJulPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationAugPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayAugPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayAugPreviousYearMinus04DaysWP = $lastSundayAugPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayAugPreviousYearMinus07DaysSA = $lastSundayAugPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAugPreviousYearMinus07DaysSP = $lastSundayAugPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAugPreviousYearMinus11DaysWP = $lastSundayAugPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayAugPreviousYearMinus14DaysSA = $lastSundayAugPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayAugPreviousYearMinus14DaysSP = $lastSundayAugPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationSepPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundaySepPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundaySepPreviousYearMinus04DaysWP = $lastSundaySepPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundaySepPreviousYearMinus07DaysSA = $lastSundaySepPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundaySepPreviousYearMinus07DaysSP = $lastSundaySepPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundaySepPreviousYearMinus11DaysWP = $lastSundaySepPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundaySepPreviousYearMinus14DaysSA = $lastSundaySepPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundaySepPreviousYearMinus14DaysSP = $lastSundaySepPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationOctPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayOctPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayOctPreviousYearMinus04DaysWP = $lastSundayOctPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayOctPreviousYearMinus07DaysSA = $lastSundayOctPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayOctPreviousYearMinus07DaysSP = $lastSundayOctPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayOctPreviousYearMinus11DaysWP = $lastSundayOctPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayOctPreviousYearMinus14DaysSA = $lastSundayOctPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayOctPreviousYearMinus14DaysSP = $lastSundayOctPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationNovPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayNovPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayNovPreviousYearMinus04DaysWP = $lastSundayNovPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayNovPreviousYearMinus07DaysSA = $lastSundayNovPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayNovPreviousYearMinus07DaysSP = $lastSundayNovPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayNovPreviousYearMinus11DaysWP = $lastSundayNovPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayNovPreviousYearMinus14DaysSA = $lastSundayNovPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayNovPreviousYearMinus14DaysSP = $lastSundayNovPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationDecPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayDecPreviousYear # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayDecPreviousYearMinus04DaysWP = $lastSundayDecPreviousYear.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayDecPreviousYearMinus07DaysSA = $lastSundayDecPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayDecPreviousYearMinus07DaysSP = $lastSundayDecPreviousYear.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayDecPreviousYearMinus11DaysWP = $lastSundayDecPreviousYear.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayDecPreviousYearMinus14DaysSA = $lastSundayDecPreviousYear.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayDecPreviousYearMinus14DaysSP = $lastSundayDecPreviousYear.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}

# You need to figure out what these variables need to be below for $X & $Y.

if ($SingspirationJan -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayJan # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJanMinus04DaysWP = $lastSundayJan.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayJanMinus07DaysSA = $lastSundayJan.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJanMinus07DaysSP = $lastSundayJan.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJanMinus11DaysWP = $lastSundayJan.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayJanMinus14DaysSA = $lastSundayJan.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayJanMinus14DaysSP = $lastSundayJan.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayJanMinus18DaysWP = $lastSundayJan.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayJanMinus21DaysSA = $lastSundayJan.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayJanMinus21DaysSP = $lastSundayJan.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayJanMinus25DaysWP = $lastSundayJan.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayJanMinus28DaysSA = $lastSundayJan.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayJanMinus28DaysSP = $lastSundayJan.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
	if ($SingspirationFeb -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayFeb # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayFebMinus04DaysWP = $lastSundayFeb.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayFebMinus07DaysSA = $lastSundayFeb.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayFebMinus07DaysSP = $lastSundayFeb.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayFebMinus11DaysWP = $lastSundayFeb.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayFebMinus14DaysSA = $lastSundayFeb.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayFebMinus14DaysSP = $lastSundayFeb.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayFebMinus18DaysWP = $lastSundayFeb.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayFebMinus21DaysSA = $lastSundayFeb.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayFebMinus21DaysSP = $lastSundayFeb.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayFebMinus25DaysWP = $lastSundayFeb.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayFebMinus28DaysSA = $lastSundayFeb.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayFebMinus28DaysSP = $lastSundayFeb.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationMar -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayMar # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayMarMinus04DaysWP = $lastSundayMar.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayMarMinus07DaysSA = $lastSundayMar.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMarMinus07DaysSP = $lastSundayMar.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMarMinus11DaysWP = $lastSundayMar.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayMarMinus14DaysSA = $lastSundayMar.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayMarMinus14DaysSP = $lastSundayMar.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayMarMinus18DaysWP = $lastSundayMar.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayMarMinus21DaysSA = $lastSundayMar.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayMarMinus21DaysSP = $lastSundayMar.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayMarMinus25DaysWP = $lastSundayMar.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayMarMinus28DaysSA = $lastSundayMar.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayMarMinus28DaysSP = $lastSundayMar.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationApr -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayApr # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayAprMinus04DaysWP = $lastSundayApr.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayAprMinus07DaysSA = $lastSundayApr.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAprMinus07DaysSP = $lastSundayApr.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAprMinus11DaysWP = $lastSundayApr.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayAprMinus14DaysSA = $lastSundayApr.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayAprMinus14DaysSP = $lastSundayApr.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayAprMinus18DaysWP = $lastSundayApr.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayAprMinus21DaysSA = $lastSundayApr.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayAprMinus21DaysSP = $lastSundayApr.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayAprMinus25DaysWP = $lastSundayApr.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayAprMinus28DaysSA = $lastSundayApr.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayAprMinus28DaysSP = $lastSundayApr.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationMay -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayMay # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayMayMinus04DaysWP = $lastSundayMay.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayMayMinus07DaysSA = $lastSundayMay.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMayMinus07DaysSP = $lastSundayMay.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMayMinus11DaysWP = $lastSundayMay.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayMayMinus14DaysSA = $lastSundayMay.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayMayMinus14DaysSP = $lastSundayMay.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayMayMinus18DaysWP = $lastSundayMay.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayMayMinus21DaysSA = $lastSundayMay.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayMayMinus21DaysSP = $lastSundayMay.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayMayMinus25DaysWP = $lastSundayMay.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayMayMinus28DaysSA = $lastSundayMay.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayMayMinus28DaysSP = $lastSundayMay.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationJun -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayJun # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJunMinus04DaysWP = $lastSundayJun.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayJunMinus07DaysSA = $lastSundayJun.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJunMinus07DaysSP = $lastSundayJun.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJunMinus11DaysWP = $lastSundayJun.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayJunMinus14DaysSA = $lastSundayJun.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayJunMinus14DaysSP = $lastSundayJun.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayJunMinus18DaysWP = $lastSundayJun.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayJunMinus21DaysSA = $lastSundayJun.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayJunMinus21DaysSP = $lastSundayJun.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayJunMinus25DaysWP = $lastSundayJun.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayJunMinus28DaysSA = $lastSundayJun.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayJunMinus28DaysSP = $lastSundayJun.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationJul -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayJul # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJulMinus04DaysWP = $lastSundayJul.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayJulMinus07DaysSA = $lastSundayJul.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJulMinus07DaysSP = $lastSundayJul.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJulMinus11DaysWP = $lastSundayJul.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayJulMinus14DaysSA = $lastSundayJul.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayJulMinus14DaysSP = $lastSundayJul.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayJulMinus18DaysWP = $lastSundayJul.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayJulMinus21DaysSA = $lastSundayJul.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayJulMinus21DaysSP = $lastSundayJul.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayJulMinus25DaysWP = $lastSundayJul.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayJulMinus28DaysSA = $lastSundayJul.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayJulMinus28DaysSP = $lastSundayJul.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationAug -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayAug # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayAugMinus04DaysWP = $lastSundayAug.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayAugMinus07DaysSA = $lastSundayAug.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAugMinus07DaysSP = $lastSundayAug.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAugMinus11DaysWP = $lastSundayAug.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayAugMinus14DaysSA = $lastSundayAug.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayAugMinus14DaysSP = $lastSundayAug.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayAugMinus18DaysWP = $lastSundayAug.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayAugMinus21DaysSA = $lastSundayAug.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayAugMinus21DaysSP = $lastSundayAug.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayAugMinus25DaysWP = $lastSundayAug.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayAugMinus28DaysSA = $lastSundayAug.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayAugMinus28DaysSP = $lastSundayAug.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationSep -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundaySep # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundaySepMinus04DaysWP = $lastSundaySep.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundaySepMinus07DaysSA = $lastSundaySep.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundaySepMinus07DaysSP = $lastSundaySep.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundaySepMinus11DaysWP = $lastSundaySep.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundaySepMinus14DaysSA = $lastSundaySep.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundaySepMinus14DaysSP = $lastSundaySep.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundaySepMinus18DaysWP = $lastSundaySep.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundaySepMinus21DaysSA = $lastSundaySep.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundaySepMinus21DaysSP = $lastSundaySep.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundaySepMinus25DaysWP = $lastSundaySep.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundaySepMinus28DaysSA = $lastSundaySep.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundaySepMinus28DaysSP = $lastSundaySep.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationOct -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayOct # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayOctMinus04DaysWP = $lastSundayOct.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayOctMinus07DaysSA = $lastSundayOct.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayOctMinus07DaysSP = $lastSundayOct.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayOctMinus11DaysWP = $lastSundayOct.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayOctMinus14DaysSA = $lastSundayOct.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayOctMinus14DaysSP = $lastSundayOct.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayOctMinus18DaysWP = $lastSundayOct.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayOctMinus21DaysSA = $lastSundayOct.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayOctMinus21DaysSP = $lastSundayOct.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayOctMinus25DaysWP = $lastSundayOct.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayOctMinus28DaysSA = $lastSundayOct.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayOctMinus28DaysSP = $lastSundayOct.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationNov -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayNov # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayNovMinus04DaysWP = $lastSundayNov.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayNovMinus07DaysSA = $lastSundayNov.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayNovMinus07DaysSP = $lastSundayNov.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayNovMinus11DaysWP = $lastSundayNov.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayNovMinus14DaysSA = $lastSundayNov.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayNovMinus14DaysSP = $lastSundayNov.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayNovMinus18DaysWP = $lastSundayNov.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayNovMinus21DaysSA = $lastSundayNov.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayNovMinus21DaysSP = $lastSundayNov.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayNovMinus25DaysWP = $lastSundayNov.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayNovMinus28DaysSA = $lastSundayNov.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayNovMinus28DaysSP = $lastSundayNov.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}
if ($SingspirationDec -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayDec # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayDecMinus04DaysWP = $lastSundayDec.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayDecMinus07DaysSA = $lastSundayDec.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayDecMinus07DaysSP = $lastSundayDec.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayDecMinus11DaysWP = $lastSundayDec.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayDecMinus14DaysSA = $lastSundayDec.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayDecMinus14DaysSP = $lastSundayDec.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	$lastSundayDecMinus18DaysWP = $lastSundayDec.AddDays(-18) # Can signup for current event. This is a Wednesday.
	$lastSundayDecMinus21DaysSA = $lastSundayDec.AddDays(-21) # Can signup for current event. This is a Sunday morning.
	$lastSundayDecMinus21DaysSP = $lastSundayDec.AddDays(-21) # Can signup for current event. This is a Sunday evening.
	$lastSundayDecMinus25DaysWP = $lastSundayDec.AddDays(-25) # Can signup for current event. This is a Wednesday.
	$lastSundayDecMinus28DaysSA = $lastSundayDec.AddDays(-28) # Can signup for current event. This is a Sunday morning.
	$lastSundayDecMinus28DaysSP = $lastSundayDec.AddDays(-28) # Can signup for current event. This is a Sunday evening.
}

if ($SingspirationJanYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayJanYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJanYearAfterMinus04DaysWP = $lastSundayJanYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayJanYearAfterMinus07DaysSA = $lastSundayJanYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJanYearAfterMinus07DaysSP = $lastSundayJanYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJanYearAfterMinus11DaysWP = $lastSundayJanYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayJanYearAfterMinus14DaysSA = $lastSundayJanYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayJanYearAfterMinus14DaysSP = $lastSundayJanYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationFebYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayFebYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayFebYearAfterMinus04DaysWP = $lastSundayFebYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayFebYearAfterMinus07DaysSA = $lastSundayFebYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayFebYearAfterMinus07DaysSP = $lastSundayFebYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayFebYearAfterMinus11DaysWP = $lastSundayFebYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayFebYearAfterMinus14DaysSA = $lastSundayFebYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayFebYearAfterMinus14DaysSP = $lastSundayFebYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationMarYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayMarYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayMarYearAfterMinus04DaysWP = $lastSundayMarYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayMarYearAfterMinus07DaysSA = $lastSundayMarYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMarYearAfterMinus07DaysSP = $lastSundayMarYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMarYearAfterMinus11DaysWP = $lastSundayMarYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayMarYearAfterMinus14DaysSA = $lastSundayMarYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayMarYearAfterMinus14DaysSP = $lastSundayMarYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationAprYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayAprYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayAprYearAfterMinus04DaysWP = $lastSundayAprYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayAprYearAfterMinus07DaysSA = $lastSundayAprYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAprYearAfterMinus07DaysSP = $lastSundayAprYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAprYearAfterMinus11DaysWP = $lastSundayAprYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayAprYearAfterMinus14DaysSA = $lastSundayAprYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayAprYearAfterMinus14DaysSP = $lastSundayAprYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationMayYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayMayYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayMayYearAfterMinus04DaysWP = $lastSundayMayYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayMayYearAfterMinus07DaysSA = $lastSundayMayYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMayYearAfterMinus07DaysSP = $lastSundayMayYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayMayYearAfterMinus11DaysWP = $lastSundayMayYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayMayYearAfterMinus14DaysSA = $lastSundayMayYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayMayYearAfterMinus14DaysSP = $lastSundayMayYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationJunYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayJunYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJunYearAfterMinus04DaysWP = $lastSundayJunYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayJunYearAfterMinus07DaysSA = $lastSundayJunYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJunYearAfterMinus07DaysSP = $lastSundayJunYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJunYearAfterMinus11DaysWP = $lastSundayJunYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayJunYearAfterMinus14DaysSA = $lastSundayJunYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayJunYearAfterMinus14DaysSP = $lastSundayJunYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationJulYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayJulYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJulYearAfterMinus04DaysWP = $lastSundayJulYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayJulYearAfterMinus07DaysSA = $lastSundayJulYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJulYearAfterMinus07DaysSP = $lastSundayJulYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayJulYearAfterMinus11DaysWP = $lastSundayJulYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayJulYearAfterMinus14DaysSA = $lastSundayJulYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayJulYearAfterMinus14DaysSP = $lastSundayJulYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationAugYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayAugYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayAugYearAfterMinus04DaysWP = $lastSundayAugYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayAugYearAfterMinus07DaysSA = $lastSundayAugYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAugYearAfterMinus07DaysSP = $lastSundayAugYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayAugYearAfterMinus11DaysWP = $lastSundayAugYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayAugYearAfterMinus14DaysSA = $lastSundayAugYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayAugYearAfterMinus14DaysSP = $lastSundayAugYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationSepYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundaySepYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundaySepYearAfterMinus04DaysWP = $lastSundaySepYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundaySepYearAfterMinus07DaysSA = $lastSundaySepYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundaySepYearAfterMinus07DaysSP = $lastSundaySepYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundaySepYearAfterMinus11DaysWP = $lastSundaySepYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundaySepYearAfterMinus14DaysSA = $lastSundaySepYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundaySepYearAfterMinus14DaysSP = $lastSundaySepYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationOctYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayOctYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayOctYearAfterMinus04DaysWP = $lastSundayOctYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayOctYearAfterMinus07DaysSA = $lastSundayOctYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayOctYearAfterMinus07DaysSP = $lastSundayOctYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayOctYearAfterMinus11DaysWP = $lastSundayOctYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayOctYearAfterMinus14DaysSA = $lastSundayOctYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayOctYearAfterMinus14DaysSP = $lastSundayOctYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationNovYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayNovYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayNovYearAfterMinus04DaysWP = $lastSundayNovYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	$lastSundayNovYearAfterMinus07DaysSA = $lastSundayNovYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayNovYearAfterMinus07DaysSP = $lastSundayNovYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	$lastSundayNovYearAfterMinus11DaysWP = $lastSundayNovYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	$lastSundayNovYearAfterMinus14DaysSA = $lastSundayNovYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	$lastSundayNovYearAfterMinus14DaysSP = $lastSundayNovYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
}
if ($SingspirationDecYearAfter -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
	$lastSundayDecYearAfter # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	#$lastSundayDecYearAfterText = "It's too late to sign up for tonight's Singspiration. $X Sundays left to sign up for Singspiration in $Y(08-August)."
	$lastSundayDecYearAfterMinus04DaysWP = $lastSundayDecYearAfter.AddDays(-4) # Can signup for next event. This is a Wednesday.
	#$lastSundayDecYearAfterMinus04DaysWPText = ""
	$lastSundayDecYearAfterMinus07DaysSA = $lastSundayDecYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	#$lastSundayDecYearAfterMinus07DaysSAText = ""
	$lastSundayDecYearAfterMinus07DaysSP = $lastSundayDecYearAfter.AddDays(-7) # Can signup for next event. This is a Sunday.
	#$lastSundayDecYearAfterMinus07DaysSPText = ""
	$lastSundayDecYearAfterMinus11DaysWP = $lastSundayDecYearAfter.AddDays(-11) # Can signup for next event. This is a Wednesday.
	#$lastSundayDecYearAfterMinus11DaysWPText = ""
	$lastSundayDecYearAfterMinus14DaysSA = $lastSundayDecYearAfter.AddDays(-14) # Can signup for next event. This is a Sunday morning.
	#$lastSundayDecYearAfterMinus14DaysSAText = ""
	$lastSundayDecYearAfterMinus14DaysSP = $lastSundayDecYearAfter.AddDays(-14) # Can signup for current event. This is a Sunday evening. You may end up deleting this line.
	#$lastSundayDecYearAfterMinus14DaysSPText = ""
}

if ($SingspirationJan -eq 1) {
	$SingspirationMonths = @(
    $SingspirationFeb,
    $SingspirationMar,
    $SingspirationApr,
    $SingspirationMay,
    $SingspirationJun,
    $SingspirationJul,
    $SingspirationAug,
    $SingspirationSep,
    $SingspirationOct,
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationFeb", "SingspirationMar", "SingspirationApr", "SingspirationMay", "SingspirationJun", "SingspirationJul", "SingspirationAug", "SingspirationSep", "SingspirationOct", "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationFeb") {
		$nextSingspiration = $lastSundayFeb
	} elseif ($stoppedOn -eq "SingspirationMar") {
		$nextSingspiration = $lastSundayMar
	} elseif ($stoppedOn -eq "SingspirationApr") {
		$nextSingspiration = $lastSundayApr
	} elseif ($stoppedOn -eq "SingspirationMay") {
		$nextSingspiration = $lastSundayMay
	} elseif ($stoppedOn -eq "SingspirationJun") {
		$nextSingspiration = $lastSundayJun
	} elseif ($stoppedOn -eq "SingspirationJul") {
		$nextSingspiration = $lastSundayJul
	} elseif ($stoppedOn -eq "SingspirationAug") {
		$nextSingspiration = $lastSundayAug
	} elseif ($stoppedOn -eq "SingspirationSep") {
		$nextSingspiration = $lastSundaySep
	} elseif ($stoppedOn -eq "SingspirationOct") {
		$nextSingspiration = $lastSundayOct
	} elseif ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayJan # Start. Current Singspiration (you're in January) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayFeb
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayJan # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJanTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJanMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationFeb -eq 1) {
	$SingspirationMonths = @(
    $SingspirationMar,
    $SingspirationApr,
    $SingspirationMay,
    $SingspirationJun,
    $SingspirationJul,
    $SingspirationAug,
    $SingspirationSep,
    $SingspirationOct,
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationMar", "SingspirationApr", "SingspirationMay", "SingspirationJun", "SingspirationJul", "SingspirationAug", "SingspirationSep", "SingspirationOct", "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationMar") {
		$nextSingspiration = $lastSundayMar
	} elseif ($stoppedOn -eq "SingspirationApr") {
		$nextSingspiration = $lastSundayApr
	} elseif ($stoppedOn -eq "SingspirationMay") {
		$nextSingspiration = $lastSundayMay
	} elseif ($stoppedOn -eq "SingspirationJun") {
		$nextSingspiration = $lastSundayJun
	} elseif ($stoppedOn -eq "SingspirationJul") {
		$nextSingspiration = $lastSundayJul
	} elseif ($stoppedOn -eq "SingspirationAug") {
		$nextSingspiration = $lastSundayAug
	} elseif ($stoppedOn -eq "SingspirationSep") {
		$nextSingspiration = $lastSundaySep
	} elseif ($stoppedOn -eq "SingspirationOct") {
		$nextSingspiration = $lastSundayOct
	} elseif ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayFeb # Start. Current Singspiration (you're in February) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayMar
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayFeb # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayFebTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayFebMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationMar -eq 1) {
	$SingspirationMonths = @(
    $SingspirationApr,
    $SingspirationMay,
    $SingspirationJun,
    $SingspirationJul,
    $SingspirationAug,
    $SingspirationSep,
    $SingspirationOct,
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationApr", "SingspirationMay", "SingspirationJun", "SingspirationJul", "SingspirationAug", "SingspirationSep", "SingspirationOct", "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
    # Write-Host "A Singspiration is scheduled in $stoppedOn."
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationApr") {
		$nextSingspiration = $lastSundayApr
	} elseif ($stoppedOn -eq "SingspirationMay") {
		$nextSingspiration = $lastSundayMay
	} elseif ($stoppedOn -eq "SingspirationJun") {
		$nextSingspiration = $lastSundayJun
	} elseif ($stoppedOn -eq "SingspirationJul") {
		$nextSingspiration = $lastSundayJul
	} elseif ($stoppedOn -eq "SingspirationAug") {
		$nextSingspiration = $lastSundayAug
	} elseif ($stoppedOn -eq "SingspirationSep") {
		$nextSingspiration = $lastSundaySep
	} elseif ($stoppedOn -eq "SingspirationOct") {
		$nextSingspiration = $lastSundayOct
	} elseif ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayMar # Start. Current Singspiration (you're in March) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates.
	# Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.


	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-03-01"
	#$end   = [datetime]"2026-05-31"
	$start = $lastSundayApr
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4

	# $sundays this is showing the number of Sundays until the next Singspiration.
	# $weds this is showing the number of Wednesdays until the next Singspiration.

	# Now write a loop that will make the text for the number of Sundays & Wednesdays until the next Singspiration that you can later add to the spreadsheet.
	# Or, just figure out how to offset it since you figured that part out already.

	# Ok, just for sake of example, you know you're currently in 2026-03-March & you know the next Singspiration is in 2026-05-May.
	# Now, using DateTime objects ($nextSingspiration), count the number of Sundays until the next Singspiration (pre-existing variable?). Look around this script for possible code.
	# Also, using DateTime objects ($nextSingspiration), count the number of Wednesdays until the next Singspiration (pre-existing variable?). Look around this script for possible code.
	# Ok, if these = 1 (for each month) then you'll have Singspiration that month.
	# You'll need to check when the next one is & count the number of Sundays/Wednesdays until the next one then subtract for the lead time.
	# $SingspirationJan
	# $SingspirationJanPreviousYear
	# $SingspirationJanYearAfter
	# This is how many Sundays & Wednesdays are in each month (modify month names):
	# $NumberOfSundaysInDec
	# $NumberOfWednesdaysInDec
	# $NumberOfSundaysInDecPreviousYear
	# $NumberOfWednesdaysInDecPreviousYear
	# $NumberOfSundaysInDecYearAfter
	# $NumberOfWednesdaysInDecYearAfter

	<#
	Just some rough manual notes from Notepad to help fill out the spreadsheet while I'm still working on this.
	It's too late to sign up for tonight's Singspiration. _ Sundays left to sign up for the next one in _.
	It's too late to sign up for the upcoming Singspiration. _ Sundays left to sign up for the next one in _.
	It's too late to sign up for the upcoming Singspiration. _ Wednesdays left to sign up for the next one in _.
	It's too late to sign up for the upcoming Singspiration. _ Sundays left to sign up for the next one in _.
	It's too late to sign up for the upcoming Singspiration. _ Wednesdays left to sign up for the next one in _.
	Last Wednesday to sign up for Singspiration. _ Wednesdays left to sign up for the next one in _.
	Last Sunday evening to sign up for Singspiration. _ Sundays left to sign up for the next one in _.
	Last Sunday morning to sign up for Singspiration. _ Sundays left to sign up for the next one in _.
	1 Wednesday left to sign up for Singspiration. _ Wednesdays left to sign up for the next one in _.
	1 Sunday left to sign up for Singspiration. _ Sundays left to sign up for the next one in _.
	#>

	# Ok, it looks like this code for March may be producing expected results when manually checking a calendar.
	# Clean up this month then replicate for other months & manually check results against a calendar.
	
	#Calculate the 7 previous church service dates/times for Singspiration (see above). 14 variables.
	$lastSundayMar # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayMarTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays (7) Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMarTextSP = "It's too late to sign up for tonight's Singspiration. $sundays (7) Sundays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 (7) Wednesdays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 (8) Sundays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 (8) Sundays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 (8) Wednesdays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 (9) Sundays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 (9) Sundays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 (10) Wednesdays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 (10) Sundays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 (11) Sundays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 (11) Wednesdays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 (11) Sundays left to sign up for the next one in $nextSingspirationString (08-August)."
	$lastSundayMarMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 (11) Sundays left to sign up for the next one in $nextSingspirationString (08-August)."
}

if ($SingspirationApr -eq 1) {
	$SingspirationMonths = @(
    $SingspirationMay,
    $SingspirationJun,
    $SingspirationJul,
    $SingspirationAug,
    $SingspirationSep,
    $SingspirationOct,
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationMay", "SingspirationJun", "SingspirationJul", "SingspirationAug", "SingspirationSep", "SingspirationOct", "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationMay") {
		$nextSingspiration = $lastSundayMay
	} elseif ($stoppedOn -eq "SingspirationJun") {
		$nextSingspiration = $lastSundayJun
	} elseif ($stoppedOn -eq "SingspirationJul") {
		$nextSingspiration = $lastSundayJul
	} elseif ($stoppedOn -eq "SingspirationAug") {
		$nextSingspiration = $lastSundayAug
	} elseif ($stoppedOn -eq "SingspirationSep") {
		$nextSingspiration = $lastSundaySep
	} elseif ($stoppedOn -eq "SingspirationOct") {
		$nextSingspiration = $lastSundayOct
	} elseif ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayApr # Start. Current Singspiration (you're in April) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayMay
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayApr # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayAprTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAprMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationMay -eq 1) {
	$SingspirationMonths = @(
    $SingspirationJun,
    $SingspirationJul,
    $SingspirationAug,
    $SingspirationSep,
    $SingspirationOct,
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationJun", "SingspirationJul", "SingspirationAug", "SingspirationSep", "SingspirationOct", "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationJun") {
		$nextSingspiration = $lastSundayJun
	} elseif ($stoppedOn -eq "SingspirationJul") {
		$nextSingspiration = $lastSundayJul
	} elseif ($stoppedOn -eq "SingspirationAug") {
		$nextSingspiration = $lastSundayAug
	} elseif ($stoppedOn -eq "SingspirationSep") {
		$nextSingspiration = $lastSundaySep
	} elseif ($stoppedOn -eq "SingspirationOct") {
		$nextSingspiration = $lastSundayOct
	} elseif ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayMay # Start. Current Singspiration (you're in May) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayJun
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayMay # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayMayTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayMayMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationJun -eq 1) {
	$SingspirationMonths = @(
    $SingspirationJul,
    $SingspirationAug,
    $SingspirationSep,
    $SingspirationOct,
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationJul", "SingspirationAug", "SingspirationSep", "SingspirationOct", "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationJul") {
		$nextSingspiration = $lastSundayJul
	} elseif ($stoppedOn -eq "SingspirationAug") {
		$nextSingspiration = $lastSundayAug
	} elseif ($stoppedOn -eq "SingspirationSep") {
		$nextSingspiration = $lastSundaySep
	} elseif ($stoppedOn -eq "SingspirationOct") {
		$nextSingspiration = $lastSundayOct
	} elseif ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayJun # Start. Current Singspiration (you're in June) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayJul
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4

	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayJun # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJunTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJunMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationJul -eq 1) {
	$SingspirationMonths = @(
    $SingspirationAug,
    $SingspirationSep,
    $SingspirationOct,
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationAug", "SingspirationSep", "SingspirationOct", "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationAug") {
		$nextSingspiration = $lastSundayAug
	} elseif ($stoppedOn -eq "SingspirationSep") {
		$nextSingspiration = $lastSundaySep
	} elseif ($stoppedOn -eq "SingspirationOct") {
		$nextSingspiration = $lastSundayOct
	} elseif ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayJul # Start. Current Singspiration (you're in July) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayAug
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayJul # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayJulTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayJulMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationAug -eq 1) {
	$SingspirationMonths = @(
    $SingspirationSep,
    $SingspirationOct,
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationSep", "SingspirationOct", "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationSep") {
		$nextSingspiration = $lastSundaySep
	} elseif ($stoppedOn -eq "SingspirationOct") {
		$nextSingspiration = $lastSundayOct
	} elseif ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayAug # Start. Current Singspiration (you're in August) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundaySep
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayAug # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayAugTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayAugMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationSep -eq 1) {
	$SingspirationMonths = @(
    $SingspirationOct,
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationOct", "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationOct") {
		$nextSingspiration = $lastSundayOct
	} elseif ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundaySep # Start. Current Singspiration (you're in September) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayOct
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundaySep # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundaySepTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundaySepMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationOct -eq 1) {
	$SingspirationMonths = @(
    $SingspirationNov,
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationNov", "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationNov") {
		$nextSingspiration = $lastSundayNov
	} elseif ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayOct # Start. Current Singspiration (you're in October) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayNov
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayOct # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayOctTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayOctMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationNov -eq 1) {
	$SingspirationMonths = @(
    $SingspirationDec,
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationDec",
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationDec") {
		$nextSingspiration = $lastSundayDec
	} elseif ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayNov # Start. Current Singspiration (you're in November) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayDec
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayNov # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayNovTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayNovMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

if ($SingspirationDec -eq 1) {
	$SingspirationMonths = @(
    $SingspirationJanYearAfter,
    $SingspirationFebYearAfter,
    $SingspirationMarYearAfter,
    $SingspirationAprYearAfter,
    $SingspirationMayYearAfter,
    $SingspirationJunYearAfter,
    $SingspirationJulYearAfter,
    $SingspirationAugYearAfter,
    $SingspirationSepYearAfter,
    $SingspirationOctYearAfter,
    $SingspirationNovYearAfter,
    $SingspirationDecYearAfter
	)

	# The next month is the first month on this list:
	$SingspirationMonthNames = @(
    "SingspirationJanYearAfter", "SingspirationFebYearAfter", "SingspirationMarYearAfter", "SingspirationAprYearAfter", "SingspirationMayYearAfter", "SingspirationJunYearAfter",
    "SingspirationJulYearAfter", "SingspirationAugYearAfter", "SingspirationSepYearAfter", "SingspirationOctYearAfter", "SingspirationNovYearAfter", "SingspirationDecYearAfter"
	)

	$found = $false
	$stoppedOn = ""
	for ($i = 0; $i -lt $SingspirationMonths.Count; $i++) {
    if ($SingspirationMonths[$i] -eq 1) {
        $found = $true
        $stoppedOn = $SingspirationMonthNames[$i]
        break
    }
	}

	if ($found) {
	$stoppedOn # This contains the string of the variable that will have the next Singspiration.
	} else {
    Write-Host "No Singspiration is scheduled in the checked months."
	}

	# Now you need to get the date of the next Singspiration based on the contents of $stoppedOn.
	If ($stoppedOn -eq "SingspirationJanYearAfter") {
		$nextSingspiration = $lastSundayJanYearAfter
	} elseif ($stoppedOn -eq "SingspirationFebYearAfter") {
		$nextSingspiration = $lastSundayFebYearAfter
	} elseif ($stoppedOn -eq "SingspirationMarYearAfter") {
		$nextSingspiration = $lastSundayMarYearAfter
	} elseif ($stoppedOn -eq "SingspirationAprYearAfter") {
		$nextSingspiration = $lastSundayAprYearAfter
	} elseif ($stoppedOn -eq "SingspirationMayYearAfter") {
		$nextSingspiration = $lastSundayMayYearAfter
	} elseif ($stoppedOn -eq "SingspirationJunYearAfter") {
		$nextSingspiration = $lastSundayJunYearAfter
	} elseif ($stoppedOn -eq "SingspirationJulYearAfter") {
		$nextSingspiration = $lastSundayJulYearAfter
	} elseif ($stoppedOn -eq "SingspirationAugYearAfter") {
		$nextSingspiration = $lastSundayAugYearAfter
	} elseif ($stoppedOn -eq "SingspirationSepYearAfter") {
		$nextSingspiration = $lastSundaySepYearAfter
	} elseif ($stoppedOn -eq "SingspirationOctYearAfter") {
		$nextSingspiration = $lastSundayOctYearAfter
	} elseif ($stoppedOn -eq "SingspirationNovYearAfter") {
		$nextSingspiration = $lastSundayNovYearAfter
	} elseif ($stoppedOn -eq "SingspirationDecYearAfter") {
		$nextSingspiration = $lastSundayDecYearAfter
	} else {
		Write-Host "No Singspiration scheduled in the next year."
		return # Exit if no Singspiration is found.
		}

	#Format DateTime object for use in text:
	$nextSingspirationString = $nextSingspiration.ToString("MM-MMMM")

	$lastSundayDec # Start. Current Singspiration (you're in December) DateTime object.
	$nextSingspiration # End. Next Singspiration DateTime object.
	# Do math to find the number of Sundays & Wednesdays between these 2 dates. Ask AI how to count the number of Sundays & Wednesdays between 2 DateTime objects in PowerShell.

	function Count-DayOfWeekBetween-function {
    	param(
        	[Parameter(Mandatory)][datetime]$Start,
        	[Parameter(Mandatory)][datetime]$End,
        	[Parameter(Mandatory)][System.DayOfWeek]$DayOfWeek
    	)

    	if ($Start -gt $End) { return 0 }

    	# normalize to dates
    	$s = $Start.Date
    	$e = $End.Date
		#$s = $s.AddDays(1) # Exclude start date
		$e = $e.AddDays(-1) # Exclude end date

    	# find first occurrence of $DayOfWeek on or after $s
    	$daysUntil = ([int]$DayOfWeek - [int]$s.DayOfWeek + 7) % 7
    	$first = $s.AddDays($daysUntil)

    	if ($first -gt $e) { return 0 }

    	$diff = ($e - $first).Days
    	$count = 1 + [math]::Floor($diff / 7)
    	return $count
	}

	# Example usage:
	#$start = [datetime]"2026-04-01"
	#$end   = [datetime]"2026-04-xx"
	$start = $lastSundayJanYearAfter
	$end   = $nextSingspiration

	$sundays = ""
	$weds    = ""
	$sundays = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Sunday)
	$weds    = Count-DayOfWeekBetween-function -Start $start -End $end -DayOfWeek ([DayOfWeek]::Wednesday)

	Write-Output "Sundays: $sundays"
	Write-Output "Wednesdays: $weds"
	# Now you need to offset the number of Sundays & Wednesdays by the lead time. Subtract 3:
	$sundays = $sundays - 3
	$weds = $weds - 3

	$wedsPlus1 = $weds + 1
	$sundaysPlus1 = $sundays + 1
	$wedsPlus2 = $weds + 2
	$sundaysPlus2 = $sundays + 2
	$wedsPlus3 = $weds + 3
	$sundaysPlus3 = $sundays + 3
	$wedsPlus4 = $weds + 4
	$sundaysPlus4 = $sundays + 4
	
	#Calculate the 7 previous church service dates/times for Singspiration. 14 variables.
	$lastSundayDec # Event takes place. Can signup for next event. This is a Sunday. You probably will end up deleting this line.
	$lastSundayDecTextSA = "It's too late to sign up for the upcoming Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecTextSP = "It's too late to sign up for tonight's Singspiration. $sundays Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus04DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus1 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus07DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus07DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus1 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus11DaysWPText = "It's too late to sign up for the upcoming Singspiration. $wedsPlus2 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus14DaysSAText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus14DaysSPText = "It's too late to sign up for the upcoming Singspiration. $sundaysPlus2 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus18DaysWPText = "Last Wednesday to sign up for Singspiration. $wedsPlus3 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus21DaysSAText = "Last Sunday morning to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus21DaysSPText = "Last Sunday evening to sign up for Singspiration. $sundaysPlus3 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus25DaysWPText = "1 Wednesday left to sign up for Singspiration. $wedsPlus4 Wednesdays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus28DaysSAText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
	$lastSundayDecMinus28DaysSPText = "1 Sunday left to sign up for Singspiration. $sundaysPlus4 Sundays left to sign up for the next one in $nextSingspirationString."
}

# You are here. The script seems to run without error. Run it when you have time & check the values of the variables to make sure they seem correct.

# Finished calculating all the lead time needed for Singspiration events for PreviousYear, Next Year, and the YearAfter.
# Check if variables exist to work on reporting. 6 per month across 3 years, so 12*3 = 36 months. 36*6 = 216 variables to check.
# Think about this some more. You can probably just add the math in the loops above.
# Should only need text for the year you are working on, not the years before & after it.
# 
# $lastSundayJanPreviousYearMinus04DaysWP
# $lastSundayJanPreviousYearMinus07DaysSA
# $lastSundayJanPreviousYearMinus07DaysSP
# $lastSundayJanPreviousYearMinus11DaysWP
# $lastSundayJanPreviousYearMinus14DaysSA
# $lastSundayJanPreviousYearMinus14DaysSP
#
# $lastSundayJanMinus04DaysWP
# $lastSundayJanMinus07DaysSA
# $lastSundayJanMinus07DaysSP
# $lastSundayJanMinus11DaysWP
# $lastSundayJanMinus14DaysSA
# $lastSundayJanMinus14DaysSP
#
# $lastSundayJanYearAfterMinus04DaysWP
# $lastSundayJanYearAfterMinus07DaysSA
# $lastSundayJanYearAfterMinus07DaysSP
# $lastSundayJanYearAfterMinus11DaysWP
# $lastSundayJanYearAfterMinus14DaysSA
# $lastSundayJanYearAfterMinus14DaysSP











if ($SingspirationJan -eq 1) {
	# See if you can do the subtraction math here for the nummber of services left to sign up for each Singspiration.
	# I'm guessing that it may be a complete report to just work backward to the beginning of the future year or the previous Singspiration in the future year being calculated.
	$lastSundayJan # This is the Singspiration date.
	$lastSundayJan.AddDays(-4) # Sunday PM event minus 4 days = Wednesday PM.
	# you are kinda here but maybe not (well, add previous/next years first). Ok, the previous/next years have been added above.
}










# Another idea. Loop through the year. If it's a Sunday or Wednesday
# This section of code comes from the PowerPoint date format script & might be useful if modified.
#$StartDate = Get-Date -Year ((Get-Date).year+1) -Month 01 -Day 01 # This gets the first day of next year.
$StartDate = Get-Date -Year $FutureYear -Month 01 -Day 01 # This gets the first day of next year.
#$EndDate = Get-Date -Year ((Get-Date).year+1) -Month 12 -Day 31 # This gets the last day of next year.
$EndDate = Get-Date -Year $FutureYear -Month 12 -Day 31 # This gets the last day of next year.
$ap = (Get-Date -Format "tt").ToLower().Substring(0,1) # This gets a single lowercase letter for A.M. or P.M., "a" or "p".
While ($StartDate -lt $EndDate) # This starts a while loop for the year.
{
	# Write-Output $((Get-Date -Date $StartDate -Format "yyyy-MM-dd ddd. ")+$ap+".") # This works for the date & time.  Now try other lines to change up the formatting some.  "t" for the first character of AM/PM.
	
	$day = $(Get-Date -Date $StartDate -Format "ddd").Substring(0,1).ToLower() # This makes a lowercase single letter of the first letter of the day of the week.  "smtwtfs"
	$datepptx = $((Get-Date -Date $StartDate -Format "yyyy-MM-dd")+$day+$ap+".pptx") # This formats the file name with the date & time like you normally do.
	$datepptxa = $((Get-Date -Date $StartDate -Format "yyyy-MM-dd")+$day+"a.pptx") # This formats the file name with the date & time like you normally do.  Always a.
	$datepptxp = $((Get-Date -Date $StartDate -Format "yyyy-MM-dd")+$day+"p.pptx") # This formats the file name with the date & time like you normally do.  Always p.
	
	# Write-Output $date
	
	# Now work on outputting different things based on the day of the week:
	$date = Get-Date -Date $StartDate

	If ($date.DayOfWeek -eq "Sunday")
	{
		# Do stuff during Sunday.
		# You need to work on statically setting "a" & "p" values for the file names since that's most common.
		#Write-Output $datepptx
		Write-Output $datepptxa
		#Copy-Item $NextYearChurchServicesFolder\$TemplateFile $NextYearChurchServicesFolder\$datepptxa
		Write-Output $datepptxp
		#Copy-Item $NextYearChurchServicesFolder\$TemplateFile $NextYearChurchServicesFolder\$datepptxp
	}

	If ($date.DayOfWeek -eq "Monday")
	{
		# Do stuff during Monday.
	}

	If ($date.DayOfWeek -eq "Tuesday")
	{
		# Do stuff during Tuesday.
	}

	If ($date.DayOfWeek -eq "Wednesday")
	{
		# Do stuff during Wednesday.
		#Write-Output $datepptx
		Write-Output $datepptxp
		#Copy-Item $NextYearChurchServicesFolder\$TemplateFile $NextYearChurchServicesFolder\$datepptxp
	}

	If ($date.DayOfWeek -eq "Thursday")
	{
		# Do stuff during Thursday.
	}

	If ($date.DayOfWeek -eq "Friday")
	{
		# Do stuff during Friday.
	}

	If ($date.DayOfWeek -eq "Saturday")
	{
		# Do stuff during Saturday.
	}

	# Write-Output $datepptx

	$StartDate = $StartDate.AddDays(1)
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

# Testing to see if a loop can be used from this function & the work above to generate a report.
# You are here (& above).










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








