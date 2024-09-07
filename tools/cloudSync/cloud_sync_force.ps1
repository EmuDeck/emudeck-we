$result = yesNoDialog -TitleText "CloudSync Force" -MessageText "Do you want to force the download or the upload" -OKButtonText "Upload" -CancelButtonText "Download"

if ($result -eq "OKButton") {
    $dialog = steamToast  -MessageText "Uploading... don't turn off your device"
    cloud_sync_uploadEmuAll
    $dialog.Close()
} else {
    $dialog = steamToast  -MessageText "Downloading... don't turn off your device"
    cloud_sync_downloadEmuAll
    $dialog.Close()
}