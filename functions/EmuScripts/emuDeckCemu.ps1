function Cemu_install(){
	setMSG "Downloading Cemu"
	$url_cemu = getLatestReleaseURLGH 'cemu-project/Cemu' 'zip' 'windows-x64'
	download $url_cemu "cemu.zip"
	
	$folderPath = "$temp/cemu"
	$subfolders = Get-ChildItem -Path $folderPath -Directory
	
	foreach ($subfolder in $subfolders) {
		$subfolderName = $subfolder.Name		
		moveFromTo "$temp/cemu/$subfolderName" "$emusPath\cemu"
	}
	
	Remove-Item -Recurse -Force cemu -ErrorAction SilentlyContinue
	createLauncher "cemu"

}
function Cemu_init(){
	setMSG "Cemu - Configuration"
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\cemu" "$emusPath\cemu"
	sedFile "$emusPath\cemu\controllerProfiles\controller0.xml" "DSUController" "XInput"
	#sedFile "$emusPath\cemu\controllerProfiles\Deck-Gamepad-Gyro.xml" "DSUController" "XInput"	
	sedFile "$emusPath\cemu\settings.xml" "C:\Emulation" "$emulationPath"
	
	Cemu_setupSaves
	
	
	
}
function Cemu_update(){
	echo "NYI"
}
function Cemu_setEmulationFolder(){
	echo "NYI"
}
function Cemu_setupSaves(){
	setMSG "Cemu - Saves Links"
	$SourceFilePath = "$emusPath\cemu\mlc01\usr\save\"
	rm -fo  "saves\cemu" -Recurse -ErrorAction SilentlyContinue
	mkdir "saves\Cemu" -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue	
	$ShortcutPath = -join($emulationPath,"\saves\Cemu\saves.lnk")
	createLink $SourceFilePath $ShortcutPath
}

function Cemu_setResolution($resolution){
	echo $resolution
}

function Cemu_setupStorage(){
	echo "NYI"
}
function Cemu_wipe(){
	echo "NYI"
}
function Cemu_uninstall(){
	echo "NYI"
}
function Cemu_migrate(){
	echo "NYI"
}
function Cemu_setABXYstyle(){
	echo "NYI"
}
function Cemu_wideScreenOn(){
	echo "NYI"
}
function Cemu_wideScreenOff(){
	echo "NYI"
}
function Cemu_bezelOn(){
	echo "NYI"
}
function Cemu_bezelOff(){
	echo "NYI"
}
function Cemu_finalize(){
	echo "NYI"
}
function Cemu_IsInstalled(){
	$test=Test-Path -Path "$emusPath\cemu"
	if($test){
		echo "true"
	}
}
function Cemu_resetConfig(){
	Cemu_init
	if($?){
		echo "true"
	}
}