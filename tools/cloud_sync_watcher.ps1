. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\allCloud.ps1

### TEST CODE START

$emuName = $args[0]

# specify the path to the folder you want to monitor:
$Path = "$savesPath"
if ($emuName -eq 'all'){
	$emuPath = "$savesPath"
}else{
	$emuPath = "$savesPath\$emuName"
}


# specify which files you want to monitor
$FileFilter = '*'  

# specify whether you want to monitor subfolders as well:
$IncludeSubfolders = $true

# specify the file or folder properties you want to monitor:
$AttributeFilter = [IO.NotifyFilters]::FileName, [IO.NotifyFilters]::LastWrite 

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
	
	$ValoresABuscar = @(".hash", ".last_upload", ".pending_upload", "$emuPath")
	
	# Verificar si $String contiene cualquiera de los valores en $ValoresABuscar
	$ContieneAlgunValor = $ValoresABuscar | ForEach-Object { $FullPath -like "*$_" }

		
	# type of change:
	$ChangeType = $details.ChangeType
	
	# when the change occured:
	$Timestamp = $event.TimeGenerated
	
	# save information to a global variable for testing purposes
	# so you can examine it later
	# MAKE SURE YOU REMOVE THIS IN PRODUCTION!
	#$global:all = $details
	
	# now you can define some action to take based on the
	# details about the change event:
	
	# let's compose a message:
	$text = "{0} was {1} at {2}" -f $FullPath, $ChangeType, $Timestamp
	Write-Host ""
	#Write-Host $text -ForegroundColor DarkYellow
	
	Write-Host $FullPath
	
	# you can also execute code based on change type here:
	switch ($ChangeType)
	{
	  'Changed'  { "CHANGE"
	  
	  	if ($ContieneAlgunValor -contains $true -or $FullPath -eq $savesPath -or $FullPath -eq $emuPath) {
			  Write-Host "No upload"
		  } else {
			  Write-Host "upload";
			  cloud_sync_uploadEmu $emuName
		  }
	  }
	  'Created'  { "CREATED"
	  	if ($ContieneAlgunValor -contains $true -or $FullPath -eq $savesPath -or $FullPath -eq $emuPath) {
			  Write-Host "No upload"
		  } else {
			  Write-Host "upload";
			  cloud_sync_uploadEmu $emuName
		  }
	  }
	  'Deleted'  { "DELETED"
		# to illustrate that ALL changes are picked up even if
		# handling an event takes a lot of time, we artifically
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
	Register-ObjectEvent -InputObject $watcher -EventName Deleted  -Action $action 
	Register-ObjectEvent -InputObject $watcher -EventName Renamed  -Action $action 
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
	
	# Nombre del proceso a buscar
	$nombreProceso = "EmuDeck Launcher"
	$rutaArchivo = "$env:USERPROFILE\emudeck\cloud.lock"
	
	# Verificar si existe un proceso con el nombre especificado
	$proceso = Get-Process | Where-Object { $_.MainWindowTitle -eq $nombreProceso }
	
	# Si no se encuentra el proceso, salimos del script
	if ($proceso -eq $null) {
		#Write-Host "La ventana de CMD '$nombreProceso' no se encontró. El script se terminará."
		
		# Buscar archivo
		if (-not (Test-Path $rutaArchivo)) {
			#Write-Host "La ventana de CMD '$nombreProceso' no se encontró y el archivo '$rutaArchivo' no existe."
			# Esperar un período de tiempo antes de volver a verificar
			exit
		} else {
			# Si se encuentra el archivo, establecer $encontrado en $true para salir del bucle			
			#Write-Host "El archivo '$rutaArchivo' se encontró. Continuar con el script..."
		}
		
	}
	
	# Si se encuentra el proceso, puedes continuar con tu lógica aquí
	
		
  } while ($true)
}
finally
{
  # this gets executed when user presses CTRL+C:
  
  # stop monitoring
  $watcher.EnableRaisingEvents = $false
  
  # remove the event handlers
  $handlers | ForEach-Object {
	Unregister-Event -SourceIdentifier $_.Name
  }
  
  # event handlers are technically implemented as a special kind
  # of background job, so remove the jobs now:
  $handlers | Remove-Job
  
  # properly dispose the FileSystemWatcher:
  $watcher.Dispose()
  
  Write-Warning "Event Handler disabled, monitoring ends."
}

### TEST CODE FINNISH