$cloud_sync_path="$toolsPath/rclone"
$cloud_sync_bin="$cloud_sync_path/rclone.exe"
$cloud_sync_config="$cloud_sync_path/rclone.conf"


function Get-Custom-Credentials($provider) {
	Add-Type -AssemblyName System.Windows.Forms
	$form = New-Object System.Windows.Forms.Form
	$form.Text = "Cloud Login"
	$form.Size = New-Object System.Drawing.Size(400, 300)
	$form.StartPosition = "CenterScreen"
	$form.FormBorderStyle = "FixedDialog"

	$labelUsername = New-Object System.Windows.Forms.Label
	$labelUsername.Text = "User:"
	$labelUsername.Location = New-Object System.Drawing.Point(30, 30)
	$form.Controls.Add($labelUsername)

	$textBoxUsername = New-Object System.Windows.Forms.TextBox
	$textBoxUsername.Location = New-Object System.Drawing.Point(140, 30)
	$textBoxUsername.Size = New-Object System.Drawing.Size(150, 20)
	$form.Controls.Add($textBoxUsername)

	$labelPassword = New-Object System.Windows.Forms.Label
	$labelPassword.Text = "Pass:"
	$labelPassword.Location = New-Object System.Drawing.Point(30, 70)
	$form.Controls.Add($labelPassword)

	$textBoxPassword = New-Object System.Windows.Forms.TextBox
	$textBoxPassword.Location = New-Object System.Drawing.Point(140, 70)
	$textBoxPassword.Size = New-Object System.Drawing.Size(150, 20)
	$textBoxPassword.PasswordChar = "*"
	$form.Controls.Add($textBoxPassword)
	
	if ($cloud_sync_releaseURL -match $regex) {
	if( $provider -eq "Emudeck-NextCloud"){
	
		$labelWebDAV = New-Object System.Windows.Forms.Label
		$labelWebDAV.Text = "WebDAV url:"
		$labelWebDAV.Location = New-Object System.Drawing.Point(30, 110)
		$form.Controls.Add($labelWebDAV)
		
		$filename = $matches[1]
		$textBoxUrl = New-Object System.Windows.Forms.TextBox
		$textBoxUrl.Location = New-Object System.Drawing.Point(140, 110)
		$textBoxUrl.Size = New-Object System.Drawing.Size(150, 20)
		$form.Controls.Add($textBoxUrl)
	}
	
	if( $provider -eq "Emudeck-SFTP" ){
		$labelUrl = New-Object System.Windows.Forms.Label
		$labelUrl.Text = "Url:"
		$labelUrl.Location = New-Object System.Drawing.Point(30, 110)
		$form.Controls.Add($labelUrl)
		
		$filename = $filename.Replace('.zip','')
		$textBoxUrl = New-Object System.Windows.Forms.TextBox
		$textBoxUrl.Location = New-Object System.Drawing.Point(140, 110)
		$textBoxUrl.Size = New-Object System.Drawing.Size(150, 20)
		$form.Controls.Add($textBoxUrl)
		
		Rename-Item "temp\rclone\$filename" -NewName "rclone" 
		$labelPort = New-Object System.Windows.Forms.Label
		$labelPort.Text = "Port:"
		$labelPort.Location = New-Object System.Drawing.Point(30, 150)
		$form.Controls.Add($labelPort)
		
		$textBoxPort = New-Object System.Windows.Forms.TextBox
		$textBoxPort.Location = New-Object System.Drawing.Point(140, 150)
		$textBoxPort.Size = New-Object System.Drawing.Size(150, 20)
		$form.Controls.Add($textBoxPort)
	
	}
	
	if( $provider -eq "Emudeck-SMB" ){
		$labelUrl = New-Object System.Windows.Forms.Label
		$labelUrl.Text = "Url:"
		$labelUrl.Location = New-Object System.Drawing.Point(30, 110)
		$form.Controls.Add($labelUrl)
		
		moveFromTo "temp/rclone/" "$toolsPath\"	
		Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$toolsPath/rclone"
		rm -fo  "temp\rclone" -Recurse 
		$textBoxUrl = New-Object System.Windows.Forms.TextBox
		$textBoxUrl.Location = New-Object System.Drawing.Point(140, 110)
		$textBoxUrl.Size = New-Object System.Drawing.Size(150, 20)
		$form.Controls.Add($textBoxUrl)
	
	}
	if( $provider -eq "Emudeck-SFTP" ){
		$buttonHeight=200
	}else{
		$buttonHeight=160
	}

	$buttonOK = New-Object System.Windows.Forms.Button
	$buttonOK.Text = "OK"
	$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$buttonOK.Location = New-Object System.Drawing.Point(80, $buttonHeight)
	$form.Controls.Add($buttonOK)

	$buttonCancel = New-Object System.Windows.Forms.Button
	$buttonCancel.Text = "Cancel"
	$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
	$buttonCancel.Location = New-Object System.Drawing.Point(160, $buttonHeight)
	$form.Controls.Add($buttonCancel)

	$form.AcceptButton = $buttonOK
	$form.CancelButton = $buttonCancel

	$result = $form.ShowDialog()

	if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
		$username = $textBoxUsername.Text
		$password = $textBoxPassword.Text
		$url = $textBoxUrl.Text
		$port = $textBoxPort.Text

		return [PSCustomObject]@{
			Username = $username
			Password = $password
			Url = $url
			Port = $port
		}
	}

	return $null
}

