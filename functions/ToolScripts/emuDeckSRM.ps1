function SRM_install(){
	setMSG 'Downloading Steam Rom Manager'
	$url_srm = getLatestReleaseURLGH 'dragoonDorise/steam-rom-manager' 'exe' 'portable'
	download $url_srm "srm.exe"
	Move-item -Path "$temp/srm.exe" -destination "$toolsPath/srm.exe" -force
	echo "" > "$env:USERPROFILE\EmuDeck\.srm_migrated_2123"
}
function SRM_init(){

  #Fix for games with - in it's path
  $test=Test-Path -Path "$env:USERPROFILE\EmuDeck\.srm_migrated_2123"
  if($test){
	  echo "already migrated"
  }else{
	  confirmDialog -TitleText 'SRM fix for games containing "-" in the filename' -MessageText "We are gonna fix your SRM shorcuts, if you find any game not working after this please reparse that system."
	  #Steam installation Path
		$steamRegPath = "HKCU:\Software\Valve\Steam"
		$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
		$steamInstallPath = $steamInstallPath.Replace("/", "\\")

		$folders = Get-ChildItem -Path (Join-Path $steamInstallPath "userdata") -Directory

		# Busca el archivo shortcuts.vdf en cada carpeta de userdata
		foreach ($folder in $folders) {
			$filePath = Join-Path $folder.FullName "shortcuts.vdf"
			if (Test-Path -Path $filePath) {
				$shorcutsPath = $filePath
				$shorcutsContent = Get-Content -Path $filePath
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
  rm -fo "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\parsers\emudeck" -ErrorAction SilentlyContinue -Recurse
  Start-Sleep -Seconds 1
  mkdir $env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\parsers\emudeck -ErrorAction SilentlyContinue
  mkdir $env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\parsers\custom -ErrorAction SilentlyContinue
  Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\controllerTemplates.json" -Destination "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\"
  Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\userSettings.json" -Destination "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\"

	rm -fo "$toolsPath\userData\parsers\emudeck" -ErrorAction SilentlyContinue -Recurse
	Start-Sleep -Seconds 1
	mkdir $toolsPath\userData\parsers\emudeck -ErrorAction SilentlyContinue
	mkdir $toolsPath\userData\parsers\custom -ErrorAction SilentlyContinue
	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\controllerTemplates.json" -Destination "$toolsPath\userData\"
	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\userSettings.json" -Destination "$toolsPath\userData\"


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

  $mainParserFolder = "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\parsers\emudeck"

  $mainParserFile = "$env:USERPROFILE\AppData\Roaming\steam-rom-manager\userData\userConfigurations.json"
  "[`n" + ((Get-Content "$mainParserFolder\*.json" -raw) -join ","  ) + "`n]" | Out-File $mainParserFile -Encoding UTF8
  (get-content $mainParserFile) -replace '\x00','' | set-content $mainParserFile -Encoding UTF8

  $mainParserFolder = "$toolsPath\userData\parsers\emudeck"
  $mainParserFile = "$toolsPath\userData\userConfigurations.json"
  "[`n" + ((Get-Content "$mainParserFolder\*.json" -raw) -join ","  ) + "`n]" | Out-File $mainParserFile -Encoding UTF8
 (get-content $mainParserFile) -replace '\x00','' | set-content $mainParserFile -Encoding UTF8


  #Steam installation Path
  $steamRegPath = "HKCU:\Software\Valve\Steam"
  $steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
  $steamInstallPath = $steamInstallPath.Replace("/", "\\")

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
	sedFile "$toolsPath\userData\userSettings.json" "STEAMPATH" "$steamInstallPath"
	sedFile "$toolsPath\userData\userSettings.json" "Users\" "Users\\"
	sedFile "$toolsPath\userData\userSettings.json" ":\" ":\\"
	sedFile "$toolsPath\userData\userSettings.json" "\\\" "\\"
	sedFile "$toolsPath\userData\controllerTemplates.json" "STEAMPATH" "$steamInstallPath"
	sedFile "$toolsPath\userData\controllerTemplates.json" "Users\" "Users\\"
	sedFile "$toolsPath\userData\controllerTemplates.json" ":\" ":\\"
	sedFile "$toolsPath\userData\controllerTemplates.json" "\\\" "\\"


  #Desktop Icon
  #createLink "$toolsPath\srm.exe" "$env:USERPROFILE\Desktop\EmuDeck - Steam Rom Manager.lnk"
  #Start Menu
  #mkdir "$EmuDeckStartFolder" -ErrorAction SilentlyContinue
  #createLink "$toolsPath\srm.exe" "$EmuDeckStartFolder\EmuDeck - Steam Rom Manager.lnk"

  #SteamInput
  $PFPath="$steamInstallPath\controller_base\templates\"
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

  $setupSaves=''
  if ($doInstallPegasus -eq "true"){
	createLauncher "pegasus\pegasus-frontend"
  }
  if ($doInstallRA -eq "true"){
	createLauncher retroarch
	$setupSaves += SRM_testSaveFolder "$emusPath\retroarch\saves"
  }
  if ($doInstallDolphin -eq "true"){
	createLauncher dolphin
	$setupSaves += SRM_testSaveFolder "$emusPath\Dolphin-x64\User\GC"
  }
  if ($doInstallPCSX2 -eq "true"){
	createLauncher pcsx2
	$setupSaves += SRM_testSaveFolder "$emusPath\PCSX2-Qt\memcards"
  }
  if ($doInstallRPCS3 -eq "true"){
	createLauncher rpcs3
	$setupSaves += SRM_testSaveFolder "$storagePath\rpcs3\dev_hdd0\home\00000001\savedata"
  }
  if ($doInstallYuzu -eq "true"){
	createLauncher yuzu
	$setupSaves += SRM_testSaveFolder "$emusPath\yuzu\yuzu-windows-msvc\user\nand\user\save"
  }
  if ($doInstallRyujinx -eq "true"){
	createLauncher "Ryujinx"
	$setupSaves += SRM_testSaveFolder "$emusPath\Ryujinx\portable\bis\user\save"
  }
  if ($doInstallCitra -eq "true"){
	createLauncher citra
	$setupSaves += SRM_testSaveFolder "$emusPath\citra\user\sdmc"
  }
  if ($doInstallDuck -eq "true"){
	createLauncher duckstation
	$setupSaves += SRM_testSaveFolder "$emusPath\duckstation\memcards"
  }
  if ($doInstallmelonDS -eq "true"){
	createLauncher melonDS
	$setupSaves += SRM_testMelonDSFolder "$savesPath\melonDS\saves"
  }
  if ($doInstallCemu -eq "true"){
	createLauncher cemu
	$setupSaves += SRM_testSaveFolder "$emusPath\cemu\mlc01\usr\save"
  }

  if ($doInstallPPSSPP -eq "true"){
	createLauncher PPSSPP
	$setupSaves += SRM_testSaveFolder "$emusPath\PPSSPP\memstick\PSP\PPSSPP_STATE"
  }
  if ($doInstallESDE -eq "true"){
	  createLauncher "esde\EmulationStationDE"
	}

#if ($doInstallXemu -eq "true"){
#	createLauncher xemu
# $setupSaves += SRM_testSaveFolder "$savesPath\xemu\saves"
#}
#if ($doInstallXenia -eq "true"){
#	createLauncher xenia
# $setupSaves += SRM_testSaveFolder "$savesPath\xenia\saves"
#}
#if ($doInstallVita3k -eq "true"){
#	createLauncher Vita3k
# $setupSaves += SRM_testSaveFolder "$savesPath\Vita3k\saves"
#}
#if ($doInstallScummVM -eq "true"){
#	createLauncher ScummVM
# $setupSaves += SRM_testSaveFolder "$savesPath\ScummVM\saves"
#}


if ( $setupSaves -ne '' ){

	confirmDialog -TitleText "Administrator Privileges needed" -MessageText "After this message you'll get several windows asking for elevated permissions. This is so we can create symlinks for all your emulators saves and states folders."

$scriptContent = @"
. "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1"; $setupSaves
"@

	startScriptWithAdmin -ScriptContent $scriptContent

}

}


function SRM_testSaveFolder($path) {
  $splits = $path.Split("\")
  $emu = $splits[6]
  if (Test-Path -Path $path) {
	$element = Get-Item -Path $path
	if ($element.Extension -eq ".lnk") {
	  return "$emu`_setupSaves;"
	} elseif ((Get-Item "$element").LinkType -ne "SymbolicLink") {
	  return "$emu`_setupSaves;"
	}
  } else {
	return "$emu`_setupSaves;"
  }
}


function SRM_testMelonDSFolder($path) {
  $splits = $path.Split("\")
  $emu = $splits[3]
  if (Test-Path -Path $path) {
  $element = Get-Item -Path $path
  if ($element.Extension -eq ".lnk") {
	return "$emu`_setupSaves;"
  } elseif ((Get-Item "$element").LinkType -eq "SymbolicLink") {
	return "$emu`_setupSaves;"
  }
  } else {
  return "$emu`_setupSaves;"
  }
}






  # if ( $doInstallXemu -ne "true" -or -not (Xemu_isInstalled -like "*true*")){
  # 	$exclusionList=$exclusionList+"microsoft_xbox-xemu.json"
  # }
  # if ( $doInstallXenia -ne "true" -or -not (Xenia_isInstalled -like "*true*")){
  #    $exclusionList=$exclusionList+"microsoft_xbox_360-xenia-xbla.json"
  #    $exclusionList=$exclusionList+"microsoft_xbox_360-xenia.json"
  # }
  # if ( $doInstallScummVM -ne "true" -or -not (ScummVM_isInstalled -like "*true*")){
  # 	$exclusionList=$exclusionList+"scumm_scummvm.json"
  # }
  if ( $doInstallmelonDS -ne "true" -or -not (melonDS_isInstalled -like "*true*")){
	  $exclusionList=$exclusionList+"nintendo_ds-melonds.json"
  }
  # if ( $doInstallVita3K -ne "true" -or -not (Vita3K_isInstalled -eq "true" -like "*true*")){
  # 	$exclusionList=$exclusionList+"sony_psvita-vita3k-pkg.json"
  # }
  # if ( $doInstallMGBA -ne "true" -or -not (MGBA_isInstalled -eq "true" -like "*true*")){
  #   $exclusionList=$exclusionList+"nintendo_gb-mGBA.json"
  #   $exclusionList=$exclusionList+"nintendo_gba-mgba.json"
  #   $exclusionList=$exclusionList+"nintendo_gbc-mgba.json"
  # }
  # if ( $doInstallMAME -ne "true" -or -not (MAME_isInstalled -eq "true" -like "*true*")){
  #   $exclusionList=$exclusionList+"arcade-mame.json"
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
	  #gba
	  # if ( "$emuGBA" -ne "both" ){
		#   if ( "$emuGBA" -eq "mgba" ){
		# 	$exclusionList = $exclusionList + 'nintendo_gameboy-advance-ares.json'
		# 	$exclusionList = $exclusionList + 'nintendo_gba-ra-mgba.json'
		#   }else{
		# 	$exclusionList = $exclusionList + 'nintendo_gba-mgba.json'
		#   }
	  # }
	#mame
	# if ( "$emuMAME" -ne "both" ){
	  #   if ( "$emuMAME" -eq "mame" ){
	  # 	$exclusionList = $exclusionList + 'arcade-ra-mame_2010.json'
	  # 	$exclusionList = $exclusionList + 'arcade-ra-mame.json'
	  # 	$exclusionList = $exclusionList + 'arcade-ra-mame_2003_plus.json'
	  #   }else{
	  # 	$exclusionList = $exclusionList + 'arcade-mame.json'
	  # 	$exclusionList = $exclusionList + 'tiger_electronics_gamecom-mame.json'
	  # 	$exclusionList = $exclusionList + 'vtech_vsmile-mame.json'
	  # 	$exclusionList = $exclusionList + 'snk_neo_geo_cd-mame.json'
	  # 	$exclusionList = $exclusionList + 'philips_cd_i-mame.json'
	  #   }
	# }