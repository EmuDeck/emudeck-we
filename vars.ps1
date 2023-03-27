#TODO: Dynamic urls https://stackoverflow.com/questions/33520699/iterating-through-a-json-file-powershell
$EmuDeckStartFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck"
$desktop_path = [Environment]::GetFolderPath("Desktop")
$url_ra = "https://buildbot.libretro.com/stable/1.14.0/windows/x86_64/RetroArch.7z"
$url_dolphin = "https://dl.dolphin-emu.org/builds/a3/80/dolphin-master-5.0-17995-x64.7z"
$url_cemu = "https://cemu.info/releases/cemu_1.27.1.zip"
$url_ppsspp = "https://ppsspp.org/files/1_14_4/ppsspp_win.zip"
$url_duck = "https://github.com/stenzek/duckstation/releases/download/latest/duckstation-windows-x64-release.zip"
$url_pcsx2 = "https://github.com/dragoonDorise/rpcsx2win/releases/download/1.7.3930/pcsx2.7z"
$url_esde = "https://gitlab.com/es-de/emulationstation-de/-/package_files/48555328/download"
$url_yuzu = "https://github.com/yuzu-emu/yuzu-mainline/releases/download/mainline-0-1014/yuzu-windows-msvc-20220512-4d5eaaf3f.zip"
$userFolder = $env:USERPROFILE
$dolphinDir = -join($userFolder,'\tools\EmulationStation-DE\Emulators\Dolphin-x64\User\Config')
$duckDir = -join($userFolder,'\Documents\DuckStation')
$dolphinIni=-join($dolphinDir,'\Dolphin.ini')
$duckIni=-join($duckDir,'\settings.ini')
$deckPath="/run/media/mmcblk0p1/"
$raConfigDir=-join($winPath,'\Emulation\tools\EmulationStation-DE\Emulators\RetroArch\')
$RetroArch_configFile=-join($winPath,'\Emulation\tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg')
$raExe=-join($winPath,'\Emulation\tools\\EmulationStation-DE\\Emulators\\RetroArch\\','retroarch.exe')


