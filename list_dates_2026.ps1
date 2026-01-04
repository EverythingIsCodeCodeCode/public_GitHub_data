# PowerShell script to list all dates in 2026 in YYYY-MM-DD Weekday format

$year = 2026
$startDate = Get-Date "$year-01-01"
$endDate = Get-Date "$year-12-31"
$dates = @()

for ($date = $startDate; $date -le $endDate; $date = $date.AddDays(1)) {
    $formatted = $date.ToString("yyyy-MM-dd dddd")
    $dates += $formatted
}

$dates | Out-File "dates_$year.txt"
