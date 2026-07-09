$Ryujinx_configFile="$emusPath\Ryujinx\portable\Config.json"

function Ryujinx_install() {
    setMSG "Downloading Ryujinx"

    $apiUrl  = "https://git.ryujinx.app/api/v1/repos/Ryubing/Canary/releases/latest"
    $headers = @{ "User-Agent" = "EmuDeck" }
    $release = Invoke-RestMethod -Uri $apiUrl -Headers $headers
	$url_Ryujinx = $release.assets |
        Where-Object { $_.browser_download_url -match "win_x64" -and $_.browser_download_url -like "*.zip" } |
        Select-Object -ExpandProperty browser_download_url -First 1

    if (-not $url_Ryujinx) {
        setMSG "Ryujinx: no Windows ZIP file was found in the latest release."
        return $false
    }

    download $url_Ryujinx "ryujinx.zip"
    moveFromTo "$temp\ryujinx\publish\" "$emusPath\Ryujinx"
    createLauncher "Ryujinx"
}


function Ryujinx_init(){
	setMSG "Ryujinx - Configuration"
	$destination="$emusPath\Ryujinx"
	mkdir "$destination\portable" -ErrorAction SilentlyContinue
	Copy-Item -Path "$env:APPDATA\EmuDeck\backend\configs\Ryujinx\Config.json" -Destination "$destination\portable\Config.json" -Force
	Ryujinx_setEmulationFolder
	Ryujinx_setupSaves
	Ryujinx_setResolution $yuzuResolution


	sedFile "$destination\portable\Config.json" "C:\\Emulation" "$emulationPath"
	sedFile "$destination\portable\Config.json" ":\Emulation" ":\\Emulation"

}

function Ryujinx_update(){
	Write-Output "NYI"
}
function Ryujinx_setEmulationFolder(){
	$destination="$emusPath\Ryujinx"
	sedFile $destination\portable\Config.json "/run/media/mmcblk0p1/Emulation/roms/switch" "$romsPath/switch"
}
function Ryujinx_setupSaves(){

	setMSG "Ryujinx - Creating Keys  Links"
	#Firmware
	mkdir "$emusPath\Ryujinx\portable" -ErrorAction SilentlyContinue
	mkdir "$biosPath\ryujinx" -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\Ryujinx\portable\system"
	$emuSavePath = "$emulationPath\bios\ryujinx\keys"
	createSaveLink $simLinkPath $emuSavePath

	setMSG "Ryujinx - Saves Links"
	mkdir "$emusPath\Ryujinx\portable\bis\user" -ErrorAction SilentlyContinue
	$simLinkPath = "$emusPath\Ryujinx\portable\bis\user\save"
	$emuSavePath = "$emulationPath\saves\ryujinx\saves"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\Ryujinx\portable\bis\system\save"
	$emuSavePath = "$emulationPath\saves\ryujinx\system_saves"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\Ryujinx\portable\bis\user\saveMeta"
	$emuSavePath = "$emulationPath\saves\ryujinx\saveMeta"
	createSaveLink $simLinkPath $emuSavePath

	$simLinkPath = "$emusPath\Ryujinx\portable\system"
	$emuSavePath = "$emulationPath\saves\ryujinx\system"
	createSaveLink $simLinkPath $emuSavePath

	#cloud_sync_save_hash "$savesPath\ryujinx"

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
	Write-Output "NYI"
}
function Ryujinx_wipe(){
	Write-Output "NYI"
}
function Ryujinx_uninstall(){
	Remove-Item -path "$emusPath\Ryujinx" -recurse -force
	if($?){
		Write-Output "true"
	}
}
function Ryujinx_migrate(){
	Write-Output "NYI"
}
function Ryujinx_setABXYstyle(){
	Write-Output "NYI"
}
function Ryujinx_wideScreenOn(){
	Write-Output "NYI"
}
function Ryujinx_wideScreenOff(){
	Write-Output "NYI"
}
function Ryujinx_bezelOn(){
	Write-Output "NYI"
}
function Ryujinx_bezelOff(){
	Write-Output "NYI"
}
function Ryujinx_finalize(){
	Write-Output "NYI"
}
function Ryujinx_IsInstalled(){
	$test=Test-Path -Path "$emusPath\Ryujinx"
	if($test){
		Write-Output "true"
	}else{
		Write-Output "false"
	}
}
function Ryujinx_resetConfig(){
	Ryujinx_init
	if($?){
		Write-Output "true"
	}
}


