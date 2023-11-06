. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1


cls
$upload="Yes"
$download="Yes"
echo "" > "$userFolder/EmuDeck/logs/rclone.log"
Write-Host "Testing EmuDeck integrity..." -ForegroundColor White

if ( ! $userFolder ){
	cls
	Write-Host "We can't find your installation"  -ForegroundColor Red
	Write-Host "Open an Issue in our discord and upload this file: $env:USERPROFILE\emudeck\settings.ps1"  -ForegroundColor Red
	Read-Host -Prompt "Press any key to continue or CTRL+C to quit"
	exit
}

if ( "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\allCloud.ps1"  -like "NYI*"){
	confirmDialog -TitleText "Corrupted installation" -MessageText "EmuDeck will reinstall after clicking OK, nothing will be deleted. This could take a while"
	cls
	Write-Host "Downloading EmuDeck..." -ForegroundColor Cyan
	$url_emudeck = getLatestReleaseURLGH 'EmuDeck/emudeck-electron-early' 'exe' 'emudeck'
	download $url_emudeck "emudeck_install.exe"
	&"$temp/emudeck_install.exe"
	cls
	Write-Host "Please open CloudSyncHealth again after the reinstallation of EmuDeck has finished" -ForegroundColor Cyan
	break
	exit
}


function cloud_sync_download_test($emuName){
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {

		$target = "$emulationPath\saves\$emuName\"
		if ( Test-Path "$target" ){
			echo "test" > "$target\.temp" -ErrorAction SilentlyContinue
			$fileHash = "$target\.temp"
			Write-Host "Testing $emuName download..."
			& $cloud_sync_bin -q --log-file "$userFolder/EmuDeck/logs/rclone.log" copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$cloud_sync_provider`:Emudeck\saves\$emuName\.temp" "$fileHash"
			if ($?) {
				Write-Host "success" -ForegroundColor Green
			}else{
				Write-Host "failure" -ForegroundColor Red
				$download="No"
			}
			rm -fo "$target\.temp" -ErrorAction SilentlyContinue
		}else{
			Write-Host "$emuName not installed" -ForegroundColor Yellow
		}

	}
}

function cloud_sync_upload_test($emuNAme){
	if ((Test-Path "$cloud_sync_bin") -and ($cloud_sync_status -eq $true)) {

		$target = "$emulationPath\saves\$emuName\"
		if ( Test-Path "$target" ){
			echo "test" > "$target\.temp" -ErrorAction SilentlyContinue
			$fileHash = "$target\.temp"

			Write-Host "Testing $emuName upload..."

			& $cloud_sync_bin -q --log-file "$userFolder/EmuDeck/logs/rclone.log" copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$fileHash" "$cloud_sync_provider`:Emudeck\saves\$emuName\.temp"
			if ($?) {
				Write-Host "success" -ForegroundColor Green
			}else{
				Write-Host "failure" -ForegroundColor Red
				$upload="No"
			}
			rm -fo "$target\.temp" -ErrorAction SilentlyContinue
		}else{
			Write-Host "$emuName not installed" -ForegroundColor Yellow
		}


	}

}

cls
Write-Host "Generating CloudSync Status Report..." -ForegroundColor DarkCyan
Write-Host ""


$subcarpetas = Get-ChildItem "$emusPath" -Directory -Recurse
$resultadosSL = @()
###
###
### Do we have symlinks in the emulators?
###
###
foreach ($subcarpeta in $subcarpetas) {
	$symlinks = Get-ChildItem -Path $subcarpeta.FullName -Attributes ReparsePoint
	if ($symlinks.Count -gt 0) {
		$resultadosSL += $subcarpeta.FullName
	}
}

$textoABuscarduckstation="duckstation"
$textoABuscarPCSX2="PCSX2-Qt"
$textoABuscarRetroArch="RetroArch"
$textoABuscarcemu="cemu\mlc01\usr"
$textoABuscarcitra="citra\user"
$textoABuscarDolphin="Dolphin-x64\User"
$textoABuscarPPSSPP="PPSSPP\memstick\PSP"
$textoABuscarRyujinx="Ryujinx\portable\bis\user"
$textoABuscaryuzu="yuzu\yuzu-windows-msvc\user\nand\user"
$textoABuscaryuzu2="yuzu-windows-msvc\user\nand\system\save\8000000000000010\su"
$duckstationSL="No"
$pcsx2SL="No"
$retroarchSL="No"
$cemuSL="No"
$citraSL="No"
$dolphinSL="No"
$ppssppSL="No"
$ryujinxSL="No"
$yuzuSL="No"

