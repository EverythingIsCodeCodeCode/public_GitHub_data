# Init PowerShell GUI
Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$MyForm = New-Object System.Windows.Forms.Form
$MyForm.ClientSize = '500,300'
$MyForm.Text = "PowerShell GUI Example"
$MyForm.BackColor = "#ffffff"

# Add a label
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Welcome to My PowerShell GUI!"
$Label.Location = '50,20'
$MyForm.Controls.Add($Label)

# Add a checkbox
$Checkbox = New-Object System.Windows.Forms.CheckBox
$Checkbox.Text = "Is the user temporary?"
$Checkbox.Location = '50,60'
$MyForm.Controls.Add($Checkbox)

# Add radio buttons
$RadioGroup = New-Object System.Windows.Forms.GroupBox
$RadioGroup.Text = "Account Expiry:"
$RadioGroup.Location = '50,100'

$Radio1 = New-Object System.Windows.Forms.RadioButton
$Radio1.Text = "7 days"
$Radio1.Location = '10,20'
$RadioGroup.Controls.Add($Radio1)

$Radio2 = New-Object System.Windows.Forms.RadioButton
$Radio2.Text = "30 days"
$Radio2.Location = '10,40'
$RadioGroup.Controls.Add($Radio2)

$Radio3 = New-Object System.Windows.Forms.RadioButton
$Radio3.Text = "90 days"
$Radio3.Location = '10,60'
$RadioGroup.Controls.Add($Radio3)

$MyForm.Controls.Add($RadioGroup)

# Add a combobox (dropdown list)
$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Location = '50,210'
$ComboBox.Items.AddRange(@("Option 1", "Option 2", "Option 3"))
$ComboBox.SelectedIndex = 0
$MyForm.Controls.Add($ComboBox)

# Add a button
$Button = New-Object System.Windows.Forms.Button
$Button.Text = "Click Me!"
$Button.Location = '50,240'
$Button.Add_Click({
    # Action to perform when the button is clicked
    [System.Windows.Forms.MessageBox]::Show("Button clicked!", "Info", [System.Windows.Forms.MessageBoxButtons]::OK)
})
$MyForm.Controls.Add($Button)

# Display the form
[void]$MyForm.ShowDialog()
