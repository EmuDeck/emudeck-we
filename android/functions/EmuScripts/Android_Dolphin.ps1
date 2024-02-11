#!/bin/bash

function Android_Dolphin_install(){
	setMSG "Installing Dolphin"
	$temp_url="$(Android_getLatestReleaseURLGH "Medard22/Dolphin-MMJR2-VBI" ".apk")"
	$temp_emu="dolphinmmjr2"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Dolphin_init(){
	setMSG "Setting up Dolphin"

	copyFromTo "$env:APPDATA/EmuDeck/backend/android/configs/mmjr2-vbi/" "$Android_temp_internal/"
	$originFile="$Android_temp_internal/mmjr2-vbi/Config/Dolphin.txt"
	$origin="XXXX"

	#SD or internal?
	if ( $androidStoragePath -like "*-*" ){
		$target = $androidStoragePath -replace "/storage/", ""
	}else{
		$target="primary"
	}

	sedFile $originFile $origin $target

	Android_ADB_push "$Android_temp_internal/mmjr2-vbi" /storage/emulated/0/mmjr2-vbi

}