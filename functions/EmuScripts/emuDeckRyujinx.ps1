function Ryujinx_install(){
	setMSG "Downloading Ryujinx"
	$url_ryu = getLatestReleaseURLGH "Ryujinx/release-channel-master" "zip"
	download $url_ryu "Ryujinx.zip"
	moveFromTo "$temp/Ryujinx/publish" "$emusPath\Ryujinx"
	createLauncher "Ryujinx"
}
function Ryujinx_init(){
	setMSG "Ryujinx - Configuration"
	$destination="$emusPath\Ryujinx"
	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\Ryujinx\Config.json" -Destination "$destination\portable\Config.json"
	mkdir "$destination\portable" -ErrorAction SilentlyContinue
	Ryujinx_setEmulationFolder	
	Ryujinx_setupSaves
}

function Ryujinx_update(){
	echo "NYI"
}
function Ryujinx_setEmulationFolder(){
	$destination="$emusPath\Ryujinx"
	sedFile $destination\portable\Config.json "/run/media/mmcblk0p1/Emulation/roms/switch" "$romsPath/switch"
}
function Ryujinx_setupSaves(){
  setMSG "Ryujinx - Saves Links"
  $SourceFilePath = "$emusPath\Ryujinx\portable\bis\user\save\"  
  mkdir $SourceFilePath -ErrorAction SilentlyContinue
  $ShortcutPath = -join($emulationPath,"\saves\ryujinx\saves.lnk")
  mkdir "saves\ryujinx" -ErrorAction SilentlyContinue
  createLink $SourceFilePath $ShortcutPath
  
  $SourceFilePath = "$emusPath\Ryujinx\portable\bis\user\saveMeta\"  
  mkdir $SourceFilePath -ErrorAction SilentlyContinue
  $ShortcutPath = -join($emulationPath,"\saves\ryujinx\saveMeta.lnk")
  createLink $SourceFilePath $ShortcutPath
	
}

function Ryujinx_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 1;  $docked="false"}
		"1080P" { $multiplier = 1; $docked="true"   }
		"1440P" { $multiplier = 2;  $docked="false" }
		"4K" { $multiplier = 2; $docked="true" }
	}	
	
	$jsonConfig = Get-Content -Path "$emusPath\Ryujinx\portable\Config.json" | ConvertFrom-Json
	$jsonConfig.docked_mode = $docked
	$jsonConfig.res_scale = $multiplier
}
function Ryujinx_setupStorage(){
	echo "NYI"
}
function Ryujinx_wipe(){
	echo "NYI"
}
function Ryujinx_uninstall(){
	echo "NYI"
}
function Ryujinx_migrate(){
	echo "NYI"
}
function Ryujinx_setABXYstyle(){
	echo "NYI"
}
function Ryujinx_wideScreenOn(){
	echo "NYI"
}
function Ryujinx_wideScreenOff(){
	echo "NYI"
}
function Ryujinx_bezelOn(){
	echo "NYI"
}
function Ryujinx_bezelOff(){
	echo "NYI"
}
function Ryujinx_finalize(){
	echo "NYI"
}
function Ryujinx_IsInstalled(){
	$test=Test-Path -Path "$emusPath\Ryujinx"
	if($test){
		echo "true"
	}
}
function Ryujinx_resetConfig(){
	Ryujinx_init
	if($?){
		echo "true"
	}
}