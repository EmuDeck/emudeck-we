$cloud_sync_path="$toolsPath/rclone"
$cloud_sync_bin="$cloud_sync_path/rclone.exe"
$cloud_sync_config_file_symlink="$cloud_sync_path/rclone.conf"
$cloud_sync_config_file="$env:APPDATA\EmuDeck\rclone.conf"


function Get-Custom-Credentials($provider){
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
		$labelUrl.Text = "IP/Host:"
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
		$labelUrl.Text = "IP/Host:"
		$labelUrl.Location = New-Object System.Drawing.Point(30, 110)
		$form.Controls.Add($labelUrl)
		$textBoxUrl = New-Object System.Windows.Forms.TextBox
		$textBoxUrl.Location = New-Object System.Drawing.Point(140, 110)
		$textBoxUrl.Size = New-Object System.Drawing.Size(150, 20)
		$form.Controls.Add($textBoxUrl)

		$labelShare = New-Object System.Windows.Forms.Label
        $labelShare.Text = "Share name:"
        $labelShare.Location = New-Object System.Drawing.Point(30, 150)
        $form.Controls.Add($labelShare)
		$textBoxShare = New-Object System.Windows.Forms.TextBox
		$textBoxShare.Location = New-Object System.Drawing.Point(140, 150)
        $textBoxShare.Size = New-Object System.Drawing.Size(150, 20)
        $form.Controls.Add($textBoxShare)

		#$labelPort = New-Object System.Windows.Forms.Label
		#$labelPort.Text = "You need to create an emudeck folder in the root of your storage before #setting up CloudSync"
		#$labelPort.Location = New-Object System.Drawing.Point(40, 200)
		#$labelPort.Width = 300
		#$labelPort.Height = 40
		#$form.Controls.Add($labelPort)

	}
	if( $provider -eq "Emudeck-SFTP" ){
		$buttonHeight=200
	} elseif( $provider -eq "Emudeck-SMB" ) {
	    $buttonHeight=200
	} else{
		$buttonHeight=160
	}

	$buttonOK = New-Object System.Windows.Forms.Button
	$buttonOK.Text = "OK"
	$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$buttonOK.Location = New-Object System.Drawing.Point(100, $buttonHeight)
	$form.Controls.Add($buttonOK)

	$buttonCancel = New-Object System.Windows.Forms.Button
	$buttonCancel.Text = "Cancel"
	$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
	$buttonCancel.Location = New-Object System.Drawing.Point(180, $buttonHeight)
	$form.Controls.Add($buttonCancel)

	$form.AcceptButton = $buttonOK
	$form.CancelButton = $buttonCancel

	$result = $form.ShowDialog()

	if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
		$username = $textBoxUsername.Text
		$password = $textBoxPassword.Text
		$share = $textBoxShare.Text
		$url = $textBoxUrl.Text
		$port = $textBoxPort.Text
		#stopLog
		return [PSCustomObject]@{
			Username = $username
			Password = $password
			Share = $share
			Url = $url
			Port = $port
		}
	}
	return $null
}


function cloud_sync_install_service(){
	#startLog($MyInvocation.MyCommand.Name)
	mkdir "$toolsPath/cloudSync" -ErrorAction SilentlyContinue
	cp "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/tools/cloudSync/WinSW-x64.xml" "$toolsPath/cloudSync"
	cp "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/tools/cloudSync/WinSW-x64.exe" "$toolsPath/cloudSync"

	sedFile "$toolsPath/cloudSync/WinSW-x64.xml" "USERPATH" "$env:USERPROFILE"
	sedFile "$toolsPath/cloudSync/WinSW-x64.xml" "USERNAME" "$env:USERNAME"

$scriptContent = @"
& "$toolsPath/cloudSync/WinSW-x64.exe" uninstall
& "$toolsPath/cloudSync/WinSW-x64.exe" install
& sc.exe sdset CloudWatch "D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;CCLCSWRPWPDTLOCRRC;;;WD)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)"
"@
	startScriptWithAdmin -ScriptContent $scriptContent
	Start-Sleep -Seconds 2

	#stopLog

}