$script:Ryujinx_sdlBindingReady = $false

function Ryujinx_ensureSdlBinding(){
	if($script:Ryujinx_sdlBindingReady){ return $true }

	$dll = "$emusPath\Ryujinx\SDL3.dll"
	if(-not (Test-Path $dll)){
		Write-Host "Ryujinx: SDL3.dll not found at $dll"
		return $false
	}

	if(-not ("EmuDeckSDL" -as [type])){
		$source = @"
using System;
using System.Runtime.InteropServices;

public static class EmuDeckSDL
{
    [StructLayout(LayoutKind.Sequential)]
    public struct SDL_GUID
    {
        public byte b0;  public byte b1;  public byte b2;  public byte b3;
        public byte b4;  public byte b5;  public byte b6;  public byte b7;
        public byte b8;  public byte b9;  public byte b10; public byte b11;
        public byte b12; public byte b13; public byte b14; public byte b15;
    }

    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern IntPtr LoadLibraryExW(string lpFileName, IntPtr hFile, uint dwFlags);


    public static IntPtr TryLoadLibrary(string path, uint flags, out int err)
    {
        IntPtr h = LoadLibraryExW(path, IntPtr.Zero, flags);
        err = Marshal.GetLastWin32Error();
        return h;
    }

    [DllImport("SDL3.dll", CallingConvention = CallingConvention.Cdecl)]
    [return: MarshalAs(UnmanagedType.I1)]
    public static extern bool SDL_Init(uint flags);

    [DllImport("SDL3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern void SDL_Quit();

    [DllImport("SDL3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr SDL_GetGamepads(out int count);

    [DllImport("SDL3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern SDL_GUID SDL_GetJoystickGUIDForID(uint instance_id);

    [DllImport("SDL3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr SDL_GetJoystickNameForID(uint instance_id);
}
"@
		try {
			Add-Type -TypeDefinition $source -ErrorAction Stop
		} catch {
			Write-Host "Ryujinx: could not compile the SDL binding: $_"
			return $false
		}
	}

	
	$LOAD_WITH_ALTERED_SEARCH_PATH = 0x00000008
	$err = 0
	if([EmuDeckSDL]::TryLoadLibrary($dll, $LOAD_WITH_ALTERED_SEARCH_PATH, [ref]$err) -eq [IntPtr]::Zero){
		if($err -eq 193){			
			Write-Host "Ryujinx: $dll does not match this process architecture, skipping gamepad detection"
		} else {
			# 126 = a dependency is missing, 5 = access denied
			Write-Host "Ryujinx: failed to load $dll (win32 error $err)"
		}
		return $false
	}

	$script:Ryujinx_sdlBindingReady = $true
	return $true
}

function Ryujinx_ptrToUtf8($ptr){
	if($ptr -eq [IntPtr]::Zero){ return $null }
	$len = 0
	while([System.Runtime.InteropServices.Marshal]::ReadByte($ptr, $len) -ne 0){ $len++ }
	if($len -eq 0){ return "" }
	$bytes = New-Object byte[] $len
	[System.Runtime.InteropServices.Marshal]::Copy($ptr, $bytes, 0, $len)
	return [System.Text.Encoding]::UTF8.GetString($bytes)
}

function Ryujinx_formatGamepadId([byte[]]$b){
	$tail = ($b[10..15] | ForEach-Object { '{0:x2}' -f $_ }) -join ''
	$guid = '0000{0:x2}{1:x2}-{2:x2}{3:x2}-{4:x2}{5:x2}-{6:x2}{7:x2}-{8}' -f `
		$b[1], $b[0], $b[5], $b[4], $b[6], $b[7], $b[8], $b[9], $tail
	return "0-$guid"
}

function Ryujinx_getFirstGamepad(){
	if(-not (Ryujinx_ensureSdlBinding)){ return $null }

	$SDL_INIT_GAMEPAD = 0x00002000
	if(-not [EmuDeckSDL]::SDL_Init($SDL_INIT_GAMEPAD)){
		Write-Host "Ryujinx: SDL_Init failed"
		return $null
	}

	try {
		$count = 0
		$idsPtr = [EmuDeckSDL]::SDL_GetGamepads([ref]$count)
		if($idsPtr -eq [IntPtr]::Zero -or $count -lt 1){ return $null }

		$jid = [uint32][System.Runtime.InteropServices.Marshal]::ReadInt32($idsPtr, 0)

		$guid = [EmuDeckSDL]::SDL_GetJoystickGUIDForID($jid)
		$bytes = [byte[]]@(
			$guid.b0,  $guid.b1,  $guid.b2,  $guid.b3,
			$guid.b4,  $guid.b5,  $guid.b6,  $guid.b7,
			$guid.b8,  $guid.b9,  $guid.b10, $guid.b11,
			$guid.b12, $guid.b13, $guid.b14, $guid.b15
		)

		$name = Ryujinx_ptrToUtf8 ([EmuDeckSDL]::SDL_GetJoystickNameForID($jid))
		if([string]::IsNullOrEmpty($name)){ $name = "Unknown Controller" }

		return @{ Id = (Ryujinx_formatGamepadId $bytes); Name = $name }
	}
	finally {
		[EmuDeckSDL]::SDL_Quit()
	}
}

function Ryujinx_setGamepadName($configFile){
	if([string]::IsNullOrEmpty($configFile)){ $configFile = $Ryujinx_configFile }

	if(-not (Test-Path $configFile)){
		Write-Host "Ryujinx: $configFile not found"
		return $false
	}

	$pad = Ryujinx_getFirstGamepad
	if(-not $pad){
		Write-Host "No controller detected, keeping existing Ryujinx input config"
		return $false
	}
	Write-Host "Detected gamepad: $($pad.Name) -> $($pad.Id)"

	$json = Get-Content -Raw -Path $configFile | ConvertFrom-Json

	$entries = @($json.input_config)
	$idx = -1
	for($i = 0; $i -lt $entries.Count; $i++){
		if("$($entries[$i].backend)".StartsWith("Gamepad")){ $idx = $i; break }
	}
	if($idx -lt 0){
		Write-Host "Ryujinx: no gamepad entry in input_config, nothing to update"
		return $false
	}

	$json.input_config[$idx].id = $pad.Id
	$json.input_config[$idx].name = "$($pad.Name) (0)"

	$out = $json | ConvertTo-Json -Depth 100
	[System.IO.File]::WriteAllText($configFile, $out, (New-Object System.Text.UTF8Encoding($false)))

	return $true
}

function Ryujinx_launch_fixes(){
	Ryujinx_setGamepadName | Out-Null
}

function Ryujinx_configIsSDL2($configFile){
	if([string]::IsNullOrEmpty($configFile)){ $configFile = $Ryujinx_configFile }
	if(-not (Test-Path $configFile)){ return $false }

	try {
		$cfg = Get-Content -Raw -Path $configFile | ConvertFrom-Json
	} catch {
		# A broken config is not a reason to reinstall the emulator behind the user's back
		Write-Host "Ryujinx: could not parse $configFile, skipping the SDL3 migration"
		return $false
	}

	foreach($entry in @($cfg.input_config)){
		if("$($entry.backend)".StartsWith("GamepadSDL2")){ return $true }
	}
	return $false
}

function Ryujinx_migrateToSDL3(){
	if((Ryujinx_IsInstalled) -ne "true"){ return $false }
	if(-not (Ryujinx_configIsSDL2)){ return $false }

	confirmDialog -TitleText "Ryujinx SDL3 Migration" -MessageText "Ryujinx will update itself now to fix controller detection issues"

	$installOutput = Ryujinx_install
	if(@($installOutput) -contains $false){
		Write-Host "Ryujinx: update failed, leaving the existing config untouched"
		return $false
	}
	Ryujinx_init | Out-Null
	return $true
}
