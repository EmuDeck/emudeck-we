. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1

$Host.UI.RawUI.WindowTitle = "CloudSync"

function cloud_sync_upload($emuName){	
	Write-Host  $emuName
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {
		#We lock cloudsync
		cloud_sync_lock
		if ($emuName -eq 'all'){
		
			$sh = New-Object -ComObject WScript.Shell	
			echo $cloud_sync_bin
			$target = "$emulationPath\saves\"
			& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\"
			if ($?) {			
				$baseFolder = "$target"
				$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"				
				Get-ChildItem -Directory $baseFolder | ForEach-Object {
					$folder = $_.FullName
					$emuName = (Get-Item $folder).Name
					$lastUploadFile = "$savesPath/$emuName/.last_upload"
					$failUploadFile = "$savesPath/$emuName/.fail_upload"
				
					if (Test-Path -PathType Container $folder) {
						Set-Content -Path "$lastUploadFile" -Value $timestamp
						Remove-Item -Path "$failUploadFile" -Force -Recurse -ErrorAction SilentlyContinue
					}
				}
				toastNotification -title "EmuDeck CloudSync" -message "Saves uploaded!" -img "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\img\cloud.png"	
				#$dialog.Close()		
			}
		}else{				
			Write-Host "cloudsync start"
			$target = "$emulationPath\saves\$emuName"		
			& $cloud_sync_bin copy --fast-list --checkers=50 --exclude=/.fail_upload --exclude=/.fail_download --exclude=/.pending_upload "$target" "$cloud_sync_provider`:Emudeck\saves\$emuName\"			
			if ($?) {
				Write-Host "todo ok"
				rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
				toastNotification -title "EmuDeck CloudSync" -message "Saves uploaded!" -img "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\img\cloud.png"
				#$dialog.Close()
			}else{
				Write-Host "ERROR"
			}
			Write-Host "cloudsync finish"
		}
		#We unlock cloudsync
		cloud_sync_unlock
		
	}
}

# make sure you adjust this to point to the folder you want to monitor
$PathToMonitor = $savesPath

$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path = $PathToMonitor
$FileSystemWatcher.IncludeSubdirectories = $true
$FileSystemWatcher.EnableRaisingEvents = $true

$patron = 'Emulation\\saves\\([^\\]+)\\.*'

# define the code that should execute when a file change is detected
$Action = {
	$details = $event.SourceEventArgs
	$FullPath = $details.FullPath

	if ($FullPath -match $patron) {
		$carpetaDespuesDeSaves = $Matches[1]
		cloud_sync_upload($carpetaDespuesDeSaves)
	} else {
		Write-Host "No se encontró una carpeta después de Emulation\saves."
	}
	
	Write-Host "Change detected - $carpetaDespuesDeSaves"
	cloud_sync_upload($carpetaDespuesDeSaves)
}

# add event handler for Changed event
Register-ObjectEvent -InputObject $FileSystemWatcher -EventName Changed -Action $Action -SourceIdentifier FSChange

Write-Host "Watching for changes to $PathToMonitor"

try {
	do {
		Wait-Event -Timeout 1
		Write-Host "." -NoNewline
	} while ($true)
} finally {
	# this gets executed when user presses CTRL+C
	Unregister-Event -SourceIdentifier FSChange
	$FileSystemWatcher.EnableRaisingEvents = $false
	$FileSystemWatcher.Dispose()
	"Event Handler disabled."
}
