$DuckStation_configFile="$emusPath\duckstation\settings.ini"

function DuckStation_install(){
	setMSG "Downloading DuckStation"
	$url_duck = getLatestReleaseURLGH "stenzek/duckstation" "zip" "windows-x64" "symbols"
	download $url_duck "duckstation.zip"
	moveFromTo "$temp/duckstation" "$emusPath\duckstation"
	createLauncher "duckstation"
}
function DuckStation_init(){
	setMSG "DuckStation - Configuration"
	New-Item -Path "$emusPath\duckstation\portable.txt" -ErrorAction SilentlyContinue
	$destination="$emusPath\duckstation"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\DuckStation" "$emusPath\duckstation\"

	#Paths
	sedFile $destination\settings.ini "C:\Emulation" "$emulationPath"

	DuckStation_setupSaves
	DuckStation_setResolution $duckstationResolution

	if ("$achievementsUserToken" -ne "" ){
		DuckStation_retroAchievementsSetLogin
	}

	#
	#New Aspect Ratios
	#

	# Classic 3D Games
	if ( "$arClassic3D" -eq 169 ){
		DuckStation_wideScreenOn
	}else{
		DuckStation_wideScreenOff
	}


}
function DuckStation_update(){
	Write-Output "NYI"
}
function DuckStation_setEmulationFolder(){
	Write-Output "NYI"
}
function DuckStation_setupSaves(){
	setMSG "DuckStation - Creating Saves Links"
	#Saves
	$simLinkPath = "$emusPath\duckstation\memcards"
	$emuSavePath = "$emulationPath\saves\duckstation\saves"
	createSaveLink $simLinkPath $emuSavePath

	#States
	$simLinkPath = "$emusPath\duckstation\savestates"
	$emuSavePath = "$emulationPath\saves\duckstation\states"
	createSaveLink $simLinkPath $emuSavePath
	#cloud_sync_save_hash "$savesPath\duckstation"
}

function DuckStation_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 3 }
		"1080P" { $multiplier = 5 }
		"1440P" { $multiplier = 6 }
		"4K" { $multiplier = 9 }
	}

	setConfig "ResolutionScale" $multiplier $DuckStation_configFile
}

function DuckStation_setupStorage(){
	Write-Output "NYI"
}
function DuckStation_wipe(){
	Write-Output "NYI"
}
function DuckStation_uninstall(){
	Remove-Item -path "$emusPath\duckstation" -recurse -force
	if($?){
		Write-Output "true"
	}
}
function DuckStation_migrate(){
	Write-Output "NYI"
}
function DuckStation_setABXYstyle(){
	Write-Output "NYI"
}
function DuckStation_wideScreenOn(){
	Write-Output "NYI"
}
function DuckStation_wideScreenOff(){
	Write-Output "NYI"
}
function DuckStation_bezelOn(){
	Write-Output "NYI"
}
function DuckStation_bezelOff(){
	Write-Output "NYI"
}
function DuckStation_finalize(){
	Write-Output "NYI"
}
function DuckStation_IsInstalled(){
	$test=Test-Path -Path "$emusPath\duckstation\duckstation-qt-x64-ReleaseLTCG.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function DuckStation_resetConfig(){
	DuckStation_init
	if($?){
		Write-Output "true"
	}
}

function DuckStation_wideScreenOn(){
	setConfig "WidescreenHack" "true" "$DuckStation_configFile"
	setConfig "AspectRatio" "16:9" "$DuckStation_configFile"
}
function DuckStation_wideScreenOff(){
	setConfig "WidescreenHack" "false" "$DuckStation_configFile"
	setConfig "AspectRatio" "4:3" "$DuckStation_configFile"
}
function DuckStation_encryptCheevosToken($token, $username){
		if ([string]::IsNullOrEmpty($token) -or [string]::IsNullOrEmpty($username)) { return "" }

		$enc = [System.Text.Encoding]::UTF8
		$sha = [System.Security.Cryptography.SHA256]::Create()

		$buf = New-Object System.Collections.Generic.List[byte]
		$portable = Test-Path "$emusPath\duckstation\portable.txt"
		if (-not $portable) {
				try {
						$machineGuid = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Cryptography" -Name MachineGuid).MachineGu
						if ($machineGuid) { $buf.AddRange($enc.GetBytes($machineGuid)) }
				} catch { }
		}
		$buf.AddRange($enc.GetBytes($username))

		$key = $sha.ComputeHash($buf.ToArray())
		for ($i = 0; $i -lt 100; $i++) { $key = $sha.ComputeHash($key) }

		# Padding a múltiplo de 16 con ceros (NO PKCS7)
		$tb = $enc.GetBytes($token)
		$len = [int][Math]::Ceiling($tb.Length / 16.0) * 16
		$len = [int][Math]::Ceiling($tb.Length / 16.0) * 16
		if ($len -eq 0) { $len = 16 }
		$data = New-Object byte[] $len
		[Array]::Copy($tb, $data, $tb.Length)

		$aes = [System.Security.Cryptography.Aes]::Create()
		$aes.KeySize = 128
		$aes.Mode    = [System.Security.Cryptography.CipherMode]::CBC
		$aes.Padding = [System.Security.Cryptography.PaddingMode]::None
		$aes.Key = [byte[]]($key[0..15])
		$aes.IV  = [byte[]]($key[16..31])
		$out = $aes.CreateEncryptor().TransformFinalBlock($data, 0, $data.Length)
		return [Convert]::ToBase64String($out)
  }

  function DuckStation_retroAchievementsSetLogin(){
		$ra = RA_getCredentials
		$encToken = DuckStation_encryptCheevosToken $ra.Token $ra.User
		$hc = "$($ra.Hardcore)".ToLower()
		$content = Get-Content -Path $DuckStation_configFile -Raw
		$content = $content -replace '(?s)(\[Cheevos\].*?Enabled\s*=\s*)\w+', "[Cheevos]`nEnabled = true`nUsername = $($ra.User)`nToken = $encToken`nChallengeMode = $hc"
		$content | Set-Content -Path $DuckStation_configFile -Encoding UTF8
  }

  function DuckStation_retroAchievementsHardCoreOn(){
		setConfig 'ChallengeMode' 'true' "$DuckStation_configFile"
  }
  function DuckStation_retroAchievementsHardCoreOff(){
		setConfig 'ChallengeMode' 'false' "$DuckStation_configFile"
  }
