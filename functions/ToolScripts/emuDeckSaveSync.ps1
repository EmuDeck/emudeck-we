$cloud_sync_path="$toolsPath/rclone"
$cloud_sync_bin="$cloud_sync_path/rclone.exe"
$cloud_sync_config_file="$cloud_sync_path/rclone.conf"


function Get-Custom-Credentials($provider) {
	Add-Type -AssemblyName System.Windows.Forms
	$form = New-Object System.Windows.Forms.Form
	$form.Text = "Cloud Login"
	$form.Size = New-Object System.Drawing.Size(400, 300)
	$form.StartPosition = "CenterScreen"
	$form.FormBorderStyle = "FixedDialog"
	$form.TopMost = $true
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
		rm -fo "temp\rclone" -Recurse 
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
	taskkill /F /IM rclone.exe > NUL 2>NUL
	Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$toolsPath/rclone"	
	setSetting "cloud_sync_status" "true"
	setSetting "cloud_sync_provider" "$cloud_sync_provider"
	
	if ($cloud_sync_provider -eq "Emudeck-NextCloud") {
		$credentials = Get-Custom-Credentials "Emudeck-NextCloud"		
		$pass=$credentials.Password
		$params="obscure $pass"
		$obscuredPassword = Invoke-Expression "$cloud_sync_bin $params"
		& $cloud_sync_bin config update "Emudeck-NextCloud" vendor="nextcloud" url=$($credentials.Url) user=$($credentials.Username) pass="$obscuredPassword"
		Write-Output 'true'
	} elseif ($cloud_sync_provider -eq "Emudeck-SFTP") {
		$credentials = Get-Custom-Credentials "Emudeck-SFTP"
		$pass=$credentials.Password
		$params="obscure $pass"
		$obscuredPassword = Invoke-Expression "$cloud_sync_bin $params"
		& $cloud_sync_bin config update "Emudeck-SFTP" host=$($credentials.Url) user=$($credentials.Username) port=$($credentials.Port) pass="$obscuredPassword"
		Write-Output 'true'
	} elseif ($cloud_sync_provider -eq "Emudeck-SMB") {
		$credentials = Get-Custom-Credentials "Emudeck-SMB"
		$pass=$credentials.Password
		$params="obscure $pass"
		$obscuredPassword = Invoke-Expression "$cloud_sync_bin $params"
		& $cloud_sync_bin config update "Emudeck-SMB" host=$($credentials.Url) user=$($credentials.Username) pass="$obscuredPassword"
		Write-Output 'true'
	} else {
		& $cloud_sync_bin config update "$cloud_sync_provider"
		Write-Output 'true'
	}
	
	#we create the folders to avoid errors in some providers
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\Cemu\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\citra\saves" ;
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\citra\states";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\dolphin\GC";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\dolphin\StateSaves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\dolphin\Wii";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\duckstation\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\duckstation\states";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\MAME\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\MAME\states";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\melonds\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\melonds\states";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\primehack\GC" ;
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\primehack\StateSaves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\primehack\Wii" ;
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\mgba\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\mgba\states" ;
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\pcsx2\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\pcsx2\states" ;
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\ppsspp\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\ppsspp\states" ;
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\retroarch\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\retroarch\states" ;
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\rpcs3\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\scummvm\saves" ;
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\Vita3K\saves";
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\yuzu\saves" ;
	#& $cloud_sync_bin mkdir  "$cloud_sync_provider`:Emudeck\saves\yuzu\profiles";
	
	
	#Add-Type -AssemblyName PresentationFramework
	#[System.Windows.MessageBox]::Show("Press OK when you are logged into your Cloud Provider", "EmuDeck")
	#
	#foreach($_ in Get-Content $cloud_sync_config_file) {
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

	Write-Output $section;

	foreach($_ in Get-Content $cloud_sync_config_file) {
		if ($_ -like "*$section*") {
			$found = "true"
		}elseif ($found -eq "true" -and $_ -like "token =*") {				
			$_ = $_ -replace "token =", "token =$token"		
			$found = "false"
		}
		$content += "$_" + "`n"
	
	}
	
	$content | Set-Content $cloud_sync_config_file
	
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
	rm -fo "$toolsPath/rclone" -Recurse 
}

