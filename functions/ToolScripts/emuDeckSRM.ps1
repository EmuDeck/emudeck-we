function SRM_install(){
	setMSG 'Downloading Steam Rom Manager'
	$url_srm = getLatestReleaseURLGH 'SteamGridDB/steam-rom-manager' 'exe' 'portable'
	download $url_srm "srm.exe"
	Move-item -Path "$temp/srm.exe" -destination "$toolsPath/srm.exe" -force
}
function SRM_init(){
  setMSG 'Steam Rom Manager - Configuration'
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
	  	$exclusionList = $exclusionList + 'ares/'
		$exclusionList = $exclusionList + "amiga_600-ra-puae.json";
		$exclusionList = $exclusionList + "amiga_1200-ra-puae.json";
		$exclusionList = $exclusionList + "amiga_cd-ra-puae.json";
		$exclusionList = $exclusionList + "amiga-ra-puae.json";
		$exclusionList = $exclusionList + "amstrad_cpc-ra-cap32.json";
		$exclusionList = $exclusionList + "arcade_naomi-ra-flycast.json";
		$exclusionList = $exclusionList + "arcade-ra-fbneo.json";
		$exclusionList = $exclusionList + "arcade-ra-mame_2003_plus.json";
		$exclusionList = $exclusionList + "arcade-ra-mame_2010.json";
		$exclusionList = $exclusionList + "arcade-ra-mame.json";
		$exclusionList = $exclusionList + "atari_2600-ra-stella.json";
		$exclusionList = $exclusionList + "atari_jaguar-ra-virtualjaguar.json";
		$exclusionList = $exclusionList + "atari_lynx-ra-mednafen.json";
		$exclusionList = $exclusionList + "bandai_wonderswan_color-ra-mednafen_swan.json";
		$exclusionList = $exclusionList + "bandai_wonderswan-ra-mednafen_swan.json";
		$exclusionList = $exclusionList + "commodore_16-ra-vice_xplus4.json";
		$exclusionList = $exclusionList + "commodore_64-ra-vice_x64.json";
		$exclusionList = $exclusionList + "commodore_vic_20-ra-vice_xvic.json";
		$exclusionList = $exclusionList + "doom-ra-prboom.json";
		$exclusionList = $exclusionList + "dos-ra-dosbox_pure.json";
		$exclusionList = $exclusionList + "nec_pc_98-ra-np2kai.json";
		$exclusionList = $exclusionList + "nec_pc_engine_turbografx_16_cd-ra-beetle_pce.json";
		$exclusionList = $exclusionList + "nec_pc_engine_turbografx_16-ra-beetle_pce.json";
		$exclusionList = $exclusionList + "nintendo_3ds-citra.json";
		$exclusionList = $exclusionList + "nintendo_64-ra-mupen64plus_next.json";
		$exclusionList = $exclusionList + "nintendo_ds-melonds.json";
		$exclusionList = $exclusionList + "nintendo_ds-ra-melonds.json";
		$exclusionList = $exclusionList + "nintendo_gb-ra-gambatte.json";
		$exclusionList = $exclusionList + "nintendo_gb-ra-sameboy.json";
		$exclusionList = $exclusionList + "nintendo_gba-ra-mgba.json";
		$exclusionList = $exclusionList + "nintendo_gbc-ra-gambatte.json";
		$exclusionList = $exclusionList + "nintendo_gbc-ra-sameboy.json";
		$exclusionList = $exclusionList + "nintendo_nes-ra-mesen.json";
		$exclusionList = $exclusionList + "nintendo_sgb-ra-mesen-s.json";
		$exclusionList = $exclusionList + "nintendo_snes-ra-bsnes_hd.json";
		$exclusionList = $exclusionList + "nintendo_snes-ra-snes9x.json";
		$exclusionList = $exclusionList + "panasonic_3do-ra-opera.json";
		$exclusionList = $exclusionList + "philips_cd_i-ra-same_cdi.json";
		$exclusionList = $exclusionList + "pico_8-ra-retro8.json";
		$exclusionList = $exclusionList + "rpg_maker-ra-easyrpg.json";
		$exclusionList = $exclusionList + "sega_32X-ra-picodrive.json";
		$exclusionList = $exclusionList + "sega_CD_Mega_CD-ra-genesis_plus_gx.json";
		$exclusionList = $exclusionList + "sega_dreamcast-ra-flycast.json";
		$exclusionList = $exclusionList + "sega_game_gear-ra-genesis_plus_gx.json";
		$exclusionList = $exclusionList + "sega_genesis-ra-genesis_plus_gx_wide.json";
		$exclusionList = $exclusionList + "sega_genesis-ra-genesis_plus_gx.json";
		$exclusionList = $exclusionList + "sega_mastersystem-ra-genesis-plus-gx.json";
		$exclusionList = $exclusionList + "sega_saturn-ra-mednafen.json";
		$exclusionList = $exclusionList + "sega_saturn-ra-yabause.json";
		$exclusionList = $exclusionList + "sharp-x68000-ra-px68k.json";
		$exclusionList = $exclusionList + "sinclair_zx-spectrum-ra-fuse.json";
		$exclusionList = $exclusionList + "snk_neo_geo_pocket_color-ra-beetle_neopop.json";
		$exclusionList = $exclusionList + "snk_neo_geo_pocket-ra-beetle_neopop.json";
		$exclusionList = $exclusionList + "sony_psp-ra-ppsspp.json";
		$exclusionList = $exclusionList + "sony_psx-ra-beetle_psx_hw.json";
		$exclusionList = $exclusionList + "sony_psx-ra-swanstation.json";
		$exclusionList = $exclusionList + "tic-80-ra-tic80.json";
	  }elseif ( "$emuMULTI" -eq "ra" ){
		$exclusionList = $exclusionList + 'ares/'
  	}else{
		$exclusionList = $exclusionList + 'atari_2600-ra-stella.json'
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
  #psx
	  if ( "$emuPSX" -ne "both" ){
		  if ( "$emuPSX" -eq "duckstation" ){
			$exclusionList = $exclusionList + 'sony_psx-ra-swanstation.json'
			$exclusionList = $exclusionList + 'sony_psx-ra-beetle_psx_hw.json'
		  }else{
			$exclusionList = $exclusionList + 'sony_psx-duckstation.json'
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
  #mame
  if ( "$emuMAME" -ne "both" ){
  	if ( "$emuMAME" -eq "mame" ){
		$exclusionList = $exclusionList + 'arcade-ra-mame_2010.json'
		$exclusionList = $exclusionList + 'arcade-ra-mame.json'
		$exclusionList = $exclusionList + 'arcade-ra-mame_2003_plus.json'
  	}else{
		$exclusionList = $exclusionList + 'arcade-mame.json'
		$exclusionList = $exclusionList + 'tiger_electronics_gamecom-mame.json'
		$exclusionList = $exclusionList + 'vtech_vsmile-mame.json'
		$exclusionList = $exclusionList + 'snk_neo_geo_cd-mame.json'
		$exclusionList = $exclusionList + 'philips_cd_i-mame.json'
  	}
  }

  #Exclusion based on install status.


  if { $doInstallPrimeHack -ne "true"){
		$exclusionList=$exclusionList+"nintendo_primehack.json"
	}
	if { $doInstallRPCS3 -ne "true"){
		$exclusionList=$exclusionList+"sony_ps3-rpcs3-extracted_iso_psn.json"
		$exclusionList=$exclusionList+"sony_ps3-rpcs3-pkg.json"
	}
	if { $doInstallCitra -ne "true"){
		$exclusionList=$exclusionList+"nintendo_3ds-citra-mGBA.json"
	}
	if { $doInstallDolphin -ne "true"){
		$exclusionList=$exclusionList+"nintendo_gc-dolphin.json"
		$exclusionList=$exclusionList+"nintendo_wii-dolphin.json"
	}
	if { $doInstallDuck -ne "true"){
		$exclusionList=$exclusionList+"sony_psx-duckstation.json"
	}
	if { $doInstallPPSSPP -ne "true"){
		$exclusionList=$exclusionList+"sony_psp-ppsspp.json"
	}
	# if { $doInstallXemu -ne "true"){
	# 	$exclusionList=$exclusionList+"microsoft_xbox-xemu.json"
	# }
	# if { $doInstallXenia -ne "true"){
	#    $exclusionList=$exclusionList+"microsoft_xbox_360-xenia-xbla.json"
	#    $exclusionList=$exclusionList+"microsoft_xbox_360-xenia.json"
	# }
	# if { $doInstallScummVM -ne "true"){
	# 	$exclusionList=$exclusionList+"scumm_scummvm.json"
	# }
	if { $doInstallRMG -ne "true"){
		$exclusionList=$exclusionList+"nintendo_64-rmg.json"
	}
	if { $doInstallmelonDS -ne "true"){
		$exclusionList=$exclusionList+"nintendo_ds-melonds.json"
	}
	# if { $doInstallVita3K -ne "true"){
	# 	$exclusionList=$exclusionList+"sony_psvita-vita3k-pkg.json"
	# }
	# if { $doInstallMGBA -ne "true"){
	#   $exclusionList=$exclusionList+"nintendo_gb-mGBA.json"
	#   $exclusionList=$exclusionList+"nintendo_gba-mgba.json"
	#   $exclusionList=$exclusionList+"nintendo_gbc-mgba.json"
	# }
	# if { $doInstallMAME -ne "true"){
	#   $exclusionList=$exclusionList+"arcade-mame.json"
	# }
	if { $doInstallYuzu -ne "true"){
	  $exclusionList=$exclusionList+"nintendo_switch-yuzu.json"
	}
	if { $doInstallRyujinx -ne "true"){
	  $exclusionList=$exclusionList+"nintendo_switch-ryujinx.json"
	}
	if { "$doInstallPCSX2QT" -ne "true"){
	  $exclusionList=$exclusionList+"sony_ps2-pcsx2.json"
	}

  Start-Sleep -Seconds 1

  Get-ChildItem -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-rom-manager\userData\parsers\emudeck\" -Filter *.json | ForEach-Object {
	if ($_ -notin $exclusionList) {
	  Copy-Item -Path $_.FullName -Destination "$toolsPath\userData\parsers\emudeck" -Force
	}
  }

  $mainParserFolder = "$toolsPath\userData\parsers\emudeck"
  $mainParserFile = "$toolsPath\userData\userConfigurations.json"
  "[`n" + ((Get-Content $mainParserFolder\*.json -raw) -join ","  ) + "`n]" | Out-File $mainParserFile -Encoding UTF8

  (get-content $mainParserFile) -replace '\x00','' | set-content $mainParserFile



  #Steam installation
  $steamRegPath = "HKCU:\Software\Valve\Steam"
  $steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
  $steamInstallPath = $steamInstallPath.Replace("/", "\\")

  #Paths
  sedFile $toolsPath\UserData\userConfigurations.json "C:\\Emulation" $emulationPath
  sedFile $toolsPath\UserData\userConfigurations.json "EMUSPATH" $emusPathSRM
  sedFile $toolsPath\UserData\userConfigurations.json "USERPATH" "$userFolder"
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
  #createLink "$toolsPath\srm.exe" "$env:USERPROFILE\Desktop\EmuDeck - Steam Rom Manager.lnk"
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

	#We reset the saves folders
	$setupSaves=''
	$path="$savesPath\retroarch\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="RetroArch_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="RetroArch_setupSaves;"
	}

    $path = "$savesPath\duckstation\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="DuckStation_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="DuckStation_setupSaves;"
	}

    $path = "$savesPath\dolphin\wii"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="Dolphin_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="Dolphin_setupSaves;"
	}

    $path = "$savesPath\yuzu\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="Yuzu_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="Yuzu_setupSaves;"
	}

    $path = "$savesPath\ryujinx\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="Ryujinx_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="Ryujinx_setupSaves;"
	}

    $path = "$savesPath\citra\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="Citra_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="Citra_setupSaves;"
	}

    $path = "$savesPath\Cemu\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="Cemu_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="Cemu_setupSaves;"
	}

    $path = "$savesPath\pcsx2\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="PCSX2QT_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="PCSX2QT_setupSaves;"
	}

    $path = "$savesPath\rpcs3\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="RPCS3_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="RPCS3_setupSaves;"
	}

    $path = "$savesPath\ppsspp\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="PPSSPP_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
		$setupSaves+="PPSSPP_setupSaves;"
	}

    $path = "$savesPath\melonDS\saves"
	if (Test-Path -Path $path) {
		$element = Get-Item -Path $path
	}
	if (-not (Test-Path -Path $path)) {
		$setupSaves+="melonDS_setupSaves;"
	}elseif ( $element.Extension -eq ".lnk" ){
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
	confirmDialog -TitleText "Administrator Privileges needed" -MessageText "After this message you'll get several windows asking for elevated permissions. This is so we can create symlinks for all your emulators saves and states folders."

$scriptContent = @"
	. "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1"; $setupSaves
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
