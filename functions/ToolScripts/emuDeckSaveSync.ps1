$cloud_sync_path="$toolsPath/rclone"
$cloud_sync_bin="$cloud_sync_path/rclone.exe"
$cloud_sync_config_file_symlink="$cloud_sync_path/rclone.conf"
$cloud_sync_config_file="$env:USERPROFILE\AppData\Roaming\EmuDeck\rclone.conf"


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

function cloud_sync_install_service(){

	mkdir "$toolsPath/cloudSync" -ErrorAction SilentlyContinue
	cp "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/tools/cloudSync/WinSW-x64.xml" "$toolsPath/cloudSync"
	cp "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/tools/cloudSync/WinSW-x64.exe" "$toolsPath/cloudSync"

	sedFile "$toolsPath/cloudSync/WinSW-x64.xml" "USERPATH" "$env:USERPROFILE"
	sedFile "$toolsPath/cloudSync/WinSW-x64.xml" "USERNAME" "$env:USERNAME"

	& "$toolsPath/cloudSync/WinSW-x64.exe" uninstall
	& "$toolsPath/cloudSync/WinSW-x64.exe" install
	& sc.exe sdset CloudWatch "D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;CCLCSWRPWPDTLOCRRC;;;WD)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)"

}



function cloud_sync_install($cloud_sync_provider){

	confirmDialog -TitleText "Administrator Privileges needed" -MessageText "In order to cloudSync to work we need to create a background service. Expect a window asking for elevated privileges after this message."

$scriptContent = @"
 & "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" stop "CloudWatch"

 if (-not ( & "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" status "CloudWatch" )) {
	#We create the service
	cloud_sync_install_service
 }else{
	& "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" stop "CloudWatch"
	& "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" remove "CloudWatch" confirm
	cloud_sync_install_service
 }
 if (-not(Test-Path "$cloud_sync_bin")) {
	$cloud_sync_releaseURL = getLatestReleaseURLGH 'rclone/rclone' 'zip' 'windows-amd64'
	download $cloud_sync_releaseURL "rclone.zip"
	setSetting "cloud_sync_provider" "$cloud_sync_provider"
	. "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1"
	$regex = '^.*\/(rclone-v\d+\.\d+\.\d+-windows-amd64\.zip)$'

	if ($cloud_sync_releaseURL -match $regex) {
	 $filename = $matches[1]
	 $filename = $filename.Replace('.zip','')
	 Rename-Item "$temp\rclone\$filename" -NewName "rclone"
	 moveFromTo "$temp/rclone" "$toolsPath"
	}
 }
"@
 startScriptWithAdmin -ScriptContent $scriptContent
}

function cloud_sync_toggle($status){
 setSetting "cloud_sync_status" $status
}

function cloud_sync_config($cloud_sync_provider){
	taskkill /F /IM rclone.exe > NUL 2>NUL
	Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$cloud_sync_path"
	createSymlink $cloud_sync_config_file_symlink $cloud_sync_config_file
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

	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\Cemu\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\citra\saves" ;
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\citra\states";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\dolphin\GC";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\dolphin\StateSaves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\dolphin\Wii";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\duckstation\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\duckstation\states";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\MAME\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\MAME\states";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\melonds\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\melonds\states";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\primehack\GC" ;
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\primehack\StateSaves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\primehack\Wii" ;
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\mgba\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\mgba\states" ;
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\pcsx2\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\pcsx2\states" ;
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\ppsspp\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\ppsspp\states" ;
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\retroarch\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\retroarch\states" ;
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\rpcs3\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\scummvm\saves" ;
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\Vita3K\saves";
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\yuzu\saves" ;
	#& $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves\yuzu\profiles";


	#Add-Type -AssemblyName PresentationFramework
	#[System.Windows.MessageBox]::Show("Press OK when you are logged into your Cloud Provider", "EmuDeck")
	#
	#foreach($_ in Get-Content $cloud_sync_config_file_symlink) {
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

	Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$env:USERPROFILE\AppData\Roaming\EmuDeck"

	createSymlink $cloud_sync_config_file_symlink $cloud_sync_config_file

	Write-Output $section;

	foreach($_ in Get-Content $cloud_sync_config_file_symlink) {
		if ($_ -like "*$section*") {
			$found = "true"
		}elseif ($found -eq "true" -and $_ -like "token =*") {
			$_ = $_ -replace "token =", "token =$token"
			$found = "false"
		}
		$content += "$_" + "`n"

	}

	$content | Set-Content $cloud_sync_config_file_symlink

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
	rm -fo "$cloud_sync_path" -Recurse
}