function cloud_sync_install($cloud_sync_provider){	
	if (-not(Test-Path "$cloud_sync_bin")) {
		$cloud_sync_releaseURL = getLatestReleaseURLGH 'rclone/rclone' 'zip' 'windows-amd64'
		download $cloud_sync_releaseURL "rclone.zip"	
		setSetting "cloud_sync_provider" "$cloud_sync_provider"
		. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1
		$regex = '^.*\/(rclone-v\d+\.\d+\.\d+-windows-amd64\.zip)$'
		
		if ($cloud_sync_releaseURL -match $regex) {		
			$filename = $matches[1]		
			$filename = $filename.Replace('.zip','')		
			Rename-Item "$temp\rclone\$filename" -NewName "rclone" 
			moveFromTo "$temp/rclone" "$toolsPath"
		}
	}
}

function cloud_sync_toggle($status){
  setSetting "cloud_sync_status" $status
}	

function cloud_sync_config($cloud_sync_provider){
	
	Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$toolsPath/rclone"	
	setSetting "cloud_sync_status" "true"
		
	if ($cloud_sync_provider -eq "Emudeck-NextCloud") {
		$credentials = Get-Custom-Credentials "Emudeck-NextCloud"		
		$pass=$credentials.Password
		$params="obscure $pass"
		$obscuredPassword = Invoke-Expression "$cloud_sync_bin $params"
		& $cloud_sync_bin config update "Emudeck-NextCloud" vendor="nextcloud" url=$($credentials.Url) user=$($credentials.Username) pass="$obscuredPassword"
		echo 'true'
	} elseif ($cloud_sync_provider -eq "Emudeck-SFTP") {
		$credentials = Get-Custom-Credentials "Emudeck-SFTP"
		$pass=$credentials.Password
		$params="obscure $pass"
		$obscuredPassword = Invoke-Expression "$cloud_sync_bin $params"
		& $cloud_sync_bin config update "Emudeck-SFTP" host=$($credentials.Url) user=$($credentials.Username) port=$($credentials.Port) pass="$obscuredPassword"
		echo 'true'
	} elseif ($cloud_sync_provider -eq "Emudeck-SMB") {
		$credentials = Get-Custom-Credentials "Emudeck-SMB"
		$pass=$credentials.Password
		$params="obscure $pass"
		$obscuredPassword = Invoke-Expression "$cloud_sync_bin $params"
		& $cloud_sync_bin config update "Emudeck-SMB" host=$($credentials.Url) user=$($credentials.Username) pass="$obscuredPassword"
		echo 'true'
	} else {
		& $cloud_sync_bin config update "$cloud_sync_provider"
		echo 'true'
	}


	
	
	#Add-Type -AssemblyName PresentationFramework
	#[System.Windows.MessageBox]::Show("Press OK when you are logged into your Cloud Provider", "EmuDeck")
	#
	#foreach($_ in Get-Content $cloud_sync_config) {
	#	if ($_ -like "*Emudeck*") {		
	#		$section = $_		
	#	}elseif ($_ -match "^token\s*=\s*(\S.*)$") {			
	#		$token = $_
	#		$stop = $true
	#		break
	#	}
	#}
	#
	##Cleanup
	#$section = $section.Replace("[", "")
	#$section = $section.Replace("]", "")
	#
	#$token = $token.Replace("token =", "")
	#$token = $token.Replace("token =", "")
	#$token = $token.Replace('"', "'")
	#
	#$json = '{ "section": "' + $section + '", "token": "' + $token + '" }'
	#
	#$headers = @{
	#	"content-type"="application/x-www-form-urlencoded"
	#	"Content-Encoding"="utf-8"
	#}
	#
	#$response = Invoke-RestMethod -Method POST -Uri "https://patreon.emudeck.com/hastebin.php" -Headers $headers -Body @{data="$json"} -ContentType #"application/x-www-form-urlencoded"
	#Add-Type -AssemblyName PresentationFramework
	#[System.Windows.MessageBox]::Show("CloudSync Configured!`n`nIf you want to set CloudSync on another EmuDeck installation you need to use this #code:`n$response", "Success!")

}

