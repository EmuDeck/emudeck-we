$user=$args[0]
$userPath = ( Get-CimInstance Win32_UserProfile -Filter "SID = '$((Get-LocalUser $user).Sid)'" ).LocalPath

Start-Transcript $userPath\emudeck\cloudwatcher.log

$f1 = Join-Path -Path $userPath -ChildPath 'EmuDeck\settings.ps1'
$f2 = Join-Path -Path $userPath -ChildPath 'AppData\Roaming\EmuDeck\backend\functions\createLink.ps1'
$f3 = Join-Path -Path $userPath -ChildPath 'AppData\Roaming\EmuDeck\backend\functions\createLauncher.ps1'
$f4 = Join-Path -Path $userPath -ChildPath 'AppData\Roaming\EmuDeck\backend\functions\helperFunctions.ps1'
$f5 = Join-Path -Path $userPath -ChildPath 'AppData\Roaming\EmuDeck\backend\functions\ToolScripts\emuDeckSaveSync.ps1'

. $f1
. $f2
. $f3
. $f4
. $f5

echo "" > $savesPath/.watching

$nssm = Join-Path -Path $userPath -ChildPath '\AppData\Roaming\EmuDeck\backend\wintools\nssm.exe'
$emuName = Get-Content "$savesPath/.emulator"

# specify the path to the folder you want to watch:

if ($emuName -eq 'all'){
	$emuPath = "$savesPath"
}elseif($emuName -eq $null -or $emuName -eq ''){
	$emuPath = "$savesPath"
	$emuName = 'all'
}else{
	$emuPath = "$savesPath\$emuName"
}

$Path = "$emuPath"

# specify which files you want to monitor
$FileFilter = '*'  

# specify whether you want to monitor subfolders as well:
$IncludeSubfolders = $true

# specify the file or folder properties you want to monitor:
$AttributeFilter = [IO.NotifyFilters]::FileName, [IO.NotifyFilters]::LastWrite 

# Create a dictionary to track the last modified time of each file
$lastModifiedTimes = @{}

