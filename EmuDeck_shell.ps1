#We add Winrar folders to the Path
$env:path = $env:path + ";C:\Program Files\WinRaR"
$env:path = $env:path + ";C:\Program Files (x86)\WinRaR"

$Host.UI.RawUI.WindowTitle = "EmuDeck Windows Edition Alpha Installer";

#
# Functions
#

. .\functions\showListDialog.ps1
. .\functions\waitForWinRar.ps1
. .\functions\download.ps1
. .\functions\downloadCore.ps1
. .\functions\showNotification.ps1
. .\functions\moveFromTo.ps1
. .\functions\copyFromTo.ps1
. .\functions\waitForUser.ps1
. .\functions\sedFile.ps1
. .\functions\createLink.ps1

#
# Variables
#
Clear-Host
#We need to pick the HD first thing so we can set the rest of the path variables
$drives = (Get-PSDrive -PSProvider FileSystem).Root
$winPath = showListDialog 'Select Destination' 'Please select where do you want to install EmuDeck:' $drives
. .\vars.ps1

# Draw welcome screen
Write-Host  -ForegroundColor blue -BackgroundColor black " _____               ______          _      _    _ _____ "
Write-Host  -ForegroundColor blue -BackgroundColor black "|  ___|              |  _  \        | |    | |  | |  ___|"
Write-Host  -ForegroundColor blue -BackgroundColor black "| |__ _ __ __   _   _| | | |___  ___| | __ | |  | | |__  "
Write-Host  -ForegroundColor blue -BackgroundColor black "|  __| '_ ` _ \ | | | | | | / _ \/ __| |/ / | |/\| |  __| "
Write-Host  -ForegroundColor blue -BackgroundColor black "| |__| | | | | | |_| | |/ /  __/ (__|   <  \  /\  / |___ "
Write-Host  -ForegroundColor blue -BackgroundColor black "\____/_| |_| |_|\__,_|___/ \___|\___|_|\_\  \/  \/\____/ "

Write-Output ""
Write-Host "================ Welcome to EmuDeck Windows Edition ================" -ForegroundColor blue -BackgroundColor black
Write-Output ""
Write-Output "This script will create an Emulation folder in $EmulationPath"
Write-Output "and in there we will download all the Emulators, EmulationStation, Steam Rom Manager and Rom Folder Structure."
Write-Output ""
Write-Output "Before you continue make sure you have WinRar installed"
Write-Output "You can download Winrar from https://www.win-rar.com/download.html"
Write-Output ""
waitForUser

Clear-Host


# Creating folders

mkdir $EmulationPath -ErrorAction SilentlyContinue
Set-Location $EmulationPath
mkdir $biosPath -ErrorAction SilentlyContinue
mkdir $toolsPath -ErrorAction SilentlyContinue
mkdir $savesPath -ErrorAction SilentlyContinue
Clear-Host

Write-Output "Installing, please stand by..."
Write-Output ""

#EmuDeck Download
showNotification -ToastTitle "Downloading EmuDeck files"
download "https://github.com/dragoonDorise/EmuDeck/archive/refs/heads/dev.zip" "temp.zip"
moveFromTo "temp\EmuDeck-dev" "EmuDeck"
moveFromTo "EmuDeck\roms" "roms"
moveFromTo "EmuDeck\tools\launchers" "tools\launchers"

#Dowloading..ESDE
showNotification -ToastTitle 'Downloading EmulationStation DE'
download $url_esde "esde.zip"
moveFromTo "esde\EmulationStation-DE" "tools/EmulationStation-DE"

#SRM
showNotification -ToastTitle 'Downloading Steam Rom Manager'
download $url_srm "tools/srm.exe"

#
# Emulators Download
#

#RetroArch
showNotification -ToastTitle 'Downloading RetroArch'
download $url_ra "ra.7z"
moveFromTo "ra\RetroArch-Win64" "tools\EmulationStation-DE\Emulators\RetroArch"

#Dolphin
showNotification -ToastTitle 'Downloading Dolphin'
download $url_dolphin "dolphin.7z"
moveFromTo "dolphin\Dolphin-x64" "tools\EmulationStation-DE\Emulators\Dolphin-x64"

#PCSX2 
showNotification -ToastTitle 'Downloading PCSX2'
download $url_pcsx2 "pcsx2.7z"
moveFromTo "pcsx2\PCSX2 1.6.0" "tools\EmulationStation-DE\Emulators\PCSX2"