function cloud_sync_config_with_code($code){
	setSetting "cloud_sync_status" "true"
	
	$headers = @{
		"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0"
	}
	
	$response = Invoke-WebRequest -Uri "https://patreon.emudeck.com/hastebin.php?code=$code" -Headers $headers
	
	$json = ConvertFrom-Json $response.Content
	
	$section = $json.section
	$token = $json.token
	
	#cleanup
	$token = $token.Replace("'", '"')
	
	Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$toolsPath/rclone"

	echo $section;

	foreach($_ in Get-Content $cloud_sync_config) {
		if ($_  -like "*$section*") {
			$found = "true"
		}elseif ($found -eq "true" -and $_ -like "token =*") {				
			$_ = $_ -replace "token =", "token =$token"		
			$found = "false"
		}
		$content += "$_" + "`n"
	
	}
	
	$content | Set-Content $cloud_sync_config
	
	Add-Type -AssemblyName PresentationFramework
	[System.Windows.MessageBox]::Show("CloudSync Configured!", "Success!")
}

function cloud_sync_install_and_config($cloud_sync_provider){
	cloud_sync_install($cloud_sync_provider)
	cloud_sync_config($cloud_sync_provider)
}

function cloud_sync_install_and_config_with_code($cloud_sync_provider){
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
	
	cloud_sync_install($cloud_sync_provider)
	cloud_sync_config_with_code($code)
}

function cloud_sync_uninstall(){	
	setSetting "cloud_sync_status" "false"
	rm -fo  "$toolsPath/rclone"	
}

function cloud_sync_download($emuName){
Add-Type -TypeDefinition @"
	using System;
	using System.Runtime.InteropServices;

	public class Win32 {
		[DllImport("user32.dll")]
		public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
	}
"@
	
	$Process = Get-Process -Name "cmd" | Select-Object -First 1
	$Handle = $Process.MainWindowHandle
	$Minimize = 6
	
	[Win32]::ShowWindowAsync($Handle, $Minimize)
	
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {
		$dialog = showDialog("Downloading saves for $emuName...")
		$sh = New-Object -ComObject WScript.Shell
		if ($emuName -eq "melonDS"){
			if (Test-Path "$emulationPath\saves\$emuName\saves") {	
				$target = "$emulationPath\saves\$emuName\saves"
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$cloud_sync_provider`:Emudeck\saves\$emuName\saves" "$target"
			}
			if (Test-Path "$emulationPath\saves\$emuName\states") {	
				$target = "$emulationPath\saves\$emuName\states"
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$cloud_sync_provider`:Emudeck\saves\$emuName\states" "$target"
			}
		}else{
			
			if (Test-Path "$emulationPath\saves\$emuName\saves.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saves.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$cloud_sync_provider`:Emudeck\saves\$emuName\saves" "$target"
			}
			if (Test-Path "$emulationPath\saves\$emuName\states.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\states.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$cloud_sync_provider`:Emudeck\saves\$emuName\states" "$target"
			}
			if (Test-Path "$emulationPath\saves\$emuName\profiles.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\profiles.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$cloud_sync_provider`:Emudeck\saves\$emuName\profiles" "$target"
			}
			if (Test-Path "$emulationPath\saves\$emuName\profiles.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\profiles.lnk").TargetPath
				& $cloud_sync_bin copy -P -L "$cloud_sync_provider`:Emudeck\saves\$emuName\profiles" "$target"
			}
			if (Test-Path "$emulationPath\saves\$emuName\GC.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\GC.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$cloud_sync_provider`:Emudeck\saves\$emuName\GC" "$target"
			}
			if (Test-Path "$emulationPath\saves\$emuName\WII.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\WII.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$cloud_sync_provider`:Emudeck\saves\$emuName\WII" "$target"
			}
			if (Test-Path "$emulationPath\saves\$emuName\saveMeta.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saveMeta.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$cloud_sync_provider`:Emudeck\saves\$emuName\saveMeta" "$target"
			}
			if (Test-Path "$emulationPath\saves\$emuName\saveMeta.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saveMeta.lnk").TargetPath
				& $cloud_sync_bin copy -P -L "$cloud_sync_provider`:Emudeck\saves\$emuName\saveMeta" "$target"
			}
		}
		$dialog.Close()
	}
}

