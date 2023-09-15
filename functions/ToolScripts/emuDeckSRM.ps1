function SRM_install(){
	setMSG 'Downloading Steam Rom Manager'
	$url_srm = getLatestReleaseURLGH 'SteamGridDB/steam-rom-manager' 'exe' 'portable'
	download $url_srm "srm.exe"	
	Move-item -Path "$temp/srm.exe" -destination "$toolsPath/srm.exe" -force	
}
function SRM_init(){
	setMSG 'Steam Rom Manager - Configuration'	
	mkdir $toolsPath\userData\parsers\emudeck -ErrorAction SilentlyContinue
	mkdir $toolsPath\userData\parsers\custom -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\controllerTemplates.json" $toolsPath\userData\
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\userSettings.json" $toolsPath\userData\
	
	$exclusionList=""
	# Multiemulator?
	if ( "$emuMULTI" -ne "both" ){
		if ( "$emuMULTI" -eq "ra" ){
	  	$exclusionList="${exclusionList}ares/"
		}else{
	  	$exclusionList="${exclusionList}atari_2600-ra-stella.json "
	  	$exclusionList="${exclusionList}bandai_wonderswan_color-ra-mednafen_swan.json "
	  	$exclusionList="${exclusionList}bandai_wonderswan-ra-mednafen_swan.json "
	  	$exclusionList="${exclusionList}nec_pc_engine_turbografx_16_cd-ra-beetle_pce.json "
	  	$exclusionList="${exclusionList}nec_pc_engine_turbografx_16-ra-beetle_pce.json "
	  	$exclusionList="${exclusionList}nintendo_64-ra-mupen64plus_next.json "
	  	$exclusionList="${exclusionList}nintendo_gb-ra-gambatte.json "
	  	$exclusionList="${exclusionList}nintendo_gb-ra-sameboy.json "
	  	$exclusionList="${exclusionList}nintendo_gba-ra-mgba.json "
	  	$exclusionList="${exclusionList}nintendo_gbc-ra-gambatte.json "
	  	$exclusionList="${exclusionList}nintendo_gbc-ra-sameboy.json "
	  	$exclusionList="${exclusionList}nintendo_nes-ra-mesen.json "
	  	$exclusionList="${exclusionList}nintendo_snes-ra-bsnes_hd.json "
	  	$exclusionList="${exclusionList}nintendo_snes-ra-snes9x.json "
	  	$exclusionList="${exclusionList}sega_32X-ra-picodrive.json "
	  	$exclusionList="${exclusionList}sega_CD_Mega_CD-ra-genesis_plus_gx.json "
	  	$exclusionList="${exclusionList}sega_dreamcast-ra-flycast.json "
	  	$exclusionList="${exclusionList}sega_game_gear-ra-genesis_plus_gx.json "
	  	$exclusionList="${exclusionList}sega_genesis-ra-genesis_plus_gx_wide.json "
	  	$exclusionList="${exclusionList}sega_genesis-ra-genesis_plus_gx.json "
	  	$exclusionList="${exclusionList}sega_mastersystem-ra-genesis-plus-gx.json "
	  	$exclusionList="${exclusionList}sinclair_zx-spectrum-ra-fuse.json "
	  	$exclusionList="${exclusionList}snk_neo_geo_pocket_color-ra-beetle_neopop.json "
	  	$exclusionList="${exclusionList}snk_neo_geo_pocket-ra-beetle_neopop.json "
		}
	}
	
	#gba?
	if ( "$emuGBA" -ne "both" ){
		if ( "$emuGBA" -eq "mgba" ){
			$exclusionList="${exclusionList}nintendo_gameboy-advance-ares.json "
			$exclusionList="${exclusionList}nintendo_gba-ra-mgba.json "
		}else{		
			$exclusionList="${exclusionList}nintendo_gba-mgba.json "
		}
	}
	#psp
	if ( "$emuPSP" -ne "both" ){
		if ( "$emuPSP" -eq "ppsspp" ){
			$exclusionList="${exclusionList}sony_psp-ra-ppsspp.json "
		}else{
			$exclusionList="${exclusionList}sony_psp-ppsspp.json "		
		}
	}
	#melonDS
	if ( "$emuNDS" -ne "both" ){
		if ( "$emuNDS" -eq "melonds" ){
			$exclusionList="${exclusionList}nintendo_ds-ra-melonds.json "
		}else{
			$exclusionList="${exclusionList}nintendo_ds-melonds.json "
		}
	}
	#mame
	if ( "$emuMAME" -ne "both" ){
		if ( "$emuMAME" -eq "mame" ){	
			$exclusionList="${exclusionList}arcade-ra-mame_2010.json "
			$exclusionList="${exclusionList}arcade-ra-mame.json "
			$exclusionList="${exclusionList}arcade-ra-mame_2003_plus.json "
		}else{
			$exclusionList="${exclusionList}arcade-mame.json "
			$exclusionList="${exclusionList}tiger_electronics_gamecom-mame.json "
			$exclusionList="${exclusionList}vtech_vsmile-mame.json "
			$exclusionList="${exclusionList}snk_neo_geo_cd-mame.json "
			$exclusionList="${exclusionList}philips_cd_i-mame.json "		
		}
	}
	
	#Optional parsers
	$exclusionList="${exclusionList}nintendo_gbc-ra-sameboy.json "
	$exclusionList="${exclusionList}nintendo_gb-ra-sameboy.json "
	$exclusionList="${exclusionList}sega_saturn-ra-yabause.json "
	$exclusionList="${exclusionList}sony_psx-ra-swanstation.json "
	$exclusionList="${exclusionList}nintendo_gbc-mgba.json "
	$exclusionList="${exclusionList}nintendo_gb-mGBA.json "
	
	
	#$exclusionList | Set-Content -Path "$env:USERPROFILE\EmuDeck\exclude.txt"
	
	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\parsers\emudeck\*.json" -Destination "$toolsPath\userData\parsers\emudeck" -Recurse -Force -Exclude $exclusionList
	
	$mainParserFolder="$toolsPath\userData\parsers\"
	$mainParserFile = "$toolsPath\userData\userConfigurations.json"
	 
	$JSONpartials = Get-ChildItem -Path "$mainParserFolder" -Filter "*.json" -File -Recurse
	$combinedData = @()
	foreach ($file in $JSONpartials) {
		$JSONcontent = Get-Content -Path $file.FullName | ConvertFrom-Json
		$combinedData += $JSONcontent
	}
	$combinedData | ConvertTo-Json | Set-Content -Path $mainParserFile
	
	#rm -fo "$env:USERPROFILE\EmuDeck\exclude.txt"
	
	
	Start-Sleep -Seconds 1
	
	#Steam installation	
	$steamRegPath = "HKCU:\Software\Valve\Steam"
	$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
	$steamInstallPath = $steamInstallPath.Replace("/", "\\")
	
	#Paths
	sedFile $toolsPath\UserData\userConfigurations.json "C:\\Emulation" $emulationPath
	sedFile $toolsPath\UserData\userConfigurations.json "EMUSPATH" $emusPathSRM
	sedFile $toolsPath\UserData\userConfigurations.json "USERPATH" $userFolder
	sedFile $toolsPath\UserData\userConfigurations.json "Users\" "Users\\"
	sedFile $toolsPath\UserData\userConfigurations.json ":\" ":\\"
	sedFile $toolsPath\UserData\userConfigurations.json "\\\" "\\"
	
	sedFile $toolsPath\UserData\userSettings.json "C:\\Emulation" $emulationPath
	sedFile $toolsPath\UserData\userSettings.json "EMUSPATH" $emusPathSRM
	sedFile $toolsPath\UserData\userSettings.json "STEAMPATH" $steamInstallPath
	sedFile $toolsPath\UserData\userSettings.json "Users\" "Users\\"
	sedFile $toolsPath\UserData\userSettings.json ":\" ":\\"
	sedFile $toolsPath\UserData\userSettings.json "\\\" "\\"
	
	sedFile $toolsPath\UserData\controllerTemplates.json "STEAMPATH" $steamInstallPath
	sedFile $toolsPath\UserData\controllerTemplates.json "Users\" "Users\\"
	sedFile $toolsPath\UserData\controllerTemplates.json ":\" ":\\"
	sedFile $toolsPath\UserData\controllerTemplates.json "\\\" "\\"


	#Desktop Icon
	createLink "$toolsPath\srm.exe" "$env:USERPROFILE\Desktop\EmuDeck - Steam Rom Manager.lnk"		
	#Start Menu
	#mkdir "$EmuDeckStartFolder" -ErrorAction SilentlyContinue
	#createLink "$toolsPath\srm.exe" "$EmuDeckStartFolder\EmuDeck - Steam Rom Manager.lnk"
	
	#SteamInput
	$PFPath="$env:ProgramFiles (x86)\Steam\controller_base\templates\"
	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-input\*" -Destination $PFPath -Recurse
	

		
}
function SRM_update(){
	Write-Output "NYI"
}
function SRM_setEmulationFolder(){
	Write-Output "NYI"
}
function SRM_setupSaves(){
	Write-Output "NYI"
}
function SRM_setupStorage(){
	Write-Output "NYI"
}
function SRM_wipe(){
	Write-Output "NYI"
}
function SRM_uninstall(){
	Remove-Item –path "$toolsPath\userData" –recurse -force
	Remove-Item –path "$toolsPath\srm.exe" –recurse -force
}
function SRM_migrate(){
	Write-Output "NYI"
}
function SRM_setABXYstyle(){
	Write-Output "NYI"
}
function SRM_wideScreenOn(){
	Write-Output "NYI"
}
function SRM_wideScreenOff(){
	Write-Output "NYI"
}
function SRM_bezelOn(){
	Write-Output "NYI"
}
function SRM_bezelOff(){
	Write-Output "NYI"
}
function SRM_finalize(){
	Write-Output "NYI"
}
function SRM_IsInstalled(){
	$test=Test-Path -Path "$toolsPath\srm.exe"
	if($test){
		Write-Output "true"
	}
}
function SRM_resetConfig(){
	SRM_init
	SRM_resetLaunchers
	if($?){
		Write-Output "true"
	}
}

