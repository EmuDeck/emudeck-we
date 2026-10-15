$env:GIT_TERMINAL_PROMPT = "0"
$null | git -C "$env:APPDATA\EmuDeck\backend" fetch --depth=1 origin (git -C "$env:APPDATA\EmuDeck\backend" rev-parse --abbrev-ref HEAD)
if ($?) { $null | git -C "$env:APPDATA\EmuDeck\backend" reset --hard FETCH_HEAD } else { $null | git -C "$env:APPDATA\EmuDeck\backend" reset --hard }
$null | git -C "$env:APPDATA\EmuDeck\backend" clean -fd

cd "$env:APPDATA/EmuDeck/Emulators/m2emulator"
$emulatorFile = "./EMULATOR.exe"
$emuName = "model2"

. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
launcherInit
hideMe
isLatestVersionGH($emuName)
checkAndStartSteam
cloud_sync_init($emuName)

& $emulatorFile $args

rm -fo -r "$savesPath/.watching" -ErrorAction SilentlyContinue
rm -fo -r "$savesPath/.emulator" -ErrorAction SilentlyContinue