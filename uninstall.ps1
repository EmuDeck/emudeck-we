. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"

$result = yesNoDialog -TitleText "EmuDeck uninstall" -MessageText "Hi! Are you sure you want to uninstall EmuDeck? If you are having issues do a Custom Reset, if that doesn't fix your issue visit the EmuDeck Discord or Reddit for support. For links, see: https://www.emudeck.com/#download" -OKButtonText "Uninstall" -CancelButtonText "Cancel"

	if ($result -eq "OKButton") {
		#Decky
		taskkill /IM decky-loader-win.exe /F
		taskkill /IM emudeck.exe /F
		#Steam Input
		SRM_removeSteamInputProfiles
		#Cloud service
		#cloud_sync_uninstall_service
		#Emulation folder.
		rm -fo -r "$toolsPath"
		#Launchers
		rm -fo -r "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\EmuDeck"


		#App
		& "$env:USERPROFILE\AppData\Local\Programs\EmuDeck\Uninstall EmuDeck.exe"
		#Backend
		rm -fo -r "$env:APPDATA\EmuDeck"
	} else {
		echo "Nope"
	}
