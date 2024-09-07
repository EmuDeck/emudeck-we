. "$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1"
$result = yesNoDialog -TitleText "CloudSync Force" -MessageText "Do you want to force the download or the upload" -OKButtonText "Upload" -CancelButtonText "Download"

if ($result -eq "OKButton") {
    $dialog = steamToast  -MessageText "Uploading all systems... don't turn off your device"
    cloud_sync_uploadEmuAll
    $dialog.Close()
} else {
    $dialog = steamToast  -MessageText "Downloading all systems... don't turn off your device"
    cloud_sync_downloadEmuAll
    $dialog.Close()
}