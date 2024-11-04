<#
2024-10-06sp.
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

#>


# Import variables using dot sourcing:
# . .\public_GitHub_data\gitignore_data\variables.ps1
. .\gitignore_data\variables.ps1
# List variables:
Write-Output $NextYearChurchServicesFolder
Write-Output $TemplateFile

$StartDate = Get-Date -Year ((Get-Date).year+1) -Month 01 -Day 01 # This gets the first day of next year.
$EndDate = Get-Date -Year ((Get-Date).year+1) -Month 12 -Day 31 # This gets the last day of next year.

$Current_Service = ""
$Earliest_available_SA_service = ""
$Earliest_available_SP_service = ""
$Earliest_available_WP_service = ""
#Still troubleshooting initializing an array.
#$ap = (Get-Date -Format "tt").ToLower().Substring(0,1) # This gets a single lowercase letter for A.M. or P.M., "a" or "p".

# Get the number of church services in the year which will be used for the number of rows in the array::
$NumberOfChurchServices = 0
While ($StartDate -lt $EndDate) # This starts a while loop for the year.
{
	$date = Get-Date -Date $StartDate

	If ($date.DayOfWeek -eq "Sunday")
	{
		# Do stuff during Sunday.
		$NumberOfChurchServices = $NumberOfChurchServices + 2
	}

	If ($date.DayOfWeek -eq "Wednesday")
	{
		# Do stuff during Wednesday.
		$NumberOfChurchServices = $NumberOfChurchServices + 1
	}

	$StartDate = $StartDate.AddDays(1)
}
# Write-Output $NumberOfChurchServices # 157

$StartDate = Get-Date -Year ((Get-Date).year+1) -Month 01 -Day 01 # This gets the first day of next year.
$EndDate = Get-Date -Year ((Get-Date).year+1) -Month 12 -Day 31 # This gets the last day of next year.

# You are here.
# You're trying to initialize an array, hashtable, or something with the number or rows of church services next year & 4 columns.
# There's a few different options to try from a few different websites.
<#
https://www.google.com/search?q=powershell+initialize+multidimensional+array+100+rows+by+4+columns&sca_esv=778fd8ccaca240ed&sxsrf=ADLYWIKrnibOwiGlA-tVOTAKft1f4bKVLQ%3A1728866355827&ei=M2gMZ52VMqrEp84PhLOD4Q8&ved=0ahUKEwjd-oKI0YyJAxUq4skDHYTZIPwQ4dUDCA8&uact=5&oq=powershell+initialize+multidimensional+array+100+rows+by+4+columns&gs_lp=Egxnd3Mtd2l6LXNlcnAiQnBvd2Vyc2hlbGwgaW5pdGlhbGl6ZSBtdWx0aWRpbWVuc2lvbmFsIGFycmF5IDEwMCByb3dzIGJ5IDQgY29sdW1uczIFECEYoAEyBRAhGKABMgUQIRigATIFECEYoAEyBRAhGKABSKZXUPYLWLFRcAF4AZABAJgBXKABswGqAQEyuAEDyAEA-AEBmAIDoALDAcICChAAGLADGNYEGEfCAgYQABgWGB7CAggQABiiBBiJBcICCBAAGIAEGKIEmAMAiAYBkAYIkgcBM6AHkA0&sclient=gws-wiz-serp

https://stackoverflow.com/questions/9397137/powershell-multidimensional-arrays

https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-arrays?view=powershell-7.4

https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-hashtable?view=powershell-7.4

https://stackoverflow.com/questions/9397137/powershell-multidimensional-arrays/9397385#9397385
#>

$DateArray = New-Object 'object[,]' $NumberOfChurchServices, 4

# Populate the array with sample data (optional)
for ($i = 0; $i -lt $NumberOfChurchServices; $i++) {
    for ($j = 0; $j -lt 4; $j++) {
        $DateArray[$i, $j] = "Row $i, Column $j"
    }
}


$DateArray = @(
	@($NumberOfChurchServices),
	@($NumberOfChurchServices)
)

<#
$data = @(
    @(01,02,03,04),
    @(05,06,07,08),
    @(09,10,11,12)
)
Write-Output $data[0][0] # 1
Write-Output $data[2][3] # 12
#>


#Read more: https://www.sharepointdiary.com/2020/10/fix-cannot-index-into-a-null-array-error-in-powershell.html#ixzz8pu8vpf2R
$array = @()
$array = @()@()@()@()
$array = @(),@(),@(),@()
$array[0]
$array[0][0][0][0] = "stuff"
$array[0],[0],[0],[0] = "stuff"
# You need to solve this error (probably learn how to initialize the array):
# InvalidOperation: Cannot index into a null array.
# Maybe worth a Google:
# Why doesn't PowerShell automatically initialize arrays?
# How to make PowerShell automatically initialize arrays.





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

