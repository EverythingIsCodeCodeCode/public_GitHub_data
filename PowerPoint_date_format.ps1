<#
2023-09-10 Sunday 7:54p.
This script generates the church service dates for next year.

#>


$Number = 0
$DaysInYear = 365
# 12 December always has 31 days so 12-31 is always the last day of the year.  Good for scripts :) .
# This next line knows what day of the week the first of next year is.
$test = Get-Date -Year ((Get-Date).year+1) -Month 01 -Day 01; Write-Output -InputObject '$test'; Write-Output -InputObject $test; Write-Output -InputObject " "
Write-Output -InputObject '$test.Date'; $test.Date; Write-Output -InputObject " "
Write-Output -InputObject '$test.Day'; $test.Day; Write-Output -InputObject " "
Write-Output -InputObject '$test.DayOfWeek'; $test.DayOfWeek; Write-Output -InputObject " "
Write-Output -InputObject '$test.DayOfYear'; $test.DayOfYear; Write-Output -InputObject " "
Write-Output -InputObject '$test.Hour'; $test.Hour; Write-Output -InputObject " "
Write-Output -InputObject '$test.Kind'; $test.Kind; Write-Output -InputObject " "
Write-Output -InputObject '$test.Millisecond'; $test.Millisecond; Write-Output -InputObject " "
Write-Output -InputObject '$test.Minute'; $test.Minute; Write-Output -InputObject " "
Write-Output -InputObject '$test.Month'; $test.Month; Write-Output -InputObject " "
Write-Output -InputObject '$test.Second'; $test.Second; Write-Output -InputObject " "
Write-Output -InputObject '$test.Ticks'; $test.Ticks; Write-Output -InputObject " "
Write-Output -InputObject '$test.TimeOfDay'; $test.TimeOfDay; Write-Output -InputObject " "
Write-Output -InputObject '$test.Year'; $test.Year; Write-Output -InputObject " "
Write-Output -InputObject '$test.DisplayHint'; $test.DisplayHint; Write-Output -InputObject " "
Write-Output -InputObject '$test.DateTime'; $test.DateTime; Write-Output -InputObject " "
Write-Output -InputObject '$test.ToUniversalTime()'; $test.ToUniversalTime(); Write-Output -InputObject " "
# Write-Output -InputObject '#$test.GetDateTimeFormats()'; #$test.GetDateTimeFormats(); Write-Output -InputObject " "
Write-Output -InputObject '$test.GetHashCode()'; $test.GetHashCode(); Write-Output -InputObject " "
# Write-Output -InputObject '$test.GetType()'; $test.GetType(); Write-Output -InputObject " "
Write-Output -InputObject '$test.GetTypeCode()'; $test.GetTypeCode(); Write-Output -InputObject " "
Write-Output -InputObject '$test.IsDaylightSavingTime()'; $test.IsDaylightSavingTime(); Write-Output -InputObject " "



# Get the last two digits of next year (next 3 lines)
$NextYear = (Get-Date).year+1
$NextYearString = $NextYear | Out-String
$NextYearString = $NextYearString.subString(2,2)

$Month = "01"
$Day = "01"

DO
{
$Number = $Number + 1
#2018-12-03 Mon. 6:41p.
#This script will generate a PowerPoint file name using the naming convention used for Sunday morning, Sunday night, & Wednesday night.
#It will not generate proper file names for other church times such as Monday & Tuesday night revivals.
$Date1 = (Get-Date).AddDays($Number) | Get-Date -Format $NextYearString-MM-dd
#$Date1 = $Date1 -Format yy-MM-dd
#Write-Host $Date1
$Date2 = (Get-Date).AddDays($Number) | Get-Date -Format ddd
$Date2 = $Date2.ToLower() | Out-String
$Date2 = $Date2.subString(0, [System.Math]::Min(1, $Date2.Length))
#Write-Host $Date2
$Date3 = (Get-Date).AddDays($Number) | Get-Date -Format tt
$Date3 = $Date3.ToLower() | Out-String
$Date3 = $Date3.subString(0, [System.Math]::Min(1, $Date3.Length))
#Write-Host $Date3
$Date4 = ".pptx"
$Date5 = $Date1+$Date2+$Date3+$Date4
$DayOfWeek = (Get-Date).AddDays($Number) # NOT WORKING YET - NEED A WAY TO SEE WHAT NAMED DAY OF THE WEEK YOU'RE ON.
$DayOfWeek = (Get-Date).DayOfWeek # NOT WORKING YET - NEED A WAY TO SEE WHAT NAMED DAY OF THE WEEK YOU'RE ON. # Check what the day of the week is.  Monday, Tuesday, etcetera.
If ($DayOfWeek = "Wednesday")
{
Write-Host $Date5 | Sort-Object -Descending
# Write-Host $Date5 | Sort-Object -Descending
}
$DaysInYear = $DaysInYear - 1
# Write-Host $DaysInYear
} While ($DaysInYear -gt 0)



# Ok, getting a fresh start further on down and leaving the code up above while I'm developing this.
# For the loop, whatever one you end up using, first write a small something that checks at the end of the loop if this is 12-31 then exit.

# Simple loop - try 01:
$asdf = Get-Date -Year ((Get-Date).year+1) -Month 01 -Day 01; Write-Output -InputObject '$test'; Write-Output -InputObject $asdf; Write-Output -InputObject " "
DO
{
# $something = 0
# Append an incrementing number on the next line in a text file.
Write-Output $asdf
$asdf = $asdf.AddDays(1)
} While (($asdf.Year -lt ($asdf.year + 1)) -and ($asdf.Month -lt 13) -and ($asdf.Day -lt 32))




# Simple loop - try 02:
#ChatGPT, & Google Bard didn't quite get me there.  Bing Chat gave me this great loop idea which was exactly what I was looking for!:
$StartDate = Get-Date -Year ((Get-Date).year+1) -Month 01 -Day 01 # This gets the first day of next year.
$EndDate = Get-Date -Year ((Get-Date).year+1) -Month 12 -Day 31 # This gets the last day of next year.
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
		Write-Output $datepptxp
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

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-date?view=powershell-7.3
# https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings?view=netframework-4.8

#End of script.
