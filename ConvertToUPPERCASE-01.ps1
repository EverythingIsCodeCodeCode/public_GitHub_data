<#
2024-05-22 Wed. 9:15a.
Made with ChatGPT.
This script will make a GUI window that lets people convert text to UPPERCASE.  To make a desktop icon shortcut, modify it to something similar to the line below:
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Path\To\Your\Script\UppercaseConverter.ps1"
It doesn't require Internet access.  The URIs are part of the standard .NET framework and are recognized by the XAML parser to render the GUI elements correctly.
#>

Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Uppercase Converter" Height="350" Width="400">
    <Grid>
        <TextBox Name="InputTextBox" Height="120" Margin="10,10,10,200" VerticalScrollBarVisibility="Auto" AcceptsReturn="True"/>
        <Button Name="ConvertButton" Content="Convert to Uppercase" Width="150" Height="40" HorizontalAlignment="Center" VerticalAlignment="Bottom" Margin="0,0,0,50"/>
        <TextBox Name="OutputTextBox" Height="120" Margin="10,140,10,90" VerticalScrollBarVisibility="Auto" IsReadOnly="True"/>
        <TextBlock Name="ClipboardStatus" Height="20" Margin="10,0,10,20" VerticalAlignment="Bottom" HorizontalAlignment="Center" TextAlignment="Center"/>
    </Grid>
</Window>
"@

# Load the XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Define the event handler for the button click
$convertToUppercase = {
    $inputText = $window.FindName("InputTextBox").Text
    $outputText = $inputText.ToUpper()
    $window.FindName("OutputTextBox").Text = $outputText

    # Copy the converted text to the clipboard
    [System.Windows.Clipboard]::SetText($outputText)
    $window.FindName("ClipboardStatus").Text = "Text copied to clipboard!"
}

# Attach the event handler to the button click event
$convertButton = $window.FindName("ConvertButton")
$convertButton.Add_Click($convertToUppercase)

# Show the window
$window.ShowDialog() | Out-Null
