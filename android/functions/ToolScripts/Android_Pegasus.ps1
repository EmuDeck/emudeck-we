$Android_Pegasus_temp="$Android_temp_internal/Android/data/org.pegasus_frontend.android/files/pegasus-frontend"

function Android_Pegasus_install(){
	setMSG "Installing Pegasus"
	$temp_url="https://github.com/mmatyas/pegasus-frontend/releases/download/continuous/pegasus-fe_alpha16-75-gc78a6851_android64.apk"
	$temp_emu="yuzu"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Pegasus_init(){
	setMSG "Setting up Pegasus"
	#Download theme
	mkdir "$Android_Pegasus_temp/themes/" -ErrorAction SilentlyContinue
	$temp_url="$(getLatestReleaseURLGH "plaidman/retromega-next" ".zip")"
	$temp_emu="retromega-next"
	Android_download "$temp_emu.zip" $temp_url
	& $7z x -o"$Android_Pegasus_temp/themes/$temp_emu" -aoa "$Android_folder\$temp_emu.zip"
	rm -fo -r "$Android_folder\$temp_emu.zip"
	#Change paths
	copyFromTo "$env:APPDATA/EmuDeck/backend/android/configs/Android/data/org.pegasus_frontend.android/files/pegasus-frontend" "$Android_Pegasus_temp/"
	$originFile="$Android_Pegasus_temp/game_dirs.txt"
	$origin="XXXX"
	$target="$androidStoragePath"
	sedFile $originFile $origin $target

	Android_ADB_push $Android_Pegasus_temp/ /storage/emulated/0/Android/data/org.pegasus_frontend.android/files/pegasus-frontend/
}