function cloud_sync_download($emuName){
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {
		#We wait for any upload in progress
		cloud_sync_check_lock
		if ($emuName -eq 'all'){
				
			$dialog = cleanDialog -TitleText "CloudSync" -MessageText "Downloading saves for all installed system, please wait..."
			
			$sh = New-Object -ComObject WScript.Shell	
			
			$target = "$emulationPath\saves\"
			& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload "$cloud_sync_provider`:Emudeck\saves\" "$target" 
			if ($?) {			
				$baseFolder = "$target"
				$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"				
				Get-ChildItem -Directory $baseFolder | ForEach-Object {
					$folder = $_.FullName
					$emuName = (Get-Item $folder).Name
					$lastUploadFile = "$savesPath/$emuName/.last_download"
					$failUploadFile = "$savesPath/$emuName/.fail_upload"
				
					if (Test-Path -PathType Container $folder) {
						Set-Content -Path "$lastUploadFile" -Value $timestamp
						Remove-Item -Path "$failUploadFile" -Force -Recurse -ErrorAction SilentlyContinue
					}
				}								
			}
		}else{
			$dialog = cleanDialog -TitleText "CloudSync" -MessageText "Downloading saves for $emuName, please wait..."			
			$target = "$emulationPath\saves\$emuName\"
			& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\"
		}	

		$dialog.Close()
	}
}

function cloud_sync_upload($emuName){	
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {
		#We lock cloudsync
		cloud_sync_lock
		if ($emuName -eq 'all'){
				
			toastNotification -title "EmuDeck CloudSync" -message "Uploading saves for all systems in the background..." -img "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\img\cloud.png"
						
			$sh = New-Object -ComObject WScript.Shell	
			
			$target = "$emulationPath\saves\"
			& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\"
			if ($?) {			
				$baseFolder = "$target"
				$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"				
				Get-ChildItem -Directory $baseFolder | ForEach-Object {
					$folder = $_.FullName
					$emuName = (Get-Item $folder).Name
					$lastUploadFile = "$savesPath/$emuName/.last_upload"
					$failUploadFile = "$savesPath/$emuName/.fail_upload"
				
					if (Test-Path -PathType Container $folder) {
						Set-Content -Path "$lastUploadFile" -Value $timestamp
						Remove-Item -Path "$failUploadFile" -Force -Recurse -ErrorAction SilentlyContinue
					}
				}
				toastNotification -title "EmuDeck CloudSync" -message "Saves uploaded!" -img "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\img\cloud.png"			
			}
		}else{				
						
			toastNotification -title "EmuDeck CloudSync" -message "Uploading saves for $emuName in the background..." -img "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\img\cloud.png"
			
			$sh = New-Object -ComObject WScript.Shell	
			
			$target = "$emulationPath\saves\$emuName\"
			& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\"
			if ($?) {
				rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
				toastNotification -title "EmuDeck CloudSync" -message "Saves uploaded!" -img "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\img\cloud.png"
			}
		}
		#We unlock cloudsync
		cloud_sync_unlock
		$dialog.Close()
	}
}