## rpcs3 special case

$subcarpetas = Get-ChildItem "$storagePath/rpcs3" -Directory -Recurse
$rpcs3SL = "No"
foreach ($subcarpeta in $subcarpetas) {
	$symlinks = Get-ChildItem -Path $subcarpeta.FullName -Attributes ReparsePoint
	if ($symlinks.Count -gt 0) {
		$rpcs3SL = "Yes"
	}
}


if ($resultadosSL.Count -gt 0) {
	$resultadosSL | ForEach-Object {

		if ($_  -like "*$textoABuscarduckstation*"){
			$duckstationSL="Yes"
		}
		if ($_  -like "*$textoABuscarPCSX2*"){
			$pcsx2SL="Yes"
		}
		if ($_  -like "*$textoABuscarRetroArch*"){
			$retroarchSL="Yes"
		}
		if ($_  -like "*$textoABuscarcemu*"){
			$cemuSL="Yes"
		}
		if ($_  -like "*$textoABuscarcitra*"){
			$citraSL="Yes"
		}
		if ($_  -like "*$textoABuscarDolphin*"){
			$dolphinSL="Yes"
		}
		if ($_  -like "*$textoABuscarPPSSPP*"){
			$ppssppSL="Yes"
		}
		if ($_  -like "*$textoABuscarRyujinx*"){
			$ryujinxSL="Yes"
		}
		if ($_  -like "*$textoABuscaryuzu*"){
			$yuzuSL="Yes"
		}else{
			$yuzuSL="No"
		}
		if ($_  -like "*$textoABuscaryuzu2*"){
			$yuzuSL="Yes"
		}else{
			$yuzuSL="No"
		}

	}
}
###
###
### Are the folders in Emulations/saves Folders or are lnk same with internal emulators?
###
###
$lnkFiles="No"
foreach ($subcarpeta in $subcarpetas) {
	$archivoslnk = Get-ChildItem -Path $subcarpeta.FullName -Filter *.lnk
	if ($archivoslnk.Count -gt 0) {

		foreach ($archivo in $archivoslnk) {
			Remove-Item $archivo.FullName
		}

		$lnkFiles="Yes"

		break
	}else{
		$lnkFiles="No"
	}
}

$subcarpetasSaves = Get-ChildItem $savesPath -Directory -Recurse
$lnkFilesSaves="No"
foreach ($subcarpeta in $subcarpetasSaves) {
	$archivoslnk = Get-ChildItem -Path $subcarpeta.FullName -Filter *.lnk
	if ($archivoslnk.Count -gt 0) {

		foreach ($archivo in $archivoslnk) {
			Remove-Item $archivo.FullName
		}

		$lnkFilesSaves="Yes"

		break
	}else{
		$lnkFilesSaves="No"
	}
}

$lnkFilesSaves2="No"

$carpetasNoDirectorio = @()

foreach ($subcarpeta in $subcarpetasSaves) {

	if (-not (Test-Path -Path $subcarpeta.FullName -PathType Container)) {

		$carpetasNoDirectorio += $subcarpeta.FullName
	}
}

if ($carpetasNoDirectorio.Count -gt 0) {
	$lnkFilesSaves2="No"
} else {
	$lnkFilesSaves2="Yes"
}



###
###
### Is there a rclone.conf?
###
###
$rcloneConf = "No"
if (Test-Path "$toolsPath\rclone\rclone.conf") {
	$rcloneConf = "Yes"
}

###
###
### Are the parsers updated?
###
###
$steamRegPath = "HKCU:\Software\Valve\Steam"
$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
$steamInstallPath = $steamInstallPath.Replace("/", "\\")

$steamPath = "$steamInstallPath\userdata"
# Busca el archivo shortcuts.vdf en cada carpeta de userdata
$parsersUpdated="Yes"