#RPCS3
showNotification -ToastTitle 'Downloading RPCS3'
download $url_rpcs3 "rpcs3.7z"
moveFromTo "rpcs3" "tools\EmulationStation-DE\Emulators\RPCS3"

#Xemu
showNotification -ToastTitle 'Downloading Xemu'
download $url_xemu "xemu-win-release.zip"
moveFromTo "xemu-win-release" "tools\EmulationStation-DE\Emulators\xemu"

#Yuzu
showNotification -ToastTitle 'Downloading Yuzu'
download $url_yuzu "yuzu.zip"
moveFromTo "yuzu\yuzu-windows-msvc" "tools\EmulationStation-DE\Emulators\yuzu\yuzu-windows-msvc"

#Citra
showNotification -ToastTitle 'Downloading Citra'
download $url_citra "citra.zip"
moveFromTo "citra/nightly-mingw" "tools\EmulationStation-DE\Emulators\citra"

#Duckstation
showNotification -ToastTitle 'Downloading DuckStation'
download $url_duck "duckstation.zip"
moveFromTo "duckstation" "tools\EmulationStation-DE\Emulators\duckstation"

#Cemu
showNotification -ToastTitle 'Downloading Cemu'
download $url_cemu "cemu.zip"
moveFromTo "cemu\cemu_1.26.2" "tools\EmulationStation-DE\Emulators\cemu"

#Xenia
showNotification -ToastTitle 'Downloading Xenia'
download $url_xenia "xenia.zip"
moveFromTo "xenia" "tools\EmulationStation-DE\Emulators\xenia"


showNotification -ToastTitle 'Downloading RetroArch Cores'
mkdir $EmulationPath"tools\EmulationStation-DE\Emulators\RetroArch\cores" -ErrorAction SilentlyContinue
$RAcores = @('a5200_libretro.dll','81_libretro.dll','atari800_libretro.dll','bluemsx_libretro.dll','chailove_libretro.dll','fbneo_libretro.dll','freechaf_libretro.dll','freeintv_libretro.dll','fuse_libretro.dll','gearsystem_libretro.dll','gw_libretro.dll','hatari_libretro.dll','lutro_libretro.dll','mednafen_pcfx_libretro.dll','mednafen_vb_libretro.dll','mednafen_wswan_libretro.dll','mu_libretro.dll','neocd_libretro.dll','nestopia_libretro.dll','nxengine_libretro.dll','o2em_libretro.dll','picodrive_libretro.dll','pokemini_libretro.dll','prboom_libretro.dll','prosystem_libretro.dll','px68k_libretro.dll','quasi88_libretro.dll','scummvm_libretro.dll','squirreljme_libretro.dll','theodore_libretro.dll','uzem_libretro.dll','vecx_libretro.dll','vice_xvic_libretro.dll','virtualjaguar_libretro.dll','x1_libretro.dll','mednafen_lynx_libretro.dll','mednafen_ngp_libretro.dll','mednafen_pce_libretro.dll','mednafen_pce_fast_libretro.dll','mednafen_psx_libretro.dll','mednafen_psx_hw_libretro.dll','mednafen_saturn_libretro.dll','mednafen_supafaust_libretro.dll','mednafen_supergrafx_libretro.dll','blastem_libretro.dll','bluemsx_libretro.dll','bsnes_libretro.dll','bsnes_mercury_accuracy_libretro.dll','cap32_libretro.dll','citra2018_libretro.dll','citra_libretro.dll','crocods_libretro.dll','desmume2015_libretro.dll','desmume_libretro.dll','dolphin_libretro.dll','dosbox_core_libretro.dll','dosbox_pure_libretro.dll','dosbox_svn_libretro.dll','fbalpha2012_cps1_libretro.dll','fbalpha2012_cps2_libretro.dll','fbalpha2012_cps3_libretro.dll','fbalpha2012_libretro.dll','fbalpha2012_neogeo_libretro.dll','fceumm_libretro.dll','fbneo_libretro.dll','flycast_libretro.dll','fmsx_libretro.dll','frodo_libretro.dll','gambatte_libretro.dll','gearboy_libretro.dll','gearsystem_libretro.dll','genesis_plus_gx_libretro.dll','genesis_plus_gx_wide_libretro.dll','gpsp_libretro.dll','handy_libretro.dll','kronos_libretro.dll','mame2000_libretro.dll','mame2003_plus_libretro.dll','mame2010_libretro.dll','mame_libretro.dll','melonds_libretro.dll','mesen_libretro.dll','mesen-s_libretro.dll','mgba_libretro.dll','mupen64plus_next_libretro.dll','nekop2_libretro.dll','np2kai_libretro.dll','nestopia_libretro.dll','parallel_n64_libretro.dll','pcsx2_libretro.dll','pcsx_rearmed_libretro.dll','picodrive_libretro.dll','ppsspp_libretro.dll','puae_libretro.dll','quicknes_libretro.dll','race_libretro.dll','sameboy_libretro.dll','smsplus_libretro.dll','snes9x2010_libretro.dll','snes9x_libretro.dll','stella2014_libretro.dll','stella_libretro.dll','tgbdual_libretro.dll','vbam_libretro.dll','vba_next_libretro.dll','vice_x128_libretro.dll','vice_x64_libretro.dll','vice_x64sc_libretro.dll','vice_xscpu64_libretro.dll','yabasanshiro_libretro.dll','yabause_libretro.dll','bsnes_hd_beta_libretro.dll','swanstation_libretro.dll')
$RAcores.count

