#TODO: Dynamic urls https://stackoverflow.com/questions/33520699/iterating-through-a-json-file-powershell

$url_ra = "https://buildbot.libretro.com/stable/1.10.3/windows/x86_64/RetroArch.7z"
$url_dolphin = "https://dl.dolphin-emu.org/builds/c0/39/dolphin-master-5.0-16101-x64.7z"
$url_pcsx2 = "https://github.com/dragoonDorise/rpcsx2win/releases/download/1.0/pcsx2.7z"
$url_rpcs3 = "https://github.com/RPCS3/rpcs3-binaries-win/releases/download/build-2ba437b6dc0c68a6f2cc4a683012c3d25310839a/rpcs3-v0.0.22-13600-2ba437b6_win64.7z"
$url_yuzu = "https://github.com/yuzu-emu/yuzu-mainline/releases/download/mainline-0-1014/yuzu-windows-msvc-20220512-4d5eaaf3f.zip"
$url_duck = "https://github.com/stenzek/duckstation/releases/download/latest/duckstation-windows-x64-release.zip"
$url_cemu = "https://cemu.info/releases/cemu_1.26.2.zip"
$url_xenia = "https://github.com/xenia-project/release-builds-windows/releases/latest/download/xenia_master.zip"
$url_ppsspp = "https://ppsspp.org/files/1_13_2/ppsspp_win.zip"
$url_xemu = "https://github.com/mborgerson/xemu/releases/latest/download/xemu-win-release.zip"
$url_srm = "https://github.com/SteamGridDB/steam-rom-manager/releases/download/v2.3.36/Steam-ROM-Manager-portable-2.3.36.exe"
$url_esde = "https://gitlab.com/es-de/emulationstation-de/-/package_files/36880305/download"
$url_citra ="https://github.com/citra-emu/citra-nightly/releases/download/nightly-1766/citra-windows-mingw-20220520-a6e7a81.7z"
$userFolder = $env:USERPROFILE
$dolphinDir = -join($userFolder,'\tools\EmulationStation-DE\Emulators\Dolphin-x64\User\Config')
$duckDir = -join($userFolder,'\Documents\DuckStation')
$dolphinIni=-join($dolphinDir,'\Dolphin.ini')
$duckIni=-join($duckDir,'\settings.ini')
$deckPath="/run/media/mmcblk0p1/"
$raConfigDir=-join($winPath,'\Emulation\tools\EmulationStation-DE\Emulators\RetroArch\')
$raConfigfile=-join($winPath,'\Emulation\tools\EmulationStation-DE\Emulators\RetroArch\retroarch.cfg')
$raExe=-join($winPath,'\Emulation\tools\\EmulationStation-DE\\Emulators\\RetroArch\\','retroarch.exe')

$EmulationPath=-join($winPath,'Emulation\')
$romsPath=-join($winPath,'Emulation\roms')
$biosPath=-join($winPath,'Emulation\bios\')
$toolsPath=-join($winPath,'Emulation\bios\')
$savesPath=-join($winPath,'Emulation\bios\')