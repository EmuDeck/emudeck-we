$rclone_path="$toolsPath/rclone"
$rclone_bin="$rclone_path/rclone.exe"
$rclone_config="$rclone_path/rclone.conf"


function rclone_install($rclone_provider){	
	$rclone_releaseURL = getLatestReleaseURLGH 'rclone/rclone' 'zip' 'windows-amd64'
	download $rclone_releaseURL "rclone.zip"	
	setSetting "rclone_provider" "$rclone_provider"
	. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1
	$regex = '^.*\/(rclone-v\d+\.\d+\.\d+-windows-amd64\.zip)$'
	
	if ($rclone_releaseURL -match $regex) {
		
		$filename = $matches[1]
		
		$filename = $filename.Replace('.zip','')
		
		Rename-Item "temp\rclone\$filename" -NewName "rclone" 
		
		moveFromTo "temp/rclone/" "$toolsPath\"	
		Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$toolsPath/rclone"
		rm -fo  "temp\rclone" -Recurse
	}
}

function rclone_config($rclone_provider){
	& $rclone_bin config update "$rclone_provider" 
	
	Add-Type -AssemblyName PresentationFramework
	[System.Windows.MessageBox]::Show("Press OK when you are logged into your Cloud Provider", "EmuDeck")
	
	foreach($_ in Get-Content $rclone_config) {
		if ($_ -like "*Emudeck*") {		
			$section = $_		
		}elseif ($_ -like "token = *") {		
			$token = $_
			$stop = $true
			break
		}
	}
	
	#Cleanup
	$section = $section.Replace("[", "")
	$section = $section.Replace("]", "")
	
	$token = $token.Replace("token =", "")
	$token = $token.Replace("token =", "")
	$token = $token.Replace('"', "'")
	
	$json = '{ "section": "' + $section + '", "token": "' + $token + '" }'
	
	$headers = @{
		"content-type"="application/x-www-form-urlencoded"
		"Content-Encoding"="utf-8"
	}
	
	$response = Invoke-RestMethod -Method POST -Uri "https://patreon.emudeck.com/hastebin.php" -Headers $headers -Body @{data="$json"} -ContentType "application/x-www-form-urlencoded"

	Add-Type -AssemblyName PresentationFramework
	[System.Windows.MessageBox]::Show("CloudSync Configured!`n`nIf you want to set CloudSync on another EmuDeck installation you need to use this code:`n$response", "Success!")

}

function rclone_config_with_code($code){
	$headers = @{
		"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0"
	}
	
	$response = Invoke-WebRequest -Uri "https://patreon.emudeck.com/hastebin.php?code=$code" -Headers $headers
	
	$json = ConvertFrom-Json $response.Content
	
	$section = $json.section
	$token = $json.token
	
	#cleanup
	$token = $token.Replace("'", '"')
	#$section = $section.Replace("[", '')
	#$section = $section.Replace("]", '')
	
	Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$toolsPath/rclone"

	foreach($_ in Get-Content $rclone_config) {
		if ($_ -eq "$section") {
			$found = "true"
		}elseif ($found -eq "true" -and $_ -like "token =*") {				
			$_ = $_ -replace "token =", "token = $token"		
			$found = "false"
		}
		$content += "$_" + "`n"
	
	}
	
	$content | Set-Content $rclone_config
	
	Get-Content -Path $rclone_config
	
	Add-Type -AssemblyName PresentationFramework
	[System.Windows.MessageBox]::Show("CloudSync Configured!", "Success!")
}

function rclone_install_and_config($rclone_provider){
	rclone_install($rclone_provider)
	rclone_config($rclone_provider)
}

function rclone_install_and_config_with_code($rclone_provider){
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	
	$Form = New-Object System.Windows.Forms.Form
	$Form.Text = "Enter SaveSync Code"
	$Form.ClientSize = New-Object System.Drawing.Size(300, 100)
	$Form.StartPosition = "CenterScreen"
	
	$Label = New-Object System.Windows.Forms.Label
	$Label.Text = "Please enter your SaveSync code:"
	$Label.Location = New-Object System.Drawing.Point(10, 20)
	$Label.AutoSize = $true
	$Form.Controls.Add($Label)
	
	$TextBox = New-Object System.Windows.Forms.TextBox
	$TextBox.Location = New-Object System.Drawing.Point(10, 40)
	$TextBox.Size = New-Object System.Drawing.Size(260, 20)
	$TextBox.PasswordChar = "*"
	$Form.Controls.Add($TextBox)
	
	$OKButton = New-Object System.Windows.Forms.Button
	$OKButton.Text = "OK"
	$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$OKButton.Location = New-Object System.Drawing.Point(10, 70)
	$OKButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
	$Form.AcceptButton = $OKButton
	$Form.Controls.Add($OKButton)
	
	$CancelButton = New-Object System.Windows.Forms.Button
	$CancelButton.Text = "Cancel"
	$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
	$CancelButton.Location = New-Object System.Drawing.Point(90, 70)
	$CancelButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
	$Form.CancelButton = $CancelButton
	$Form.Controls.Add($CancelButton)
	
	$Form.Topmost = $true
	
	$Result = $Form.ShowDialog()
	
	if ($Result -eq [System.Windows.Forms.DialogResult]::OK) {
		$code = $TextBox.Text
	}
	
	rclone_install($rclone_provider)
	rclone_config_with_code($code)
}