foreach ( $core in $RAcores )
{
	$url= -join('http://buildbot.libretro.com/nightly/windows/x86_64/latest/',$core,'.zip')
	$dest= -join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\cores\',$core)
	showNotification -ToastTitle "Downloading $url"	
	downloadCore $url $dest
}


# Deleting temp folders
showNotification -ToastTitle 'Cleaning up...'
Remove-Item cemu
Remove-Item ra
Remove-Item dolphin
Remove-Item esde
Remove-Item pcsx2
Remove-Item yuzu
Remove-Item temp
Remove-Item citra
Write-Host "Done!" -ForegroundColor green -BackgroundColor black


#
# Emus Configuration
# 

showNotification -ToastTitle 'Configuring Emulators'


#RetroArch

Remove-Item $raConfigfile

showNotification -ToastTitle 'RetroArch - Bezels & Filters'
copyFromTo "EmuDeck\configs\org.libretro.RetroArch\config\retroarch" "tools\EmulationStation-DE\Emulators\RetroArch"
$path=-join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\config')
Get-ChildItem $path -Recurse -Filter *.cfg | 
Foreach-Object {
	$originFile = $_.FullName

	$origin="~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus"
	$target=-join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus')
	
	sedFile $originFile $origin $target
	
	#Video Filters path
	$origin="/app/lib/retroarch/filters/video"
	$target=-join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\filters\video')
	
	sedFile $originFile $origin $target
}

showNotification -ToastTitle 'RetroArch - Shaders'
$path=-join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\config')
Get-ChildItem $path -Recurse -Filter *.glslp | 
Foreach-Object {
	$originFile = $_.FullName

	$origin="/app/share/libretro/shaders/"
	$target=-join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\shaders\')
	sedFile $originFile $origin $target
}
$path=-join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\config')
Get-ChildItem $path -Recurse -Filter *.slangp | 
Foreach-Object {
	$originFile = $_.FullName

	$origin="/app/share/libretro/shaders/"
	$target=-join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\shaders\')
	sedFile $originFile $origin $target
}


showNotification -ToastTitle 'RetroArch - Bios & Saves'

#Saves
mkdir saves/retroarch -ErrorAction SilentlyContinue
$SourceFilePath = -join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\saves\')
mkdir $SourceFilePath -ErrorAction SilentlyContinue
$ShortcutPath = -join($EmulationPath,'saves\retroarch\saves.lnk')
createLink $SourceFilePath $ShortcutPath

