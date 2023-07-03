@echo off
tasklist /FI "IMAGENAME eq steam.exe" 2>NUL | find /I /N "steam.exe">NUL
if "%ERRORLEVEL%"=="1" (
	powershell -ExecutionPolicy Bypass -command "& { cd $env:USERPROFILE ; cd AppData ; cd Roaming  ; cd EmuDeck ; cd backend ; cd functions ; . ./all.ps1 ; showDialog('Steam not detected.`nYour controls might not work....'); Clear-Host; Start-Sleep -Seconds 3 }")
)
set args=%*
"ESDEPATH\EmulationStation.exe" %args%