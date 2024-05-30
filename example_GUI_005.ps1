# Init PowerShell GUI
Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$MyForm = New-Object System.Windows.Forms.Form
$MyForm.ClientSize = '500,300'
$MyForm.Text = "PowerShell GUI Example"
$MyForm.BackColor = "#ffffff"

# Create a MenuStrip
$MenuStrip = New-Object System.Windows.Forms.MenuStrip

# File menu
$FileMenu = New-Object System.Windows.Forms.ToolStripMenuItem("File")
$MenuStrip.Items.Add($FileMenu)

# File menu items
$OpenMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Open")
$FileMenu.DropDownItems.Add($OpenMenuItem)

$SaveMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Save")
$FileMenu.DropDownItems.Add($SaveMenuItem)

$ExitMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Exit")
$ExitMenuItem.Add_Click({
    $MyForm.Close()
})
$FileMenu.DropDownItems.Add($ExitMenuItem)

# Help menu
$HelpMenu = New-Object System.Windows.Forms.ToolStripMenuItem("Help")
$MenuStrip.Items.Add($HelpMenu)

# Help menu items
$AboutMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("About")
$AboutMenuItem.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("This is a PowerShell GUI Example.", "About", [System.Windows.Forms.MessageBoxButtons]::OK)
})
$HelpMenu.DropDownItems.Add($AboutMenuItem)

# Add MenuStrip to the form
$MyForm.MainMenuStrip = $MenuStrip
$MyForm.Controls.Add($MenuStrip)

# Add a label
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Welcome to My PowerShell GUI!"
$Label.Location = '50,30'
$Label.AutoSize = $true
$MyForm.Controls.Add($Label)

# Add a checkbox
$Checkbox = New-Object System.Windows.Forms.CheckBox
$Checkbox.Text = "Is the user temporary?"
$Checkbox.Location = '50,70'
$Checkbox.AutoSize = $true
$MyForm.Controls.Add($Checkbox)

# Add radio buttons within a group box
$RadioGroup = New-Object System.Windows.Forms.GroupBox
$RadioGroup.Text = "Account Expiry:"
$RadioGroup.Location = '50,110'
$RadioGroup.Size = '200,100'  # Explicitly setting the size to ensure visibility

$Radio1 = New-Object System.Windows.Forms.RadioButton
$Radio1.Text = "7 days"
$Radio1.Location = '10,20'
$Radio1.AutoSize = $true
$RadioGroup.Controls.Add($Radio1)

$Radio2 = New-Object System.Windows.Forms.RadioButton
$Radio2.Text = "30 days"
$Radio2.Location = '10,40'
$Radio2.AutoSize = $true
$RadioGroup.Controls.Add($Radio2)

$Radio3 = New-Object System.Windows.Forms.RadioButton
$Radio3.Text = "90 days"
$Radio3.Location = '10,60'
$Radio3.AutoSize = $true
$RadioGroup.Controls.Add($Radio3)

$MyForm.Controls.Add($RadioGroup)

# Add a combobox (dropdown list)
$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Location = '50,220'
$ComboBox.Width = 150
$ComboBox.Items.AddRange(@("Option 1", "Option 2", "Option 3"))
$ComboBox.SelectedIndex = 0
$MyForm.Controls.Add($ComboBox)

# Add a button
$Button = New-Object System.Windows.Forms.Button
$Button.Text = "Click Me!"
$Button.Location = '50,260'
$Button.AutoSize = $true
$Button.Add_Click({
    # Action to perform when the button is clicked
    [System.Windows.Forms.MessageBox]::Show("Button clicked!", "Info", [System.Windows.Forms.MessageBoxButtons]::OK)
})
$MyForm.Controls.Add($Button)

# Display the form
[void]$MyForm.ShowDialog()
