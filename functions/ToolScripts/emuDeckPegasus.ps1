
#variables
$pegasus_toolName="Pegasus Frontend"
$pegasus_path="$env:USERPROFILE\AppData\Local\pegasus-frontend"
$pegasus_dir_file="$pegasus_path\game_dirs.txt"
$pegasus_config_file="$pegasus_path\settings.txt"

function pegasus_cleanup(){
	echo "NYI"
}

#Install
function pegasus_install(){
	setMSG "Installing $pegasus_toolName"
	mkdir $pegasusPath -ErrorAction SilentlyContinue
	$url_pegasus = getLatestReleaseURLGH 'mmatyas/pegasus-frontend' 'zip' 'win'
	download $url_pegasus "Pegasus.7z"
	moveFromTo "$temp/Pegasus/" "$pegasusPath/"
	Remove-Item -Recurse -Force $temp/Pegasus -ErrorAction SilentlyContinue
	createLauncher "pegasus\pegasus-frontend"
}

#ApplyInitialSettings
function pegasus_init(){
	setMSG "Setting up $pegasus_toolName"
	$destination="$pegasus_path/"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\pegasus" "$destination"

	#metadata and cores paths
	copyFromTo "$env:APPDATA\EmuDeck\backend\roms" "$romsPath"

	Get-ChildItem -Path $romsPath -File -Filter "metadata.txt" -Recurse | ForEach-Object {
		(Get-Content $_.FullName) | ForEach-Object {
			$_ -replace "CORESPATH/", "$emusPath\RetroArch\cores\"
		} | Set-Content $_.FullName -Encoding UTF8
	}

	Get-ChildItem -Path $romsPath -File -Filter "metadata.txt" -Recurse | ForEach-Object {
		(Get-Content $_.FullName) | ForEach-Object {
			$_ -replace "/run/media/mmcblk0p1/Emulation/tools/launchers/", "$toolsPath\launchers\"
		} | Set-Content $_.FullName -Encoding UTF8
	}

	sedFile "$pegasus_dir_file" "/run/media/mmcblk0p1/Emulation" "$emulationPath"

}


function pegasus_resetConfig(){
	pegasus_init
	if($?){
		Write-Output "true"
	}
}

function pegasus_update(){
	pegasus_init
	if($?){
		Write-Output "true"
	}
}

function pegasus_addCustomSystems(){
	echo "NYI"
}

function pegasus_applyTheme(){
	echo "NYI"
}

function pegasus_setDefaultEmulators(){
	echo "NYI"
}

function pegasus_setEmu(){
	echo "NYI"
}

function pegasus_IsInstalled(){
	$test=Test-Path -Path "$pegasus_path\pegasus-fe.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}

function pegasus_uninstall(){
	echo "NYI"
}
