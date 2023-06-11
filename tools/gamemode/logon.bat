@echo off 
echo|set /p="Setting up Steam UI, don't close this window..."
 "C:\Program Files (x86)\Steam\Steam.exe" "-bigpicture" && IF %ERRORLEVEL% != 0 ( cmd /c start /min ""  "%USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\desktopmode.bat" ) ELSE ( cmd /c start /min ""  "%USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\disablegamemode.bat" )
 exit