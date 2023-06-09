@echo off 
REG ADD "HKCU\Control Panel\Desktop" /v Wallpaper /d "%USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\bg.png" /f
echo|set /p="Setting up Steam UI..."
 "C:\Program Files (x86)\Steam\Steam.exe" "-bigpicture" && cmd /c start /min ""  "%USERPROFILE%\AppData\Roaming\EmuDeck\backend\tools\gamemode\desktopmode.bat"
 exit