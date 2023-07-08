function setSetting($old, $new) {
	$fileToCheck = "$userFolder\EmuDeck\settings.ps1"

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -ExpandProperty Line
	if ($line) {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$modifiedContents = $fileContents | ForEach-Object { $_.Replace($line, $newLine) }

		Set-Content -Path $fileToCheck -Value $modifiedContents

		Write-Host "Line '$line' changed to '$newLine'"
	} else {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$newLine += "`r`n"  # Agregar nueva línea al final del contenido
		Add-Content $fileToCheck $newLine

		Write-Host "New line '$newLine' created in $fileToCheck"
	}
}

function setSettingNoQuotes($file, $old, $new) {
	$fileToCheck = $file

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -ExpandProperty Line
	if ($line) {
		$newLine = -join($old, '=', $new)
		$modifiedContents = $fileContents | ForEach-Object { $_.Replace($line, $newLine) }

		Set-Content -Path $fileToCheck -Value $modifiedContents

		Write-Host "Line '$line' changed to '$newLine'"
	} else {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$newLine += "`r`n"  # Agregar nueva línea al final del contenido
		Add-Content $fileToCheck $newLine

		Write-Host "New line '$newLine' created in $fileToCheck"
	}
}

 function setConfig($old, $new, $fileToCheck){	

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line
	if ($line){
		$newLine=-join($old,'=',$new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)} -ErrorAction SilentlyContinue
	
		Set-Content -Path $fileToCheck -Value $modifiedContents
		Write-Output "Line $line changed to $newLine"
	}else{
		$newLine=-join($old,'=',$new)
		Add-Content $fileToCheck $newLine
		Write-Output "Line created on $fileToCheck"
	}

}

 function setConfigRA($old, $new, $fileToCheck){	

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line
	if ($line){
		$newLine=-join($old,' = ',$new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)} -ErrorAction SilentlyContinue
		
		Set-Content -Path $fileToCheck -Value $modifiedContents
		
		Write-Output "Line $line changed to $newLine"
	}else{
		$newLine=-join($old,' = ',$new)
		Add-Content $fileToCheck $newLine
		Write-Output "Line created on $fileToCheck"
	}


}


function customLocation(){
	$drives = (Get-PSDrive -PSProvider FileSystem).Root
	$winPath = showListDialog 'Select Destination' 'Please select where do you want to install EmuDeck:' $drives
	Start-Sleep -Seconds 0.5
	Write-Output $winPath;
}

function testLocationValid($mode, $path){
	if (!$path){
		Write-Output "Wrong"
	}else{
		Write-Output "Valid"
	}	
}

function escapeSedKeyword($input){
	Write-Output $input
}

function escapeSedValue($input){
	Write-Output $input
}

function changeLine($keyword, $replace, $file) {
	(Get-Content $file).replace($keyword, $replace) | Set-Content $file
}

function setMSG($message){
	$progressBarValue = Get-Content -Path $userFolder\AppData\Roaming\EmuDeck\msg.log -TotalCount 1 -ErrorAction SilentlyContinue
	$progressBarUpdate=[int]$progressBarValue+5

	#We prevent the UI to close if we have too much MSG, the classic eternal 99%
	if ( $progressBarUpdate -eq 95 ){
		$progressBarUpdate=90
	}
	"$progressBarUpdate" | Out-File -encoding ascii $userFolder\AppData\Roaming\EmuDeck\msg.log
	Write-Output $message
	Add-Content $userFolder\AppData\Roaming\EmuDeck\msg.log "# $message" -NoNewline
	Start-Sleep -Seconds 0.5
}



function checkForFile($fileName){
	(Get-ChildItem -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck" -Filter ".ui-finished" -Recurse -ErrorAction SilentlyContinue -Force) -and (Write-Output "true") ; rm -fo $dir/$fileName
}


function getLatestReleaseURLGH($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

	$url = "https://api.github.com/repos/$Repository/releases/latest"

	$url = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty assets | 
		   Where-Object { $_.browser_download_url -Match $FindToMatch -and $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } | 
		   Select-Object -ExpandProperty browser_download_url | Select-Object -First 1
		   return $url

	return $url
}

function getReleaseURLGH($Repository, $FileType, $IgnoreText = "pepe"){

    $url = "https://api.github.com/repos/$Repository/releases?per_page=1"
    $apiData = Invoke-RestMethod -Uri $url

    $releaseURL = $apiData.assets |
        Where-Object { $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } |
        Select-Object -ExpandProperty browser_download_url 
	return $releaseURL
}

function check_internet_connection(){

	if ((Test-Connection 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue).StatusCode -eq 0) { return "true" } else { return "false" }

}

function changeController($device){
	Write-Output "NYI"
}


function showDialog($text){
    Add-Type -AssemblyName System.Windows.Forms

    # Create an instance of the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "EmuDeck"
    $form.Width = 300
    $form.Height = 100
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    # Disable the maximize button
    $form.MaximizeBox = $false

	# Set the form to be topmost
	$form.TopMost = $true

    # Create an instance of the control Label to show the text
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "$text"
    $label.AutoSize = $true
    $label.Left = ($form.Width - $label.Width) / 3
    $label.Top = ($form.Height - $label.Height) / 3

    # Add the Label control to the form
    $form.Controls.Add($label)

    # Show the form and the text
    $form.Show()
    return $form
}

function showListDialog($title, $subtitle, $options){
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	
	$form = New-Object System.Windows.Forms.Form
	$form.Text = $title
	$form.Size = New-Object System.Drawing.Size(300,200)
	$form.StartPosition = 'CenterScreen'
	
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
	$label.Text = $subtitle
	$form.Controls.Add($label)
	
	$listBox = New-Object System.Windows.Forms.ListBox
	$listBox.Location = New-Object System.Drawing.Point(10,40)
	$listBox.Size = New-Object System.Drawing.Size(260,20)
	$listBox.Height = 80
	
	
	
	ForEach ($option in $options) { [void] $listBox.Items.Add($option) }
	
	$form.Controls.Add($listBox)
	
	$form.Topmost = $true
	
	$result = $form.ShowDialog()
	
	if ($result -eq [System.Windows.Forms.DialogResult]::OK)
	{
		return $listBox.SelectedItem
	}else{
		exit
	}
}

function showYesNoDialog($title, $desc){

	Add-Type -AssemblyName System.Windows.Forms

	$result = [System.Windows.Forms.MessageBox]::Show(
		"$desc",
		"$title",
		[System.Windows.Forms.MessageBoxButtons]::YesNo
	)
	
	return $result

}