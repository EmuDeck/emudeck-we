#TODO: Dynamic urls https://stackoverflow.com/questions/33520699/iterating-through-a-json-file-powershell
$EmuDeckStartFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck"
$desktop_path = [Environment]::GetFolderPath("Desktop")
$url_ra = "https://buildbot.libretro.com/stable/1.14.0/windows/x86_64/RetroArch.7z"
$url_dolphin = "https://dl.dolphin-emu.org/builds/a3/80/dolphin-master-5.0-17995-x64.7z"
$url_pcsx2 = "https://github.com/dragoonDorise/rpcsx2win/releases/download/1.7.3930/pcsx2.7z"
$url_rpcs3 = "https://github.com/RPCS3/rpcs3-binaries-win/releases/download/build-d3183708e81ba2707d39829cc1c0cb226dd9e50e/rpcs3-v0.0.26-14599-d3183708_win64.7z"
$url_yuzu = "https://github.com/yuzu-emu/yuzu-mainline/releases/download/mainline-0-1014/yuzu-windows-msvc-20220512-4d5eaaf3f.zip"
$url_duck = "https://github.com/stenzek/duckstation/releases/download/latest/duckstation-windows-x64-release.zip"
$url_cemu = "https://cemu.info/releases/cemu_1.26.2.zip"
$url_xenia = "https://github.com/xenia-project/release-builds-windows/releases/latest/download/xenia_master.zip"
$url_ppsspp = "https://ppsspp.org/files/1_14_4/ppsspp_win.zip"
$url_xemu = "https://github.com/mborgerson/xemu/releases/latest/download/xemu-win-release.zip"
$url_srm = "https://github.com/SteamGridDB/steam-rom-manager/releases/download/v2.3.40/Steam-ROM-Manager-portable-2.3.40.exe"
$url_esde = "https://gitlab.com/es-de/emulationstation-de/-/package_files/48555328/download"
$url_citra ="https://github.com/citra-emu/citra-nightly/releases/download/nightly-1766/citra-windows-mingw-20220520-a6e7a81.7z"
$userFolder = $env:USERPROFILE
$dolphinDir = -join($userFolder,'\tools\EmulationStation-DE\Emulators\Dolphin-x64\User\Config')
$duckDir = -join($userFolder,'\Documents\DuckStation')
$dolphinIni=-join($dolphinDir,'\Dolphin.ini')
$duckIni=-join($duckDir,'\settings.ini')
$deckPath="/run/media/mmcblk0p1/"
$raConfigDir=-join($winPath,'\Emulation\tools\EmulationStation-DE\Emulators\RetroArch\')
$RetroArch_configFile=-join($winPath,'\Emulation\tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg')
$raExe=-join($winPath,'\Emulation\tools\\EmulationStation-DE\\Emulators\\RetroArch\\','retroarch.exe')