function cloud_sync_upload($emuName){	
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {
		$dialog = showDialog("Uploading saves for $emuName...")
		$sh = New-Object -ComObject WScript.Shell
		
		if ($emuName -eq "melonDS"){
			if (Test-Path "$emulationPath\saves\$emuName\saves") {	
				$target = "$emulationPath\saves\$emuName\saves"
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\saves"
			}
			if (Test-Path "$emulationPath\saves\$emuName\states") {	
				$target = "$emulationPath\saves\$emuName\states"
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\states"
			}
		}else{
			
			if (Test-Path "$emulationPath\saves\$emuName\saves.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saves.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\saves"
			}
			if (Test-Path "$emulationPath\saves\$emuName\states.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\states.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\states" 
			}
			if (Test-Path "$emulationPath\saves\$emuName\profiles.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\profiles.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\profiles"
			}
			if (Test-Path "$emulationPath\saves\$emuName\profiles.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\profiles.lnk").TargetPath
				& $cloud_sync_bin copy -P -L "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\profiles"
			}
			if (Test-Path "$emulationPath\saves\$emuName\GC.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\GC.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\GC" 
			}
			if (Test-Path "$emulationPath\saves\$emuName\WII.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\WII.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\WII" 
			}
			if (Test-Path "$emulationPath\saves\$emuName\saveMeta.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saveMeta.lnk").TargetPath
				& $cloud_sync_bin copy --quiet --exclude=/.fail_upload --exclude=/.fail_download--exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\saveMeta" 
			}
			if (Test-Path "$emulationPath\saves\$emuName\saveMeta.lnk") {	
				$target = $sh.CreateShortcut("$emulationPath\saves\$emuName\saveMeta.lnk").TargetPath
				& $cloud_sync_bin copy -P -L "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\saveMeta" 
			}
		}
	$dialog.Close()
	}
}

function cloud_sync_downloadEmu($emuName){
	if (Test-Path "$cloud_sync_bin") {
		#We check for internet connection
		if ( check_internet_connection -eq 'true' ){
		
			#Do we have a pending upload?
			if (Test-Path "$savesPath/$emuName/.pending_upload") {
			
				$date = Get-Content "$savesPath/$emuName/.pending_upload"
				Add-Type -AssemblyName System.Windows.Forms
				
				$result = [System.Windows.Forms.MessageBox]::Show(
					"We've detected a pending upload, make sure you dont close the Emulator using the Steam Button, do you want us to upload your saves to the cloud and overwrite them? This upload should have happened on $date. Press Yes to upload them to the cloud, No to download from the cloud and overwrite your Cloud saves, or Cancel to skip",
					"CloudSync conflict",
					[System.Windows.Forms.MessageBoxButtons]::YesNoCancel
				)
				
				switch ($result) {
					"Yes" {
						rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue	
						cloud_sync_upload($emuName)								
					}
					"No" {
						rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
						cloud_sync_download($emuName)						
					}
					"Cancel" {
						echo ""
					}
				}		
			}		
			
			Get-Date | Out-File -FilePath $savesPath/$emuName/.pending_upload
			
			#Do we have a failed download?
			if (Test-Path "$savesPath/$emuName/.fail_download") {
			
				$date = Get-Content "$savesPath/$emuName/.fail_download"
				Add-Type -AssemblyName System.Windows.Forms
				
				$result = [System.Windows.Forms.MessageBox]::Show(
					"We've detected a previously failed download, do you want us to download your saves and overwrite your local saves? Your latest upload was on $date. Press Yes to download from the cloud and overwrite your local saves, No to upload and overwrite your Cloud saves, Cancel to skip",
					"CloudSync conflict",
					[System.Windows.Forms.MessageBoxButtons]::YesNoCancel
				)
				
				switch ($result) {
					"Yes" {
						cloud_sync_download($emuName)
						rm -fo "$savesPath/$emuName/.fail_download" -ErrorAction SilentlyContinue
					}
					"No" {
						rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
						rm -fo "$savesPath/$emuName/.fail_download"	 -ErrorAction SilentlyContinue
						cloud_sync_upload($emuName)											
					}
					"Cancel" {
						echo ""
					}
				}
			}else{
				cloud_sync_download($emuName)
			}
		}else{
			Get-Date | Out-File -FilePath $savesPath/$emuName/.fail_download
		}
	}
}

