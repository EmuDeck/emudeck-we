$EmuDeckStartFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck"

#Fixed emu urls
$url_ra = "https://buildbot.libretro.com/nightly/windows/x86_64/RetroArch.7z"
$url_dolphin = "https://dl.dolphin-emu.org/builds/40/56/dolphin-master-5.0-18498-x64.7z"
$url_ppsspp = "https://www.ppsspp.org/files/1_16_6/ppsspp_win.zip"
$url_esde = "https://gitlab.com/es-de/emulationstation-de/-/package_files/113822782/download"
$url_scummVM = "https://downloads.scummvm.org/frs/scummvm/2.7.1/scummvm-2.7.1-win32-x86_64.zip"

$userFolder = "$env:USERPROFILE"
$emusPath = "$env:USERPROFILE\EmuDeck\EmulationStation-DE\Emulators"
$emusPathSRM = "$env:USERPROFILE\\EmuDeck\\EmulationStation-DE\\Emulators"
$esdePath = "$env:USERPROFILE/EmuDeck/EmulationStation-DE"
$pegasusPath = "$env:USERPROFILE/EmuDeck/Pegasus"
$temp = "$env:USERPROFILE\EmuDeck\temp"
$nssm = "$env:APPDATA\EmuDeck\backend\wintools\nssm.exe"
$7z = "$env:APPDATA\EmuDeck\backend\wintools\7z.exe"
#Steam installation Path
$steamRegPath = "HKCU:\Software\Valve\Steam"
$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
$steamInstallPath = $steamInstallPath.Replace("/", "\")
$steamInstallPathSRM = $steamInstallPath.Replace("\", '\\')
$steamInstallExe = "$steamInstallPath/Steam.exe"