
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
	download $url_pegasus "Pegasus.zip"
	moveFromTo "$temp/Pegasus/" "$pegasusPath/"
	Remove-Item -Recurse -Force $temp/Pegasus -ErrorAction SilentlyContinue
	pegasus_init
}

function pegasus_setPaths(){
	#metadata and cores paths
	copyFromTo "$env:APPDATA\EmuDeck\backend\roms" "$romsPath"

	Get-ChildItem -Path $romsPath -File -Filter "metadata.txt" -Recurse | ForEach-Object {
		sedFile $_.FullName "/run/media/mmcblk0p1/Emulation" "$emulationPath"
	}

	Get-ChildItem -Path $romsPath -File -Filter "metadata.txt" -Recurse | ForEach-Object {
		sedFile $_.FullName "CORESPATH/" "$emusPath\RetroArch\cores\"
	}

	Get-ChildItem -Path $romsPath -File -Filter "metadata.txt" -Recurse | ForEach-Object {
		sedFile $_.FullName '\' '/'
	}

	sedFile "$pegasus_dir_file" "/run/media/mmcblk0p1/Emulation" "$emulationPath"

}

#ApplyInitialSettings
function pegasus_init(){
	setMSG "Setting up $pegasus_toolName"
	$destination="$pegasus_path/"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:APPDATA\EmuDeck\backend\configs\pegasus" "$destination"

	createLauncher "pegasus/pegasus-frontend"

	pegasus_setPaths

	Get-ChildItem -Path $romsPath | ForEach-Object {
		$systemPath = $_.FullName
		Remove-Item -Path "$systemPath\media" -Recurse -Force -ErrorAction SilentlyContinue
	}

	Get-ChildItem -Path $romsPath | ForEach-Object {
		$systemPath = $_.FullName
		$system = ($systemPath -split '\\')[-1]
		$coversPath = Join-Path $storagePath "downloaded_media\$system\covers"
		$box2dfrontPath = Join-Path $storagePath "downloaded_media\$system\box2dfront"
		$marqueesPath = Join-Path $storagePath "downloaded_media\$system\marquees"
		$wheelPath = Join-Path $storagePath "downloaded_media\$system\wheel"

		mkdir $coversPath -ErrorAction SilentlyContinue
		mkdir $box2dfrontPath -ErrorAction SilentlyContinue
		mkdir $marqueesPath -ErrorAction SilentlyContinue
		mkdir $wheelPath -ErrorAction SilentlyContinue
	}

	Get-ChildItem -Path $romsPath | ForEach-Object {
		$systemPath = $_.FullName
		$system = ($systemPath -split '\\')[-1]
		$targetPath = Join-Path $storagePath "downloaded_media\$system"

		createSaveLink "$systemPath\media" $targetPath
		createSaveLink "$storagePath\downloaded_media\$system\covers"  "$storagePath\downloaded_media\$system\box2dfront"
		createSaveLink "$storagePath\downloaded_media\$system\marquees"  "$storagePath\downloaded_media\$system\wheel"
	}

	pegasus_applyTheme $pegasusThemeUrl

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

function pegasus_applyTheme($pegasusThemeUrl){
	$themeFolderTemp = $pegasusThemeUrl -split '/' | Select-Object -Last 1
	$themeFolder = $themeFolderTemp -replace "\.git$"
	mkdir "$pegasus_path\themes" -ErrorAction SilentlyContinue
	cd "$pegasus_path\themes"
	git clone $pegasusThemeUrl ".\$themeFolder"
	if($?){
		cd "$pegasus_path\themes\$themeFolder"
		git pull
	}
	changeLine "general.theme:" "general.theme: themes/$themeFolder" "$pegasus_config_file"

}

function pegasus_setDefaultEmulators(){
	echo "NYI"
}

function pegasus_setEmu(){
	echo "NYI"
}

function pegasus_IsInstalled(){
	$test=Test-Path -Path "$env:USERPROFILE\EmuDeck\Pegasus\pegasus-fe.exe"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}

function pegasus_uninstall(){
	rm -r -fo $pegasus_path -ErrorAction SilentlyContinue
	rm -r -fo "$env:USERPROFILE\EmuDeck\Pegasus" -ErrorAction SilentlyContinue
	if($?){
		Write-Output "true"
	}
}
