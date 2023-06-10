@echo off 
echo|set /p="Setting up Steam UI..."
 "C:\Program Files (x86)\Steam\Steam.exe" "-bigpicture" && cmd /c start /min ""  "%USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\desktopmode.bat"
 exit