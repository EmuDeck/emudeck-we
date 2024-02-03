#!/bin/bash

function Android_Citra_install(){
	setMSG "Installing Citra"
	$temp_url="$(Android_getLatestReleaseURLGH "weihuoya/citra" ".apk")"
	$temp_emu="citra"
	Android_ADB_dl_installAPK $temp_emu $temp_url
}

function Android_Citra_init(){
	echo "NYI"
}