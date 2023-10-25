. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1
cls
$upload="Yes"
$download="Yes"

Write-Host "Testing EmuDeck integrity..." -ForegroundColor White

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
Write-Host "Generaring CloudSync Status Report..." -ForegroundColor DarkCyan
Write-Host ""

$subcarpetas = Get-ChildItem $EmusPath -Directory -Recurse
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
$textoABuscaryuzu="yuzu\yuzu-windows-msvc\user"

$duckstationSL="No"
$pcsx2SL="No"
$retroarchSL="No"
$cemuSL="No"
$citraSL="No"
$dolphinSL="No"
$ppssppSL="No"
$ryujinxSL="No"
$yuzuSL="No"


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
		$shorcutsContent = Get-Content -Path $filePath
		if ($shorcutsContent -like "*.bat*"){
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

#### Shorcuts
Write-Host "Is using old Shorcuts (.lnk) for the save folders inside $emusPath?" -ForegroundColor DarkYellow
if ( $lnkFiles -eq "Yes" ){
	$color = "Red"
}else{
	$color = "Green"
}
Write-Host $lnkFiles  -ForegroundColor $color
Write-Host ""
Write-Host "Is using old Shorcuts (.lnk) for the save folders inside $savesPath?" -ForegroundColor DarkYellow
if ( $lnkFilesSaves -eq "Yes" ){
	$color = "Red"
}else{
	$color = "Green"
}
Write-Host $lnkFilesSaves  -ForegroundColor $color
Write-Host ""
Write-Host "Are there proper folders inside $savesPath?" -ForegroundColor DarkYellow
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
Write-Host  "Is using the new symlinks for the save folders inside $emusPath?" -ForegroundColor DarkYellow
if ($duckstationSL -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
if ($pcsx2SL -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
if ($retroarchSL -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
if ($cemuSL -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
if ($citraSL -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
if ($dolphinSL -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
if ($ppssppSL -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
if ($ryujinxSL -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
if ($yuzuSL -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
Write-Host "duckstation: $duckstationSL"  -ForegroundColor $color
Write-Host "pcsx2: $pcsx2SL"  -ForegroundColor $color
Write-Host "retroarch: $retroarchSL"  -ForegroundColor $color
Write-Host "cemu: $cemuSL"  -ForegroundColor $color
Write-Host "citra: $citraSL"  -ForegroundColor $color
Write-Host "dolphin: $dolphinSL"  -ForegroundColor $color
Write-Host "ppsspp: $ppssppSL"  -ForegroundColor $color
Write-Host "ryujinx: $ryujinxSL"  -ForegroundColor $color
Write-Host "yuzu: $yuzuSL"  -ForegroundColor $color
Write-Host ""

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
}
Write-Host "$rcloneConf"  -ForegroundColor $color
Write-Host ""
Write-Host  "Is cloudSync installed?" -ForegroundColor DarkYellow
if (Test-Path "$cloud_sync_bin"){
	Write-Host "$cloudFunc"  -ForegroundColor "Green"
}else{
	Write-Host "$cloudFunc"  -ForegroundColor "Red"
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

if($lnkFiles -eq "Yes"){
	Write-Host "We've cleaned up your old .lnk files but make sure you don't have .lnk files in your cloud provider, delete them if you do" -ForegroundColor Yellow
}
if ($lnkFiles -eq "Yes" -or $lnkFilesSaves -eq "Yes" -or $lnkFilesSaves2 -eq "No" -or $rcloneConf -eq "No" -or $duckstationSL -eq "No" -or $pcsx2SL -eq "No" -or $retroarchSL -eq "No" -or $cemuSL -eq "No" -or $citraSL -eq "No" -or $dolphinSL -eq "No" -or $ppssppSL -eq "No" -or $ryujinxSL -eq "No" -or $yuzuSL -eq "No") {
	Write-Host "Do a Custom Reset" -ForegroundColor Yellow
}elseif($download -eq "No" -or $upload -eq "No" ){
	Write-Host "Reinstall CloudSync" -ForegroundColor Yellow
}elseif($parsersUpdated -eq "No"){
	Write-Host "Open EmuDeck, go to Manage Emulators and reset SteamRomManager Configuration. Then open Steam Rom Managar and parse all your games again to get the proper launchers" -ForegroundColor Yellow
}elseif($cloudFunc -eq "No"){
	Write-Host "Open EmuDeck, check that in the top right you have a yellow triangle that says EARLY" -ForegroundColor Yellow
}else{
	Write-Host "Everything seems to be in proper order, at least on Windows" -ForegroundColor Yellow
}

waitForUser