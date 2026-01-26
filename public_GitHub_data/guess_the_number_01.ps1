<#
2026-01-25sp.
https://www.bing.com/search?q=powershell%20script%20guess%20the%20number%20game&qs=ds&form=ATCVAJ
This PowerShell script is a guess the number game.
#>

# Generate a random number between 1 and 100
$randomNumber = Get-Random -Minimum 1 -Maximum 101
$guess = 0
$attempts = 0
Write-Host "Welcome to the Guess the Number Game!"
Write-Host "I have picked a number between 1 and 100. Can you guess it?"
# Loop until the user guesses the correct number
while ($guess -ne $randomNumber) {
   $guess = [int](Read-Host "Enter your guess")
   $attempts++
   if ($guess -lt $randomNumber) {
       Write-Host "Too low! Try again." -ForegroundColor Yellow
   } elseif ($guess -gt $randomNumber) {
       Write-Host "Too high! Try again." -ForegroundColor Red
   } else {
       Write-Host "Congratulations! You guessed the number in $attempts attempts!" -ForegroundColor Green
   }
}
