$ZSNES_configPath = "$env:USERPROFILE\AppData\LocalLow\ZEMU Software Inc_\SUPERZSNES"
$ZSNES_configFile = "$ZSNES_configPath\szsnes_ui.data"

function ZSNES_install(){

    setMSG "Downloading SUPER ZSNES"

    $page = Invoke-WebRequest "https://www.zsnes.com/" -UseBasicParsing
    $link = $page.Links | Where-Object { $_.href -like "files/SuperZSNES*.zip" } | Select-Object -First 1
    $url_zsnes = "https://www.zsnes.com/$($link.href)"

    download $url_zsnes "zsnes.zip"
    moveFromTo "$temp/zsnes" "$emusPath/zsnes"
    createLauncher "zsnes"
}

function ZSNES_setPath([byte[]]$data, [string]$marker, [string]$path){

    # Buscar el marcador sin alterar los bytes del archivo.
    $text = [System.Text.Encoding]::GetEncoding(28591).GetString($data)
    $position = $text.IndexOf($marker, [System.StringComparison]::Ordinal)

    if ($position -lt 1){
        throw "ZSNES: no se encuentra $marker en la plantilla"
    }

    $stream = [System.IO.MemoryStream]::new()
    $writer = [System.IO.BinaryWriter]::new($stream)

    # Copiar hasta justo antes de la longitud del marcador.
    $writer.Write($data, 0, $position - 1)

    # Escribir la nueva ruta y su longitud automáticamente.
    $writer.Write($path)

    # Copiar lo que queda después del marcador.
    $end = $position + $marker.Length
    $writer.Write($data, $end, $data.Length - $end)

    $result = $stream.ToArray()
    $writer.Dispose()

    return ,$result
}

function ZSNES_init(){

    setMSG "ZSNES - Configuration"

    mkdir $ZSNES_configPath -ErrorAction SilentlyContinue

    copyFromTo "$env:APPDATA\EmuDeck\backend\configs\zsnes" "$ZSNES_configPath"

    ZSNES_setupSaves
}

function ZSNES_setupSaves(){

    setMSG "ZSNES - Saves"

    mkdir "$savesPath\zsnes\saves" -ErrorAction SilentlyContinue
    mkdir "$savesPath\zsnes\states" -ErrorAction SilentlyContinue

    $data = [System.IO.File]::ReadAllBytes($ZSNES_configFile)

    # Solo sustituir los marcadores que todavía estén presentes.
    $text = [System.Text.Encoding]::GetEncoding(28591).GetString($data)

    if ($text.Contains("%SAVES_PATH%")){
        $data = ZSNES_setPath $data "%SAVES_PATH%" "$savesPath/zsnes/saves".Replace('\', '/')
    }

    if ($text.Contains("%STATES_PATH%")){
        $data = ZSNES_setPath $data "%STATES_PATH%" "$savesPath/zsnes/states".Replace('\', '/')
    }

    [System.IO.File]::WriteAllBytes($ZSNES_configFile, $data)
}

function ZSNES_update(){
    Write-Output "NYI"
}

function ZSNES_IsInstalled(){
    $test = Test-Path -Path "$emusPath\zsnes\SUPERZSNES.exe"
    if($test){
        Write-Output "true"
    }else{
        Write-Output "false"
    }
}

function ZSNES_uninstall(){
    rm -fo -r "$emusPath\zsnes"
    if($?){
        Write-Output "true"
    }
}

function ZSNES_resetConfig(){
    ZSNES_init
    if($?){
        Write-Output "true"
    }
}

function ZSNES_addToSteam(){
    setMSG "Adding SUPER ZSNES to Steam"
    add_to_steam 'zsnes' 'SUPER ZSNES' "$toolsPath\launchers\zsnes.ps1" "$emusPath\zsnes" "$emudeckFolder\backend\tools\launchers\icons\zsnes.ico" "Emulation"
}