function SRM_resetLaunchers(){	

	#We reset the saves folders
	$setupSaves=''
	$element = Get-Item -Path "$savesPath\retroarch\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="RetroArch_setupSaves;"
	}
	
	$element = Get-Item -Path "$savesPath\duckstation\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="DuckStation_setupSaves;"
	}
	
	$element = Get-Item -Path "$savesPath\dolphin\wii"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="Dolphin_setupSaves;"
	}
	
	$element = Get-Item -Path "$savesPath\yuzu\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="Yuzu_setupSaves;"
	}
	
	$element = Get-Item -Path "$savesPath\ryujinx\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="Ryujinx_setupSaves;"
	}
	
	$element = Get-Item -Path "$savesPath\citra\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="Citra_setupSaves;"
	}
	
	$element = Get-Item -Path "$savesPath\Cemu\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="Cemu_setupSaves;"
	}
	
	$element = Get-Item -Path "$savesPath\pcsx2\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="PCSX2QT_setupSaves;"
	}
	
	$element = Get-Item -Path "$savesPath\rpcs3\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="RPCS3_setupSaves;"
	}	
	
	$element = Get-Item -Path "$savesPath\ppsspp\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="PPSSPP_setupSaves;"
	}	
	
	$element = Get-Item -Path "$savesPath\melonDS\saves"
	if ( "$element" -eq ".lnk" ){
		$setupSaves+="melonDS_setupSaves;"
	}
	
	#if ( "$doSetupXemu" -eq "true" ){
		#$setupSaves+="#Xemu_setupSaves;"
	#}
	
	#if ( "$doSetupXenia" -eq "true" ){
		#$setupSaves+="#Xenia_setupSaves;"
	#}
	
	
	#if ( "$doSetupVita3K" -eq "true" ){
		#$setupSaves+="#Vita3K_setupSaves;"
	#}
	
	#if ( "$doSetupScummVM" -eq "true" ){
		#$setupSaves+="#ScummVM_setupSaves;"
	#}
	
