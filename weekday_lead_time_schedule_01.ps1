
<#
2025-11-25 Tue. 4p.
weekday_lead_time_schedule_01.ps1

Generate a list of weekdays for a given year (column A) and compute a two-week
lead date for each (column B). Weekends and configured holidays/skip-days are
excluded from the primary list. Optionally adjust lead dates to the next
business day if they fall on weekends/holidays.

Usage examples:
  # Generate for 2025 and write CSV to current folder
  pwsh ./weekday_lead_time_schedule_01.ps1 -Year 2025

  # Provide an explicit output path and a holiday file
  pwsh ./weekday_lead_time_schedule_01.ps1 -Year 2026 -OutputPath C:\temp\schedule.csv -HolidayFile C:\temp\holidays.txt

  # Adjust lead dates forward to next business day if they fall on weekends/holidays
  pwsh ./weekday_lead_time_schedule_01.ps1 -Year 2025 -AdjustLeadToBusinessDay

Holidays file format (one date per line, any parseable date, e.g.)
  2025-01-01
  2025-12-25

Edit the `$DefaultHolidays` array below to add fixed known holidays, or pass a
holiday file with `-HolidayFile` or extra dates via `-ExtraHolidays`.
#>

Param(
	[Parameter(Position=0)]
	[int]$Year = (Get-Date).Year,

	[Parameter(Position=1)]
	[string]$OutputPath = (Join-Path -Path (Get-Location) -ChildPath "weekday_lead_time_schedule_$((Get-Date -Year $Year -Month 1 -Day 1).Year).csv"),

	[Parameter(Position=2)]
	[string]$HolidayFile = "",

	[Parameter()]
	[string[]]$ExtraHolidays = @(),

	[switch]$AdjustLeadToBusinessDay
)

function Parse-DateSafe {
	param([string]$s)
	try {
		return [datetime]::Parse($s)
	} catch {
		return $null
	}
}

# -------------------------
# Define default holidays here (edit as needed)
# -------------------------
$DefaultHolidays = @(
	# Examples (year-agnostic; you can replace with date strings specific to the year):
	# "2025-01-01", "2025-12-25"
)

# Merge extra holidays passed on the command line
if ($ExtraHolidays) {
	$DefaultHolidays += $ExtraHolidays
}

# If a holiday file is provided, read and add its lines
if ($HolidayFile -and (Test-Path $HolidayFile)) {
	$fileLines = Get-Content -Path $HolidayFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
	$DefaultHolidays += $fileLines
}

# Parse and normalize holidays to Date objects
$HolidayDates = $DefaultHolidays | ForEach-Object { Parse-DateSafe $_ } | Where-Object { $_ -ne $null } | ForEach-Object { $_.Date } | Sort-Object -Unique

# Build schedule for the year: weekdays only, excluding holidays
$StartDate = Get-Date -Year $Year -Month 1 -Day 1
$EndDate   = Get-Date -Year $Year -Month 12 -Day 31

$Rows = [System.Collections.Generic.List[object]]::new()

for ($d = $StartDate; $d -le $EndDate; $d = $d.AddDays(1)) {
	# Skip weekends
	if ($d.DayOfWeek -eq 'Saturday' -or $d.DayOfWeek -eq 'Sunday') { continue }

	# Skip configured holidays
	if ($HolidayDates -contains $d.Date) { continue }

	$lead = $d.AddDays(14)

	if ($AdjustLeadToBusinessDay) {
		while ($lead.DayOfWeek -eq 'Saturday' -or $lead.DayOfWeek -eq 'Sunday' -or ($HolidayDates -contains $lead.Date)) {
			$lead = $lead.AddDays(1)
		}
	}

	$Rows.Add([PSCustomObject]@{
		Date = $d.ToString('yyyy-MM-dd')
		LeadDate = $lead.ToString('yyyy-MM-dd')
	})
}

# Ensure output folder exists
$outDir = Split-Path -Path $OutputPath -Parent
if (-not (Test-Path $outDir)) {
	New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}

$Rows | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host "Wrote $($Rows.Count) rows to $OutputPath"

