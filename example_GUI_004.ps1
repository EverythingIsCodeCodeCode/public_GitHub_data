# Init PowerShell GUI
Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$LocalPrinterForm = New-Object System.Windows.Forms.Form
$LocalPrinterForm.ClientSize = '500,300'
$LocalPrinterForm.Text = "My PowerShell GUI Example"
$LocalPrinterForm.BackColor = "#ffffff"

# Add a label
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Welcome to My PowerShell GUI!"
$Label.Location = '50,20'
$LocalPrinterForm.Controls.Add($Label)

# Add a button
$Button = New-Object System.Windows.Forms.Button
$Button.Text = "Click Me!"
$Button.Location = '50,60'
$Button.Add_Click({
    # Action to perform when the button is clicked
    [System.Windows.Forms.MessageBox]::Show("Button clicked!", "Info", [System.Windows.Forms.MessageBoxButtons]::OK)
})
$LocalPrinterForm.Controls.Add($Button)

# Add an input field (textbox)
$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Location = '50,100'
$LocalPrinterForm.Controls.Add($TextBox)

# Display the form
[void]$LocalPrinterForm.ShowDialog()
