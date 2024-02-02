$Android_Pegasus_temp="$env:USERPROFILE/Desktop/EmudeckAndroid/Android/data/org.pegasus_frontend.android/files/pegasus-frontend"

function Android_Pegasus_install(){
	$temp_url="https://github.com/mmatyas/pegasus-frontend/releases/download/continuous/pegasus-fe_alpha16-75-gc78a6851_android64.apk"
	$temp_emu="yuzu"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Pegasus_init(){
	#Download theme
	mkdir "$Android_Pegasus_temp/themes/" -ErrorAction SilentlyContinue
	$temp_url="$(getLatestReleaseURLGH "plaidman/retromega-next" ".zip")"
	$temp_emu="retromega-next"
	Android_download "$temp_emu.zip" $temp_url
	& $7z x -o"$Android_Pegasus_temp/themes/$temp_emu" -aoa "$env:USERPROFILE\emudeck\android\$temp_emu.zip"
	#Change paths
	copyFromTo "$env:APPDATA/EmuDeck/backend/configs/Android/data/org.pegasus_frontend.android/files/pegasus-frontend" "$Android_Pegasus_temp/"
	$originFile="$Android_Pegasus_temp/game_dirs.txt"
	$origin="XXXX"
	$target="$androidStoragePath"
	sedFile $originFile $origin $target

	Android_ADB_push $Android_Pegasus_temp /storage/emulated/0/Android/data/org.pegasus_frontend.android/files/pegasus-frontend/
}