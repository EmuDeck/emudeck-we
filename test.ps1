. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1


### TEST CODE START

$test=Test-Path -Path "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\RetroArch.exe"
if(-not($test -and $doInstallRA -eq "true" )){
	RetroArch_install
}

### TEST CODE FINNISH

waitForUser