function cloud_sync_download($emuName){
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {
		#We wait for any upload in progress
		cloud_sync_check_lock
		if ($emuName -eq 'all'){

			$sh = New-Object -ComObject WScript.Shell

			$target = "$emulationPath\saves\"

			$fileHash = "$target\.hash"

			#We compare the hashes
			if (Test-Path -PathType Any "$fileHash"){
				$hash= Get-Content $fileHash
			}else{
				$hash="0"
			}

			& $cloud_sync_bin --progress copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$cloud_sync_provider`:Emudeck\saves\.hash" "$fileHash"

			if (Test-Path -PathType Any "$fileHash"){
				$hashCloud= Get-Content $fileHash
			}

			if (Test-Path -PathType Any "$fileHash"){

				if ($hash -eq $hashCloud){
					$dialog = steamToast  -MessageText "Saves up to date, no need to sync"
				}else{
					$dialog = steamToast  -MessageText "Downloading saves for all installed system, please wait..."
					& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload --exclude=/.watching --exclude=/.emulator -q --log-file "$userFolder/emudeck/rclone.log" --exclude=/.user "$cloud_sync_provider`:Emudeck\saves\" "$target"
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
				}
			}else{
				$dialog = steamToast  -MessageText "Downloading saves for all installed system, please wait..."
				& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload --exclude=/.watching --exclude=/.emulator --exclude=/.user "$cloud_sync_provider`:Emudeck\saves\" "$target"
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
			}
		}else{
			$target = "$emulationPath\saves\$emuName\"

			$fileHash = "$target\.hash"

			#We compare the hashes
			if (Test-Path -PathType Any "$fileHash"){
				$hash= Get-Content $fileHash
			}else{
				$hash="0"
			}

			& $cloud_sync_bin -q --log-file "$userFolder/emudeck/rclone.log" copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$cloud_sync_provider`:Emudeck\saves\$emuName\.hash" "$fileHash"

			if (Test-Path -PathType Any "$fileHash"){
				$hashCloud= Get-Content $fileHash
			}


			if (Test-Path -PathType Any "$fileHash"){
				if ($hash -eq $hashCloud){
					$dialog = steamToast  -MessageText "Saves up to date, no need to sync"
				}else{
					$dialog = steamToast  -MessageText "Downloading saves for $emuName, please wait..."
					& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload --exclude=/.watching --exclude=/.emulator -q --log-file "$userFolder/emudeck/rclone.log" --exclude=/.user "$cloud_sync_provider`:Emudeck\saves\$emuName\" "$target"
				}
			}else{
				$dialog = steamToast  -MessageText "Downloading saves for $emuName, please wait..."
				& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload --exclude=/.watching --exclude=/.emulator -q --log-file "$userFolder/emudeck/rclone.log"  --exclude=/.user "$cloud_sync_provider`:Emudeck\saves\$emuName\" "$target"
			}

		}

		$dialog.Close()
	}


}

function cloud_sync_save_hash($target){
	# Calculate the total size of the folder (including subfolders)
	$targetSize = Get-ChildItem -Recurse -Path $target | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum
	# Convert the size to a string
	$targetSizeString = $targetSize.ToString()
	# Calculate the SHA256 hash of the size string
	$sha256 = New-Object System.Security.Cryptography.SHA256Managed
	$hashBytes = [System.Text.Encoding]::UTF8.GetBytes($targetSizeString)
	$hash = [BitConverter]::ToString($sha256.ComputeHash($hashBytes)) -replace '-'
	# Path to the file where you want to save the hash
	$filePath = "$target\.hash"
	# Save the hash to a file
	$hash | Out-File -FilePath $filePath
}