function cloud_sync_downloadEmu($emuName, $mode){
	if (Test-Path "$cloud_sync_bin") {
		#We check for internet connection
		if ( check_internet_connection -eq 'true' ){
		
			#Do we have a pending upload?
			if (Test-Path "$savesPath/$emuName/.pending_upload") {
			
				$date = Get-Content "$savesPath/$emuName/.pending_upload"
				
				$result = yesNoDialog -TitleText "CloudSync conflict - $emuName" -MessageText "We've detected a pending upload, make sure you always close the Emulator pressing SELECT + START, do you want us to upload your saves to the cloud now?`n`nThis upload should have happened on $date.`n`n Select Upload if your more recent save is in this device, select Download if the more recent save is in the cloud " -OKButtonText "Upload" -CancelButtonText "Download"
				
				if ($result -eq "OKButton") {
					rm -fo "$savesPath/$emuName/.fail_download" -ErrorAction SilentlyContinue
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_upload($emuName)
				} else {
					rm -fo "$savesPath/$emuName/.fail_download" -ErrorAction SilentlyContinue
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					#cloud_sync_download($emuName) No need to download, since we are going to do it later on this same script
				}
			}		
			
			Get-Date | Out-File -FilePath $savesPath/$emuName/.pending_upload
			
			#Do we have a failed download?
			if (Test-Path "$savesPath/$emuName/.fail_download") {
			
				$date = Get-Content "$savesPath/$emuName/.fail_download"
				
				$result = yesNoDialog -TitleText "CloudSync conflict - $emuName" -MessageText "We've detected a previously failed download, do you want us to download your saves and overwrite your local saves?`n`nYour latest upload was on $date.`n`n Select Upload if your more recent save is in this device, select Download if the more recent save is in the cloud " -OKButtonText "Upload" -CancelButtonText "Download"
				
				if ($result -eq "OKButton") {
					rm -fo "$savesPath/$emuName/.fail_download" -ErrorAction SilentlyContinue
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_download($emuName)
				} else {
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					rm -fo "$savesPath/$emuName/.fail_download"	 -ErrorAction SilentlyContinue
					cloud_sync_upload($emuName)	
				}

			}else{
				
				if($mode -ne 'check-conflicts'){
					cloud_sync_download($emuName)
				}
			}
		}else{
			Get-Date | Out-File -FilePath $savesPath/$emuName/.fail_download
		}
	}
}

function cloud_sync_uploadEmu($emuName, $mode){
	if (Test-Path "$cloud_sync_bin") {
		#We check for internet connection
		if ( check_internet_connection -eq 'true' ){
			#Do we have a failed download?
			if (Test-Path "$savesPath/$emuName/.fail_upload") {
			
				$date = Get-Content "$savesPath/$emuName/.fail_upload"
				Add-Type -AssemblyName System.Windows.Forms
				
				$result = yesNoDialog -TitleText "CloudSync conflict - $emuName" -MessageText "We've detected a previously failed upload, do you want us to upload your saves and overwrite your saves in the cloud?`n`nYour latest upload was on $date.`n`n Select Upload if your more recent save is in this device, select Download if the more recent save is in the cloud" -OKButtonText "Upload" -CancelButtonText "Download"
				
				if ($result -eq "OKButton") {
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_upload($emuName)						
					rm -fo "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
				} else {
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_download($emuName)
					rm -fo "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue	
				}
			
			}else{
				rm -fo "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
				rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
				if($mode -ne 'check-conflicts'){
					cloud_sync_upload($emuName)
				}
				
			}
		}else{
			Get-Date | Out-File -FilePath $savesPath/$emuName/.fail_upload
		}
	}
}


function cloud_sync_downloadEmuAll(){
			
	Get-ChildItem -Directory $savesPath/ | ForEach-Object {
		$simLinkPath = $_.FullName
		$emuName = (Get-Item $simLinkPath).Name
		cloud_sync_downloadEmu $emuName 'check-conflicts'			
	}					
	cloud_sync_download 'all'
}

function cloud_sync_uploadEmuAll(){
	
	Get-ChildItem -Directory $savesPath/ | ForEach-Object {
		$simLinkPath = $_.FullName
		$emuName = (Get-Item $simLinkPath).Name
		cloud_sync_uploadEmu $emuName 'check-conflicts'
				
	}				
	
	cloud_sync_download 'all'
}


function cloud_sync_lock(){
	Add-Content "$userFolder\EmuDeck\cloud.lock" "Locked" -NoNewline
}

function cloud_sync_unlock(){
	Remove-Item "$userFolder\EmuDeck\cloud.lock" -Force -ErrorAction SilentlyContinue
}

function cloud_sync_check_lock(){
	$lockedFile = "$userFolder\EmuDeck\cloud.lock"
	if (Test-Path -Path $lockedFile) {
		$modal = cleanDialog -TitleText "CloudSync in progress" -MessageText "We're syncing your saved games, please wait..."
	}

	while (Test-Path -Path $lockedFile) {
		Start-Sleep -Seconds 1
	}
	if ($modal) {
		$modal.Close()
	}
	return $true
}
