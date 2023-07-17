@Write-Output off 
echo|set /p="Setting up Steam UI, don't close this window..."
 "C:\Program Files (x86)\Steam\Steam.exe" "-bigpicture" && Write-Output LAUNCHED && cmd /c start /min ""  "%USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\desktopmode.bat" || cmd /c start /min ""  "%USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\disablegamemode.bat"
 Write-Output FAILED
 
 exit