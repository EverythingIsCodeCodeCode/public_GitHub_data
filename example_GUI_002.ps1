# Init PowerShell GUI
Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$LocalPrinterForm = New-Object System.Windows.Forms.Form

# Define the size, title, and background color
$LocalPrinterForm.ClientSize = '500,300'
$LocalPrinterForm.Text = "My PowerShell GUI Example"
$LocalPrinterForm.BackColor = "#ffffff"

# Display the form
[void]$LocalPrinterForm.ShowDialog()
