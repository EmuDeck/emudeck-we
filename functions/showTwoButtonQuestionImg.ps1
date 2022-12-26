function showTwoButtonQuestionImg($img, $titleText, $subtitleText, $button1Text, $button2Text){
	
	$paddingLeft= 32	
	$paddingTop= 50
	$subtitleTop= 128
	$textColor="183,182,177"
	$imgTop= 172
	$buttonBorder="85, 187, 255"
	$buttonBG="white"
	$buttonColor="69,70,67"
	

		
	$URL = -join("https://raw.githubusercontent.com/EmuDeck/emudeck-electron/main/src/assets/",$img)
	$Path= -join($HOME,'/',$img)

	
	
	Invoke-WebRequest -URI $URL -OutFile $Path
	Add-Type -AssemblyName 'System.Windows.Forms'
	$file = (get-item $Path)
	$img = [System.Drawing.Image]::Fromfile((get-item $file))
	[System.Windows.Forms.Application]::EnableVisualStyles();
	$form = new-object Windows.Forms.Form
	$form.Text = "EmuDeck"
	#$form.Width = 1280;
	#$form.Height =  800;	
	$form.Size = New-Object System.Drawing.Size(1280,720)
	$form.StartPosition = 'CenterScreen'
	$form.BackColor = '34, 34, 42'
	
	
	#Title
	$title = New-Object System.Windows.Forms.label
	$title.Location = New-Object System.Drawing.Size($paddingLeft,$paddingTop)	
	$title.AutoSize = "true"	
	$title.ForeColor = "White"	
	$title.Text = $titleText
	$title.Font = New-Object System.Drawing.Font("Verdana",32,[System.Drawing.FontStyle]::Bold)
	$form.Controls.Add($title)
	
	#SubTitle
	$subtitle = New-Object System.Windows.Forms.label
	$subtitle.Location = New-Object System.Drawing.Size($paddingLeft,$subtitleTop)	
	$subtitle.AutoSize = "true"
	$subtitle.ForeColor = $textColor	
	$subtitle.Text = $subtitleText
	$subtitle.Font = New-Object System.Drawing.Font("Verdana",16,[System.Drawing.FontStyle]::Regular)
	$form.Controls.Add($subtitle)
	
	#Image
	$pictureBox = new-object Windows.Forms.PictureBox
	$pictureBox.Width =  630;
	$pictureBox.Height =  370;
	$pictureBox.Location = New-Object System.Drawing.Size($paddingLeft,$imgTop)	
	$pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
	$pictureBox.Image = $img;
	$form.controls.add($pictureBox)
	
	#Buttons
	$okButton = New-Object System.Windows.Forms.Button
	$okButton.Location = New-Object System.Drawing.Point(682,180)
	$okButton.Size = New-Object System.Drawing.Size(75,75)
	$okButton.Text = $button1Text
	$okButton.ForeColor = $buttonColor
	$okButton.BackColor = $buttonBG;
	$okButton.Font = New-Object System.Drawing.Font("Verdana",18,[System.Drawing.FontStyle]::Bold)
	$okButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes

	$form.AcceptButton = $okButton
	$form.Controls.Add($okButton)
	
	$cancelButton = New-Object System.Windows.Forms.Button
	$cancelButton.Location = New-Object System.Drawing.Point(682,272)
	$cancelButton.Size = New-Object System.Drawing.Size(75,75)
	$cancelButton.Text = $button2Text
	$cancelButton.ForeColor = $buttonColor
	$cancelButton.BackColor = $buttonBG;
	$cancelButton.Font = New-Object System.Drawing.Font("Verdana",18,[System.Drawing.FontStyle]::Bold)
	$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::No
	$form.CancelButton = $cancelButton
	$form.Controls.Add($cancelButton)
	

	

	$form.Add_Shown( { $form.Activate() } )
	$result = $form.ShowDialog()
	
	return $result
	
}