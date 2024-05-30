# Create a simple GUI window
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object Windows.Forms.Form
$form.Text = "My Simple GUI"
$form.Size = New-Object Drawing.Size(300, 200)

# Add a label
$label = New-Object Windows.Forms.Label
$label.Text = "Hello, World!"
$label.Location = New-Object Drawing.Point(50, 50)
$form.Controls.Add($label)

# Show the form
$form.ShowDialog()
