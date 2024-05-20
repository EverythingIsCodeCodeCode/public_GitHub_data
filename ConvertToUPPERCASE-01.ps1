<#
2024-05-19sp
This PowerShell function & script will convert text to UPPERCASE
#>

# function ConvertTo-Uppercase {
	function CTU {
		param (
			[string]$InputString
		)
	
		$upperCaseString = $InputString.ToUpper()
		return $upperCaseString
	}
	
	# Example usage:
	# $myString = "Hello, World!"
	$myString = Read-Host -Prompt "Type or paste text here to convert it to UPPERCASE."
	
	# $convertedString = ConvertTo-Uppercase -InputString $myString
	$convertedString = CTU -InputString $myString
	
	#$array01 = $convertedString
	#$array01 += "Uppercase string:"
	#$array01 += ""
	#$array01 += "$convertedString"
	#$array01 += ""
	#$array01 += "Your clipboard text is ready to paste."
	#$array01 += "Press Enter to close this window."
	#$array01 | Out-GridView -PassThru
	#This method doesn't display each line on its own row in a single Out-GridView window.
	
	Write-Host "Uppercase string:"
	Write-Host ""
	Write-Host "$convertedString"
	Write-Host ""
	Set-Clipboard -Value $convertedString
	Write-Host "Your clipboard text is ready to paste."
	Write-Host "Press Enter to close this window."
	Pause
	#When running this from a desktop shortcut icon, this method doesn't let you send text to the clipboard.  It also doesn't do it automatically.
	
	#$UppercaseString = "Uppercase string:"
	#$BlankLine = ""
	#$Clipboard = "Your clipboard text is ready to paste."
	#$Enter = "Press Enter to close this window."
	#Out-GridView -InputObject $UppercaseString, $BlankLine, $convertedString, $BlankLine, $Clipboard, $Enter -PassThru
	#Select-Object -InputObject $UppercaseString, $BlankLine, $convertedString, $BlankLine, $Clipboard, $Enter | Out-GridView -PassThru
	#These methods don't display each line on its own row in a single Out-GridView window.
	