function cloud_sync_uninstall_service(){
$scriptContent = @"
& "$toolsPath/cloudSync/WinSW-x64.exe" uninstall
"@
	startScriptWithAdmin -ScriptContent $scriptContent
}

function cloud_sync_install($cloud_sync_provider){
	#startLog($MyInvocation.MyCommand.Name)
	$batFilePath = "$env:APPDATA\EmuDeck\backend\tools\cloudSync\cloud_sync_force.bat"
	$shortcutPath = "$env:USERPROFILE\Desktop\Force CloudSync.lnk"
	$iconPath = "$env:USERPROFILE/AppData/Local/Programs/EmuDeck/EmuDeck.exe"
	$wshShell = New-Object -ComObject WScript.Shell
	$shortcut = $wshShell.CreateShortcut($shortcutPath)
	$shortcut.TargetPath = $batFilePath
	$shortcut.IconLocation = $iconPath
	$shortcut.Save()


# 	confirmDialog -TitleText "Administrator Privileges needed" -MessageText "During the installation of CloudSync you'll get several windows asking for elevated permissions. This is so we can create symlinks, a background service and set its proper permissions. Please accept all of them"

 #	& "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" stop "CloudWatch"

	 # if (-not ( & "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" status "CloudWatch" )) {
		# #We create the service
		# cloud_sync_install_service
	 # }else{
		# & "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" stop "CloudWatch"
		# & "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" remove "CloudWatch" confirm
		# cloud_sync_install_service
	 # }
	 if (-not(Test-Path "$cloud_sync_bin")) {
		$cloud_sync_releaseURL = getLatestReleaseURLGH 'rclone/rclone' 'zip' 'windows-amd64'
		download $cloud_sync_releaseURL "rclone.zip"
		setSetting "cloud_sync_provider" "$cloud_sync_provider"
		. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"
		$regex = '^.*\/(rclone-v\d+\.\d+\.\d+-windows-amd64\.zip)$'

		if ($cloud_sync_releaseURL -match $regex) {
		 $filename = $matches[1]
		 $filename = $filename.Replace('.zip','')
		 Rename-Item "$temp\rclone\$filename" -NewName "rclone"
		 moveFromTo "$temp/rclone" "$toolsPath"
		}
	 }
	 #stopLog
}

function cloud_sync_toggle($status){
	#startLog($MyInvocation.MyCommand.Name)
	setSetting "cloud_sync_status" $status
	#stopLog
}

#we create the folders to avoid errors in some providers
function createCloudFile($folder) {
	$cloudFilePath = Join-Path $folder ".cloud"
	if (-not (Test-Path $cloudFilePath)) {
		New-Item -Path $cloudFilePath -ItemType File
	}
}

