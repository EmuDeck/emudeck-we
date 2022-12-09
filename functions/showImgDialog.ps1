function showImgDialog(){
	
	$URL = "https://raw.githubusercontent.com/EmuDeck/emudeck-electron/main/src/assets/bezels.png"
	$Path= -join($userFolder,'/bezels.jpg')
	Invoke-WebRequest -URI $URL -OutFile $Path
	Add-Type -AssemblyName 'System.Windows.Forms'
	$file = (get-item "$userFolder/bezels.jpg")
	$img = [System.Drawing.Image]::Fromfile((get-item $file))
	[System.Windows.Forms.Application]::EnableVisualStyles();
	$form = new-object Windows.Forms.Form
	$form.Text = "Image Viewer"
	#$form.Width = 1440;
	#$form.Height =  720;
	$form.Size = New-Object System.Drawing.Size(1440,720)
	$form.StartPosition = 'CenterScreen'
	
	$pictureBox = new-object Windows.Forms.PictureBox
	$pictureBox.Width =  1280;
	$pictureBox.Height =  720;
	$pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
	
	$okButton = New-Object System.Windows.Forms.Button
	$okButton.Location = New-Object System.Drawing.Point(75,120)
	$okButton.Size = New-Object System.Drawing.Size(75,23)
	$okButton.Text = 'OK'
	$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$form.AcceptButton = $okButton
	$form.Controls.Add($okButton)
	
	$cancelButton = New-Object System.Windows.Forms.Button
	$cancelButton.Location = New-Object System.Drawing.Point(150,120)
	$cancelButton.Size = New-Object System.Drawing.Size(75,23)
	$cancelButton.Text = 'Cancel'
	$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
	$form.CancelButton = $cancelButton
	$form.Controls.Add($cancelButton)
	
	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,20)
	$label.Size = New-Object System.Drawing.Size(280,20)
	$label.Text = "TEXTO"
	$form.Controls.Add($label)
	
	$pictureBox.Image = $img;
	$form.controls.add($pictureBox)
	$form.Add_Shown( { $form.Activate() } )
	$result = $form.ShowDialog()
	
	return $result
	
}