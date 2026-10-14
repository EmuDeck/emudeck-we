function migrateToConhost(){
	if (Test-Path "$emudeckFolder\.conhost_migrated") {
		return
	}

	$steamRunning = Get-Process -Name "steam" -ErrorAction SilentlyContinue
	killSteam

	$latin1 = [System.Text.Encoding]::GetEncoding(28591)
	Get-ChildItem -Path "$steamInstallPath\userdata\*\config\shortcuts.vdf" -ErrorAction SilentlyContinue | ForEach-Object {
		$content = $latin1.GetString([System.IO.File]::ReadAllBytes($_.FullName))
		$newContent = $content.Replace('cmd.exe" /k start /min "Loading PowerShell Launcher"', 'conhost.exe" --headless')
		$newContent = $newContent.Replace('}" && exit " && exit --emudeck', '}"')
		$newContent = $newContent.Replace(' && exit " && exit --emudeck', '')
		$newContent = $newContent.Replace(' && exit && exit --emudeck', '')
		if ($newContent -cne $content) {
			Copy-Item -Path $_.FullName -Destination "$($_.FullName).conhost.bak" -Force
			[System.IO.File]::WriteAllBytes($_.FullName, $latin1.GetBytes($newContent))
		}
	}

	$WScriptShell = New-Object -ComObject WScript.Shell
	Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck\*.lnk" -ErrorAction SilentlyContinue | ForEach-Object {
		$shortcut = $WScriptShell.CreateShortcut($_.FullName)
		if ($shortcut.TargetPath -like "*powershell.exe") {
			$shortcut.TargetPath = "$env:windir\System32\conhost.exe"
			$shortcut.Arguments = "--headless powershell.exe $($shortcut.Arguments)"
			$shortcut.Save()
		}
	}

	"" | Set-Content "$emudeckFolder\.conhost_migrated"

	if ($steamRunning) {
		startSteam "-silent"
	}
}
