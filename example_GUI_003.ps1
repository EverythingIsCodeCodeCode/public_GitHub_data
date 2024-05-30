# Create a simple GUI window with buttons, labels, and text boxes
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object Windows.Forms.Form
$form.Text = "My Enhanced GUI"
$form.Size = New-Object Drawing.Size(400, 300)

# Add a label
$label = New-Object Windows.Forms.Label
$label.Text = "Welcome to My GUI!"
$label.Location = New-Object Drawing.Point(20, 20)
$form.Controls.Add($label)

# Add a button
$button = New-Object Windows.Forms.Button
$button.Text = "Click Me!"
$button.Location = New-Object Drawing.Point(20, 60)
$form.Controls.Add($button)

# Add a text box
$textBox = New-Object Windows.Forms.TextBox
$textBox.Location = New-Object Drawing.Point(20, 100)
$form.Controls.Add($textBox)

# Show the form
$form.ShowDialog()
