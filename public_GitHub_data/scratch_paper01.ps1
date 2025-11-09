Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Sample GUI'
$form.Size = New-Object System.Drawing.Size(400,300)
$form.StartPosition = 'CenterScreen'

# Create a button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(150,120)
$button.Size = New-Object System.Drawing.Size(100,40)
$button.Text = 'Click Me!'
$button.Add_Click({
	[System.Windows.Forms.MessageBox]::Show('Hello, World!', 'Message')
})

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(150,80)
$label.Size = New-Object System.Drawing.Size(200,20)
$label.Text = 'Welcome to PowerShell GUI'

# Add controls to the form
$form.Controls.Add($button)
$form.Controls.Add($label)

# Show the form
$form.ShowDialog()