function cloud_sync_upload{
	param(
		[string]$emuName,
		[string]$mode
	)

	if ($userFolder) {
		echo "running as user"
	}else{
		echo "running as service"
		$userFolder = $mode
	}

	Write-Host "upload"
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {
		#We lock cloudsync
		Write-Host "Locking..."
		cloud_sync_lock "$userFolder"
		Write-Host "Locked"
		if ($emuName -eq 'all'){
			Write-Host "upload all"
			$sh = New-Object -ComObject WScript.Shell

			$target = "$emulationPath\saves\"

			cloud_sync_save_hash($target)

			& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload --exclude=/.watching --exclude=/.emulator --exclude=/.user -q --log-file "$userFolder/emudeck/rclone.log" "$target" "$cloud_sync_provider`:Emudeck\saves\"
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
			}
		}else{
			Write-Host "upload one"
			$target = "$emulationPath\saves\$emuName"
			cloud_sync_save_hash($target)

			& $cloud_sync_bin copy -q --log-file "$userFolder/emudeck/rclone.log" --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload --exclude=/.watching --exclude=/.emulator --exclude=/.user "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\"
			if ($?) {
				Write-Host "upload success"
				Write-Host $target
				#rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue

			}else{
				Write-Host "upload KO"
			}

		}
		#We unlock cloudsync
		cloud_sync_unlock "$userFolder"
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
					cloud_sync_createBackup($emuName)
					cloud_sync_upload -emuName $emuName
				} else {
					rm -fo "$savesPath/$emuName/.fail_download" -ErrorAction SilentlyContinue
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_createBackup($emuName)
					#cloud_sync_download($emuName) No need to download, since we are going to do it later on this same script
				}
			}

			#Get-Date | Out-File -FilePath $savesPath/$emuName/.pending_upload

			#Do we have a failed download?
			if (Test-Path "$savesPath/$emuName/.fail_download") {

				$date = Get-Content "$savesPath/$emuName/.fail_download"

				$result = yesNoDialog -TitleText "CloudSync conflict - $emuName" -MessageText "We've detected a previously failed download, do you want us to download your saves and overwrite your local saves?`n`nYour latest upload was on $date.`n`n Select Upload if your more recent save is in this device, select Download if the more recent save is in the cloud " -OKButtonText "Upload" -CancelButtonText "Download"

				if ($result -eq "OKButton") {
					rm -fo "$savesPath/$emuName/.fail_download" -ErrorAction SilentlyContinue
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_createBackup($emuName)
					cloud_sync_download($emuName)
				} else {
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					rm -fo "$savesPath/$emuName/.fail_download"	 -ErrorAction SilentlyContinue
					cloud_sync_createBackup($emuName)
					cloud_sync_upload -emuName $emuName
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

function cloud_sync_createBackup($emuName){
 $date = Get-Date -Format "MM_dd_yyyy"
 Copy-Item -Path "$savesPath\$emuName" -Destination "$toolsPath\save-backups\$emuName" -Recurse
 #We delete backups older than one month
 $oldDate = (Get-Date).AddDays(-30)
 Get-ChildItem -Path "$toolsPath\save-backups" -Directory | Where-Object { $_.CreationTime -lt $oldDate } | Remove-Item -Force -Recurse
}

function cloud_sync_uploadEmu{
	param(
		[string]$emuName,
		[string]$mode
	)
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
					cloud_sync_createBackup($emuName)
					cloud_sync_upload -emuName $emuName
					rm -fo "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
				} else {
					rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_createBackup($emuName)
					cloud_sync_download($emuName)
					rm -fo "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
				}

			}else{
				rm -fo "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
				rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue

				#We use $mode for also check conflicts and to pass the username where using the background service
				if($mode -ne 'check-conflicts'){
					cloud_sync_upload -emuName $emuName -mode $mode
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
	cloud_sync_upload 'all'

}


function cloud_sync_lock($userPath){
	if (-not [string]::IsNullOrEmpty($userPath)) {
		$userFolder = "$userPath"
	}

	Add-Content "$userFolder\EmuDeck\cloud.lock" "Locked" -NoNewline
	$toast = steamToast -MessageText "Uploading..."
	Start-Sleep -Seconds 2
	$toast.Close()
}

function cloud_sync_unlock($userPath){
	if (-not [string]::IsNullOrEmpty($userPath)) {
		$userFolder = "$userPath"
	}
	Remove-Item "$userFolder\EmuDeck\cloud.lock" -Force -ErrorAction SilentlyContinue
	$toast = steamToast -MessageText "Uploads completed!"
	Start-Sleep -Seconds 2
	$toast.Close()
}

function cloud_sync_check_lock(){
	$lockedFile="$userFolder\EmuDeck\cloud.lock"
	if(Test-Path -Path $lockedFile){
		$toast = steamToast -MessageText "CloudSync in progress! We're syncing your saved games, please wait..."
		while (Test-Path -Path $lockedFile) {
			Start-Sleep -Seconds 1
		}
		$toast.Close()
	}
}
function cloud_sync_notification($text){

	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon
	$objNotifyIcon.Icon = [System.Drawing.SystemIcons]::Information
	$objNotifyIcon.BalloonTipIcon = "Info"
	$objNotifyIcon.BalloonTipTitle = "CloudSync"
	$objNotifyIcon.BalloonTipText = "$text"
	$objNotifyIcon.Visible = $True
	$objNotifyIcon.ShowBalloonTip(10000)

}

function cloud_sync_init($emulator){
	if ( Test-Path $cloud_sync_config_file_symlink ){
		if ( $cloud_sync_status -eq "true"){
			$toast = steamToast -MessageText "CloudSync watching in the background"
			#We pass the emulator to the service
			echo "$emulator" > $savesPath/.emulator
			cloud_sync_downloadEmu $emulator
			& "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" stop "CloudWatch"
			cls
			Start-Process "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" -Args "start CloudWatch" -WindowStyle Hidden
			cls
			Start-Sleep -Seconds 1
			$toast.Close()
		}
	}
}
