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
	$SingspirationAug = 1 # The number of Sundays in August in the future year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInAugPreviousYear -le 4) {
	$SingspirationAugPreviousYear = 0 # The number of Sundays in August in the Previous Year is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInAugPreviousYear -ge 5) {
	$SingspirationAugPreviousYear = 1 # The number of Sundays in August in the Previous Year is 5 or more so we'll have Singspiration this month.
}

if ($NumberOfSundaysInAugYearAfter -le 4) {
	$SingspirationAugYearAfter = 0 # The number of Sundays in August in the Year After is 4 or less so we won't have Singspiration this month.
}
if ($NumberOfSundaysInAugYearAfter -ge 5) {
	$SingspirationAugYearAfter = 1 # The number of Sundays in August in the Year After is 5 or more so we'll have Singspiration this month.
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

# You are here (& testing things below) - adding $PreviousYear & $YearAfter to the code.

if ($SingspirationJanPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
}
if ($SingspirationFebPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}
if ($SingspirationMarPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).
}
if ($SingspirationAprPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}
if ($SingspirationMayPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}
if ($SingspirationJunPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}
if ($SingspirationJulPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}
if ($SingspirationAugPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}
if ($SingspirationSepPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}
if ($SingspirationOctPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}
if ($SingspirationNovPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}
if ($SingspirationDecPreviousYear -eq 1) {
	#Calculate the 7 previous church service dates/times for Singspiration (see above).	
}











if ($SingspirationJan -eq 1) {
	# See if you can do the subtraction math here for the nummber of services left to sign up for each Singspiration.
	# I'm guessing that it may be a complete report to just work backward to the beginning of the future year or the previous Singspiration in the future year being calculated.
	$lastSundayJan # This is the Singspiration date.
	$lastSundayJan.AddDays(-4) # Sunday PM event minus 4 days = Wednesday PM.
	# you are kinda here but maybe not (well, add previous/next years first)
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