function cloud_sync_config($cloud_sync_provider, $token){

	setSetting "cs_user" ""

   #startLog($MyInvocation.MyCommand.Name)
   taskkill /F /IM rclone.exe > NUL 2>NUL
   Copy-Item "$env:APPDATA\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$cloud_sync_path" -Force
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
   } elseif ($cloud_sync_provider -eq "Emudeck-OneDrive") {
	  #Get-ChildItem $savesPath -Recurse -Directory | ForEach-Object {
	#	 createCloudFile $_.FullName
	 # }
	  Start-Process $cloud_sync_bin -ArgumentList @"
	  config update $cloud_sync_provider
"@ -WindowStyle Maximized -Wait
	  & $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves"
	  # & $cloud_sync_bin copy $savesPath "$cloud_sync_provider`:Emudeck\saves" --include "*.cloud"
	  #Cleaning up
	  #Get-ChildItem -Path $carpetaLocal -Filter "*.cloud" | ForEach-Object {
	#	 Remove-Item $_.FullName
	#  }
	  Write-Output 'true'
   } elseif ($cloud_sync_provider -eq "Emudeck-SFTP") {
	  $credentials = Get-Custom-Credentials "Emudeck-SFTP"
	  $pass=$credentials.Password
	  $params="obscure $pass"
	  $obscuredPassword = Invoke-Expression "$cloud_sync_bin $params"
	  Get-ChildItem $savesPath -Recurse -Directory | ForEach-Object {
		 createCloudFile $_.FullName
	  }
	  Start-Process $cloud_sync_bin -ArgumentList @"
	  config update "Emudeck-SFTP" host=$($credentials.Url) user=$($credentials.Username) port=$($credentials.Port) pass="$obscuredPassword"
"@ -WindowStyle Maximized -Wait
	  & $cloud_sync_bin mkdir "$cloud_sync_provider`:Emudeck\saves"

	  cloud_sync_save_hash($savesPath)

	  & $cloud_sync_bin copy "$savesPath/.hash" "$cloud_sync_provider`:Emudeck\saves"
	  #Cleaning up
	  Get-ChildItem -Path $carpetaLocal -Filter "*.cloud" | ForEach-Object {
		 Remove-Item $_.FullName
	  }
	  Write-Output 'true'
   } elseif ($cloud_sync_provider -eq "Emudeck-cloud") {

		$token = $token -replace "---", '|||'

		 $parts = $token -split '\|\|\|'
		 $json = '{"token":"'+ $token + '"}'
		 $response = Invoke-RestMethod -Method Post -Uri "https://token.emudeck.com/b2.php" `
			 -ContentType "application/json" `
			 -Body $json

		 # Asignar los valores a variables
		 $cloud_key_id = $response.cloud_key_id
		 $cloud_key = $response.cloud_key

		 $pass= $($password.cloud_token)

		 $ofuspass = $pass

		 $user=$($parts[0])
		 setSetting "cs_user" "cs$user\"


		 Start-Process $cloud_sync_bin -ArgumentList @"
				  config update Emudeck-cloud key="$cloud_key" account="$cloud_key_id"
"@  -WindowStyle Maximized -Wait

		 & $cloud_sync_bin mkdir "$cloud_sync_provider`:$cs_user`Emudeck\saves"
		 cloud_sync_save_hash($savesPath)

		 & $cloud_sync_bin copy "$savesPath/.hash" "$cloud_sync_provider`:$cs_user`Emudeck\saves"

		 Write-Output 'true'
   } elseif ($cloud_sync_provider -eq "Emudeck-SMB") {
	  $credentials = Get-Custom-Credentials "Emudeck-SMB"
	  $pass=$credentials.Password
	  $share=$credentials.Share
	  $params="obscure $pass"
	  $obscuredPassword = Invoke-Expression "$cloud_sync_bin $params"

	  Start-Process $cloud_sync_bin -ArgumentList @"
	  config update "Emudeck-SMB" host=$($credentials.Url) user=$($credentials.Username) pass="$obscuredPassword"
"@  -WindowStyle Maximized -Wait

	  Get-ChildItem $savesPath -Recurse -Directory | ForEach-Object {
		 createCloudFile $_.FullName
	  }

      $path="${cloud_sync_provider}:${share}\Emudeck\saves"
	  & $cloud_sync_bin mkdir $path
	  & $cloud_sync_bin copy $savesPath $path --include "*.cloud"
	  #Cleaning up
	  Get-ChildItem -Path $carpetaLocal -Filter "*.cloud" | ForEach-Object {
		 Remove-Item $_.FullName
	  }

	  Write-Output 'true'
   } else {
	  & $cloud_sync_bin config update "$cloud_sync_provider"
	  Write-Output 'true'
   }


}


function cloud_sync_install_and_config($cloud_sync_provider, $token){
	#startLog($MyInvocation.MyCommand.Name)
	cloud_sync_install($cloud_sync_provider)
	if ($LASTEXITCODE -eq 0) {
		cloud_sync_config $cloud_sync_provider $token
		if ($LASTEXITCODE -eq 0) {
			Write-Output "true_cs"
		  } else {
			Write-Output "false_cs"
		  }
	  } else {
		Write-Output "false_cs"
	  }

	#stopLog
}


