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
	RPCS3_setupStorage
	RPCS3_setupSaves
	RPCS3_setEmulationFolder
}
function RPCS3_update(){
	echo "NYI"
}
function RPCS3_setEmulationFolder(){
	sedFile "$emusPath/RPCS3/config/vfs.yml" "C:/Emulation" "$emulationPath"
	
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
	rm -fo "$savesPath\rpcs3\saves.lnk" -Recurse -ErrorAction SilentlyContinue
	mkdir "$savesPath\rpcs3\" -ErrorAction SilentlyContinue
	createLink "$emulationPath\storage\rpcs3\dev_hdd0\home\00000001\savedata" "$savesPath\rpcs3\saves.lnk"
}

function RPCS3_setupStorage(){
	$SourceFilePath = "$emusPath\RPCS3\dev_hdd0"
	
	#We move HDD to the Emulation storage folder
	$test=Test-Path -Path "$emusPath\RPCS3\dev_hdd0"
	if($test){	
		$userDrive=$emulationPath[0]
		
		$destinationFree = (Get-PSDrive -Name $userDrive).Free
		$sizeInGB = [Math]::Round($destinationFree / 1GB)
		
		$originSize = (Get-ChildItem -Path $SourceFilePath -Recurse | Measure-Object -Property Length -Sum).Sum
		$wshell = New-Object -ComObject Wscript.Shell
		
		if ( $originSize -gt $destinationFree ){			
			$Output = $wshell.Popup("You don't have enough space in your $userDrive drive, free at least $sizeInGB GB")
			exit
		}				
		$Output = $wshell.Popup("We are going to move RPCS3 data to $userDrive to save space from your internal storage. This could take long, so please wait until you get a new confirmation window")
		
		
		moveFromTo "$emusPath\RPCS3\dev_hdd0" "$emulationPath/storage/rpcs3/dev_hdd0"	
		$Output = $wshell.Popup("Migration complete!")
	
	}else{
		mkdir "$emulationPath/storage/rpcs3/dev_hdd0/home/00000001/savedata"  -ErrorAction SilentlyContinue
	}
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