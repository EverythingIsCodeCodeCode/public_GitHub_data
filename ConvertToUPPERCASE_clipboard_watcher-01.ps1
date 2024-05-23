<#
2024-05-23 Thu. 10:32a.
ConvertToUPPERCASE_clipboard_watcher-01.ps1


Made with ChatGPT.
This script will watch the clipboard, convert text in it to UPPERCASE, and place it back in the clipboard so that it can be pasted.
To make a desktop icon shortcut, modify it to something similar to the line below:
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Path\To\Your\Script\UppercaseConverter.ps1"
#>

# Function to process clipboard content
function Process-Clipboard {
    $previousClipboardText = ""

    while ($true) {
        try {
            # Get the current clipboard content
            $currentClipboardText = Get-ClipboardText

            # Check if the clipboard text is not null or empty and has changed
            if (![string]::IsNullOrEmpty($currentClipboardText) -and $currentClipboardText -ne $previousClipboardText) {
                # Convert the text to uppercase
                $upperText = $currentClipboardText.ToUpper()

                # Set the new text to the clipboard
                Set-ClipboardText -Text $upperText

                # Update previous clipboard text to avoid duplicate processing
                $previousClipboardText = $upperText

                # Print to console for debugging
                Write-Output "Converted clipboard content to uppercase: $upperText"
            }

            # Wait for a short period before checking again
            Start-Sleep -Milliseconds 500
        } catch {
            # Handle any exceptions that might occur (e.g., clipboard being empty)
            Write-Output "Error accessing clipboard: $_"
            Start-Sleep -Milliseconds 500
        }
    }
}

# Function to get clipboard text
function Get-ClipboardText {
    try {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Clipboard]::GetText()
    } catch {
        Write-Output "Error getting clipboard text: $_"
        return $null
    }
}

# Function to set clipboard text
function Set-ClipboardText {
    param (
        [string]$Text
    )
    try {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Clipboard]::SetText($Text)
    } catch {
        Write-Output "Error setting clipboard text: $_"
    }
}

# Run the clipboard processing function
Process-Clipboard
