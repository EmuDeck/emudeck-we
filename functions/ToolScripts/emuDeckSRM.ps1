function SRM_install(){
	setMSG 'Downloading Steam Rom Manager'
	$url_srm = getLatestReleaseURLGH 'dragoonDorise/steam-rom-manager' 'exe' 'portable'
	download $url_srm "srm.exe"
	Move-item -Path "$temp/srm.exe" -destination "$toolsPath/srm.exe" -force
	echo "" > "$env:USERPROFILE\EmuDeck\.srm_migrated_2123"
}

function SRM_createParsers(){
	Write-Output "Genearting Dynamic Parsers..."
	rm -fo "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\parsers\emudeck" -ErrorAction SilentlyContinue -Recurse
	Start-Sleep -Seconds 1
	mkdir $env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\parsers\emudeck -ErrorAction SilentlyContinue
	mkdir $env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\parsers\custom -ErrorAction SilentlyContinue

	rm -fo "$toolsPath\userData\parsers\emudeck" -ErrorAction SilentlyContinue -Recurse
	Start-Sleep -Seconds 1
	mkdir $toolsPath\userData\parsers\emudeck -ErrorAction SilentlyContinue
	mkdir $toolsPath\userData\parsers\custom -ErrorAction SilentlyContinue

	$exclusionList = @(
	'nintendo_gbc-ra-sameboy.json',
	'nintendo_gb-ra-sameboy.json',
	'sega_saturn-ra-yabause.json',
	'sony_psx-ra-swanstation.json',
	'nintendo_gbc-mgba.json',
	'nintendo_gb-mGBA.json'
	)

	# Multiemulator?
	if ( "$emuMULTI" -ne "both" ){
		if ( "$emuMULTI" -eq "undefined" ){
		echo "none"
		}elseif ( "$emuMULTI" -eq "ra" ){
		$exclusionList = $exclusionList + 'ares/'
		}else{
		$exclusionList = $exclusionList + 'atari_2600-ra-stella.json'
		$exclusionList = $exclusionList + 'amiga_1200-ra-puae.json';
		$exclusionList = $exclusionList + 'amiga_cd-ra-puae.json';
		$exclusionList = $exclusionList + 'bandai_wonderswan_color-ra-mednafen_swan.json'
		$exclusionList = $exclusionList + 'bandai_wonderswan-ra-mednafen_swan.json'
		$exclusionList = $exclusionList + 'nec_pc_engine_turbografx_16_cd-ra-beetle_pce.json'
		$exclusionList = $exclusionList + 'nec_pc_engine_turbografx_16-ra-beetle_pce.json'
		$exclusionList = $exclusionList + 'nintendo_64-ra-mupen64plus_next.json'
		$exclusionList = $exclusionList + 'nintendo_gb-ra-gambatte.json'
		$exclusionList = $exclusionList + 'nintendo_gb-ra-sameboy.json'
		$exclusionList = $exclusionList + 'nintendo_gba-ra-mgba.json'
		$exclusionList = $exclusionList + 'nintendo_gbc-ra-gambatte.json'
		$exclusionList = $exclusionList + 'nintendo_gbc-ra-sameboy.json'
		$exclusionList = $exclusionList + 'nintendo_nes-ra-mesen.json'
		$exclusionList = $exclusionList + 'nintendo_snes-ra-bsnes_hd.json'
		$exclusionList = $exclusionList + 'nintendo_snes-ra-snes9x.json'
		$exclusionList = $exclusionList + 'sega_32X-ra-picodrive.json'
		$exclusionList = $exclusionList + 'sega_CD_Mega_CD-ra-genesis_plus_gx.json'
		$exclusionList = $exclusionList + 'sega_dreamcast-ra-flycast.json'
		$exclusionList = $exclusionList + 'sega_game_gear-ra-genesis_plus_gx.json'
		$exclusionList = $exclusionList + 'sega_genesis-ra-genesis_plus_gx_wide.json'
		$exclusionList = $exclusionList + 'sega_genesis-ra-genesis_plus_gx.json'
		$exclusionList = $exclusionList + 'sega_mastersystem-ra-genesis-plus-gx.json'
		$exclusionList = $exclusionList + 'sinclair_zx-spectrum-ra-fuse.json'
		$exclusionList = $exclusionList + 'snk_neo_geo_pocket_color-ra-beetle_neopop.json'
		$exclusionList = $exclusionList + 'snk_neo_geo_pocket-ra-beetle_neopop.json'
		}
	}


	#psx
		if ( "$emuPSX" -ne "both" ){
			if ( "$emuPSX" -eq "duckstation" ){
			$exclusionList = $exclusionList + 'sony_psx-ra-swanstation.json'
			$exclusionList = $exclusionList + 'sony_psx-ra-beetle_psx_hw.json'
			}else{
			$exclusionList = $exclusionList + 'sony_psx-duckstation.json'
			}
		}

	#psp
	if ( "$emuPSP" -ne "both" ){
		if ( "$emuPSP" -eq "ppsspp" ){
		$exclusionList = $exclusionList + 'sony_psp-ra-ppsspp.json'
		}else{
		$exclusionList = $exclusionList + 'sony_psp-ppsspp.json'
		}
	}

	#melonDS
	if ( "$emuNDS" -ne "both" ){
		if ( "$emuNDS" -eq "melonDS" ){
		$exclusionList = $exclusionList + 'nintendo_ds-ra-melonds.json'
		}else{
		$exclusionList = $exclusionList + 'nintendo_ds-melonds.json'
		}
	}

	#FlyCast
	if ( "$emuDream" -ne "both" ){
		if ( "$emuDream" -eq "flycast" ){
		$exclusionList = $exclusionList + 'sony_psx-ra-swanstation.json'
		$exclusionList = $exclusionList + 'sony_psx-ra-beetle_psx_hw.json'
		}else{
		$exclusionList = $exclusionList + 'sega-dreamcast-flycast.json'
		}
	}
	#gba
	if ( "$emuGBA" -ne "both" ){
		if ( "$emuGBA" -eq "mgba" ){
			$exclusionList = $exclusionList + 'nintendo_gameboy-advance-ares.json'
			$exclusionList = $exclusionList + 'nintendo_gba-ra-mgba.json'
		}else{
			$exclusionList = $exclusionList + 'nintendo_gba-mgba.json'
		}
	}


	#Exclusion based on install status.
	if ( $doInstallPrimeHack -ne "true" -or -not (PrimeHack_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"nintendo_primehack.json"
	}
	if ( $doInstallRPCS3 -ne "true" -or -not (RPCS3_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"sony_ps3-rpcs3-extracted_iso_psn.json"
		$exclusionList=$exclusionList+"sony_ps3-rpcs3-pkg.json"
	}

	if ( $doInstallCitra -ne "true" -or -not (Citra_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"nintendo_3ds-citra.json"
	}
	if ( $doInstallDolphin -ne "true" -or -not (Dolphin_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"nintendo_gc-dolphin.json"
		$exclusionList=$exclusionList+"nintendo_wii-dolphin.json"
	}
	if ( $doInstallDuck -ne "true" -or -not (Duckstation_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"sony_psx-duckstation.json"
	}
	if ( $doInstallPPSSPP -ne "true" -or -not (PPSSPP_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"sony_psp-ppsspp.json"
	}
	if ( $doInstallYuzu -ne "true" -or -not (Yuzu_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"nintendo_switch-yuzu.json"
	}
	if ( $doInstallCemu -ne "true" -or -not (Cemu_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"nintendo_wiiu-cemu-rpx.json"
		$exclusionList=$exclusionList+"nintendo_wiiu-cemu-wud-wux-wua.json"
	}
	if ( $doInstallRyujinx -ne "true" -or -not (Ryujinx_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"nintendo_switch-ryujinx.json"
	}
	if ( "$doInstallPCSX2" -ne "true" -or -not (PCSX2QT_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"sony_ps2-pcsx2.json"
	}
	if ( "$doInstallSuperModel" -ne "true" -or -not (SuperModel_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"sega_arcade-supermodel.json"
	}
	if ( $doInstallScummVM -ne "true" -or -not (ScummVM_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"scumm_scummvm.json"
	}
	if ( $doInstallVita3K -ne "true" -or -not (Vita3K_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"sony_psvita-vita3k-pkg.json"
	}
	if ( $doInstallmGBA -ne "true" -or -not (mGBA_isInstalled -like "*true*")){
		$exclusionList=$exclusionList+"nintendo_gba-mgba.json"
	}


	Start-Sleep -Seconds 1

	echo $exclusionList > "$env:USERPROFILE\EmuDeck\logs\SRM_exclusionList.log"

	if($steamAsFrontend -ne "False"){
		Get-ChildItem -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\parsers\emudeck\" -Filter *.json | ForEach-Object {
		if ($_ -notin $exclusionList) {
			Copy-Item -Path $_.FullName -Destination "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\parsers\emudeck" -Force
		}
		}

		Get-ChildItem -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\parsers\emudeck\" -Filter *.json | ForEach-Object {
			if ($_ -notin $exclusionList) {
			Copy-Item -Path $_.FullName -Destination "$toolsPath\userData\parsers\emudeck" -Force
			}
	 	}
	}else{
		Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\parsers\emudeck\0_emulationstationde.json" -Destination "$toolsPath\userData\parsers\emudeck\0_emulationstationde.json" -Force
		Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\parsers\emudeck\1_emulators.json" -Destination "$toolsPath\userData\parsers\emudeck\1_emulators.json" -Force
	}

	$mainParserFolder = "$toolsPath\userData\parsers"
	$mainParserFile = "$toolsPath\userData\userConfigurations.json"
	$parserList = @()

	Get-ChildItem -Path $mainParserFolder -Filter *.json -File -Recurse | ForEach-Object {
	$parserList += Get-Content $_.FullName -Raw
	}

	"[`n" + ($parserList -join ","	) + "`n]" | Out-File $mainParserFile -Encoding UTF8
	(get-content $mainParserFile) -replace '\x00','' | set-content $mainParserFile

}

function SRM_addSteamInputProfiles(){
	Write-Output "Checking and updating Steam Input profiles..."
	 Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\controllerTemplates.json" -Destination "$toolsPath\userData\" -Force
	 Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\controllerTemplates.json" -Destination "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\"	-Force
	 $PFPath="$steamInstallPath\controller_base\templates\"
	 Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-input\*" -Destination $PFPath -Recurse	-Force
}

function SRM_init(){

	#Fix for games with - in it's path
	$test=Test-Path -Path "$env:USERPROFILE\EmuDeck\.srm_migrated_2123"
	if($test){
			echo "already migrated"
	}else{
			confirmDialog -TitleText 'SRM fix for games containing "-" in the filename' -MessageText "We are gonna fix your SRM shorcuts, if you find any game not working after this please reparse that system."

		$folders = Get-ChildItem -Path ("$steamInstallPath\userdata") -Directory

		foreach ($folder in $folders) {

			$filePath = "$steamInstallPath\userdata\$folder\config\shortcuts.vdf"
			if (Test-Path -Path "$filePath") {
				$shorcutsPath = "$filePath"
			}
		}
		Copy-Item "$shorcutsPath" -Destination "$shorcutsPath_2123.bak" -ErrorAction SilentlyContinue
		sedFile "$shorcutsPath" '"-L' '-L'
		sedFile "$shorcutsPath" 'cores' "'cores"
		sedFile "$shorcutsPath" '.dll"' ".dll'"
		sedFile "$shorcutsPath" '"""' "'"
		sedFile "$shorcutsPath" ' && exit " && exit' '}" && exit " && exit'
		sedFile "$shorcutsPath" '"-b"' '-b'
		sedFile "$shorcutsPath" '"-e"' '-e'
		sedFile "$shorcutsPath" '"-f"' '-f'
		sedFile "$shorcutsPath" '"-g"' '-g'
		sedFile "$shorcutsPath" '"--no-gui"' '--no-gui'
		sedFile "$shorcutsPath" '"-fullscreen"' '-fullscreen'
		echo "" > "$env:USERPROFILE\EmuDeck\.srm_migrated_2123"
	}

	setMSG 'Steam Rom Manager - Configuration'

	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\userSettings.json" -Destination "$toolsPath\userData\" -Force
	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\userSettings.json" -Destination "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\" -Force

	#Paths
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userConfigurations.json" "C:\\Emulation" "$emulationPath"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userConfigurations.json" "EMUSPATH" "$emusPathSRM"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userConfigurations.json" "USERPATH" "$userFolder"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userConfigurations.json" "Users\" "Users\\"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userConfigurations.json" ":\" ":\\"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userConfigurations.json" "\\\" "\\"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userSettings.json" "C:\\Emulation" "$emulationPath"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userSettings.json" "EMUSPATH" "$emusPathSRM"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userSettings.json" "STEAMPATH" "$steamInstallPath"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userSettings.json" "Users\" "Users\\"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userSettings.json" ":\" ":\\"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userSettings.json" "\\\" "\\"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\controllerTemplates.json" "STEAMPATH" "$steamInstallPath"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\controllerTemplates.json" "Users\" "Users\\"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\controllerTemplates.json" ":\" ":\\"
	sedFile "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\controllerTemplates.json" "\\\" "\\"

	sedFile "$toolsPath\userData\userConfigurations.json" "C:\\Emulation" "$emulationPath"
	sedFile "$toolsPath\userData\userConfigurations.json" "EMUSPATH" "$emusPathSRM"
	sedFile "$toolsPath\userData\userConfigurations.json" "USERPATH" "$userFolder"
	sedFile "$toolsPath\userData\userConfigurations.json" "Users\" "Users\\"
	sedFile "$toolsPath\userData\userConfigurations.json" ":\" ":\\"
	sedFile "$toolsPath\userData\userConfigurations.json" "\\\" "\\"

	sedFile "$toolsPath\userData\userSettings.json" "C:\\Emulation" "$emulationPath"
	sedFile "$toolsPath\userData\userSettings.json" "EMUSPATH" "$emusPathSRM"
	sedFile "$toolsPath\userData\userSettings.json" "STEAMPATH" "$steamInstallPathSRM"
	sedFile "$toolsPath\userData\userSettings.json" "Users\" "Users\\"
	sedFile "$toolsPath\userData\userSettings.json" ":\" ":\\"
	sedFile "$toolsPath\userData\userSettings.json" "\\\" "\\"

	sedFile "$toolsPath\userData\controllerTemplates.json" "STEAMPATH" "$steamInstallPathSRM"
	sedFile "$toolsPath\userData\controllerTemplates.json" "Users\" "Users\\"
	sedFile "$toolsPath\userData\controllerTemplates.json" ":\" ":\\"
	sedFile "$toolsPath\userData\controllerTemplates.json" "\\\" "\\"
	setMSG 'Steam Rom Manager - Creating Parsers & Steam Input profiles'
	SRM_createParsers
	SRM_addSteamInputProfiles

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
	Remove-Item –path "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData" –recurse -force
	Remove-Item –path "$toolsPath\userData" –recurse -force
	Remove-Item –path "$toolsPath\srm.exe" –recurse -force
	if($?){
		Write-Output "true"
	}
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

	$FIPSAlgorithmPolicy = Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy
	$EnabledValue = $FIPSAlgorithmPolicy.Enabled

	if($EnabledValue -eq 1){
	$result = yesNoDialog -TitleText "Windows FIPS detected" -MessageText "we need to turn it off so cloudSync can be used, after that the computer will restart. Once back in the desktop just run this installer again. You can read about FIPS here and why is better to disable it: https://techcommunity.microsoft.com/t5/microsoft-security-baselines/why-we-re-not-recommending-fips-mode-anymore/ba-p/701037" -OKButtonText "Fix and restart" -CancelButtonText ""

	if ($result -eq "OKButton") {
$scriptContent = @"
Set-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy -name Enabled -value 0; Restart-Computer -Force
"@
		startScriptWithAdmin -ScriptContent $scriptContent
	} else {
		echo "nope"
	}
	}

	#We clean the saves folders from .lnk files
	Get-ChildItem -Path "$savesPath" -File -Recurse | Where-Object { $_.Extension -eq ".lnk" } | Remove-Item -Force
	Get-ChildItem -Path "$emusPath" -File -Recurse | Where-Object { $_.Extension -eq ".lnk" } | Remove-Item -Force
	Get-ChildItem -Path "$toolsPath\launchers\" -File -Recurse | Where-Object { $_.Extension -eq ".bat" } | Remove-Item -Force

	createLauncher "srm\steamrommanager"
	$setupSaves=''

	if ($doInstallPegasus -eq "true" -or (Pegasus_isInstalled -like "*true*")){
		createLauncher "pegasus\pegasus-frontend"
	}
	if ($doInstallRA -eq "true" -or (RA_isInstalled -like "*true*")){
		createLauncher retroarch
		$setupSaves+="RetroArch_setupSaves;"
	}
	if ($doInstallDolphin -eq "true" -or (Dolphin_isInstalled -like "*true*")){
		createLauncher dolphin
		$setupSaves+="Dolphin_setupSaves;"
	}
	if ($doInstallPCSX2 -eq "true" -or (PCSX2_isInstalled -like "*true*")){
		createLauncher pcsx2
		$setupSaves+="PCSX2_setupSaves;"
	}
	if ($doInstallRPCS3 -eq "true" -or (RPCS3_isInstalled -like "*true*")){
		createLauncher rpcs3
		$setupSaves+="RPCS3_setupSaves;"
	}
	if ($doInstallYuzu -eq "true" -or (Yuzu_isInstalled -like "*true*")){
		createLauncher yuzu
		$setupSaves+="Yuzu_setupSaves;"
	}
	if ($doInstallRyujinx -eq "true" -or (Ryujinx_isInstalled -like "*true*")){
		createLauncher "Ryujinx"
		$setupSaves+="Ryujinx_setupSaves;"
	}
	if ($doInstallCitra -eq "true" -or (Citra_isInstalled -like "*true*")){
		createLauncher Citra
		$setupSaves+="Citra_setupSaves;"
	}
	if ($doInstallDuck -eq "true" -or (DuckStation_isInstalled -like "*true*")){
		createLauncher duckstation
		$setupSaves+="DuckStation_setupSaves;"
	}
	if ($doInstallmelonDS -eq "true" -or (melonDS_isInstalled -like "*true*")){
		createLauncher melonDS
		$setupSaves+="melonDS_setupSaves;"
	}
	if ($doInstallCemu -eq "true" -or (Cemu_isInstalled -like "*true*")){
		createLauncher cemu
		$setupSaves+="Cemu_setupSaves;"
	}

	if ($doInstallPPSSPP -eq "true" -or (PPSSPP_isInstalled -like "*true*")){
		createLauncher PPSSPP
		$setupSaves+="PPSSPP_setupSaves;"
	}
	if ($doInstallESDE -eq "true" -or (ESDE_isInstalled -like "*true*")){
		createLauncher "esde\EmulationStationDE"
	}

	if ($doInstallXemu -eq "true" -or (Xemu_isInstalled -like "*true*")){
		createLauncher xemu
		$setupSaves+="Xemu_setupSaves;"
	}
	if ($doInstallXenia -eq "true" -or (Xenia_isInstalled -like "*true*")){
		createLauncher xenia
		$setupSaves+="Xenia_setupSaves;"
	}
	if ($doInstallFlycast -eq "true" -or (Flycast_isInstalled -like "*true*")){
		createLauncher flycast
		$setupSaves+="Flycast_setupSaves;"
	}
	if ($doInstallSuperModel -eq "true" -or (SuperModel_isInstalled -like "*true*")){
		createLauncher supermodel
		$setupSaves+="SuperModel_setupSaves;"
	}
	if ($doInstallVita3k -eq "true" -or (Vita3k_isInstalled -like "*true*")){
		createLauncher Vita3k
		$setupSaves+="Vita3k_setupSaves;"
	}
	if ($doInstallScummVM -eq "true" -or (ScummVM_isInstalled -like "*true*")){
		createLauncher ScummVM
		$setupSaves+="ScummVM_setupSaves;"
	}

	if ( $setupSaves -ne '' ){
		$setupSaves = $setupSaves.Substring(0, $setupSaves.Length - 1)
		Invoke-Expression $setupSaves
	}
}







	 #gba
		 # if ( "$emuGBA" -ne "both" ){
		 #	 if ( "$emuGBA" -eq "mgba" ){
		 # 	$exclusionList = $exclusionList + 'nintendo_gameboy-advance-ares.json'
		 # 	$exclusionList = $exclusionList + 'nintendo_gba-ra-mgba.json'
		 #	 }else{
		 # 	$exclusionList = $exclusionList + 'nintendo_gba-mgba.json'
		 #	 }
		 # }

 #N64?
		 # if ( "$emuN64" -ne "both" ); then
			 # if ( "$emuN64" -eq "rgm" ); then
		 # 	$exclusionList=$exclusionList+"nintendo_64-ra-mupen64plus_next.json"
		 # 	$exclusionList=$exclusionList+"nintendo_64-ares.json"
		 # 	$exclusionList=$exclusionList+"nintendo_64dd-ares.json"
			 # else
		 # 	$exclusionList=$exclusionList"+nintendo_64-rmg.json"
			 # fi
		 # fi
	 #if ( $doInstallMGBA -ne "true" -or -not (MGBA_isInstalled -eq "true" -like "*true*")){
			#	$exclusionList=$exclusionList+"nintendo_gb-mGBA.json"
			#	$exclusionList=$exclusionList+"nintendo_gba-mgba.json"
			#	$exclusionList=$exclusionList+"nintendo_gbc-mgba.json"
			#}
