. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1
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
### Can upload?
###
###

$target = $savesPath
	# Calculate the total size of the folder (including subfolders)
$targetSize = Get-ChildItem -Recurse -Path $target | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum
# Convert the size to a string
$targetSizeString = $targetSize.ToString()
# Calculate the SHA256 hash of the size string
$sha256 = New-Object System.Security.Cryptography.SHA256Managed
$hashBytes = [System.Text.Encoding]::UTF8.GetBytes($targetSizeString)
$hash = [BitConverter]::ToString($sha256.ComputeHash($hashBytes)) -replace '-'
# Path to the file where you want to save the hash
$fileHash = "$env:USERPROFILE\emudeck\.test"
# Save the hash to a file
$hash | Out-File -FilePath $fileHash

$upload="No"
& $cloud_sync_bin copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$fileHash" "$cloud_sync_provider`:Emudeck\.test"
if($?){
	$upload="Yes"
}
###
###
### Can download?
###
###

$download="No"
rm -fo "$fileHash" -ErrorAction SilentlyContinue
& $cloud_sync_bin copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$cloud_sync_provider`:Emudeck\.test" "$fileHash"
if($?){
	$download="Yes"
}
rm -fo "$fileHash" -ErrorAction SilentlyContinue
#####
#Report
####

cls
Write-Host "CloudSync Status Report" -ForegroundColor white
Write-Host ""

#### Shorcuts
Write-Host "Has old Shorcuts inside the Emulators?" -ForegroundColor DarkYellow
if ( $lnkFiles -eq "Yes" ){
	$color = "Red"
}else{
	$color = "Green"
}
Write-Host $lnkFiles  -ForegroundColor $color
Write-Host ""
Write-Host "Has old Shorcuts inside Emulation\Saves\?" -ForegroundColor DarkYellow
if ( $lnkFilesSaves -eq "Yes" ){
	$color = "Red"
}else{
	$color = "Green"
}
Write-Host $lnkFilesSaves  -ForegroundColor $color
Write-Host ""
Write-Host "Are there proper folders inside Emulation\Saves\?" -ForegroundColor DarkYellow
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
Write-Host  "Has new Symlinks in place?" -ForegroundColor DarkYellow
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

Write-Host  "Has a cloudSync config file?" -ForegroundColor DarkYellow
if ($rcloneConf -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
Write-Host "$rcloneConf"  -ForegroundColor $color
Write-Host ""
Write-Host  "Are the SRM parsers updated?" -ForegroundColor DarkYellow
if ($parsersUpdated -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
Write-Host "$parsersUpdated"  -ForegroundColor $color
Write-Host ""

Write-Host  "Is uploading working?" -ForegroundColor DarkYellow
if ($upload -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
Write-Host "$upload"  -ForegroundColor $color
Write-Host ""

Write-Host  "Is dowloading working?" -ForegroundColor DarkYellow
if ($download -eq "Yes"){
	$color ="Green"
}else{
	$color = "Red"
}
Write-Host "$download"  -ForegroundColor $color
Write-Host ""


waitForUser