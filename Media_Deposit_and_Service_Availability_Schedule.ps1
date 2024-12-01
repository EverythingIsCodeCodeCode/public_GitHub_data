<#
2024-10-06sp.
This script works now :) .

I'm borrowing the portion of code from the "PowerPoint_date_format.ps1" script that worked & adapting it for getting a list of the dates for the media deposit & service availability schedule for the current year.

from any given current "sa" & "sp" service:  add 14 days for the earliest "sa", add 7 days for the earliest "sp", & add 10 days for the earliest "wp".
from any given current "wp" service:  add 11 days for the earliest "sa", 4 days for the earliest "sp", & 7 days for the earliest "wp".

Make a table of dates for in YYYY-MM-DD format for 2025.
In the first column, only include Sunday morning, Sunday night, & Wednesday.
In the second column, for each date in the first column that is Sunday, add 14 days.
In the third column, for each date in the first column that is Sunday, add 7 days.
In the fourth column, for each date in the first column that is Sunday, add 10 days.
In the second column, for each date in the first column that is Wednesday, add 11 days.
In the third column, for each date in the first column that is Wednesday, add 4 days.
In the fourth column, for each date in the first column that is Wednesday, add 7 days.
The columns & rows go in thirds.  For each SA, SP, & WP, the available dates are the same so you can copy the first row & paste it two more down.

#>


# Import variables using dot sourcing:
. .\gitignore_data\variables.ps1
# List variables:
Write-Output $NextYearChurchServicesFolder
Write-Output $TemplateFile

$StartDate = Get-Date -Year ((Get-Date).year+1) -Month 01 -Day 01 # This gets the first day of next year.
$EndDate = Get-Date -Year ((Get-Date).year+1) -Month 12 -Day 31 # This gets the last day of next year.

#If next year church services 404 folder doesn't exist then make it.
If (-not(Test-Path $NextYearChurchServicesFolder)){New-Item -ItemType Directory -Path $NextYearChurchServicesFolder} else {Write-Output -InputObject "Found folder:  `"$NextYearChurchServicesFolder`"."}

#While ($StartDate -lt $EndDate.AddDays(-1)) # This starts a while loop for the year.
While ($StartDate -lt $EndDate) # This starts a while loop for the year.
{
	$day = $(Get-Date -Date $StartDate -Format "ddd").Substring(0,1).ToLower() # This makes a lowercase single letter of the first letter of the day of the week.  "smtwtfs"
	$datepptxa = $((Get-Date -Date $StartDate -Format "yyyy-MM-dd")+$day+"a") # This formats the file name with the date & time like you normally do.  Always a.
	$datepptxp = $((Get-Date -Date $StartDate -Format "yyyy-MM-dd")+$day+"p") # This formats the file name with the date & time like you normally do.  Always p.
	$SundayAMEarliestSAService = $((Get-Date -Date $StartDate.AddDays(14) -Format "yyyy-MM-dd")+"sa") # This formats the file name with the date & time like you normally do.  Always a.
	$SundayAMEarliestSPService = $((Get-Date -Date $StartDate.AddDays(7) -Format "yyyy-MM-dd")+"sp") # This formats the file name with the date & time like you normally do.  Always p.
	$SundayAMEarliestWPService = $((Get-Date -Date $StartDate.AddDays(10) -Format "yyyy-MM-dd")+"wp") # This formats the file name with the date & time like you normally do.  Always p.
	$SundayPMEarliestSAService = $((Get-Date -Date $StartDate.AddDays(14) -Format "yyyy-MM-dd")+"sa") # This formats the file name with the date & time like you normally do.  Always a.
	$SundayPMEarliestSPService = $((Get-Date -Date $StartDate.AddDays(7) -Format "yyyy-MM-dd")+"sp") # This formats the file name with the date & time like you normally do.  Always p.
	$SundayPMEarliestWPService = $((Get-Date -Date $StartDate.AddDays(10) -Format "yyyy-MM-dd")+"wp") # This formats the file name with the date & time like you normally do.  Always p.
	$WednesdayEarliestSAService = $((Get-Date -Date $StartDate.AddDays(11) -Format "yyyy-MM-dd")+"sa") # This formats the file name with the date & time like you normally do.  Always a.
	$WednesdayEarliestSPService = $((Get-Date -Date $StartDate.AddDays(4) -Format "yyyy-MM-dd")+"sp") # This formats the file name with the date & time like you normally do.  Always p.
	$WednesdayEarliestWPService = $((Get-Date -Date $StartDate.AddDays(7) -Format "yyyy-MM-dd")+"wp") # This formats the file name with the date & time like you normally do.  Always p.

	# Now work on outputting different things based on the day of the week:
	$date = Get-Date -Date $StartDate

	If ($date.DayOfWeek -eq "Sunday")
	{
		# Do stuff during Sunday.
		Write-Output $datepptxa
		Write-Output $datepptxp
		$Output = $datepptxa
		$Output | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearChurchServicesNot-CSV.txt -Append
		$Output = $datepptxp
		$Output | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearChurchServicesNot-CSV.txt -Append
		$SundayAMEarliestSAService | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearEarliestSAServicesNot-CSV.txt -Append
		$SundayAMEarliestSPService | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearEarliestSPServicesNot-CSV.txt -Append
		$SundayAMEarliestWPService | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearEarliestWPServicesNot-CSV.txt -Append
		$SundayPMEarliestSAService | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearEarliestSAServicesNot-CSV.txt -Append
		$SundayPMEarliestSPService | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearEarliestSPServicesNot-CSV.txt -Append
		$SundayPMEarliestWPService | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearEarliestWPServicesNot-CSV.txt -Append
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
		Write-Output $datepptxp
		$Output = $datepptxp
		$Output | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearChurchServicesNot-CSV.txt -Append
		$WednesdayEarliestSAService | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearEarliestSAServicesNot-CSV.txt -Append
		$WednesdayEarliestSPService | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearEarliestSPServicesNot-CSV.txt -Append
		$WednesdayEarliestWPService | Tee-Object -FilePath $NextYearChurchServicesFolder\NextYearEarliestWPServicesNot-CSV.txt -Append
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

	$StartDate = $StartDate.AddDays(1)
}

#End of script.