function cloud_sync_uninstall(){
	#startLog($MyInvocation.MyCommand.Name)
	setSetting "cloud_sync_status" "false"
	rm -fo -r "$cloud_sync_path"
	#stopLog
}

function cloud_sync_download($emuName){
	#startLog($MyInvocation.MyCommand.Name)
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {


		& "$cloud_sync_bin"  --progress copyto -L --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" "$cloud_sync_provider`:$cs_user`Emudeck/saves/.token" "$savesPath/.token"

		$tokenPath = "$savesPath/.token"
		if (Test-Path $tokenPath) {
			# Lee el token desde el archivo
			$token = Get-Content $tokenPath

			$url = "https://token.emudeck.com/quick-check.php?access_token=$token"

			$response = Invoke-RestMethod -Uri $url


			if ($response.status -eq $true) {
				Write-Host "Continue"
			}
			else {
				echo "exit"
				#confirmDialog -TitleText "Outdated token" -MessageText "Please open EmuDeck to regenerate your token"
				#exit
			}
		} else {
			echo "exit"
			#confirmDialog -TitleText "Token not found" -MessageText "Please open EmuDeck to regenerate your token"
			Write-Host "Token not found: $tokenPath"
			#exit
		}

		#We wait for any upload in progress
		cloud_sync_check_lock
		if ($emuName -eq 'all'){

			$sh = New-Object -ComObject WScript.Shell

			$target = "$emulationPath\saves\"
			cloud_sync_save_hash($target)
			$fileHash = "$target\.hash"

			#We compare the hashes
			if (Test-Path -PathType Any "$fileHash"){
				$hash= Get-Content $fileHash
			}else{
				$hash="0"
			}

			& $cloud_sync_bin --progress copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" "$cloud_sync_provider`:$cs_user`Emudeck\saves\.hash" "$fileHash"

			if (Test-Path -PathType Any "$fileHash"){
				$hashCloud= Get-Content $fileHash
			}

			if (Test-Path -PathType Any "$fileHash"){

				if ($hash -eq $hashCloud){
					$dialog = steamToast  -MessageText "Saves up to date, no need to sync"
				}else{
					$dialog = steamToast  -MessageText "Downloading saves for all installed system, please wait..."
					& $cloud_sync_bin copy --fast-list --update --checkers=50 --exclude=/.fail_upload --exclude=/BigPEmuConfig.bigpcfg --exclude=/.fail_download --exclude=/system/prod.keys --exclude=/system/title.keys --exclude=/.pending_upload --exclude=/.watching --exclude=/*.lnk --exclude=/.cloud --exclude=/.emulator -q --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" --exclude=/.user "$cloud_sync_provider`:$cs_user`Emudeck\saves\" "$target"
					if ($?) {
						$baseFolder = "$target"
						$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
						Get-ChildItem -Directory $baseFolder | ForEach-Object {
							$folder = $_.FullName
							$emuName = (Get-Item $folder).Name
							$lastUploadFile = "$savesPath/$emuName/.last_download"
							$failUploadFile = "$savesPath/$emuName/.fail_upload"

							if (Test-Path -PathType Container $folder) {
								$timestamp | Set-Content "$lastUploadFile" -Encoding UTF8
								Remove-Item -Path "$failUploadFile" -Force -Recurse -ErrorAction SilentlyContinue
							}
						}
					}
				}
			}else{
				$dialog = steamToast  -MessageText "Downloading saves for all installed system, please wait..."
				& $cloud_sync_bin copy  --update --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/BigPEmuConfig.bigpcfg --exclude=/.fail_download --exclude=/system/prod.keys --exclude=/system/title.keys --exclude=/.pending_upload --exclude=/.watching --exclude=/*.lnk --exclude=/.cloud --exclude=/.emulator --exclude=/.user --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" "$cloud_sync_provider`:$cs_user`Emudeck\saves\" "$target"
				if ($?) {
					$baseFolder = "$target"
					$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
					Get-ChildItem -Directory $baseFolder | ForEach-Object {
						$folder = $_.FullName
						$emuName = (Get-Item $folder).Name
						$lastUploadFile = "$savesPath/$emuName/.last_download"
						$failUploadFile = "$savesPath/$emuName/.fail_upload"

						if (Test-Path -PathType Container $folder) {
							$timestamp | Set-Content "$lastUploadFile" -Encoding UTF8
							Remove-Item -Path "$failUploadFile" -Force -Recurse -ErrorAction SilentlyContinue
						}
					}
				}
			}
		}else{
			$target = "$emulationPath\saves\$emuName\"
			cloud_sync_save_hash($target)
			$fileHash = "$target\.hash"

			#We compare the hashes
			if (Test-Path -PathType Any "$fileHash"){
				$hash= Get-Content $fileHash
			}else{
				$hash="0"
			}

			& $cloud_sync_bin -q --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" "$cloud_sync_provider`:$cs_user`Emudeck\saves\$emuName\.hash" "$fileHash"

			if (Test-Path -PathType Any "$fileHash"){
				$hashCloud= Get-Content $fileHash
			}


			if (Test-Path -PathType Any "$fileHash"){
				if ($hash -eq $hashCloud){
					$dialog = steamToast  -MessageText "Saves up to date, no need to sync"
				}else{
					$dialog = steamToast  -MessageText "Downloading saves for $emuName, please wait..."
					& $cloud_sync_bin copy --fast-list --update --tpslimit 12 --checkers=50 --exclude=/.fail_upload --exclude=/BigPEmuConfig.bigpcfg --exclude=/.fail_download --exclude=/system/prod.keys --exclude=/system/title.keys --exclude=/.pending_upload --exclude=/.watching --exclude=/*.lnk --exclude=/.cloud --exclude=/.emulator -q --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" --exclude=/.user "$cloud_sync_provider`:$cs_user`Emudeck\saves\$emuName\" "$target"
				}
			}else{
				$dialog = steamToast  -MessageText "Downloading saves for $emuName, please wait..."
				& $cloud_sync_bin copy --fast-list --update --tpslimit 12 --checkers=50 --exclude=/.fail_upload --exclude=/BigPEmuConfig.bigpcfg --exclude=/.fail_download --exclude=/system/prod.keys --exclude=/system/title.keys --exclude=/.pending_upload --exclude=/.watching --exclude=/*.lnk --exclude=/.cloud --exclude=/.emulator -q --log-file "$env:APPDATA/EmuDeck/logs/rclone.log"  --exclude=/.user "$cloud_sync_provider`:$cs_user`Emudeck\saves\$emuName\" "$target"
			}

		}

		$dialog.Close()
	}

	#stopLog
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

			& $cloud_sync_bin copy --fast-list --update --tpslimit 12 --checkers=50 --exclude=/.fail_upload --exclude=/BigPEmuConfig.bigpcfg --exclude=/.fail_download --exclude=/system/prod.keys --exclude=/system/title.keys --exclude=/.pending_upload --exclude=/.watching --exclude=/*.lnk --exclude=/.cloud --exclude=/.emulator --exclude=/.user -q --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" "$target" "$cloud_sync_provider`:$cs_user`Emudeck\saves\"
			if ($?) {
				$baseFolder = "$target"
				$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
				Get-ChildItem -Directory $baseFolder | ForEach-Object {
					$folder = $_.FullName
					$emuName = (Get-Item $folder).Name
					$lastUploadFile = "$savesPath/$emuName/.last_upload"
					$failUploadFile = "$savesPath/$emuName/.fail_upload"

					if (Test-Path -PathType Container $folder) {
						$timestamp | Set-Content "$lastUploadFile" -Encoding UTF8
						Remove-Item -Path "$failUploadFile" -Force -Recurse -ErrorAction SilentlyContinue
					}
				}
			}
		}else{
			Write-Host "upload one"
			$target = "$emulationPath\saves\$emuName"
			cloud_sync_save_hash($target)

			& $cloud_sync_bin copy -q --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" --fast-list --update --tpslimit 12 --checkers=50 --exclude=/.fail_upload --exclude=/BigPEmuConfig.bigpcfg --exclude=/.fail_download --exclude=/system/prod.keys --exclude=/system/title.keys --exclude=/.pending_upload --exclude=/.watching --exclude=/*.lnk --exclude=/.cloud --exclude=/.emulator --exclude=/.user --log-file "$env:APPDATA/EmuDeck/logs/rclone.log" "$target" "$cloud_sync_provider`:$cs_user`Emudeck\saves\$emuName\"
			if ($?) {
				Write-Host "upload success"
				Write-Host $target
				#rm -fo -r "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue

			}else{
				Write-Host "upload KO"
			}

		}
		#We unlock cloudsync
		cloud_sync_unlock "$userFolder"
	}

}


function cloud_sync_downloadEmu($emuName, $mode){
	#startLog($MyInvocation.MyCommand.Name)
	if (Test-Path "$cloud_sync_bin") {
		#We check for internet connection
		if ( check_internet_connection -eq 'true' ){
			Stop-Process -Name "Rclone" -Force -ErrorAction SilentlyContinue
			#Do we have a pending upload?
			if (Test-Path "$savesPath/$emuName/.pending_upload") {

				$date = Get-Content "$savesPath/$emuName/.pending_upload"

				$result = yesNoDialog -TitleText "CloudSync conflict - $emuName" -MessageText "We've detected a pending upload, make sure you always close the Emulator pressing SELECT + START, do you want us to upload your saves to the cloud now?`n`nThis upload should have happened on $date.`n`n Select Upload if your more recent save is in this device, select Download if the more recent save is in the cloud " -OKButtonText "Upload" -CancelButtonText "Download"

				if ($result -eq "OKButton") {
					rm -fo -r "$savesPath/$emuName/.fail_download" -ErrorAction SilentlyContinue
					rm -fo -r "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_createBackup($emuName)
					cloud_sync_upload -emuName $emuName
				} else {
					rm -fo -r "$savesPath/$emuName/.fail_download" -ErrorAction SilentlyContinue
					rm -fo -r "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
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
					rm -fo -r "$savesPath/$emuName/.fail_download" -ErrorAction SilentlyContinue
					rm -fo -r "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_createBackup($emuName)
					cloud_sync_download($emuName)
				} else {
					rm -fo -r "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					rm -fo -r "$savesPath/$emuName/.fail_download"	 -ErrorAction SilentlyContinue
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

#stopLog
}

function cloud_sync_createBackup($emuName){
	mkdir "$emulationPath\save-backups" -ErrorAction SilentlyContinue
	mkdir "$emulationPath\save-backups\$emuName" -ErrorAction SilentlyContinue
	$date = Get-Date -Format "MM_dd_yyyy"
	#We delete backups older than one month
	$oldDate = (Get-Date).AddDays(-30)
	Get-ChildItem -Path "$emulationPath\save-backups\$emuName" -Directory | Where-Object { $_.CreationTime -lt $oldDate } | Remove-Item -Force -Recurse
	Copy-Item -Path "$savesPath\$emuName\*" -Destination "$emulationPath\save-backups\$emuName" -Recurse -ErrorAction SilentlyContinue -Force
 }

function cloud_sync_uploadEmu{
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

	if (Test-Path "$cloud_sync_bin") {
		#We check for internet connection
		if ( check_internet_connection -eq 'true' ){
			Stop-Process -Name "Rclone" -Force -ErrorAction SilentlyContinue
			#Do we have a failed download?
			if (Test-Path "$savesPath/$emuName/.fail_upload") {
				$date = Get-Content "$savesPath/$emuName/.fail_upload"
				Add-Type -AssemblyName System.Windows.Forms

				$result = yesNoDialog -TitleText "CloudSync conflict - $emuName" -MessageText "We've detected a previously failed upload, do you want us to upload your saves and overwrite your saves in the cloud?`n`nYour latest upload was on $date.`n`n Select Upload if your more recent save is in this device, select Download if the more recent save is in the cloud" -OKButtonText "Upload" -CancelButtonText "Download"

				if ($result -eq "OKButton") {
					rm -fo -r "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_createBackup($emuName)
					cloud_sync_upload -emuName $emuName
					rm -fo -r "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
				} else {
					rm -fo -r "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
					cloud_sync_createBackup($emuName)
					cloud_sync_download($emuName)
					rm -fo -r "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
				}

			}else{
				rm -fo -r "$savesPath/$emuName/.fail_upload" -ErrorAction SilentlyContinue
				rm -fo -r "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue

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
	#startLog($MyInvocation.MyCommand.Name)
	Get-ChildItem -Directory $savesPath/ | ForEach-Object {
		$simLinkPath = $_.FullName
		$emuName = (Get-Item $simLinkPath).Name
		cloud_sync_downloadEmu $emuName 'check-conflicts'
	}
	cloud_sync_download 'all'
	#stopLog
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
	#startLog($MyInvocation.MyCommand.Name)
	if (-not [string]::IsNullOrEmpty($userPath)) {
		$userFolder = "$userPath"
	}

	Add-Content "$env:APPDATA/EmuDeck\cloud.lock" "Locked" -NoNewline -Encoding UTF8
	#$toast = steamToast -MessageText "Uploading..."
	#Start-Sleep -Milliseconds 500
	#$toast.Close()
	#stopLog
}

function cloud_sync_unlock($userPath){
	#startLog($MyInvocation.MyCommand.Name)
	if (-not [string]::IsNullOrEmpty($userPath)) {
		$userFolder = "$userPath"
	}
	Remove-Item "$env:APPDATA/EmuDeck\cloud.lock" -Force -ErrorAction SilentlyContinue
	#$toast = steamToast -MessageText "Uploads completed!"
	#Start-Sleep -Milliseconds 500
	#$toast.Close()
	#stopLog
}

function cloud_sync_check_lock(){
	$lockedFile="$env:APPDATA/EmuDeck\cloud.lock"
	if(Test-Path -Path $lockedFile){
		#$toast = steamToast -MessageText "CloudSync in progress! We're syncing your saved games..."
		$counter=0
		while (Test-Path -Path $lockedFile) {
			Start-Sleep -Milliseconds 200
			$counter++
			if ($counter -gt 15) {
				Remove-Item -Force -Recurse $lockedFile
			}
		}

		#$toast.Close()
	}
}

function IsServiceRunning {
	$service = Get-Service -Name "CloudWatch"
	return $service.Status -eq 'Running'
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
	#startLog($MyInvocation.MyCommand.Name)



	if ( check_internet_connection -eq 'true' ){
		if ( Test-Path $cloud_sync_config_file_symlink ){
			if ( $cloud_sync_status -eq "true"){
				"" | Set-Content $savesPath/.watching -Encoding UTF8
				$toast = steamToast -MessageText "CloudSync watching in the background"
				#We pass the emulator to the service
				$branch = Invoke-Expression "git -C $env:USERPROFILE/AppData/Roaming/EmuDeck/backend rev-parse --abbrev-ref HEAD"
				if ("$branch" -eq "early" -or "$branch" -eq "early-unstable" -or "$branch" -eq "dev"){
					if($emulator -eq "EmulationStationDE"){
						"\" | Set-Content $savesPath/.emulator -Encoding UTF8
						cloud_sync_downloadEmuAll
					}else{
						"$emulator" | Set-Content $savesPath/.emulator -Encoding UTF8
						cloud_sync_downloadEmu $emulator
					}
				}else{
					"$emulator" | Set-Content $savesPath/.emulator -Encoding UTF8
				}

				Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/tools/cloudSync/cloud_sync_watcher_user.ps1`" $env:USERNAME"

				# & "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" stop "CloudWatch"
				# cls
				# Start-Process "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/wintools/nssm.exe" -Args "start CloudWatch" -WindowStyle Hidden
				# cls
				$toast.Close()
			}
		}
	}else{
		$toast = steamToast -MessageText "CloudSync Disabled.Your saved games will be uploaded next time you play them with internet connection."
		Start-Sleep -Seconds 1
		$toast.Close()
	}
	#stopLog
}


function cloud_decky_check_status(){
	echo "nope"
}