$scriptContent = @"
	. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1; $setupSaves
"@
	
	startScriptWithAdmin -ScriptContent $scriptContent
	
	Get-ChildItem -Path "$savesPath" -File -Recurse | Where-Object { $_.Extension -eq ".lnk" } | Remove-Item -Force
	
	Get-ChildItem -Path "$toolsPath\launchers\" -File -Recurse | Where-Object { $_.Extension -eq ".bat" } | Remove-Item -Force

	if ($doInstallRA -eq "true"){
		createLauncher retroarch
	}
	if ($doInstallDolphin -eq "true"){
		createLauncher dolphin
	}
	if ($doInstallPCSX2 -eq "true"){
		createLauncher pcsx2
	}
	if ($doInstallRPCS3 -eq "true"){
		createLauncher rpcs3
	}
	if ($doInstallYuzu -eq "true"){
		createLauncher yuzu
	}
	if ($doInstallRyujinx -eq "true"){
		createLauncher "Ryujinx"
	}
	if ($doInstallCitra -eq "true"){
		createLauncher citra
	}
	if ($doInstallDuck -eq "true"){
		createLauncher duckstation
	}
	if ($doInstallmelonDS -eq "true"){
		createLauncher melonDS
	}
	if ($doInstallCemu -eq "true"){
		createLauncher cemu
	}
	#if ($doInstallXenia -eq "true"){
	#	createLauncher xenia
	#}
	if ($doInstallPPSSPP -eq "true"){
		createLauncher PPSSPP
	}
	#if ($doInstallXemu -eq "true"){
	#	createLauncher xemu
	#}
	
	if ($doInstallESDE -eq "true"){
		createLauncher "esde\EmulationStationDE"
	}
	
}