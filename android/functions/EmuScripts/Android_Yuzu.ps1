#!/bin/bash

function Android_Yuzu_install(){
	setMSG "Installing Yuzu"
	$temp_url="$(Android_getLatestReleaseURLGH "yuzu-emu/yuzu-android" ".apk")"
	$temp_emu="yuzu"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Yuzu_init(){
	echo "NYI"
}