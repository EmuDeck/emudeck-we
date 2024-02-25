#!/bin/bash

function Android_NetherSX2_install(){
	setMSG "Installing NetherSX2"
	$temp_url="https://github.com/Trixarian/NetherSX2-patch/releases/download/1.8/NetherSX2-builder.zip"
	$temp_emu="nethersx2"
	Android_download "$temp_emu.zip" $temp_url
	& $7z x -o"$Android_folder" -aoa "$Android_folder\$temp_emu.zip"
	rm -fo -r "$Android_folder\$temp_emu.zip"


	$origin='set col="%p2f%lib\cmdcolor.exe"'
	$target='set col="cmd.exe"'
	sedFile $Android_folder\builder\build-nethersx2.bat $origin $target

	& $Android_folder\builder\build-nethersx2.bat
	adb uninstall xyz.aethersx2.android
	Android_ADB_installAPK "$env:USERPROFILE\emudeck\android\builder\\PatchedAPK\15210-v1.5-4248-noads.apk"
}

function Android_NetherSX2_init(){
	echo "NYI"
}


function Android_NetherSX2_IsInstalled(){
	$package="xyz.aethersx2.android"
	$test= adb shell pm list packages $package
	if ($test){
		Write-Output  "true"
	}else{
		Write-Output  "false"
	}
}