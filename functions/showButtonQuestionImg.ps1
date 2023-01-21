function showButtonQuestionImg($img, $titleText, $subtitleText, $button1Text, $button2Text, $button3Text, $button4Text){
	
	$paddingLeft= 32	
	$paddingTop= 50
	$subtitleTop= 128
	$textColor="183,182,177"
	$imgTop= 172
	$buttonBorder="85, 187, 255"
	$buttonBG="white"
	$buttonColor="69,70,67"
	$buttonSeparation=90
			
	$URL = -join("https://raw.githubusercontent.com/EmuDeck/emudeck-electron/main/src/assets/",$img)
	$Path= -join($userFolder,'/',$img)
	
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
	$button1 = New-Object System.Windows.Forms.Button
	$button1.Location = New-Object System.Drawing.Point(682,180)
	$button1.Size = New-Object System.Drawing.Size(120,75)
	$button1.Text = $button1Text
	$button1.ForeColor = $buttonColor
	$button1.BackColor = $buttonBG;
	$button1.Font = New-Object System.Drawing.Font("Verdana",18,[System.Drawing.FontStyle]::Bold)
	$button1.DialogResult = [System.Windows.Forms.DialogResult]::Yes
	#$form.button1 = $button1
	$form.Controls.Add($button1)
	
	$button2 = New-Object System.Windows.Forms.Button
	$button2.Location = New-Object System.Drawing.Point(682,(180 + $buttonSeparation))
	$button2.Size = New-Object System.Drawing.Size(120,75)
	$button2.Text = $button2Text
	$button2.ForeColor = $buttonColor
	$button2.BackColor = $buttonBG;
	$button2.Font = New-Object System.Drawing.Font("Verdana",18,[System.Drawing.FontStyle]::Bold)
	$button2.DialogResult = [System.Windows.Forms.DialogResult]::No
	#$form.button2 = $button2
	$form.Controls.Add($button2)
	
	if($button3Text){
		$button3 = New-Object System.Windows.Forms.Button
		$button3.Location = New-Object System.Drawing.Point(682,(180 + $buttonSeparation * 2 ))
		$button3.Size = New-Object System.Drawing.Size(120,75)
		$button3.Text = $button3Text
		$button3.ForeColor = $buttonColor
		$button3.BackColor = $buttonBG;
		$button3.Font = New-Object System.Drawing.Font("Verdana",18,[System.Drawing.FontStyle]::Bold)
		$button3.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
		#$form.button3 = $button3
		$form.Controls.Add($button3)
	}
	if($button4Text){
		$button4 = New-Object System.Windows.Forms.Button
		$button4.Location = New-Object System.Drawing.Point(682,(180 + $buttonSeparation * 3 ))
		$button4.Size = New-Object System.Drawing.Size(120,75)
		$button4.Text = $button4Text
		$button4.ForeColor = $buttonColor
		$button4.BackColor = $buttonBG;
		$button4.Font = New-Object System.Drawing.Font("Verdana",18,[System.Drawing.FontStyle]::Bold)
		$button4.DialogResult = [System.Windows.Forms.DialogResult]::Abort	
		$form.Controls.Add($button4)
	}

	$form.Add_Shown( { $form.Activate() } )
	$result = $form.ShowDialog()
	
	if($result -eq 'Yes'){
		$result=$button1Text
	}
	
	switch ( $result )
	{
		'Yes' { $result = $button1Text }
		'No' { $result = $button2Text    }
		'Cancel' { $result = $button3Text   }
		'Abort' { $result = $button4Text }
	}
	
	return $result
	
}