$archivosLinksVDF = Get-ChildItem -Path $steamPath -File -Recurse -Filter "shortcuts.vdf"

if ($archivosLinksVDF.Count -gt 0) {
	$archivosLinksVDF | ForEach-Object {
		$filePath =  $_.FullName
		$shortcutsContent = Get-Content -Path $filePath
		if ($shortcutsContent -like "*.bat*"){
			$parsersUpdated="No"
		}
	}
}

###
###
### are the functions loaded??
###
###
$cloudFunc="No"
if ( "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\allCloud.ps1" -like "*AppData*"){
	$cloudFunc="Yes"
}

cls
Write-Host "CloudSync Status Report" -ForegroundColor white
Write-Host ""

#### shortcuts


Write-Host "Is EmuDeck using old shortcuts (.lnk) for the save folders inside C:\Users\REDACTED\EmuDeck\EmulationStation-DE\Emulators?" -ForegroundColor DarkYellow
if ( $lnkFiles -eq "Yes" ){
	$color = "Red"
}else{
	$color = "Green"
}
Write-Host $lnkFiles  -ForegroundColor $color
Write-Host ""
Write-Host "Is EmuDeck using old shortcuts (.lnk) for the save folders inside ${savesPath}?" -ForegroundColor DarkYellow
if ( $lnkFilesSaves -eq "Yes" ){
	$color = "Red"
}else{
	$color = "Green"
}
Write-Host $lnkFilesSaves  -ForegroundColor $color
Write-Host ""
Write-Host "Are there proper folders inside ${savesPath}?" -ForegroundColor DarkYellow
if ( $lnkFilesSaves2 -eq "Yes" ){
	$color = "Green"
}else{
	$color = "Red"
}
Write-Host $lnkFilesSaves2  -ForegroundColor $color
if ($carpetasNoDirectorio.Count -gt 0) {
	Write-Host "Wrong folders:"
	$carpetasNoDirectorio | ForEach-Object {
		Write-Host $_
	}
}
Write-Host ""
Write-Host  "Is EmuDeck using the new symlinks for the save folders inside C:\Users\REDACTED\EmuDeck\EmulationStation-DE\Emulators?" -ForegroundColor DarkYellow
$setupSaves=''
if ($duckstationSL -eq "Yes"){
	$color1 ="Green"
}else{
	$color1 = "Red"
	$setupSaves+="DuckStation_setupSaves;"
}
if ($pcsx2SL -eq "Yes"){
	$color2 ="Green"
}else{
	$color2 = "Red"
	$setupSaves+="PCSX2QT_setupSaves;"
}
if ($rpcs3SL -eq "Yes"){
	$color3 ="Green"
}else{
	$color3 = "Red"
	$setupSaves+="RPCS3_setupSaves;"
}
if ($retroarchSL -eq "Yes"){
	$color4 ="Green"
}else{
	$color4 = "Red"
	RetroArch_init
	$setupSaves+="RetroArch_setupSaves;"
}
if ($cemuSL -eq "Yes"){
	$color5 ="Green"
}else{
	$color5 = "Red"
	$setupSaves+="Cemu_setupSaves;"
}
if ($citraSL -eq "Yes"){
	$color6 ="Green"
}else{
	$color6 = "Red"
	$setupSaves+="Citra_setupSaves;"
}
if ($dolphinSL -eq "Yes"){
	$color7 ="Green"
}else{
	$color7 = "Red"
	$setupSaves+="Dolphin_setupSaves;"
}
if ($ppssppSL -eq "Yes"){
	$color8 ="Green"
}else{
	$color8 = "Red"
	$setupSaves+="PPSSPP_setupSaves;"
}
if ($ryujinxSL -eq "Yes"){
	$color9 ="Green"
}else{
	$color9 = "Red"
	$setupSaves+="Ryujinx_setupSaves;"
}
if ($yuzuSL -eq "Yes"){
	$color10 ="Green"
}else{
	$color10 = "Red"
	$setupSaves+="Yuzu_setupSaves;"
}
Write-Host "duckstation: $duckstationSL"  -ForegroundColor $color1
Write-Host "pcsx2: $pcsx2SL"  -ForegroundColor $color2
Write-Host "rpcs3: $rpcs3SL"  -ForegroundColor $color3
Write-Host "retroarch: $retroarchSL"  -ForegroundColor $color4
Write-Host "cemu: $cemuSL"  -ForegroundColor $color5
Write-Host "citra: $citraSL"  -ForegroundColor $color6
Write-Host "dolphin: $dolphinSL"  -ForegroundColor $color7
Write-Host "ppsspp: $ppssppSL"  -ForegroundColor $color8
Write-Host "ryujinx: $ryujinxSL"  -ForegroundColor $color9
Write-Host "yuzu: $yuzuSL"  -ForegroundColor $color10
Write-Host ""
echo $setupSaves;
if( $setupSaves -ne '' ){
	Write-Host  "Trying to fix Symlinks..." -ForegroundColor DarkYellow
	& $setupSaves
	Write-Host ""
}
Write-Host  "Are CloudSync functions installed?" -ForegroundColor DarkYellow
if ($cloudFunc -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
Write-Host "$cloudFunc"  -ForegroundColor $color
Write-Host ""

Write-Host  "Has a cloudSync config file?" -ForegroundColor DarkYellow
if ($rcloneConf -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
	confirmDialog -TitleText "CloudSync not installed" -MessageText "Please Open EmuDeck and install it"
	break
	exit
}
Write-Host "$rcloneConf"  -ForegroundColor $color
Write-Host ""
Write-Host  "Is cloudSync installed?" -ForegroundColor DarkYellow
if (Test-Path "$cloud_sync_bin"){
	Write-Host "$cloudFunc"  -ForegroundColor "Green"
}else{
	Write-Host "$cloudFunc"  -ForegroundColor "Red"
	confirmDialog -TitleText "CloudSync not installed" -MessageText "Please Open EmuDeck and install it"
	break
	exit
}
Write-Host ""

Write-Host  "Are the SRM parsers updated?" -ForegroundColor DarkYellow
if ($parsersUpdated -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
Write-Host "$parsersUpdated"  -ForegroundColor $color
Write-Host ""

$miArreglo = @("yuzu","Cemu","citra","dolphin","duckstation","es-de","melonds","pcsx2","ppsspp","retroarch","rpcs3","ryujinx")

Write-Host  "Testing uploading" -ForegroundColor DarkYellow

foreach ($elemento in $miArreglo) {
	cloud_sync_upload_test $elemento
}

Write-Host ""
Write-Host  "Testing downloading" -ForegroundColor DarkYellow

foreach ($elemento in $miArreglo) {
	cloud_sync_download_test $elemento
}


Write-Host ""
Write-Host ""
Write-Host "Recomendations..." -ForegroundColor DarkCyan

if($lnkFiles -eq "Yes" -or $lnkFiles2 -eq "Yes"){
	Write-Host "We've cleaned up your old .lnk files but make sure you don't have .lnk files in your cloud provider, delete them if you do" -ForegroundColor Yellow
}
if ($lnkFiles -eq "Yes" -or $lnkFilesSaves -eq "Yes" -or $lnkFilesSaves2 -eq "No" -or $rcloneConf -eq "No" -or $duckstationSL -eq "No" -or $pcsx2SL -eq "No" -or $retroarchSL -eq "No" -or $cemuSL -eq "No" -or $citraSL -eq "No" -or $dolphinSL -eq "No" -or $ppssppSL -eq "No" -or $ryujinxSL -eq "No" -or $yuzuSL -eq "No") {
	Write-Host "Do a Custom Reset" -ForegroundColor Yellow
}elseif($download -eq "No" -or $upload -eq "No" ){
	Write-Host "Reinstall CloudSync" -ForegroundColor Yellow
}elseif($parsersUpdated -eq "No"){
	Write-Host "Open EmuDeck, go to Manage Emulators and reset Steam Rom Manager Configuration. Then open Steam Rom Manager and parse all your games again to get the proper launchers" -ForegroundColor Yellow
}elseif($cloudFunc -eq "No"){
	Write-Host "Open EmuDeck, check that in the top right you have a yellow triangle that says EARLY" -ForegroundColor Yellow
}else{
	Write-Host "Everything seems to be in proper order, at least on Windows" -ForegroundColor Yellow
}

waitForUser