function rclone_uninstall(){	
	rm -fo  "$toolsPath/rclone"	
}

function rclone_downloadEmu($emuName){	
	if (Test-Path "$rclone_bin") {
	echo "Downloading $emuName States/Saves"
		$sh = New-Object -ComObject WScript.Shell
		if (Test-Path "$emulationPath\saves\$emuName\saves.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saves.lnk").TargetPath
			& $rclone_bin copy -P -L "$rclone_provider`:Emudeck\saves\$emuName\saves" "$target"
		}
		if (Test-Path "$emulationPath\saves\$emuName\states.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\states.lnk").TargetPath
			& $rclone_bin copy -P -L "$rclone_provider`:Emudeck\saves\$emuName\states" "$target"
		}
		if (Test-Path "$emulationPath\saves\$emuName\GC.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\GC.lnk").TargetPath
			& $rclone_bin copy -P -L "$rclone_provider`:Emudeck\saves\$emuName\GC" "$target"
		}
		if (Test-Path "$emulationPath\saves\$emuName\WII.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\WII.lnk").TargetPath
			& $rclone_bin copy -P -L "$rclone_provider`:Emudeck\saves\$emuName\WII" "$target"
		}
	}
}

function rclone_uploadEmu($emuName){	
	if (Test-Path "$rclone_bin") {
	echo "Uploading $emuName States/Saves"
		$sh = New-Object -ComObject WScript.Shell
		if (Test-Path "$emulationPath\saves\$emuName\saves.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saves.lnk").TargetPath
			& $rclone_bin copy -P -L "$target" "$rclone_provider`:Emudeck\saves\$emuName\saves"
		}
		if (Test-Path "$emulationPath\saves\$emuName\states.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\states.lnk").TargetPath
			& $rclone_bin copy -P -L "$target" "$rclone_provider`:Emudeck\saves\$emuName\states" 
		}
		if (Test-Path "$emulationPath\saves\$emuName\GC.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\GC.lnk").TargetPath
			& $rclone_bin copy -P -L "$target" "$rclone_provider`:Emudeck\saves\$emuName\GC" 
		}
		if (Test-Path "$emulationPath\saves\$emuName\WII.lnk") {	
			$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\WII.lnk").TargetPath
			& $rclone_bin copy -P -L "$target" "$rclone_provider`:Emudeck\saves\$emuName\WII" 
		}
	}
}


function rclone_downloadEmuAll(){
	if ($doInstallRA -eq "true"){
		rclone_downloadEmu retroarch
	}
	if ($doInstallDolphin -eq "true"){
		rclone_downloadEmu dolphin
	}
	if ($doInstallPCSX2 -eq "true"){
		rclone_downloadEmu PCSX2
	}
	#if ($doInstallRPCS3 -eq "true"){
	#	rclone_downloadEmu RPCS3
	#}
	if ($doInstallYuzu -eq "true"){
		rclone_downloadEmu yuzu
	}
	#if ($doInstallCitra -eq "true"){
	#	rclone_downloadEmu citra
	#}
	if ($doInstallDuck -eq "true"){
		rclone_downloadEmu duckstation
	}
	if ($doInstallCemu -eq "true"){
		rclone_downloadEmu cemu
	}
	#if ($doInstallXenia -eq "true"){
	#	rclone_downloadEmu xenia
	#}
	if ($doInstallPPSSPP -eq "true"){
		rclone_downloadEmu PPSSPP
	}
	#if ($doInstallXemu -eq "true"){
	#	rclone_downloadEmu xemu
	#}
}

function rclone_uploadEmuAll(){
	if ($doInstallRA -eq "true"){
		rclone_uploadEmu retroarch
	}
	if ($doInstallDolphin -eq "true"){
		rclone_uploadEmu dolphin
	}
	if ($doInstallPCSX2 -eq "true"){
		rclone_uploadEmu PCSX2
	}
	#if ($doInstallRPCS3 -eq "true"){
	#	rclone_uploadEmu RPCS3
	#}
	if ($doInstallYuzu -eq "true"){
		rclone_uploadEmu yuzu
	}
	#if ($doInstallCitra -eq "true"){
	#	rclone_uploadEmu citra
	#}
	if ($doInstallDuck -eq "true"){
		rclone_uploadEmu duckstation
	}
	if ($doInstallCemu -eq "true"){
		rclone_uploadEmu cemu
	}
	#if ($doInstallXenia -eq "true"){
	#	rclone_uploadEmu xenia
	#}
	if ($doInstallPPSSPP -eq "true"){
		rclone_uploadEmu PPSSPP
	}
	#if ($doInstallXemu -eq "true"){
	#	rclone_uploadEmu xemu
	#}

}