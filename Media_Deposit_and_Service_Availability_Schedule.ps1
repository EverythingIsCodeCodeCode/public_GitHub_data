<#
2024-10-06sp.
I'm borrowing the portion of code from the "PowerPoint_date_format.ps1" script that worked & adapting it for getting a list of the dates for the media deposit & service availability schedule for the current year.

from any given current "sa" & "sp" service:  add 14 days for the earliest "sa", add 7 days for the earliest "sp", & add 10 days for the earliest "wp".
from any given current "wp" service:  add 11 days for the earliest "sa", 4 days for the earliest "sp", & 7 days for the earliest "wp".
#>


# Import variables using dot sourcing:
. .\public_GitHub_data\gitignore_data\variables.ps1
# List variables:
Write-Output $NextYearChurchServicesFolder
Write-Output $TemplateFile

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
		Copy-Item $NextYearChurchServicesFolder\$TemplateFile $NextYearChurchServicesFolder\$datepptxa
		Write-Output $datepptxp
		Copy-Item $NextYearChurchServicesFolder\$TemplateFile $NextYearChurchServicesFolder\$datepptxp
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
		Copy-Item $NextYearChurchServicesFolder\$TemplateFile $NextYearChurchServicesFolder\$datepptxp
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

