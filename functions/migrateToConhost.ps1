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

function revertConhost(){
	if (isEarlyUnstable) {
		return
	}

	$srmSettings = "$toolsPath\userData\userSettings.json"
	$srmConhost = (Test-Path $srmSettings) -and (Select-String -LiteralPath $srmSettings -Pattern "conhost.exe" -SimpleMatch -Quiet)
	$vdfFiles = @(Get-ChildItem -Path "$steamInstallPath\userdata\*\config\shortcuts.vdf" -ErrorAction SilentlyContinue | Where-Object { Select-String -LiteralPath $_.FullName -Pattern 'conhost.exe" --headless' -SimpleMatch -Quiet })

	if ($vdfFiles.Count -gt 0) {
		$steamRunning = Get-Process -Name "steam" -ErrorAction SilentlyContinue
		killSteam

		$latin1 = [System.Text.Encoding]::GetEncoding(28591)
		foreach ($vdf in $vdfFiles) {
			$content = $latin1.GetString([System.IO.File]::ReadAllBytes($vdf.FullName))
			$newContent = [regex]::Replace($content, 'conhost\.exe" --headless ([^\x00]*)', {
				param($match)
				$command = $match.Groups[1].Value
				if ($command.EndsWith('}"')) {
					$command += ' && exit " && exit --emudeck'
				} elseif ($command.EndsWith('.ps1"')) {
					$command = $command.Substring(0, $command.Length - 1) + ' && exit && exit --emudeck"'
				} elseif ($command.EndsWith('.ps1')) {
					$command += ' && exit " && exit --emudeck'
				}
				'cmd.exe" /k start /min "Loading PowerShell Launcher" ' + $command
			})
			Copy-Item -Path $vdf.FullName -Destination "$($vdf.FullName).conhost-revert.bak" -Force
			[System.IO.File]::WriteAllBytes($vdf.FullName, $latin1.GetBytes($newContent))
		}

		if ($steamRunning) {
			startSteam "-silent"
		}
	}

	if ($srmConhost) {
		SRM_init
	}

	Remove-Item -Path "$emudeckFolder\.conhost_migrated" -Force -ErrorAction SilentlyContinue
}