#States
$SourceFilePath = -join($EmulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\states\')
mkdir $SourceFilePath -ErrorAction SilentlyContinue
$ShortcutPath = -join($EmulationPath,'saves\retroarch\states.lnk')
createLink $SourceFilePath $ShortcutPath

#Bios
$line="system_directory = `"$biosPath`""
$line | Add-Content $raConfigfile

#Hotkeys
$line="input_enable_hotkey_btn = `"109`""
$line | Add-Content $raConfigfile
$line="input_hold_fast_forward_btn = `"105`""
$line | Add-Content $raConfigfile
$line="input_load_state_btn = `"102`""
$line | Add-Content $raConfigfile
$line="input_menu_toggle_gamepad_combo = `"2`""
$line | Add-Content $raConfigfile
$line="input_quit_gamepad_combo = `"4`""
$line | Add-Content $raConfigfile
$line="input_save_state_btn = `"103`""
$line | Add-Content $raConfigfile
$line="menu_driver = `"ozone`""
$line | Add-Content $raConfigfile
$line="input_exit_emulator_btn = `"108`""
$line | Add-Content $raConfigfile

#Duckstation


#Dolphin


#Yuzu
showNotification -ToastTitle 'Yuzu - Downloading Microsoft Visual C++ 2022'
download "https://aka.ms/vs/17/release/vc_redist.x64.exe" "tools/vc_redist.x64.exe"
.\tools/vc_redist.x64.exe

showNotification -ToastTitle 'Yuzu - Creating Keys & Firmware Links'
#Firmware
$SourceFilePath = -join($userFolder, '\AppData\Roaming\yuzu\nand\system\Contents\registered')
$ShortcutPath = -join($EmulationPath,'bios\yuzu\keys.lnk')
mkdir 'bios\yuzu' -ErrorAction SilentlyContinue
mkdir $SourceFilePath -ErrorAction SilentlyContinue
createLink $SourceFilePath $ShortcutPath

#Keys
$SourceFilePath = -join($userFolder, '\AppData\Roaming\yuzu\keys')
$ShortcutPath = -join($EmulationPath,'bios\yuzu\firmware.lnk')
mkdir $SourceFilePath -ErrorAction SilentlyContinue
createLink $SourceFilePath $ShortcutPath

#Ryu


#Citra


#Cemu


#PCSX2


#RPCS3


#Xemu


#Xenia





















#moveFromTo "EmuDeck\configs\org.citra_emu.citra" "XXXX"
#moveFromTo "EmuDeck\configs\org.ryujinx.Ryujinx" "XXXX"

#moveFromTo "EmuDeck\configs\org.DolphinEmu.dolphin-emu\config\dolphin-emu" $dolphinDir
#moveFromTo "EmuDeck\configs\info.cemu.Cemu\data\cemu" "tools\EmulationStation-DE\Emulators\cemu"
#moveFromTo "EmuDeck\configs\org.citra_emu.citra\config\citra-emu" "tools\EmulationStation-DE\Emulators\citra"
#moveFromTo "EmuDeck\configs\org.libretro.RetroArch\config\retroarch" "tools\EmulationStation-DE\Emulators\RetroArch"
#moveFromTo "EmuDeck\configs\net.pcsx2.PCSX2\config\PCSX2" "tools\EmulationStation-DE\Emulators\PCSX2"
#moveFromTo "EmuDeck\configs\net.rpcs3.RPCS3\config\rpcs3" "tools\EmulationStation-DE\Emulators\RPCS3"
#moveFromTo "EmuDeck\configs\org.duckstation.DuckStation\data\duckstation" $duckDir
#mkdir "tools\userData\" -ErrorAction SilentlyContinue
#Copy-Item  "EmuDeck\configs\steam-rom-manager\userData\userConfigurationsWE.json" "tools\userData\userConfigurations.json"
#rename tools/userData/userConfigurationsWE.json tools/userData/userConfigurations.json
#moveFromTo "EmuDeck\configs\org.yuzu_emu.yuzu" $yuzuDir
#moveFromTo "EmuDeck\configs\emulationstation" "tools\EmulationStation-DE\.emulationstation"
#moveFromTo "EmuDeck\configs\app.xemu.xemu\data\xemu\xemu" "tools\EmulationStation-DE\Emulators\xemu"
#moveFromTo "EmuDeck\configs\xenia" "tools\EmulationStation-DE\Emulators\xenia"
#mkdir "tools\EmulationStation-DE\.emulationstation" -ErrorAction SilentlyContinue
#Copy-Item EmuDeck\configs\emulationstation\es_settings.xml tools\EmulationStation-DE\.emulationstation\es_settings.xml
#Write-Host "Done!" -ForegroundColor green -BackgroundColor black
#
#showNotification -ToastTitle 'Applying Windows Especial configurations'
#sedFile 'tools\EmulationStation-DE\Emulators\xemu\xemu.ini' $deckPath $winPath
#sedFile 'tools\EmulationStation-DE\Emulators\xemu\xemu.toml' $deckPath $winPath
#sedFile 'tools\EmulationStation-DE\Emulators\cemu\settings.xml' 'Z:/run/media/mmcblk0p1/' $winPath
#sedFile 'tools\EmulationStation-DE\Emulators\cemu\settings.xml' 'roms/wiiu/roms' 'roms\wiiu\'
#sedFile $dolphinIni $deckPath $winPath
#sedFile $dolphinIni 'Emulation/bios/' 'Emulation\bios\'
#sedFile $dolphinIni '/roms/gamecube' '\roms\gamecube'
#sedFile $dolphinIni '/roms/wii' '\roms\wii'
#sedFile 'tools\EmulationStation-DE\Emulators\PCSX2\inis\PCSX2_ui.ini' $deckPath $winPath
#sedFile 'tools\EmulationStation-DE\Emulators\PCSX2\inis\PCSX2_ui.ini' 'Emulation/bios/' 'Emulation\bios\'
#sedFile $YuzuIni $deckPath $winPath
#sedFile $YuzuIni 'Emulation/roms/switch' 'Emulation\roms\switch'
#sedFile $duckIni $deckPath $winPath
#sedFile $duckIni 'Emulation/bios/' 'Emulation\bios\'
#
#SRM
#sedFile 'tools\userData\userConfigurations.json' 'E:\' $winPath
#
#ESDE
#sedFile 'tools\EmulationStation-DE\.emulationstation\es_settings.xml' $deckPath $winPath
#sedFile 'tools\EmulationStation-DE\.emulationstation\es_settings.xml' '/Emulation/roms/' 'Emulation\roms\'
#
#
#RetroArch especial fixes
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' $deckPath $winPath
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' '~/.var/app/org.libretro.RetroArch/config/retroarch/' $raConfigDir
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' '/app/share/libretro/' ':\'
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' '/"' '\"'
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' 'http://localhost:4404\' 'http://localhost:4404/'
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' '/app/lib/retroarch/filters/' '\app\lib\retroarch\filters\'
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' 'database/' 'database\'
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' 'http://buildbot.libretro.com/nightly/linux/x86_64/latest\' 'http://buildbot.libretro.com/nightly/windows/x86_64/latest/'
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' 'config/remaps' 'config\remaps'
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' '/Emulation/bios' '\Emulation\bios'
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' 'video4linux2' ''
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\citra\qt-config.ini' $deckPath $winPath
#
#Path fixes other emus
#
#sedFile $EmulationPath'tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg' '/Emulation/bios' '\Emulation\bios'
#
#sedFile 'tools/launchers/cemu.bat' 'XX' $winPath
#sedFile 'tools/launchers/dolphin-emu.bat'  'XX' $winPath
#sedFile 'tools/launchers/duckstation.bat'  'XX' $winPath
#sedFile 'tools/launchers/PCSX2.bat'  'XX' $winPath
#sedFile 'tools/launchers/retroarch.bat'  'XX' $winPath
#sedFile 'tools/launchers/RPCS3.bat'  'XX' $winPath
#sedFile 'tools/launchers/xemu-emu.bat'  'XX' $winPath
#sedFile 'tools/launchers/xenia.bat'  'XX' $winPath
#sedFile 'tools/launchers/yuzu.bat'  'XX' $winPath
#
#
#Controller configs
#Dolphin
#$controllerDolphinIni=-join($dolphinDir,'\GCPadNew.ini')
#$controllerDolphinWiiIni=-join($dolphinDir,'\WiimoteNew.ini')
#
#Dolphin GC
#sedFile $controllerDolphinIni 'evdev/0/Microsoft X-Box 360 pad 0' 'XInput/0/Gamepad'
#sedFile $controllerDolphinIni 'Buttons/A = SOUTH' 'Buttons/A = Button B'
#sedFile $controllerDolphinIni 'Buttons/B = EAST' 'Buttons/B = Button A'
#sedFile $controllerDolphinIni 'Buttons/X = NORTH' 'Buttons/X = Button Y'
#sedFile $controllerDolphinIni 'Buttons/Y = WEST' 'Buttons/Y = Button X'
#sedFile $controllerDolphinIni 'Buttons/Z = TR' 'Buttons/Z = Trigger L'
#sedFile $controllerDolphinIni 'Buttons/Start = START' 'Buttons/Start = Start'
#sedFile $controllerDolphinIni 'Main Stick/Up = `Axis 1-`' 'Main Stick/Up = `Left Y+`'
#sedFile $controllerDolphinIni 'Main Stick/Down = `Axis 1+`' 'Main Stick/Down = `Left Y-`'
#sedFile $controllerDolphinIni 'Main Stick/Left = `Axis 0-`' 'Main Stick/Left = `Left X-`'
#sedFile $controllerDolphinIni 'Main Stick/Right = `Axis 0+`' 'Main Stick/Right = `Left X+`'
#sedFile $controllerDolphinIni 'C-Stick/Up = `Axis 4-`' 'C-Stick/Up = `Right Y+`'
#sedFile $controllerDolphinIni 'C-Stick/Down = `Axis 4+`' 'C-Stick/Down = `Right Y-`'
#sedFile $controllerDolphinIni 'C-Stick/Left = `Axis 3-`' 'C-Stick/Left = `Right X-`'
#sedFile $controllerDolphinIni 'C-Stick/Right = `Axis 3+`' 'C-Stick/Right = `Right X+`'
#sedFile $controllerDolphinIni 'Triggers/L = `Full Axis 2+`' 'Triggers/L = `Shoulder L`'
#sedFile $controllerDolphinIni 'Triggers/R = `Full Axis 5+`' 'Triggers/R = `Shoulder R`'
#sedFile $controllerDolphinIni 'Triggers/L-Analog = `Full Axis 2+`' 'Triggers/L-Analog = `Trigger L`'
#sedFile $controllerDolphinIni 'Triggers/R-Analog = `Full Axis 5+`' 'Triggers/R-Analog = `Trigger R`'
#sedFile $controllerDolphinIni 'D-Pad/Up = `Axis 7-`' 'D-Pad/Up = `Pad N`'
#sedFile $controllerDolphinIni 'D-Pad/Down = `Axis 7+`' 'D-Pad/Down = `Pad S`'
#sedFile $controllerDolphinIni 'D-Pad/Left = `Axis 6-`' 'D-Pad/Left = `Pad W`'
#sedFile $controllerDolphinIni 'D-Pad/Right = `Axis 6+`' 'D-Pad/Right = `Pad E`'
#
#Dolphin Wii
#sedFile $controllerDolphinWiiIni 'evdev/0/Microsoft X-Box 360 pad 0' 'XInput/0/Gamepad'
#sedFile $controllerDolphinWiiIni 'Buttons/A = SOUTH' 'Buttons/A = Button B'
#sedFile $controllerDolphinWiiIni 'Buttons/B = EAST' 'Buttons/B = Button A'
#sedFile $controllerDolphinWiiIni 'Buttons/1 = NORTH' 'Buttons/X = Button Y'
#sedFile $controllerDolphinWiiIni 'Buttons/2 = WEST' 'Buttons/Y = Button X'
#sedFile $controllerDolphinWiiIni 'Buttons/- = SELECT' 'Buttons/- = Select'
#sedFile $controllerDolphinWiiIni 'Buttons/+ = START' 'Buttons/+ = Start'
#sedFile $controllerDolphinWiiIni 'D-Pad/Up = `Axis 7-`' 'D-Pad/Up = `Pad N`'
#sedFile $controllerDolphinWiiIni 'D-Pad/Down = `Axis 7+`' 'D-Pad/Down = `Pad S`'
#sedFile $controllerDolphinWiiIni 'D-Pad/Left = `Axis 6-`' 'D-Pad/Left = `Pad W`'
#sedFile $controllerDolphinWiiIni 'D-Pad/Right = `Axis 6+`' 'D-Pad/Right = `Pad E`'
#sedFile $controllerDolphinWiiIni 'Shake/Z = TL' 'Shake/Z = Shoulder L'
#sedFile $controllerDolphinWiiIni 'IR/Up = `Axis 4-`' 'IR/Up = `Right Y+`'
#sedFile $controllerDolphinWiiIni 'IR/Down = `Axis 4+`' 'IR/Down = `Right Y-`'
#sedFile $controllerDolphinWiiIni 'IR/Left = `Axis 3-`' 'IR/Left = `Right X-`'
#sedFile $controllerDolphinWiiIni 'IR/Right = `Axis 3+`' 'IR/Right = `Right X+`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Buttons/C = `Full Axis 5+`' 'Nunchuk/Buttons/C = `Trigger L`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Buttons/Z = `Full Axis 2+`' 'Nunchuk/Buttons/Z = `Trigger R`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Stick/Up = `Axis 1-`' 'Nunchuk/Stick/Up = `Left Y+`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Stick/Down = `Axis 1+`' 'Nunchuk/Stick/Down = `Left Y-`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Stick/Left = `Axis 0-`' 'Nunchuk/Stick/Left = `Left X-`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Stick/Right = `Axis 0+`' 'Nunchuk/Stick/Right = `Left X+`'
#sedFile $controllerDolphinWiiIni 'Nunchuk/Shake/Z = TR' 'Nunchuk/Shake/Z = TR'



Write-Host "All done!" -ForegroundColor green -BackgroundColor black


waitForUser