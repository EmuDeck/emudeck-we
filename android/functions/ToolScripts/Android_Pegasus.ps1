$Android_Pegasus_temp="$Android_temp_android_data/org.pegasus_frontend.android/files/pegasus-frontend"

function Android_Pegasus_install(){
	setMSG "Installing Pegasus"
	$temp_url="$(Android_getLatestReleaseURLGH "mmatyas/pegasus-frontend" "android64.apk")"
	$temp_emu="pegasus"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Pegasus_init(){
	setMSG "Setting up Pegasus"
	#Download theme
	mkdir "$Android_Pegasus_temp/themes/" -ErrorAction SilentlyContinue
	$temp_url="$(Android_getLatestReleaseURLGH "dragoonDorise/retromega-next" ".zip")"
	$temp_emu="retromega-next"
	Android_download "$temp_emu.zip" $temp_url
	& $7z x -o"$Android_Pegasus_temp/themes/$temp_emu" -aoa "$Android_folder\$temp_emu.zip"
	rm -fo -r "$Android_folder\$temp_emu.zip"

	$temp_url="$(Android_getLatestReleaseURLGH "dragoonDorise/ES-Simple-Clean" ".zip")"
	$temp_emu="simple-clean"
	Android_download "$temp_emu.zip" $temp_url
	& $7z x -o"$Android_Pegasus_temp/themes/$temp_emu" -aoa "$Android_folder\$temp_emu.zip"
	rm -fo -r "$Android_folder\$temp_emu.zip"

	$temp_url="$(Android_getLatestReleaseURLGH "dragoonDorise/COLORFUL" ".zip")"
	$temp_emu="colorful"
	Android_download "$temp_emu.zip" $temp_url
	& $7z x -o"$Android_Pegasus_temp/themes/$temp_emu" -aoa "$Android_folder\$temp_emu.zip"
	rm -fo -r "$Android_folder\$temp_emu.zip"


	$temp_url="$(Android_getLatestReleaseURLGH "dragoonDorise/RP-RG351" ".zip")"
	$temp_emu="rg351"
	Android_download "$temp_emu.zip" $temp_url
	& $7z x -o"$Android_Pegasus_temp/themes/$temp_emu" -aoa "$Android_folder\$temp_emu.zip"
	rm -fo -r "$Android_folder\$temp_emu.zip"

	$temp_url="$(Android_getLatestReleaseURLGH "dragoonDorise/RP-epic-noir" ".zip")"
	$temp_emu="epicnoir"
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

function Android_Pegasus_setup(){
	adb shell pm grant org.pegasus_frontend.android android.permission.WRITE_EXTERNAL_STORAGE
}

function Android_Pegasus_IsInstalled(){
	$package="org.pegasus_frontend.android"
	$test= adb shell pm list packages $package
	if ($test){
		Write-Output  "true"
	}else{
		Write-Output  "false"
	}
}

