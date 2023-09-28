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
# For the loop, whatever one you end up using, first write a small something that checks at the end of the loop if this is the 365th time it's finishing
# and if it is then exit.

# Simple loop:
DO
{
$asdf = 0
# Append an incrementing number on the next line in a text file.
$asdf = $asdf + 1
} While ($asdf -lt 365)
