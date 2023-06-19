function PCSX2QT_install(){
	#$test=Test-Path -Path "$toolsPath\vc_redist.x86.exe"
	winget install Microsoft.VCRedist.2015+.x86 --accept-package-agreements --accept-source-agreements
	setMSG "Downloading PCSX2"
	$url_pcsx2 = getReleaseURLGH "pcsx2/pcsx2" "7z" "symbols"
	download $url_pcsx2 "pcsx2.7z"
	moveFromTo "$temp\pcsx2" "$emusPath\PCSX2-Qt"
	Remove-Item -Recurse -Force $temp\pcsx2 -ErrorAction SilentlyContinue
	Rename-Item -Path "$emusPath\PCSX2-Qt\pcsx2-qt.exe" -NewName "pcsx2-qtx64.exe"
	createLauncher "pcsx2"
}
function PCSX2QT_init(){	
	setMSG "PCSX2 - Configuration"
	$destination="$emusPath\PCSX2-Qt"
	New-Item "$emusPath\PCSX2-Qt\portable.ini" -ErrorAction SilentlyContinue

	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\PCSX2" $destination
	
	PCSX2QT_setEmulationFolder
	PCSX2QT_setupSaves
	PCSX2QT_setResolution $pcsx2Resolution
}
function PCSX2QT_update(){
	Write-Outpute-Output "NYI"
}
function PCSX2QT_setEmulationFolder(){
	sedFile $destination\inis\PCSX2.ini "C:\Emulation" "$emulationPath"
}
function PCSX2QT_setupSaves(){
	#Saves
	setMSG "PCSX2 - Saves Links"
	Remove-Item -fo "saves\pcsx2" -Recurse -ErrorAction SilentlyContinue
	New-Item -ItemType "directory" -path "saves\pcsx2"

	#memcards
	$SourceFilePath = "$emusPath\PCSX2-Qt\memcards"
	if (Test-Path -Path $SourceFilePath -PathType Leaf) {
		Write-Output "$SourceFilePath Exixsts as file. Deleting."
		Remove-Item -Path $SourceFilePath -Force
	} 
	New-Item -ItemType "directory" -path $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,"\saves\pcsx2\saves.lnk")
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = "$emusPath\PCSX2-Qt\sstates"
	if (Test-Path -Path $SourceFilePath -PathType Leaf) {
		Write-Output "$SourceFilePath Exixsts as file. Deleting."
		Remove-Item -Path $SourceFilePath -Force
	} 
	New-Item -ItemType "directory" -path $SourceFilePath  -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,"\saves\pcsx2\states.lnk")
	createLink $SourceFilePath $ShortcutPath
}
function PCSX2QT_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 2 }
		"1080P" { $multiplier = 3    }
		"1440P" { $multiplier = 4   }
		"4K" { $multiplier = 6 }
	}
	
	setConfig "upscale_multiplier" $multiplier "$emusPath\PCSX2-Qt\inis\PCSX2.ini"
}
function PCSX2QT_setupStorage(){
	Write-Output "NYI"
}
function PCSX2QT_wipe(){
	Write-Output "NYI"
}
function PCSX2QT_uninstall(){
	Write-Output "NYI"
}
function PCSX2QT_migrate(){
	Write-Output "NYI"
}
function PCSX2QT_setABXYstyle(){
	Write-Output "NYI"
}
function PCSX2QT_wideScreenOn(){
	Write-Output "NYI"
}
function PCSX2QT_wideScreenOff(){
	Write-Output "NYI"
}
function PCSX2QT_bezelOn(){
	Write-Output "NYI"
}
function PCSX2QT_bezelOff(){
	Write-Output "NYI"
}
function PCSX2QT_finalize(){
	Write-Output "NYI"
}
function PCSX2QT_IsInstalled(){
	if(Test-Path -Path "$emusPath\PCSX2-Qt\pcsx2-qtx64.exe"){
		Write-Output "true"
	}
}
function PCSX2QT_resetConfig(){
	PCSX2QT_init
	if($?){
		Write-Output "true"
	}
}


function PCSX2QT_retroAchievementsSetLogin(){	
	$rat=Get-Content $env:USERPROFILE/AppData/Roaming/EmuDeck/.rat -Raw
	#setConfig "Token" $rat "$emusPath\PCSX2-Qt\inis\PCSX2.ini"		
}
