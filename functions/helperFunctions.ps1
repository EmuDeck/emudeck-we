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

 function setConfig($old, $new, $fileToCheck){	

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line
	if ($line){
		$newLine=-join($old,'=',$new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)} -ErrorAction SilentlyContinue
	
		Set-Content -Path $fileToCheck -Value $modifiedContents
		echo "Line $line changed to $newLine"
	}else{
		$newLine=-join($old,'=',$new)
		Add-Content $fileToCheck $newLine
		echo "Line created on $fileToCheck"
	}

}

 function setConfigRA($old, $new, $fileToCheck){	

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line
	if ($line){
		$newLine=-join($old,' = ',$new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)} -ErrorAction SilentlyContinue
		
		Set-Content -Path $fileToCheck -Value $modifiedContents
		
		echo "Line $line changed to $newLine"
	}else{
		$newLine=-join($old,' = ',$new)
		Add-Content $fileToCheck $newLine
		echo "Line created on $fileToCheck"
	}


}


function customLocation(){
	$drives = (Get-PSDrive -PSProvider FileSystem).Root
	$winPath = showListDialog 'Select Destination' 'Please select where do you want to install EmuDeck:' $drives
	Start-Sleep -Seconds 0.5
	echo $winPath;
}

function testLocationValid(){
	echo "Valid"
}

function escapeSedKeyword($input){
	echo $input
}

function escapeSedValue($input){
	echo $input
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
	echo $message
	Add-Content $userFolder\AppData\Roaming\EmuDeck\msg.log "# $message" -NoNewline
	Start-Sleep -Seconds 0.5
}



function checkForFile($fileName){
	(Get-ChildItem -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck" -Filter ".ui-finished" -Recurse -ErrorAction SilentlyContinue -Force) -and (echo "true") ; rm -fo $dir/$fileName
}


function getLatestReleaseURLGH($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

	$url = "https://api.github.com/repos/$Repository/releases/latest"

	$url = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty assets | 
		   Where-Object { $_.browser_download_url -Match $FindToMatch -and $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } | 
		   Select-Object -ExpandProperty browser_download_url | Select-Object -First 1
		   return $url

	return $url
}

function check_internet_connection(){

	if ((Test-Connection 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue).StatusCode -eq 0) { return "true" } else { return "false" }

}

function changeController($device){
	Yuzu_setController($device)
	Citra_setController($device)
	Dolphin_setController($device)
}


function showDialog($text){
	Add-Type -AssemblyName System.Windows.Forms
	
	# Crea una instancia del formulario
	$form = New-Object System.Windows.Forms.Form
	$form.Text = "EmuDeck"
	$form.Width = 300
	$form.Height = 100
	$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
	$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
	
	# Oculta los controles de la ventana (Maximizar, Minimizar, Cerrar)
	$form.ControlBox = $false
	
	# Crea una instancia del control Label para mostrar el texto
	$label = New-Object System.Windows.Forms.Label
	$label.Text = "$text"
	$label.AutoSize = $true
	$label.Left = ($form.Width - $label.Width) / 2
	$label.Top = ($form.Height - $label.Height) / 3
	
	# Agrega el control Label al formulario
	$form.Controls.Add($label)
	
	# Muestra el formulario y el texto
	$form.Show()
	return $form
}