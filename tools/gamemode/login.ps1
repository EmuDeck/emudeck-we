function openDesktop(){
	if (-not (Get-Process -Name "explorer" -ErrorAction SilentlyContinue)) {
		Start-Process explorer.exe
	}
}

function bigPictureIsOpen(){
	return [bool](Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like "*Big Picture*" })
}

function steamIsRunning(){
	return [bool](Get-Process -Name "steam" -ErrorAction SilentlyContinue)
}

try {
	$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue).SteamPath
	if (-not $steamPath) {
		$steamPath = "${env:ProgramFiles(x86)}\Steam"
	}
	$steamExe = Join-Path $steamPath.Replace("/", "\") "Steam.exe"

	if (Test-Path $steamExe) {
		Start-Process -FilePath $steamExe -ArgumentList "-bigpicture" -WindowStyle Hidden

		$timeout = (Get-Date).AddMinutes(2)
		while (-not (bigPictureIsOpen) -and (steamIsRunning) -and (Get-Date) -lt $timeout) {
			Start-Sleep -Seconds 2
		}
		while ((bigPictureIsOpen) -and (steamIsRunning)) {
			Start-Sleep -Seconds 2
		}
	}
} catch {
}

openDesktop