function cloud_sync_uploadEmu($emuName){
	if (Test-Path "$cloud_sync_bin") {
		#We check for internet connection
		if ( check_internet_connection -eq 'true' ){
			#Do we have a failed download?
			if (Test-Path "$savesPath/$emuName/.fail_upload") {
			
				$date = Get-Content "$savesPath/$emuName/.fail_upload"
				Add-Type -AssemblyName System.Windows.Forms
				
				$result = [System.Windows.Forms.MessageBox]::Show(
					"We've detected a previously failed upload, do you want us to upload your saves and overwrite your saves in the cloud? Your latest upload was on $date. Press Yes to upload and overwrite your Cloud saves, No to download from the cloud and overwrite your local saves, Cancel to skip",
					"CloudSync conflict",
					[System.Windows.Forms.MessageBoxButtons]::YesNoCancel
				)
				
				switch ($result) {
					"Yes" {
						rm -fo  "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
						cloud_sync_upload($emuName)						
						rm -fo  "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
						
					}
					"No" {
						rm -fo  "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
						cloud_sync_download($emuName)
						rm -fo "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue						
					}
					"Cancel" {
						echo ""
					}
				}

			
			}else{
				rm -fo  "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
				rm -fo  "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
				cloud_sync_upload($emuName)
			}
		}else{
			Get-Date | Out-File -FilePath $savesPath/$emuName/.fail_upload
		}
	}
}


function cloud_sync_downloadEmuAll(){
	if ($doInstallRA -eq "true"){
		cloud_sync_downloadEmu retroarch
	}
	if ($doInstallDolphin -eq "true"){
		cloud_sync_downloadEmu dolphin
	}
	if ($doInstallPCSX2 -eq "true"){
		cloud_sync_downloadEmu pcsx2
	}
	if ($doInstallRPCS3 -eq "true"){
		cloud_sync_downloadEmu rpcs3
	}
	if ($doInstallYuzu -eq "true"){
		cloud_sync_downloadEmu yuzu
	}
	if ($doInstallCitra -eq "true"){
		cloud_sync_downloadEmu citra
	}
	if ($doInstallmelonDS -eq "true"){
		cloud_sync_downloadEmu melonDS
	}
	if ($doInstallRyujinx -eq "true"){
		cloud_sync_downloadEmu ryujinx
	}
	if ($doInstallDuck -eq "true"){
		cloud_sync_downloadEmu duckstation
	}
	if ($doInstallCemu -eq "true"){
		cloud_sync_downloadEmu cemu
	}
	#if ($doInstallXenia -eq "true"){
	#	cloud_sync_downloadEmu xenia
	#}
	if ($doInstallPPSSPP -eq "true"){
		cloud_sync_downloadEmu PPSSPP
	}
	#if ($doInstallXemu -eq "true"){
	#	cloud_sync_downloadEmu xemu
	#}
}

function cloud_sync_uploadEmuAll(){
	if ($doInstallRA -eq "true"){
		cloud_sync_uploadEmu retroarch
	}
	if ($doInstallDolphin -eq "true"){
		cloud_sync_uploadEmu dolphin
	}
	if ($doInstallPCSX2 -eq "true"){
		cloud_sync_uploadEmu pcsx2
	}
	if ($doInstallRPCS3 -eq "true"){
		cloud_sync_uploadEmu rpcs3
	}
	if ($doInstallYuzu -eq "true"){
		cloud_sync_uploadEmu yuzu
	}
	if ($doInstallCitra -eq "true"){
		cloud_sync_uploadEmu citra
	}
	if ($doInstallmelonDS -eq "true"){
		cloud_sync_uploadEmu melonDS
	}
	if ($doInstallRyujinx -eq "true"){
		cloud_sync_downloadEmu ryujinx
	}
	if ($doInstallDuck -eq "true"){
		cloud_sync_uploadEmu duckstation
	}
	if ($doInstallCemu -eq "true"){
		cloud_sync_uploadEmu cemu
	}
	#if ($doInstallXenia -eq "true"){
	#	cloud_sync_uploadEmu xenia
	#}
	if ($doInstallPPSSPP -eq "true"){
		cloud_sync_uploadEmu PPSSPP
	}
	#if ($doInstallXemu -eq "true"){
	#	cloud_sync_uploadEmu xemu
	#}

}