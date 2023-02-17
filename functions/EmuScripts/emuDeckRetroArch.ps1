function RetroArch_install(){
	setMSG 'Downloading RetroArch'
	download $url_ra "ra.7z"
	moveFromTo "temp/ra/RetroArch-Win64" "tools\EmulationStation-DE\Emulators\RetroArch"	
	Remove-Item -Recurse -Force ra -ErrorAction SilentlyContinue
	createLauncher "RetroArch" "retroarch"
	
	setMSG 'Downloading RetroArch Cores'
	mkdir tools\EmulationStation-DE\Emulators\RetroArch\cores -ErrorAction SilentlyContinue
	$RAcores = @('a5200_libretro.dll','81_libretro.dll','atari800_libretro.dll','bluemsx_libretro.dll','chailove_libretro.dll','fbneo_libretro.dll','freechaf_libretro.dll','freeintv_libretro.dll','fuse_libretro.dll','gearsystem_libretro.dll','gw_libretro.dll','hatari_libretro.dll','lutro_libretro.dll','mednafen_pcfx_libretro.dll','mednafen_vb_libretro.dll','mednafen_wswan_libretro.dll','mu_libretro.dll','neocd_libretro.dll','nestopia_libretro.dll','nxengine_libretro.dll','o2em_libretro.dll','picodrive_libretro.dll','pokemini_libretro.dll','prboom_libretro.dll','prosystem_libretro.dll','px68k_libretro.dll','quasi88_libretro.dll','scummvm_libretro.dll','squirreljme_libretro.dll','theodore_libretro.dll','uzem_libretro.dll','vecx_libretro.dll','vice_xvic_libretro.dll','virtualjaguar_libretro.dll','x1_libretro.dll','mednafen_lynx_libretro.dll','mednafen_ngp_libretro.dll','mednafen_pce_libretro.dll','mednafen_pce_fast_libretro.dll','mednafen_psx_libretro.dll','mednafen_psx_hw_libretro.dll','mednafen_saturn_libretro.dll','mednafen_supafaust_libretro.dll','mednafen_supergrafx_libretro.dll','blastem_libretro.dll','bluemsx_libretro.dll','bsnes_libretro.dll','bsnes_mercury_accuracy_libretro.dll','cap32_libretro.dll','citra2018_libretro.dll','citra_libretro.dll','crocods_libretro.dll','desmume2015_libretro.dll','desmume_libretro.dll','dolphin_libretro.dll','dosbox_core_libretro.dll','dosbox_pure_libretro.dll','dosbox_svn_libretro.dll','fbalpha2012_cps1_libretro.dll','fbalpha2012_cps2_libretro.dll','fbalpha2012_cps3_libretro.dll','fbalpha2012_libretro.dll','fbalpha2012_neogeo_libretro.dll','fceumm_libretro.dll','fbneo_libretro.dll','flycast_libretro.dll','fmsx_libretro.dll','frodo_libretro.dll','gambatte_libretro.dll','gearboy_libretro.dll','gearsystem_libretro.dll','genesis_plus_gx_libretro.dll','genesis_plus_gx_wide_libretro.dll','gpsp_libretro.dll','handy_libretro.dll','kronos_libretro.dll','mame2000_libretro.dll','mame2003_plus_libretro.dll','mame2010_libretro.dll','mame_libretro.dll','melonds_libretro.dll','mesen_libretro.dll','mesen-s_libretro.dll','mgba_libretro.dll','mupen64plus_next_libretro.dll','nekop2_libretro.dll','np2kai_libretro.dll','nestopia_libretro.dll','parallel_n64_libretro.dll','pcsx2_libretro.dll','pcsx_rearmed_libretro.dll','picodrive_libretro.dll','ppsspp_libretro.dll','puae_libretro.dll','quicknes_libretro.dll','race_libretro.dll','sameboy_libretro.dll','smsplus_libretro.dll','snes9x2010_libretro.dll','snes9x_libretro.dll','stella2014_libretro.dll','stella_libretro.dll','tgbdual_libretro.dll','vbam_libretro.dll','vba_next_libretro.dll','vice_x128_libretro.dll','vice_x64_libretro.dll','vice_x64sc_libretro.dll','vice_xscpu64_libretro.dll','yabasanshiro_libretro.dll','yabause_libretro.dll','bsnes_hd_beta_libretro.dll','swanstation_libretro.dll')
	$RAcores.count
	
	foreach ( $core in $RAcores )
	{
		$url= -join('http://buildbot.libretro.com/nightly/windows/x86_64/latest/',$core,'.zip')	
		echo "Downloading $url"	
		downloadCore $url $core
	}
}
function RetroArch_init(){

	#We just convert the SteamOS settings with our windows paths
	Remove-Item $RetroArch_configFile  -ErrorAction SilentlyContinue
	
	setMSG 'RetroArch - Bezels & Filters'
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\RetroArch" "tools\EmulationStation-DE\Emulators\RetroArch"
	$path=-join($emulationPath,'\tools\EmulationStation-DE\Emulators\RetroArch\config')
	Get-ChildItem $path -Recurse -Filter *.cfg | 
	Foreach-Object {
		$originFile = $_.FullName
	
		$origin="~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus/"
		$target=-join($emulationPath,'\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\')
		
		sedFile $originFile $origin $target
		
		#Video Filters path
		$origin="/app/lib/retroarch/filters/video/"
		$target=-join($emulationPath,'\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\')
		
		sedFile $originFile $origin $target
	}
	
	setMSG 'RetroArch - Shaders'
	$path=-join($emulationPath,'\tools\EmulationStation-DE\Emulators\RetroArch\config')
	Get-ChildItem $path -Recurse -Filter *.glslp | 
	Foreach-Object {
		$originFile = $_.FullName
	
		$origin="/app/share/libretro/shaders/"
		$target=":/shaders/"
		sedFile $originFile $origin $target
	}
	$path=-join($emulationPath,'\tools\EmulationStation-DE\Emulators\RetroArch\config')
	Get-ChildItem $path -Recurse -Filter *.slangp | 
	Foreach-Object {
		$originFile = $_.FullName
	
		$origin="/app/share/libretro/shaders/"
		$target=":/shaders/"
		sedFile $originFile $origin $target
	}
	
	
	setMSG 'RetroArch - Bios & Saves'
	
	RetroArch_setupSaves
	
	#Bios
	$line="`rsystem_directory = `"$biosPath`""
	$line | Add-Content $RetroArch_configFile
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
	$SourceFilePath = -join($emulationPath,'\tools\EmulationStation-DE\Emulators\RetroArch\saves\')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,'\saves\retroarch\saves.lnk')
	createLink $SourceFilePath $ShortcutPath
	
	#States
	$SourceFilePath = -join($emulationPath,'\tools\EmulationStation-DE\Emulators\RetroArch\states\')
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	$ShortcutPath = -join($emulationPath,'\saves\retroarch\states.lnk')
	createLink $SourceFilePath $ShortcutPath
}

function RetroArch_setOverride($fileToCheck, $name, $key, $value){
	$path="$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\config"
	Get-ChildItem $path -Recurse -Filter $fileToCheck | 
	Foreach-Object {
		$originFile = $_.FullName				 
		setConfigRA $key $value $originFile			
	}
}

function RetroArch_bezelOnAll(){
	$path=-join($emulationPath,'\tools\EmulationStation-DE\Emulators\RetroArch\config')
	Get-ChildItem $path -Recurse -Filter *.cfg | 
	Foreach-Object {
		$originFile = $_.FullName		 
		setConfigRA 'input_overlay_enable' "true" $originFile		
	}	
}

function RetroArch_bezelOffAll(){
	$path=-join($emulationPath,'\tools\EmulationStation-DE\Emulators\RetroArch\config')
	Get-ChildItem $path -Recurse -Filter *.cfg | 
	Foreach-Object {
		$originFile = $_.FullName		 
		setConfigRA 'input_overlay_enable' "false" $originFile			
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
function RetroArch_resetConfigRA(){
	echo "NYI"
}


function RetroArch_wswanc_setConfigRA(){	
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle Cygne'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle WonderSwan'  'input_player1_analog_dpad_mode' '"1"'
}
function RetroArch_wswanc_bezelOn(){
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle Cygne'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle WonderSwan'  'input_overlay_enable' '"false"'	
}
function RetroArch_wswanc_bezelOff(){
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle Cygne'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle WonderSwan'  'input_overlay_enable' '"false"'
}
function RetroArch_wswanc_MATshaderOn(){
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle Cygne'  'video_shader_enable' 'true'
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle Cygne'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle Cygne'	'video_smooth' '"false"'

	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle WonderSwan'  'video_shader_enable' 'true'
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle WonderSwan'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle WonderSwan'	 'video_smooth' '"false"'
}

function RetroArch_wswanc_MATshaderOff(){
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle Cygne'  'video_shader_enable' 'false'
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle Cygne'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle Cygne'	'video_smooth' '"true"'

	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle WonderSwan'  'video_shader_enable' 'false'
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle WonderSwan'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'wonderswancolor.cfg' 'Beetle WonderSwan'	 'video_smooth' '"true"'
}

function RetroArch_wswan_setConfigRA(){	
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle Cygne'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle WonderSwan'  'input_player1_analog_dpad_mode' '"1"'
}
function RetroArch_wswan_bezelOn(){
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle Cygne'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle WonderSwan'  'input_overlay_enable' '"false"'
}

function RetroArch_wswan_bezelOff(){
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle Cygne'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle WonderSwan'  'input_overlay_enable' '"false"'
}

function RetroArch_wswan_MATshaderOn(){
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle Cygne'  'video_shader_enable' 'true'
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle Cygne'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle Cygne'	'video_smooth' '"false"'

	RetroArch_setOverride 'wonderswan.cfg' 'Beetle WonderSwan'  'video_shader_enable' 'true'
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle WonderSwan'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle WonderSwan'	 'video_smooth' '"false"'
}

function RetroArch_wswan_MATshaderOff(){
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle Cygne'  'video_shader_enable' 'false'
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle Cygne'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle Cygne'	'video_smooth' '"true"'

	RetroArch_setOverride 'wonderswan.cfg' 'Beetle WonderSwan'  'video_shader_enable' 'false'
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle WonderSwan'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'wonderswan.cfg' 'Beetle WonderSwan'	 'video_smooth' '"true"'
}

function RetroArch_dolphin_emu_setConfigRA(){
	RetroArch_setOverride 'dolphin_emu.cfg' 'dolphin_emu'  'video_driver' '"gl"'
	RetroArch_setOverride 'dolphin_emu.cfg' 'dolphin_emu'  'video_driver' '"gl"'
}

function RetroArch_PPSSPP_setConfigRA(){
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_auto_frameskip' '"disabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_block_transfer_gpu' '"enabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_button_preference' '"Cross"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_cheats' '"disabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_cpu_core' '"JIT"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_disable_slow_framebuffer_effects' '"disabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_fast_memory' '"enabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_force_lag_sync' '"disabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_frameskip' '"Off"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_frameskiptype' '"Number'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_gpu_hardware_transform' '"enabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_ignore_bad_memory_access' '"enabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_inflight_frames' '"Up'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_internal_resolution' '"1440x816"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_io_timing_method' '"Fast"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_language' '"Automatic"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_lazy_texture_caching' '"disabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_locked_cpu_speed' '"off"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_lower_resolution_for_effects' '"Off"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_rendering_mode' '"Buffered"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_retain_changed_textures' '"disabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_software_skinning' '"enabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_spline_quality' '"Low"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_texture_anisotropic_filtering' '"off"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_texture_deposterize' '"disabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_texture_filtering' '"Auto"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_texture_replacement' '"enabled"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_texture_scaling_level' '"Off"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_texture_scaling_type' '"xbrz"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_texture_shader' '"Off"'
	RetroArch_setOverride 'psp.cfg' 'PPSSPP'  'ppsspp_vertex_cache' '"disabled"'
}

function RetroArch_pcengine_setConfigRA(){	
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'input_player1_analog_dpad_mode' '"1"'
}
function RetroArch_pcengine_bezelOn(){
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'custom_viewport_height' '"1200"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'custom_viewport_x' '"0"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\pcengine.cfg"
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'input_overlay_aspect_adjust_landscape' '"-0.150000"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'input_overlay_scale_landscape' '"1.075000"'

	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'custom_viewport_height' '"1200"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'custom_viewport_x' '"0"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\pcengine.cfg"
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'input_overlay_aspect_adjust_landscape' '"-0.150000"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'input_overlay_scale_landscape' '"1.075000"'

}

function RetroArch_pcengine_bezelOff(){
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'input_overlay_enable' '"false"'

	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'input_overlay_enable' '"false"'
}

function RetroArch_pcengine_CRTshaderOn(){
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'	'video_smooth' '"false"'

	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'	'video_smooth' '"false"'
}

function RetroArch_pcengine_CRTshaderOff(){
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE Fast'	'video_smooth' '"true"'
	
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'	'video_smooth' '"true"'
}

function RetroArch_amiga1200_CRTshaderOff(){
	RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_smooth' '"true"'
}

function RetroArch_amiga1200_CRTshaderOn(){
	RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_smooth' '"false"'
}

function RetroArch_amiga1200_setUpCoreOpt(){
	RetroArch_setOverride 'amiga1200.opt' 'PUAE'  'puae_model' '"A1200"'
}

function RetroArch_nes_setConfigRA(){	
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_nes_bezelOn(){
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\nes.cfg"
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_opacity' '"0.700000"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_scale_landscape' '"1.070000"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_aspect_adjust_landscape' '"0.100000"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'video_scale_integer' '"false"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'aspect_ratio_index' '"0"'	
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\nes.cfg"
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_opacity' '"0.700000"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_scale_landscape' '"1.070000"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_aspect_adjust_landscape' '"0.100000"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'video_scale_integer' '"false"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'aspect_ratio_index' '"0"'
}

function RetroArch_nes_bezelOff(){
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_enable' '"false"'
}

function RetroArch_nes_CRTshaderOn(){
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'nes.cfg' 'Mesen'	'video_smooth' '"false"'

	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'	'video_smooth' '"false"'
}

function RetroArch_nes_CRTshaderOff(){
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'nes.cfg' 'Mesen'	'video_smooth' '"true"'
	
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'nes.cfg' 'Nestopia'	'video_smooth' '"true"'
}

function RetroArch_nes_ar43(){
	#RetroArch_nes_bezelOn
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'aspect_ratio_index' '"0"'
}

function RetroArch_nes_ar87(){	
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_scale_landscape' '"1.380000"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_aspect_adjust_landscape' '"-0.170000"'
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'aspect_ratio_index' '"15"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_scale_landscape' '"1.380000"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_aspect_adjust_landscape' '"-0.170000"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'aspect_ratio_index' '"15"'
}

function RetroArch_nes_ar32(){
	RetroArch_setOverride 'nes.cfg' 'Nestopia'  'aspect_ratio_index' '"7"'
	RetroArch_setOverride 'nes.cfg' 'Mesen'  'aspect_ratio_index' '"7"'
	RetroArch_nes_bezelOff
}

function RetroArch_Mupen64Plus_Next_setConfigRA(){
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_crop_overscan' '"false"'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_smooth' 'ED_RM_LINE'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_auto_scale'  '"false"'
}

function  RetroArch_n64_3DCRTshaderOn(){
	 RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_smooth' 'ED_RM_LINE'
 }

function RetroArch_n64_3DCRTshaderOff(){
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_smooth' 'ED_RM_LINE'
}

function RetroArch_n64_setConfigRA(){
	RetroArch_n64_3DCRTshaderOff
}

function RetroArch_lynx_setConfigRA(){	
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_lynx_bezelOn(){
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\lynx.cfg"
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_opacity' '"0.700000"'
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_scale_landscape' '"1.170000"'
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'video_scale_integer' '"false"'
	
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\lynx.cfg"
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_opacity' '"0.700000"'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_scale_landscape' '"1.170000"'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'video_scale_integer' '"false"'
}

function RetroArch_lynx_bezelOff(){
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_enable' '"false"'
}

function RetroArch_lynx_MATshaderOn(){
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'video_shader_enable' 'true'
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'	'video_smooth' '"false"'

	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'video_shader_enable' 'true'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'	'video_smooth' '"false"'
}

function RetroArch_lynx_MATshaderOff(){
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'video_shader_enable' 'false'
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'	'video_smooth' '"true"'

	RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'video_shader_enable' 'false'
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'atarilynx.cfg' 'Handy'	'video_smooth' '"true"'
}


function RetroArch_SameBoy_gb_setConfigRA(){	
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_dark_filter_level' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_bootloader' '"enabled"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_colorization' '"internal"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_hwmode' '"Auto"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_internal_palette' '"GB'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_mode' '"Not'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_port' '"56400"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_1' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_10' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_11' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_12' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_2' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_3' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_4' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_5' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_6' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_7' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_8' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_9' '"0"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_palette_twb64_1' '"TWB64'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_palette_twb64_2' '"TWB64'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_mix_frames' '"disabled"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_rumble_level' '"10"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_show_gb_link_settings' '"disabled"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_turbo_period' '"4"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_up_down_allowed' '"disabled"'
}

function RetroArch_ngp_setConfigRA(){	
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_ngp_bezelOn(){
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\ngpc.cfg"
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_aspect_adjust_landscape' '"-0.310000"'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_hide_in_menu' '"false"'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_scale_landscape' '"1.625000"'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_x_separation_portrait' '"-0.010000"'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_y_offset_landscape' '"-0.135000"'
}

function RetroArch_ngp_bezelOff(){
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_enable' '"false"'
}

function RetroArch_ngp_MATshaderOn(){
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'video_shader_enable' 'true'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'	 'video_smooth' '"false"'
}

function RetroArch_ngp_MATshaderOff(){
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'video_shader_enable' 'false'
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'	 'video_smooth' '"true"'
}

function RetroArch_ngpc_setConfigRA(){	
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_ngpc_bezelOn(){
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\ngpc.cfg"
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_aspect_adjust_landscape' '"-0.170000"'
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_scale_landscape' '"1.615000"'
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_x_separation_portrait' '"-0.010000"'
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_y_offset_landscape' '"-0.135000"'
}

function RetroArch_ngpc_bezelOff(){
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_enable' '"false"'
}

function RetroArch_ngpc_MATshaderOn(){
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'video_shader_enable' 'true'
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'	 'video_smooth' '"false"'
}

function RetroArch_ngpc_MATshaderOff(){
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'video_shader_enable' 'false'
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'	 'video_smooth' '"true"'
}

function RetroArch_atari2600_setConfigRA(){	
	RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_atari2600_bezelOn(){
	RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\atari2600.cfg"
	RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_overlay_aspect_adjust_landscape' '"0.095000"'
	RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_overlay_scale_landscape' '"1.070000"'
	RetroArch_setOverride 'atari2600.cfg' 'Stella'  'aspect_ratio_index' '"0"'
}

function RetroArch_atari2600_bezelOff(){
	RetroArch_setOverride 'atari2600.cfg' 'Stella' 'input_overlay_enable' '"false"'
}

function RetroArch_atari2600_CRTshaderOn(){
	RetroArch_setOverride 'atari2600.cfg' 'Stella' 'video_shader_enable' 'true'
	RetroArch_setOverride 'atari2600.cfg' 'Stella'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'atari2600.cfg' 'Stella'	'video_smooth' '"false"'
}

function RetroArch_atari2600_CRTshaderOff(){
	RetroArch_setOverride 'atari2600.cfg' 'Stella' 'video_shader_enable' '"false"'
	RetroArch_setOverride 'atari2600.cfg' 'Stella'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'atari2600.cfg' 'Stella'	'video_smooth' '"true"'
}

function RetroArch_mame_setConfigRA(){	
	RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'mame.cfg' 'MAME'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_mame_bezelOn(){
	RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'mame.cfg' 'MAME'  'input_overlay_enable' '"false"'
}

function RetroArch_mame_bezelOff(){
	RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'mame.cfg' 'MAME'  'input_overlay_enable' '"false"'
}

function RetroArch_mame_CRTshaderOn(){
	RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'video_shader_enable' 'true'
	RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'   'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'	'video_smooth' '"false"'

	RetroArch_setOverride 'mame.cfg' 'MAME'  'video_shader_enable' 'true'
	RetroArch_setOverride 'mame.cfg' 'MAME'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'mame.cfg' 'MAME'	'video_smooth' '"false"'
}

function RetroArch_mame_CRTshaderOff(){
	RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'video_shader_enable' 'false'
	RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'	'video_smooth' '"true"'

	RetroArch_setOverride 'mame.cfg' 'MAME'  'video_shader_enable' 'false'
	RetroArch_setOverride 'mame.cfg' 'MAME'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'mame.cfg' 'MAME'	'video_smooth' '"true"'
}

function RetroArch_neogeo_bezelOn(){
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\neogeo.cfg"
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_hide_in_menu' '"false"'
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_scale_landscape' '"1.170000'
}

function RetroArch_neogeo_bezelOff(){
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_enable' '"false"'
}

function RetroArch_neogeo_CRTshaderOn(){
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo' 'video_shader_enable' 'true'
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'	'video_smooth' '"false"'
}

function RetroArch_neogeo_CRTshaderOff(){
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo' 'video_shader_enable' '"false"'
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'	'video_smooth' '"true"'
}

function RetroArch_fbneo_bezelOn(){
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\neogeo.cfg"
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_hide_in_menu' '"false"'
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_scale_landscape' '"1.170000'
}

function RetroArch_fbneo_bezelOff(){
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_enable' '"false"'
}

function RetroArch_fbneo_CRTshaderOn(){
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo' 'video_shader_enable' 'true'
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'	'video_smooth' '"false"'
}

function RetroArch_fbneo_CRTshaderOff(){
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo' 'video_shader_enable' '"false"'
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'	'video_smooth' '"true"'
}


function RetroArch_segacd_setConfigRA(){	
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_segacd_bezelOn(){
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\segacd.cfg"
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_hide_in_menu' '"false"'
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.170000'
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"0"'

	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\segacd.cfg"
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_hide_in_menu' '"false"'
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.170000'
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"0"'
}
function RetroArch_segacd_bezelOff(){
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
}

function RetroArch_segacd_CRTshaderOn(){
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
}

function RetroArch_segacd_CRTshaderOff(){
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
}


function RetroArch_segacd_ar32(){
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	RetroArch_segacd_bezelOff
}
function RetroArch_segacd_ar43(){
	RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'	
	RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'	
}

function RetroArch_genesis_setConfigRA(){	
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_genesis_bezelOn(){
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\genesis.cfg"
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.170000"'	
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"0"'

	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\genesis.cfg"
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.170000"'
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"0"'

}


function RetroArch_genesis_bezelOff(){
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
}

function RetroArch_genesis_ar32(){
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	RetroArch_genesis_bezelOff
}

function RetroArch_genesis_ar43(){
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'	
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'		
}

function RetroArch_genesis_CRTshaderOn(){
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'	'video_smooth' '"false"'

	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'	'video_smooth' '"false"'
}

function RetroArch_genesis_CRTshaderOff(){
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'	'video_smooth' '"true"'

	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'	'video_smooth' '"true"'
}

function RetroArch_gamegear_setConfigRA(){	
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_gamegear_bezelOn(){
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\gg.cfg"
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_aspect_adjust_landscape' '"-0.115000"'
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.545000"'

	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\gg.cfg"
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_aspect_adjust_landscape' '"-0.115000"'
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_scale_landscape' '"1.545000"'
}

function RetroArch_gamegear_bezelOff(){
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'

	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_enable' '"false"'
}

function RetroArch_gamegear_MATshaderOn(){
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'	'video_smooth' '"false"'

	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'	'video_smooth' '"false"'
}

function RetroArch_gamegear_MATshaderOff(){
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'	'video_smooth' '"true"'

	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'	'video_smooth' '"true"'
}

function RetroArch_mastersystem_setConfigRA(){	
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_mastersystem_bezelOn(){
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\mastersystem.cfg"
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.170000"'
}

function RetroArch_mastersystem_bezelOff(){
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
}

function RetroArch_mastersystem_ar32(){
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	RetroArch_mastersystem_bezelOff
}

function RetroArch_mastersystem_CRTshaderOn(){
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'	'video_smooth' '"false"'
}

function RetroArch_mastersystem_CRTshaderOff(){
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'	'video_smooth' '"true"'
}

function RetroArch_mastersystem_ar43(){
	RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'	
}
function RetroArch_sega32x_setConfigRA(){	
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_player1_analog_dpad_mode' '"1"'
}
function RetroArch_sega32x_bezelOn(){
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\sega32x.cfg"
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_hide_in_menu' '"false"'
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_scale_landscape' '"1.070000"'
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_aspect_adjust_landscape' '"0.095000"'
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'aspect_ratio_index' '"0"'
}

function RetroArch_sega32x_bezelOff(){
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_enable' '"false"'
}

function RetroArch_sega32x_CRTshaderOn(){
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'	 'video_smooth' '"false"'
}

function RetroArch_sega32x_CRTshaderOff(){
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'	 'video_smooth' '"true"'
}

function RetroArch_sega32x_ar32(){
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'aspect_ratio_index' '"7"'
	RetroArch_sega32x_bezelOff
}

function RetroArch_sega32x_ar43(){
	RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'aspect_ratio_index' '"21"'
	RetroArch_sega32x_bezelOff
}

#function RetroArch_gba_bezelOn(){
#	#missing stuff?
#	RetroArch_setOverride 'gba.cfg' 'mGBA'  'aspect_ratio_index' '"21"'
#}
function RetroArch_gba_setConfigRA(){	
	RetroArch_setOverride 'gba.cfg' 'mGBA'  'input_player1_analog_dpad_mode' '"1"'
}
function RetroArch_gba_MATshaderOn(){
	RetroArch_setOverride 'gba.cfg' 'mGBA'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'gba.cfg' 'mGBA'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'gba.cfg' 'mGBA'	 'video_smooth' '"false"'
}

function RetroArch_gba_MATshaderOff(){
	RetroArch_setOverride 'gba.cfg' 'mGBA'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'gba.cfg' 'mGBA'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'gba.cfg' 'mGBA'	 'video_smooth' '"true"'	
}

function RetroArch_gb_bezelOn(){
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\gb.cfg"
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_scale_landscape' '"1.860000"'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_y_offset_landscape' '"-0.150000"'

	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\gb.cfg"
	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_scale_landscape' '"1.860000"'
	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_y_offset_landscape' '"-0.150000"'
}

function RetroArch_gb_setConfigRA(){	
	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_gb_bezelOff(){
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_enable' '"false"'


	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_enable' '"false"'
}

function RetroArch_gb_MATshaderOn(){
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'video_shader_enable' 'true'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'	 'video_smooth' '"false"'

	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'gb.cfg' 'Gambatte'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'gb.cfg' 'Gambatte'	 'video_smooth' '"false"'
}

function RetroArch_gb_MATshaderOff(){
	RetroArch_setOverride 'gb.cfg' 'SameBoy'  'video_shader_enable' 'false'
	RetroArch_setOverride 'gb.cfg' 'SameBoy'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'gb.cfg' 'SameBoy'	 'video_smooth' '"true"'

	RetroArch_setOverride 'gb.cfg' 'Gambatte'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'gb.cfg' 'Gambatte'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'gb.cfg' 'Gambatte'	 'video_smooth' '"true"'
}

function RetroArch_SameBoy_gbc_setConfigRA(){
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'gambatte_gbc_color_correction' '"GBC'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'gambatte_gbc_color_correction_mode' '"accurate"'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'gambatte_gbc_frontlight_position' '"central"'
}


function RetroArch_gbc_setConfigRA(){	
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_gbc_bezelOn(){
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\gbc.cfg"
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_scale_landscape' '"1.870000"'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_y_offset_landscape' '"-0.220000"'

	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'aspect_ratio_index' '"21"'
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\gbc.cfg"
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_scale_landscape' '"1.870000"'
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_y_offset_landscape' '"-0.220000"'
}

function RetroArch_gbc_bezelOff(){
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_enable' '"false"'


	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_enable' '"false"'
}

function RetroArch_gbc_MATshaderOn(){
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'video_shader_enable' 'true'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'	 'video_smooth' '"false"'

	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'video_shader_enable' 'true'
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'	 'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'	 'video_smooth' '"false"'
}

function RetroArch_gbc_MATshaderOff(){
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'video_shader_enable' 'false'
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'gbc.cfg' 'SameBoy'	 'video_smooth' '"true"'	
	
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'video_shader_enable' 'false'
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'	 'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'gbc.cfg' 'Gambatte'	 'video_smooth' '"true"'	
}

function RetroArch_n64_wideScreenOn(){
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-aspect' '"16:9 adjusted"'	
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'aspect_ratio_index' '"1"'	
	RetroArch_n64_bezelOff
	RetroArch_n64_3DCRTshaderOff
}

function RetroArch_n64_wideScreenOff(){
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-aspect' '"4:3"'	
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'aspect_ratio_index' '"0"'	
	#RetroArch_n64_bezelOn
}

function RetroArch_n64_bezelOn(){
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\N64.cfg"
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_aspect_adjust_landscape' '"0.085000"'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_scale_landscape' '"1.065000"'
}

function RetroArch_n64_bezelOff(){
	RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_enable' '"false"'
}

function RetroArch_atari800_setConfigRA(){	
	RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_atari800_bezelOn(){
	RetroArch_setOverride 'atari800.cfg' 'Stella'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\atari800.cfg"
	RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_hide_in_menu' '"true"'
	RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_scale_landscape' '"1.175000"'
	RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_aspect_adjust_landscape' '"0.000000"'
}

function RetroArch_atari800_bezelOff(){
	RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_enable' '"false"'
}

function RetroArch_atari5200_setConfigRA(){	
	RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_atari5200_bezelOn(){
	RetroArch_setOverride 'atari5200.cfg' 'Stella'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\atari5200.cfg"
	RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_hide_in_menu' '"true"'
	RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_scale_landscape' '"1.175000"'
	RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_aspect_adjust_landscape' '"0.000000"'
}

function RetroArch_atari5200_bezelOff(){
	RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_enable' '"false"'
}

function RetroArch_dreamcast_bezelOn(){
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\Dreamcast.cfg"
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay_aspect_adjust_landscape' '"0.110000"'
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay_scale_landscape' '"1.054998"'
}

function RetroArch_dreamcast_bezelOff(){
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay_enable' '"false"'
}

#temporary
function RetroArch_Flycast_bezelOff(){
	RetroArch_dreamcast_bezelOff
}

function RetroArch_Flycast_bezelOn(){
	RetroArch_dreamcast_bezelOn
}

function RetroArch_Beetle_PSX_HW_bezelOff(){
	RetroArch_psx_bezelOff
}

function RetroArch_Beetle_PSX_HW_bezelOn(){
	RetroArch_psx_bezelOn
}

function  RetroArch_dreamcast_3DCRTshaderOn(){
	 RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'	'video_smooth' 'ED_RM_LINE'
 }

function RetroArch_dreamcast_setConfigRA(){
	RetroArch_dreamcast_3DCRTshaderOff
}

function RetroArch_dreamcast_3DCRTshaderOff(){
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'	'video_smooth' 'ED_RM_LINE'
}

function RetroArch_saturn_setConfigRA(){	
	RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_player1_analog_dpad_mode' '"1"'
	RetroArch_saturn_3DCRTshaderOff
}

function RetroArch_saturn_bezelOn(){
	RetroArch_setOverride 'saturn.cfg' 'Yabause'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\saturn.cfg"
	RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay_scale_landscape' '"1.070000"'
	RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay_aspect_adjust_landscape' '"0.095000"'

	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\saturn.cfg"
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay_scale_landscape' '"1.070000"'
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay_aspect_adjust_landscape' '"0.095000"'
	
	
	RetroArch_setOverride 'saturn.cfg' 'Kronos'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\saturn.cfg"
	RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay_scale_landscape' '"1.070000"'
	RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay_aspect_adjust_landscape' '"0.095000"'

	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\saturn.cfg"
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay_scale_landscape' '"1.070000"'
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay_aspect_adjust_landscape' '"0.095000"'
}

function RetroArch_saturn_bezelOff(){
	RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay_enable' '"false"'
}

function  RetroArch_saturn_3DCRTshaderOn(){
	 RetroArch_setOverride 'saturn.cfg' 'Yabause'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'saturn.cfg' 'Yabause'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'saturn.cfg' 'Yabause'	'video_smooth' 'ED_RM_LINE'

	 RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'	'video_smooth' 'ED_RM_LINE'

	RetroArch_setOverride 'saturn.cfg' 'Kronos'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'saturn.cfg' 'Kronos'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'saturn.cfg' 'Kronos'	'video_smooth' 'ED_RM_LINE'

	 RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'	'video_smooth' 'ED_RM_LINE'
 }

function RetroArch_saturn_3DCRTshaderOff(){
	RetroArch_setOverride 'saturn.cfg' 'Yabause'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'saturn.cfg' 'Kronos'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'video_shader_enable' '"false"'

	RetroArch_setOverride 'saturn.cfg' 'Yabause'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'saturn.cfg' 'Yabause'	'video_smooth' 'ED_RM_LINE'

	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'	'video_smooth' 'ED_RM_LINE'

	RetroArch_setOverride 'saturn.cfg' 'Kronos'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'saturn.cfg' 'Kronos'	'video_smooth' 'ED_RM_LINE'

	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'	'video_smooth' 'ED_RM_LINE'
}

function RetroArch_snes_setConfigRA(){	
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_player1_analog_dpad_mode' '"1"'
}

function RetroArch_snes_bezelOn(){
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\snes.cfg"
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_auto_scale' '"false"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_enable' '"true"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_opacity' '"0.700000"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'video_scale_integer' '"false"'
}

function RetroArch_snes_bezelOff(){
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_enable' '"false"'
}

function RetroArch_snes_CRTshaderOn(){
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'video_shader_enable' '"true"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'	'video_smooth' '"false"'
}

function RetroArch_snes_CRTshaderOff(){
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'	'video_filter' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\filters\video\Normal4x.filt"
	RetroArch_setOverride 'snes.cfg' 'Snes9x'	'video_smooth' '"true"'
}

function RetroArch_snes_ar43(){
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_scale_landscape' '"1.170000"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_aspect_adjust_landscape' '"0"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\snes.cfg"
}

function RetroArch_snes_ar87(){
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay' "$emulationPath\tools\EmulationStation-DE\Emulators\RetroArch\overlays\pegasus\snes87.cfg"
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_scale_landscape' '"1.380000"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_aspect_adjust_landscape' '"-0.170000"'
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'aspect_ratio_index' '"15"'
}

function RetroArch_snes_ar32(){
	RetroArch_setOverride 'snes.cfg' 'Snes9x'  'aspect_ratio_index' '"7"'
	RetroArch_snes_bezelOff
}


#function RetroArch_bsnes_hd_beta_bezelOn(){
# 	RetroArch_setOverride 'sneshd.cfg' 'bsnes-hd beta'  'video_scale_integer' '"false"'
# }

function RetroArch_melonDS_setUpCoreOpt(){
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_audio_bitrate' '"Automatic"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_audio_interpolation' '"None"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_boot_directly' '"enabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_console_mode' '"DS"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_dsi_sdcard' '"disabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_hybrid_ratio' '"2"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_hybrid_small_screen' '"Duplicate"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_block_size' '"32"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_branch_optimisations' '"enabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_enable' '"enabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_fast_memory' '"enabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_literal_optimisations' '"enabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_opengl_better_polygons' '"enabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_opengl_filtering' '"nearest"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_opengl_renderer' '"enabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_opengl_resolution' '"5x native (1280x960)"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_randomize_mac_address' '"disabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_screen_gap' '"0"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_screen_layout' '"Hybrid Bottom"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_swapscreen_mode' '"Toggle"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_threaded_renderer' '"disabled"'
	RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_touch_mode' '"Touch"'
}

function RetroArch_melonDS_setConfigRA(){	
	RetroArch_setOverride 'nds.cfg' 'melonDS'  'rewind_enable' '"false"'
}

function RetroArch_Mupen64Plus_Next_setUpCoreOpt(){
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-169screensize' '"1920x1080"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-43screensize' '"1280x960"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-alt-map' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-angrylion-multithread' '"all threads"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-angrylion-overscan' '"disabled"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-angrylion-sync' '"Low"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-angrylion-vioverlay' '"Filtered"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-aspect' '"4:3"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-astick-deadzone' '"15"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-astick-sensitivity' '"100"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-BackgroundMode' '"OnePiece"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-BilinearMode' '"standard"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-CorrectTexrectCoords' '"Auto"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-CountPerOp' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-CountPerOpDenomPot' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-cpucore' '"dynamic_recompiler"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-d-cbutton' '"C3"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-DitheringPattern' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-DitheringQuantization' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableCopyAuxToRDRAM' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableCopyColorToRDRAM' '"Async"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableCopyDepthToRDRAM' '"Software"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableEnhancedHighResStorage' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableEnhancedTextureStorage' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableFBEmulation' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableFragmentDepthWrite' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableHiResAltCRC' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableHWLighting' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableInaccurateTextureCoordinates' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableLegacyBlending' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableLODEmulation' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableN64DepthCompare' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableNativeResFactor' '"4"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableNativeResTexrects' '"Optimized"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableOverscan' '"Enabled"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableShadersStorage' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableTexCoordBounds' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableTextureCache' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-ForceDisableExtraMem' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-FrameDuping' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-Framerate' '"Fullspeed"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-FXAA' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-GLideN64IniBehaviour' '"late"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-HybridFilter' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-IgnoreTLBExceptions' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-l-cbutton' '"C2"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-MaxHiResTxVramLimit' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-MaxTxCacheSize' '"8000"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-MultiSampling' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-OverscanBottom' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-OverscanLeft' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-OverscanRight' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-OverscanTop' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-pak1' '"memory"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-pak2' '"none"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-pak3' '"none"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-pak4' '"none"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-deinterlace-method' '"Bob"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-dither-filter' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-divot-filter' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-downscaling' '"disable"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-gamma-dither' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-native-tex-rect' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-native-texture-lod' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-overscan' '"0"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-super-sampled-read-back' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-super-sampled-read-back-dither' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-synchronous' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-upscaling' '"1x"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-vi-aa' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-vi-bilinear' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-r-cbutton' '"C1"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-rdp-plugin' '"gliden64"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-RDRAMImageDitheringMode' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-rsp-plugin' '"hle"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-ThreadedRenderer' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txCacheCompression' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txEnhancementMode' '"As Is"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txFilterIgnoreBG' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txFilterMode' '"None"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txHiresEnable' '"True"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txHiresFullAlphaChannel' '"False"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-u-cbutton' '"C4"'
	RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-virefresh' '"Auto"'
}

function RetroArch_Beetle_PSX_HW_setUpCoreOpt(){
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_adaptive_smoothing' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_analog_calibration' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_analog_toggle' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_aspect_ratio' '"corrected"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_cd_access_method' '"sync"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_cd_fastload' '"2x(native)"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_core_timing_fps' '"force_progressive"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_cpu_dynarec' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_cpu_freq_scale' '"100%(native)"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_crop_overscan' '"smart"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_crosshair_color_p1' '"red"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_crosshair_color_p2' '"blue"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_depth' '"16bpp(native)"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_display_internal_fps' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_display_vram' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_dither_mode' '"1x(native)"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_dump_textures' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_dynarec_eventcycles' '"128"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_dynarec_invalidate' '"full"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_enable_memcard1' '"enabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_enable_multitap_port1' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_enable_multitap_port2' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_filter' '"nearest"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_filter_exclude_2d_polygon' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_filter_exclude_sprite' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_frame_duping' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_gpu_overclock' '"1x(native)"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_gte_overclock' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_gun_cursor' '"cross"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_gun_input_mode' '"lightgun"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_image_crop' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_image_offset' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_image_offset_cycles' '"0"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_initial_scanline' '"0"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_initial_scanline_pal' '"0"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_internal_resolution' '"2x"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_last_scanline' '"239"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_last_scanline_pal' '"287"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_line_render' '"default"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_mdec_yuv' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_memcard_left_index' '"0"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_memcard_right_index' '"1"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_mouse_sensitivity' '"100%"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_msaa' '"1x"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_negcon_deadzone' '"0%"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_negcon_response' '"linear"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_override_bios' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pal_video_timing_override' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_2d_tol' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_mode' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_nclip' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_texture' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_vertex' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_renderer' '"hardware"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_renderer_software_fb' '"enabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_replace_textures' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_scaled_uv_offset' '"enabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_shared_memory_cards' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_skip_bios' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_super_sampling' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_track_textures' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_use_mednafen_memcard0_method' '"libretro"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_widescreen_hack' '"disabled"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_widescreen_hack_aspect_ratio' '"16:9"'
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_wireframe' '"disabled"'
}

function RetroArch_Flycast_setUpCoreOpt(){
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_allow_service_buttons' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_alpha_sorting' '"per-triangle (normal)"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_analog_stick_deadzone' '"15%"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_anisotropic_filtering' '"4"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_auto_skip_frame' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_boot_to_bios' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_broadcast' '"NTSC"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_cable_type' '"TV'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_custom_textures' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_delay_frame_swapping' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_digital_triggers' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_dump_textures' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_enable_dsp' '"enabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_enable_purupuru' '"enabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_enable_rttb' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_fog' '"enabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_force_wince' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_frame_skipping' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_gdrom_fast_loading' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_hle_bios' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_internal_resolution' '"960x720"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_language' '"English"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_lightgun1_crosshair' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_lightgun2_crosshair' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_lightgun3_crosshair' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_lightgun4_crosshair' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_mipmapping' '"enabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_oit_abuffer_size' '"512MB"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_per_content_vmus' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_pvr2_filtering' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_region' '"USA"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_screen_rotation' '"horizontal"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_show_lightgun_settings' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_show_vmu_screen_settings' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_texupscale' '"1"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_texupscale_max_filtered_texture_size' '"256"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_threaded_rendering' '"enabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_trigger_deadzone' '"0%"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_pixel_off_color' '"DEFAULT_OFF 01"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_pixel_on_color' '"DEFAULT_ON 00"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_screen_display' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_screen_opacity' '"100%"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_screen_position' '"Upper Left"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_screen_size_mult' '"1x"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_pixel_off_color' '"DEFAULT_OFF 01"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_pixel_on_color' '"DEFAULT_ON 00"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_screen_display' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_screen_opacity' '"100%"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_screen_position' '"Upper Left"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_screen_size_mult' '"1x"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_pixel_off_color' '"DEFAULT_OFF 01"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_pixel_on_color' '"DEFAULT_ON 00"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_screen_display' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_screen_opacity' '"100%"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_screen_position' '"Upper Left"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_screen_size_mult' '"1x"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_pixel_off_color' '"DEFAULT_OFF 01"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_pixel_on_color' '"DEFAULT_ON 00"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_screen_display' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_screen_opacity' '"100%"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_screen_position' '"Upper Left"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_screen_size_mult' '"1x"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_volume_modifier_enable' '"enabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_widescreen_cheats' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_widescreen_hack' '"disabled"'
}

function RetroArch_Gambatte_setUpCoreOpt(){
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_audio_resampler' '"sinc"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_dark_filter_level' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_bootloader' '"enabled"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_colorization' '"auto"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_hwmode' '"Auto"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_internal_palette' '"GB - DMG"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_mode' '"Not Connected"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_port' '"56400"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_1' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_10' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_11' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_12' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_2' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_3' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_4' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_5' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_6' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_7' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_8' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_9' '"0"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_palette_pixelshift_1' '"PixelShift 01 - Arctic Green"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_palette_twb64_1' '"WB64 001 - Aqours Blue"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_palette_twb64_2' '"TWB64 101 - 765PRO Pink"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gbc_color_correction' '"GBC only"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gbc_color_correction_mode' '"accurate"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gbc_frontlight_position' '"central"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_mix_frames' '"disabled"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_rumble_level' '"10"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_show_gb_link_settings' '"disabled"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_turbo_period' '"4"'
	RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_up_down_allowed' '"disabled"'
}

function RetroArch_Nestopia_setUpCoreOpt(){
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_arkanoid_device' '"mouse"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_aspect' '"auto"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_dpcm' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_fds' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_mmc5' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_n163' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_noise' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_s5b' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_sq1' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_sq2' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_tri' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_vrc6' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_vrc7' '"100"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_blargg_ntsc_filter' '"disabled"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_button_shift' '"disabled"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_favored_system' '"auto"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_fds_auto_insert' '"enabled"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_genie_distortion' '"disabled"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_nospritelimit' '"disabled"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_overclock' '"1x"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_overscan_h' '"disabled"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_overscan_v' '"enabled"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_palette' '"cxa2025as"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_ram_power_state' '"0x00"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_select_adapter' '"auto"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_show_advanced_av_settings' '"disabled"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_show_crosshair' '"enabled"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_turbo_pulse' '"2"'
	RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_zapper_device' '"lightgun"'
}
function RetroArch_bsnes_hd_beta_setUpCoreOpt(){
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_blur_emulation' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_coprocessor_delayed_sync' '"ON"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_coprocessor_prefer_hle' '"ON"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_cpu_fastmath' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_cpu_overclock' '"100"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_cpu_sa1_overclock' '"100"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_cpu_sfx_overclock' '"100"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_dsp_cubic' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_dsp_echo_shadow' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_dsp_fast' '"ON"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_entropy' '"Low"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_hotfixes' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ips_headered' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_bgGrad' '"4"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_igwin' '"outside"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_igwinx' '"128"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_mosaic' '"1x scale"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_perspective' '"on'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_scale' '"1x"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_strWin' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_supersample' '"none"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_widescreen' '"16:10"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_windRad' '"0"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsbg1' '"auto horz and vert"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsbg2' '"auto horz and vert"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsbg3' '"auto horz and vert"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsbg4' '"auto horz and vert"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsBgCol' '"auto"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsMarker' '"none"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsMarkerAlpha' '"1/1"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsMode' '"all"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsobj' '"safe"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_deinterlace' '"ON"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_fast' '"ON"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_no_sprite_limit' '"ON"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_no_vram_blocking' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_show_overscan' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_run_ahead_frames' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_sgb_bios' '"SGB1.sfc"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_video_aspectcorrection' '"OFF"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_video_gamma' '"100"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_video_luminance' '"100"'
	RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_video_saturation' '"100"'
}

function RetroArch_Flycast_wideScreenOn(){
	RetroArch_setOverride 'Flycast.opt' 	'Flycast'  	'reicast_widescreen_cheats' 	'"enabled"'
	RetroArch_setOverride 'Flycast.opt' 	'Flycast'  	'reicast_widescreen_hack' 	'"enabled"'
	RetroArch_setOverride 'dreamcast.cfg' 	'Flycast'  	'aspect_ratio_index' 		'"1"'	
	RetroArch_dreamcast_bezelOff
	RetroArch_dreamcast_3DCRTshaderOff
}

function RetroArch_Flycast_wideScreenOff(){
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_widescreen_cheats' '"disabled"'
	RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_widescreen_hack' '"disabled"'
	RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'aspect_ratio_index' '"0"'	
}

function RetroArch_Beetle_PSX_HW_wideScreenOn(){
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_widescreen_hack' '"enabled"'
	RetroArch_setOverride 'Beetle PSX.opt' 'Beetle PSX'  'beetle_psx_hw_widescreen_hack' '"enabled"'
	RetroArch_psx_bezelOff
}

function RetroArch_Beetle_PSX_HW_wideScreenOff(){
	RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_widescreen_hack' '"disabled"'
	RetroArch_setOverride 'Beetle PSX.opt' 'Beetle PSX'  'beetle_psx_hw_widescreen_hack' '"disabled"'
}


function RetroArch_SwanStation_setConfigRA(){		
	RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_GPU.ResolutionScale' '"3"'	
}

function RetroArch_SwanStation_wideScreenOn(){
	RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_GPU.WidescreenHack' '"true"'
	RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_Display.AspectRatio' '"16:9"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation'  'aspect_ratio_index' '"1"'	
	RetroArch_psx_bezelOff	
}

function RetroArch_SwanStation_wideScreenOff(){
	RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_GPU.WidescreenHack' '"false"'
	RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_Display.AspectRatio' '"auto"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation'  'aspect_ratio_index' '"0"'	
}

function RetroArch_psx_bezelOn(){
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay_enable' '"true"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay' '"~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus/psx.cfg"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay_aspect_adjust_landscape' '"0.100000"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay_enable' '"true"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay_scale_landscape' '"1.060000"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay_enable' '"true"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay' '"~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus/psx.cfg"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay_aspect_adjust_landscape' '"0.100000"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay_enable' '"true"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay_scale_landscape' '"1.060000"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay_enable' '"true"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation' 'aspect_ratio_index' '"0"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay' '"~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus/psx.cfg"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay_aspect_adjust_landscape' '"0.100000"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay_enable' '"true"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay_scale_landscape' '"1.060000"'
}


function RetroArch_psx_bezelOff(){
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX'  'input_overlay_enable' '"false"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation'  'input_overlay_enable' '"false"'
}

function  RetroArch_psx_3DCRTshaderOn(){
	 RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'  'video_shader_enable' 'true'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'	'video_smooth' 'ED_RM_LINE'

	 RetroArch_setOverride 'psx.cfg' 'Beetle PSX'  'video_shader_enable' 'true'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX'	'video_smooth' 'ED_RM_LINE'

	 RetroArch_setOverride 'psx.cfg' 'SwanStation'  'video_shader_enable' 'true'
	RetroArch_setOverride 'psx.cfg' 'SwanStation'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'psx.cfg' 'SwanStation'	'video_smooth' 'ED_RM_LINE'
 }
 
function RetroArch_psx_3DCRTshaderOff(){
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'	'video_smooth' 'ED_RM_LINE'

	RetroArch_setOverride 'psx.cfg' 'Beetle PSX'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'psx.cfg' 'Beetle PSX'	'video_smooth' 'ED_RM_LINE'

	RetroArch_setOverride 'psx.cfg' 'SwanStation'  'video_shader_enable' '"false"'
	RetroArch_setOverride 'psx.cfg' 'SwanStation'	'video_filter' 'ED_RM_LINE'
	RetroArch_setOverride 'psx.cfg' 'SwanStation'	'video_smooth' 'ED_RM_LINE'
}

function RetroArch_psx_setConfigRA(){
	RetroArch_psx_3DCRTshaderOff
}


function RetroArch_autoSaveOn(){
	setConfigRA "savestate_auto_load" "true" $RetroArch_configFile
	setConfigRA "savestate_auto_save" "true" $RetroArch_configFile	
}
function RetroArch_autoSaveOff(){
	setConfigRA "savestate_auto_load" "false" $RetroArch_configFile
	setConfigRA "savestate_auto_save" "false" $RetroArch_configFile	
}

function RetroArch_retroAchievementsOn(){
	setConfigRA 'cheevos_enable' 'true' "$RetroArch_configFile"
	#Mame fix
	#RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'cheevos_enable' '"false"'
	#RetroArch_setOverride 'mame.cfg' 'MAME'  'cheevos_enable' '"false"'
}
function RetroArch_retroAchievementsOff(){
	setConfigRA 'cheevos_enable' 'false' "$RetroArch_configFile"
	#Mame fix
	#RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'cheevos_enable' '"false"'
	#RetroArch_setOverride 'mame.cfg' 'MAME'  'cheevos_enable' '"false"'
}

function RetroArch_retroAchievementsHardCoreOn(){
	setConfigRA 'cheevos_hardcore_mode_enable' 'true' $RetroArch_configFile
}
function RetroArch_retroAchievementsHardCoreOff(){
	setConfigRA 'cheevos_hardcore_mode_enable' 'false' $RetroArch_configFile
}

function RetroArch_retroAchievementsSetLogin(){
	$rat=Get-Content $env:USERPROFILE/AppData/Roaming/EmuDeck/.rat -Raw
	$rau=Get-Content $env:USERPROFILE/AppData/Roaming/EmuDeck/.rau -Raw
	setConfigRA 'cheevos_token' $rat "$RetroArch_configFile"
	setConfigRA 'cheevos_username' $rau "$RetroArch_configFile"
	RetroArch_retroAchievementsOn
}

function RetroArch_setSNESAR(){
	if ( "$SNESAR" -eq 87 ){	
		RetroArch_snes_ar87
	}else{
		RetroArch_snes_ar43
	}
}
function RetroArch_setBezels(){
	if ( "$RABezels" -eq "true" ){	
		RetroArch_bezelOnAll
	}else{
		RetroArch_bezelOffAll
	}	
}
function RetroArch_setShadersCRT(){
	if ( "$RAHandClassic2D" -eq "true" ){	
		RetroArch_CRTshaderOnAll
	}else{
		RetroArch_CRTshaderOffAll
	}	
}
function RetroArch_setShaders3DCRT(){
	if ( "$RAHandClassic3D" -eq "true" ){	
		RetroArch_3DCRTshaderOnAll
	}else{
		RetroArch_3DCRTshaderOffAll
	}	
}
function RetroArch_setShadersMAT(){
	if ( "$RAHandHeldShader" -eq "true" ){	
		RetroArch_MATshadersOnAll
	}else{
		RetroArch_MATshadersOffAll
	}	
}

function RetroArch_MATshadersOnAll(){
	RetroArch_wswanc_MATshaderOn
	RetroArch_wswan_MATshaderOn
	RetroArch_lynx_MATshaderOn
	RetroArch_ngp_MATshaderOn
	RetroArch_ngpc_MATshaderOn
	RetroArch_gamegear_MATshaderOn
	RetroArch_gba_MATshaderOn
	RetroArch_gb_MATshaderOn
	RetroArch_gbc_MATshaderOn
}

function RetroArch_MATshadersOffAll(){
	RetroArch_wswanc_MATshaderOff
	RetroArch_wswan_MATshaderOff
	RetroArch_lynx_MATshaderOff
	RetroArch_ngp_MATshaderOff
	RetroArch_ngpc_MATshaderOff
	RetroArch_gamegear_MATshaderOff
	RetroArch_gba_MATshaderOff
	RetroArch_gb_MATshaderOff
	RetroArch_gbc_MATshaderOff
}

function RetroArch_3DCRTshaderOnAll{
	RetroArch_n64_3DCRTshaderOn
	RetroArch_dreamcast_3DCRTshaderOn
	RetroArch_saturn_3DCRTshaderOn
	RetroArch_psx_3DCRTshaderOn
}

function RetroArch_3DCRTshaderOffAll{
	RetroArch_n64_3DCRTshaderOff
	RetroArch_dreamcast_3DCRTshaderOff
	RetroArch_saturn_3DCRTshaderOff
	RetroArch_psx_3DCRTshaderOff
}


function RetroArch_CRTshaderOnAll(){
	RetroArch_pcengine_CRTshaderOn
	RetroArch_amiga1200_CRTshaderOn
	RetroArch_nes_CRTshaderOn
	RetroArch_atari2600_CRTshaderOn
	RetroArch_mame_CRTshaderOn
	RetroArch_neogeo_CRTshaderOn
	RetroArch_fbneo_CRTshaderOn
	RetroArch_segacd_CRTshaderOn
	RetroArch_genesis_CRTshaderOn
	RetroArch_mastersystem_CRTshaderOn
	RetroArch_sega32x_CRTshaderOn
	RetroArch_snes_CRTshaderOn

}

function RetroArch_CRTshaderOffAll(){
	RetroArch_pcengine_CRTshaderOff
	RetroArch_amiga1200_CRTshaderOff
	RetroArch_nes_CRTshaderOff
	RetroArch_atari2600_CRTshaderOff
	RetroArch_mame_CRTshaderOff
	RetroArch_neogeo_CRTshaderOff
	RetroArch_fbneo_CRTshaderOff
	RetroArch_segacd_CRTshaderOff
	RetroArch_genesis_CRTshaderOff
	RetroArch_mastersystem_CRTshaderOff
	RetroArch_sega32x_CRTshaderOff
	RetroArch_snes_CRTshaderOff

}


