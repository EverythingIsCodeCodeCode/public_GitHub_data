param([int]$year = (Get-Date).Year)

# Calculate Labor Day (first Monday in September)
$september1 = [DateTime]::new($year, 9, 1)
$offsetToLaborDay = (1 - [int]$september1.DayOfWeek + 7) % 7
$laborDay = $september1.AddDays($offsetToLaborDay)

# Sunday before Labor Day
$sundayBefore = $laborDay.AddDays(-1)

# Calculate the fifth Sunday in August
$august1 = [DateTime]::new($year, 8, 1)
$offsetToFirstSunday = (0 - [int]$august1.DayOfWeek + 7) % 7
$firstSundayAug = $august1.AddDays($offsetToFirstSunday)
$fifthSundayAug = $firstSundayAug.AddDays(28)

# Check if they match
if ($sundayBefore -eq $fifthSundayAug) {
    Write-Host "Yes, the Sunday before Labor Day is the fifth Sunday in August for year $year."
} else {
    Write-Host "No, the Sunday before Labor Day is not the fifth Sunday in August for year $year."
    Write-Host "Labor Day: $laborDay"
    Write-Host "Sunday before Labor Day: $sundayBefore"
    Write-Host "Fifth Sunday in August: $fifthSundayAug"
}
