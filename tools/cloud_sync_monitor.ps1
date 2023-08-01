. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1

$emuName = $args[0]

# Folder to monitor
$folderToMonitor = $savesPath
# Create a FileSystemWatcher object
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folderToMonitor

# Enable notifications for changes in subdirectories
$watcher.IncludeSubdirectories = $true

# Specify the types of changes to monitor
$watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName -bor [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::CreationTime -bor [System.IO.NotifyFilters]::Size -bor [System.IO.NotifyFilters]::DirectoryName

# Event that triggers when a change occurs
$onChangeAction = {
	$changeType = $eventArgs.ChangeType
	$filePath = $eventArgs.FullPath
	$parentFolder = Split-Path $filePath -Parent

	# Execute the cloud_sync_upload function when a change is detected
	cloud_sync_upload $emuName
}

# Associate the event with the FileSystemWatcher object
Register-ObjectEvent -InputObject $watcher -EventName Changed -SourceIdentifier FileChanged -Action $onChangeAction

# Start monitoring for changes
$watcher.EnableRaisingEvents = $true

# Keep the script running
Write-Host "Listening for changes in folder $folderToMonitor. Press Ctrl+C to stop."
try {
	while ($true) {
		# Keep the script running
		Start-Sleep 1
	}
} catch {
	# If the script is interrupted, clean up and stop event notification
	Unregister-Event -SourceIdentifier FileChanged
	$watcher.Dispose()
}