try
{
  $watcher = New-Object -TypeName System.IO.FileSystemWatcher -Property @{
	Path = $Path
	Filter = $FileFilter
	IncludeSubdirectories = $IncludeSubfolders
	NotifyFilter = $AttributeFilter
  }

  # define the code that should execute when a change occurs:
  $action = {
	# the code is receiving this to work with:

	# change type information:
	$details = $event.SourceEventArgs
	$Name = $details.Name
	$FullPath = $details.FullPath
	$OldFullPath = $details.OldFullPath
	$OldName = $details.OldName

	$blackList = @(".hash", ".last_upload", ".pending_upload", ".watching", "$emuPath")

	# Check if the file is in the blacklist to skip to the next loop
	$skip = $blackList | ForEach-Object { $FullPath -like "*$_" }

	if($skip -contains $true){
		Write-Host "Ignoring blacklisted file"
		return
	}

	# type of change:
	$ChangeType = $details.ChangeType

	# when the change occurred:
	$Timestamp = $event.TimeGenerated

	# Check if the file was modified in the last 2 seconds
	$lastModifiedTime = $lastModifiedTimes[$FullPath]
	if ($lastModifiedTime -and ($Timestamp).Subtract($lastModifiedTime).TotalSeconds -lt 1) {
		Write-Host "Ignoring $FullPath because it was modified again too quickly."
		return
	}

	# Update the last modified time for this file
	$lastModifiedTimes[$FullPath] = (Get-Date)

	# save information to a global variable for testing purposes
	# so you can examine it later
	# MAKE SURE YOU REMOVE THIS IN PRODUCTION!
	#$global:all = $details

	# now you can define some action to take based on the
	# details about the change event:

	# let's compose a message:
	$text = "{0} was {1} at {2}" -f $FullPath, $ChangeType, $Timestamp
	Write-Host ""
	Write-Host $text -ForegroundColor DarkYellow

	# you can also execute code based on change type here:
	switch ($ChangeType)
	{
	  'Changed'  { 
	  
		if ($skip -contains $true -or $FullPath -eq $savesPath -or $FullPath -eq $emuPath) {
			  Write-Host "No upload"
		  } else {
		  	  Get-Date | Out-File -FilePath $savesPath/$emuName/.pending_upload	   		  
			  cloud_sync_uploadEmu $emuName $userPath
			  rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue			  
		  }       
	  }
	  'Created'  {      
		if ($skip -contains $true -or $FullPath -eq $savesPath -or $FullPath -eq $emuPath) {
			  Write-Host "No upload"              
		  } else {			  
		      Get-Date | Out-File -FilePath $savesPath/$emuName/.pending_upload
			  cloud_sync_uploadEmu $emuName $userPath
			  rm -fo "$savesPath/$emuName/.pending_upload" -ErrorAction SilentlyContinue
		  }                
		  
	  }
	  'Deleted'  { "DELETED"
		# to illustrate that ALL changes are picked up even if
		# handling an event takes a lot of time, we artificially
		# extend the time the handler needs whenever a file is deleted
		Write-Host "Deletion Handler Start" -ForegroundColor Gray
		Start-Sleep -Seconds 4    
		Write-Host "Deletion Handler End" -ForegroundColor Gray
	  }
	  'Renamed'  { 
		# this executes only when a file was renamed
		$text = "File {0} was renamed to {1}" -f $OldName, $Name
		Write-Host $text -ForegroundColor Yellow
	  }
		
	  # any unhandled change types surface here:
	  default   { Write-Host $_ -ForegroundColor Red -BackgroundColor White }
	}
  }

  # subscribe your event handler to all event types that are
  # important to you. Do this as a scriptblock so all returned
  # event handlers can be easily stored in $handlers:
  $handlers = . {
	Register-ObjectEvent -InputObject $watcher -EventName Changed  -Action $action 
	Register-ObjectEvent -InputObject $watcher -EventName Created  -Action $action 
	#Register-ObjectEvent -InputObject $watcher -EventName Deleted  -Action $action 
	#Register-ObjectEvent -InputObject $watcher -EventName Renamed  -Action $action 
  }

  # monitoring starts now:
  $watcher.EnableRaisingEvents = $true

  Write-Host "Watching for changes to $Path"

  # since the FileSystemWatcher is no longer blocking PowerShell
  # we need a way to pause PowerShell while being responsive to
  # incoming events. Use an endless loop to keep PowerShell busy:
  do
  {
	# Wait-Event waits for a second and stays responsive to events
	# Start-Sleep in contrast would NOT work and ignore incoming events
	Wait-Event -Timeout 1

	# write a dot to indicate we are still monitoring:
	Write-Host "." -NoNewline
	
	# Process name to find
	$processName = "EmuDeck Launcher"
	$cmdFile = Join-Path -Path $savesPath -ChildPath '.watching'
	$lockFile = Join-Path -Path $userPath -ChildPath 'EmuDeck\cloud.lock'
	
	# Check if the process exists
	$process = Get-Process | Where-Object { $_.MainWindowTitle -eq $processName }

	
	# We exit if it doesn't
	if (-not (Test-Path $cmdFile)) {
		Write-Host "There's no .watching file"
		# Check for lock file
		if (-not (Test-Path $lockFile)) {
			Write-Host "There's no lock file, bye!"
			
			& $nssm stop CloudWatch
			exit
		}       
	}
		
  } while ($true)
}
finally
{
  # this gets executed when the user presses CTRL+C:
  
  # stop monitoring
  $watcher.EnableRaisingEvents = $false
  
  # remove the event handlers
  $handlers | ForEach-Object {
	Unregister-Event -SourceIdentifier $_.Name
  }
  
  # event handlers are technically implemented as a special kind
  # of background job, so remove the jobs now
}
Stop-Transcript