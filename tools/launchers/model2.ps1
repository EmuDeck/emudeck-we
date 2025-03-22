cd "$env:APPDATA/EmuDeck/Emulators/m2emulator"
$emulatorFile = "./EMULATOR.exe"
$emuName = "model2"

. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
hideMe
isLatestVersionGH($emuName)
checkAndStartSteam
cloud_sync_init($emuName)

& $emulatorFile $args

rm -fo -r "$savesPath/.watching" -ErrorAction SilentlyContinue
rm -fo -r "$savesPath/.emulator" -ErrorAction SilentlyContinue