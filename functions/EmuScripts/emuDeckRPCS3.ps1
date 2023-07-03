function RPCS3_install(){
	setMSG "Downloading RPCS3"
	$url_rpcs3 = getLatestReleaseURLGH "RPCS3/rpcs3-binaries-win" "7z"
	download $url_rpcs3 "rpcs3.7z"
	moveFromTo "$temp/rpcs3" "$emusPath\RPCS3"
	createLauncher "rpcs3"
	
	$url_vulkan = "https://sdk.lunarg.com/sdk/download/latest/windows/vulkan-runtime.exe"
	download $url_vulkan "vulkan-runtime.exe"
	.\vulkan-runtime.exe
	
}
function RPCS3_init(){
	setMSG "RPCS3 - Configuration"
	$destination="$emusPath\RPCS3"
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\RPCS3" "$destination"
	#RPCS3_setResolution $rpcs3Resolution
}
function RPCS3_update(){
	echo "NYI"
}
function RPCS3_setEmulationFolder(){
	echo "NYI"
}
function RPCS3_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $res = "100";  }
		"1080P" { $res = "150"; }
		"1440P" { $res = "200"; }
		"4K" { $res = "300"; }
	}	
	$destination="$emusPath\RPCS3\config.yml"
	setConfig "Resolution Scale:" $res $destination
	#Fix setConfig =
	sedFile $destination "Resolution Scale:=" "  Resolution Scale: "
}

function RPCS3_setupSaves(){
	setMSG "RPCS3 - Saves Links"
	$SourceFilePath = "$emusPath\RPCS3\dev_hdd0\home\00000001\savedata"
	$ShortcutPath = -join($emulationPath,"\saves\rpcs3\saves.lnk")
	rm -fo  "saves\RPCS3" -Recurse -ErrorAction SilentlyContinue
	mkdir "saves\rpcs3" -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}

function RPCS3_setupStorage(){
	echo "NYI"
}
function RPCS3_wipe(){
	echo "NYI"
}
function RPCS3_uninstall(){
	echo "NYI"
}
function RPCS3_migrate(){
	echo "NYI"
}
function RPCS3_setABXYstyle(){
	echo "NYI"
}
function RPCS3_wideScreenOn(){
	echo "NYI"
}
function RPCS3_wideScreenOff(){
	echo "NYI"
}
function RPCS3_bezelOn(){
	echo "NYI"
}
function RPCS3_bezelOff(){
	echo "NYI"
}
function RPCS3_finalize(){
	echo "NYI"
}
function RPCS3_IsInstalled(){
	$test=Test-Path -Path "$emusPath\RPCS3"
	if($test){
		echo "true"
	}
}
function RPCS3_resetConfig(){
	RPCS3_init
	if($?){
		echo "true"
	}
}