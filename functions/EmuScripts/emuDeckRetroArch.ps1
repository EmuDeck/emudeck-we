function RetroArch_install(){
	showNotification -ToastTitle 'Downloading RetroArch'
	download $url_ra "ra.7z"
	moveFromTo "ra\RetroArch-Win64" "tools\EmulationStation-DE\Emulators\RetroArch"	
	Remove-Item -Recurse -Force ra -ErrorAction SilentlyContinue
	createLauncher "RetroArch" "retroarch"
	
	showNotification -ToastTitle 'Downloading RetroArch Cores'
	mkdir $emulationPath"tools\EmulationStation-DE\Emulators\RetroArch\cores" -ErrorAction SilentlyContinue
	$RAcores = @('a5200_libretro.dll','81_libretro.dll','atari800_libretro.dll','bluemsx_libretro.dll','chailove_libretro.dll','fbneo_libretro.dll','freechaf_libretro.dll','freeintv_libretro.dll','fuse_libretro.dll','gearsystem_libretro.dll','gw_libretro.dll','hatari_libretro.dll','lutro_libretro.dll','mednafen_pcfx_libretro.dll','mednafen_vb_libretro.dll','mednafen_wswan_libretro.dll','mu_libretro.dll','neocd_libretro.dll','nestopia_libretro.dll','nxengine_libretro.dll','o2em_libretro.dll','picodrive_libretro.dll','pokemini_libretro.dll','prboom_libretro.dll','prosystem_libretro.dll','px68k_libretro.dll','quasi88_libretro.dll','scummvm_libretro.dll','squirreljme_libretro.dll','theodore_libretro.dll','uzem_libretro.dll','vecx_libretro.dll','vice_xvic_libretro.dll','virtualjaguar_libretro.dll','x1_libretro.dll','mednafen_lynx_libretro.dll','mednafen_ngp_libretro.dll','mednafen_pce_libretro.dll','mednafen_pce_fast_libretro.dll','mednafen_psx_libretro.dll','mednafen_psx_hw_libretro.dll','mednafen_saturn_libretro.dll','mednafen_supafaust_libretro.dll','mednafen_supergrafx_libretro.dll','blastem_libretro.dll','bluemsx_libretro.dll','bsnes_libretro.dll','bsnes_mercury_accuracy_libretro.dll','cap32_libretro.dll','citra2018_libretro.dll','citra_libretro.dll','crocods_libretro.dll','desmume2015_libretro.dll','desmume_libretro.dll','dolphin_libretro.dll','dosbox_core_libretro.dll','dosbox_pure_libretro.dll','dosbox_svn_libretro.dll','fbalpha2012_cps1_libretro.dll','fbalpha2012_cps2_libretro.dll','fbalpha2012_cps3_libretro.dll','fbalpha2012_libretro.dll','fbalpha2012_neogeo_libretro.dll','fceumm_libretro.dll','fbneo_libretro.dll','flycast_libretro.dll','fmsx_libretro.dll','frodo_libretro.dll','gambatte_libretro.dll','gearboy_libretro.dll','gearsystem_libretro.dll','genesis_plus_gx_libretro.dll','genesis_plus_gx_wide_libretro.dll','gpsp_libretro.dll','handy_libretro.dll','kronos_libretro.dll','mame2000_libretro.dll','mame2003_plus_libretro.dll','mame2010_libretro.dll','mame_libretro.dll','melonds_libretro.dll','mesen_libretro.dll','mesen-s_libretro.dll','mgba_libretro.dll','mupen64plus_next_libretro.dll','nekop2_libretro.dll','np2kai_libretro.dll','nestopia_libretro.dll','parallel_n64_libretro.dll','pcsx2_libretro.dll','pcsx_rearmed_libretro.dll','picodrive_libretro.dll','ppsspp_libretro.dll','puae_libretro.dll','quicknes_libretro.dll','race_libretro.dll','sameboy_libretro.dll','smsplus_libretro.dll','snes9x2010_libretro.dll','snes9x_libretro.dll','stella2014_libretro.dll','stella_libretro.dll','tgbdual_libretro.dll','vbam_libretro.dll','vba_next_libretro.dll','vice_x128_libretro.dll','vice_x64_libretro.dll','vice_x64sc_libretro.dll','vice_xscpu64_libretro.dll','yabasanshiro_libretro.dll','yabause_libretro.dll','bsnes_hd_beta_libretro.dll','swanstation_libretro.dll')
	$RAcores.count
	
	foreach ( $core in $RAcores )
	{
		$url= -join('http://buildbot.libretro.com/nightly/windows/x86_64/latest/',$core,'.zip')
		$dest= -join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\cores\',$core)
		echo "Downloading $url"	
		downloadCore $url $dest
	}
}
function RetroArch_init(){

	#We just convert the SteamOS settings with our windows paths
	Remove-Item $raConfigfile  -ErrorAction SilentlyContinue
	
	showNotification -ToastTitle 'RetroArch - Bezels & Filters'
	copyFromTo "$env:USERPROFILE\EmuDeck\backend\configs\RetroArch" "tools\EmulationStation-DE\Emulators\RetroArch"
	$path=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\config')
	Get-ChildItem $path -Recurse -Filter *.cfg | 
	Foreach-Object {
		$originFile = $_.FullName
	
		$origin="~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus"
		$target=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus')
		
		sedFile $originFile $origin $target
		
		#Video Filters path
		$origin="/app/lib/retroarch/filters/video"
		$target=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\filters\video')
		
		sedFile $originFile $origin $target
	}
	
	showNotification -ToastTitle 'RetroArch - Shaders'
	$path=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\config')
	Get-ChildItem $path -Recurse -Filter *.glslp | 
	Foreach-Object {
		$originFile = $_.FullName
	
		$origin="/app/share/libretro/shaders/"
		$target=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\shaders\')
		sedFile $originFile $origin $target
	}
	$path=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\config')
	Get-ChildItem $path -Recurse -Filter *.slangp | 
	Foreach-Object {
		$originFile = $_.FullName
	
		$origin="/app/share/libretro/shaders/"
		$target=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\shaders\')
		sedFile $originFile $origin $target
	}
	
	
	showNotification -ToastTitle 'RetroArch - Bios & Saves'
	
	RetroArch_setupSaves
	
	#Bios
	$line="`rsystem_directory = `"$biosPath`""
	$line | Add-Content $raConfigfile
}
function RetroArch_update(){
	echo "NYI"
}
function RetroArch_setEmulationFolder(){
	echo "NYI"
}
function RetroArch_setupSaves(){
	#Saves
	mkdir saves/retroarch -ErrorAction SilentlyContinue
	$SourceFilePath = -join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\saves\')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,'saves\retroarch\saves.lnk')
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = -join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\states\')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,'saves\retroarch\states.lnk')
	createLink $SourceFilePath $ShortcutPath
}

function RetroArch_bezelOnAll(){
	$path=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\config')
	Get-ChildItem $path -Recurse -Filter *.cfg | 
	Foreach-Object {
		$originFile = $_.FullName		 
		$origin="~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus"
		$target=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus')		
		setConfig 'input_overlay_enable' "true" $originFile		
	}	
}

function RetroArch_bezelOffAll(){
	$path=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\config')
Get-ChildItem $path -Recurse -Filter *.cfg | 
Foreach-Object {
	$originFile = $_.FullName		 
	$origin="~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus"
	$target=-join($emulationPath,'tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus')		
	setConfig 'input_overlay_enable' "false" $originFile		
}	
}

function RetroArch_setupStorage(){
	echo "NYI"
}

function RetroArch_setupStorage(){
	echo "NYI"
}
function RetroArch_wipe(){
	echo "NYI"
}
function RetroArch_uninstall(){
	echo "NYI"
}
function RetroArch_migrate(){
	echo "NYI"
}
function RetroArch_setABXYstyle(){
	echo "NYI"
}
function RetroArch_wideScreenOn(){
	echo "NYI"
}
function RetroArch_wideScreenOff(){
	echo "NYI"
}
function RetroArch_bezelOn(){
	echo "NYI"
}
function RetroArch_bezelOff(){
	echo "NYI"
}
function RetroArch_finalize(){
	echo "NYI"
}
function RetroArch_IsInstalled(){
	echo "NYI"
}
function RetroArch_resetConfig(){
	echo "NYI"
}