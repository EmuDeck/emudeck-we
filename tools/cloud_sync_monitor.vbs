Option Explicit

Dim objFSO, objShell, psCommand, timer, emuName
Dim folderPath, folderModifiedTime, folderContents
emuName = WScript.Arguments(0)

' Ruta de la carpeta que se va a monitorizar
folderPath = "C:\Emulation\saves"

Dim exclusionList
exclusionList = Array(".fail_upload", ".fail_download", ".pending_upload")

' Comando de PowerShell que se ejecutará cuando se detecte un cambio
psCommand = ". $env:USERPROFILE\Appdata\Roaming\EmuDeck\backend\functions\all.ps1; cloud_sync_uploadEmu " & emuName

' Ruta del archivo "cloud.lock" dentro de la carpeta del usuario
Dim cloudLockPath
cloudLockPath = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%USERPROFILE%") & "\emudeck\cloud.lock"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

' Alert
alert = ". $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1; toastNotification -title ""EmuDeck CloudSync"" -message ""Saves uploaded!"" -img ""$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\img\cloud.png"""

ExecutePowerShellCommand alert

' Función para ejecutar el comando de PowerShell
Sub ExecutePowerShellCommand(command)
	Dim cmd
	cmd = "powershell -ExecutionPolicy Bypass -Command """ & command & """"
	objShell.Run cmd, 0, False
End Sub

' Función para verificar si existe algún archivo y esperar hasta que deje de existir
Sub WaitForFileDeletion(filePath)
	Do While objFSO.FileExists(filePath)
		WScript.Sleep 1000
	Loop
End Sub

' Función para comprobar cambios en la carpeta y ejecutar el comando de PowerShell
Sub CheckForChanges(folder)
	On Error Resume Next

	Dim subFolder, file

	' Verificar si ha habido cambios en la carpeta actual
	If folder.DateLastModified <> folderModifiedTime Or Not AreContentsEqual(folder) Then			
		
		' Almacenar la nueva fecha de modificación y los contenidos de la carpeta
		folderModifiedTime = folder.DateLastModified
		folderContents = GetFolderContents(folder)

		' Ejecutar la función de PowerShell solo si hay cambios en la carpeta
		If Not IsExcluded(folder.Path) Then
			ExecutePowerShellCommand psCommand
		End If
	End If

	On Error GoTo 0

	' Comprobar si cmd.exe está en ejecución
	If CheckCmdRunning("cmd.exe") Then
		
		Exit Sub ' Salir sin detener el temporizador
	End If

	' Comprobar si existe el archivo "cloud.lock"
	If objFSO.FileExists(cloudLockPath) Then
		
		' Esperar hasta que el archivo "cloud.lock" deje de existir
		WaitForFileDeletion cloudLockPath
	Else
		
		' Finalizar el script
		StopTimer
		WScript.Quit
	End If

	' Recorrer las subcarpetas y llamar recursivamente a la función para verificar cambios en ellas
	For Each subFolder In folder.SubFolders
		CheckForChanges subFolder
	Next

End Sub

' Función para buscar si un proceso está en ejecución por su nombre
Function CheckCmdRunning(processName)
	Dim colProcesses, objProcess
	Set colProcesses = GetObject("winmgmts:\\.\root\cimv2").ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & processName & "'")
	
	For Each objProcess In colProcesses
		If objProcess.Name = processName Then
			CheckCmdRunning = True
			Exit Function
		End If
	Next
	
	CheckCmdRunning = False
End Function

Function IsExcluded(filePath)
	Dim i
	For i = LBound(exclusionList) To UBound(exclusionList)
		If LCase(filePath) = LCase(folderPath & "\" & exclusionList(i)) Then
			IsExcluded = True
			Exit Function
		End If
	Next
	IsExcluded = False
End Function

' Función para verificar si el contenido de la carpeta ha cambiado
Function AreContentsEqual(folder)
	Dim contentHash, file, subFolder
	contentHash = ""

	For Each file In folder.Files
		contentHash = contentHash & file.Path & file.Size & file.DateLastModified
	Next

	' Recorrer las subcarpetas y obtener su contenido de forma recursiva
	For Each subFolder In folder.SubFolders
		contentHash = contentHash & GetFolderContents(subFolder)
	Next

	AreContentsEqual = (contentHash = folderContents)
End Function

' Función para obtener el contenido de la carpeta
Function GetFolderContents(folder)
	Dim contentHash, file, subFolder
	contentHash = ""

	For Each file In folder.Files
		contentHash = contentHash & file.Path & file.Size & file.DateLastModified
	Next

	' Recorrer las subcarpetas y obtener su contenido de forma recursiva
	For Each subFolder In folder.SubFolders
		contentHash = contentHash & GetFolderContents(subFolder)
	Next

	GetFolderContents = contentHash
End Function

' Función para iniciar el temporizador
Sub StartTimer(interval)
	Dim cmd
	cmd = "ping -n " & interval & " 127.0.0.1"
	Set timer = objShell.Exec(cmd)
End Sub

' Función para detener el temporizador
Sub StopTimer()
	If Not timer Is Nothing Then
		timer.Terminate
		Set timer = Nothing
	End If
End Sub

' Iniciar la comprobación en segundo plano

folderModifiedTime = objFSO.GetFolder(folderPath).DateLastModified
folderContents = GetFolderContents(objFSO.GetFolder(folderPath))

StartTimer 1 ' Intervalo de comprobación en segundos (por ejemplo, 1 segundo)

Do While True
	CheckForChanges objFSO.GetFolder(folderPath)
Loop
