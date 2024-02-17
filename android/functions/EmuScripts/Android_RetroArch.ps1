$Android_RetroArch_temp="$Android_temp_internal/RetroArch"
$Android_RetroArch_temp_android_data="$Android_temp_android_data/com.retroarch.aarch64"
$Android_RetroArch_configFile="$Android_RetroArch_temp/retroarch.cfg"


function Android_RetroArch_install(){
	setMSG "Installing RetroArch"
	$temp_url="https://buildbot.libretro.com/stable/1.16.0/android/RetroArch_aarch64.apk"
	$temp_emu="ra"
	Android_ADB_dl_installAPK $temp_emu $temp_url

	mkdir "$Android_RetroArch_temp/downloads" -ErrorAction SilentlyContinue

	setMSG "Downloading RetroArch Cores. This will take a while"
	mkdir "$Android_RetroArch_temp/downloads" -ErrorAction SilentlyContinue
	$RAcores = @("a5200_libretro_android.so","81_libretro_android.so","atari800_libretro_android.so","bluemsx_libretro_android.so","fbneo_libretro_android.so","freeintv_libretro_android.so","fuse_libretro_android.so","gw_libretro_android.so","hatari_libretro_android.so","mednafen_pcfx_libretro_android.so","mednafen_vb_libretro_android.so","mednafen_wswan_libretro_android.so","mu_libretro_android.so","neocd_libretro_android.so","nxengine_libretro_android.so","o2em_libretro_android.so","picodrive_libretro_android.so","pokemini_libretro_android.so","prboom_libretro_android.so","prosystem_libretro_android.so","px68k_libretro_android.so","quasi88_libretro_android.so","virtualjaguar_libretro_android.so","mednafen_lynx_libretro_android.so","mednafen_ngp_libretro_android.so","mednafen_pce_libretro_android.so","mednafen_saturn_libretro_android.so","mednafen_supergrafx_libretro_android.so","bluemsx_libretro_android.so","bsnes_libretro_android.so","cap32_libretro_android.so","crocods_libretro_android.so","desmume2015_libretro_android.so","desmume_libretro_android.so","dosbox_core_libretro_android.so","fbalpha2012_cps1_libretro_android.so","fbalpha2012_cps2_libretro_android.so","fbalpha2012_cps3_libretro_android.so","fbalpha2012_libretro_android.so","fbalpha2012_neogeo_libretro_android.so","fbneo_libretro_android.so","flycast_libretro_android.so","gambatte_libretro_android.so","genesis_plus_gx_libretro_android.so","genesis_plus_gx_wide_libretro_android.so","gpsp_libretro_android.so","handy_libretro_android.so","kronos_libretro_android.so","mame2000_libretro_android.so","mame2003_plus_libretro_android.so","mame2010_libretro_android.so","mame_libretro_android.so","melonds_libretro_android.so","mesen_libretro_android.so","mgba_libretro_android.so","mupen64plus_next_libretro_android.so","ppsspp_libretro_android.so","puae_libretro_android.so","snes9x_libretro_android.so","stella2014_libretro_android.so","stella_libretro_android.so","vice_x128_libretro_android.so","vice_x64_libretro_android.so","vice_x64sc_libretro_android.so","vice_xscpu64_libretro_android.so","yabasanshiro_libretro_android.so","yabause_libretro_android.so","bsnes_hd_beta_libretro_android.so","swanstation_libretro_android.so")
	$RAcores.count

	foreach ( $core in $RAcores )
	{
		$url= -join("http://buildbot.libretro.com/nightly/android/latest/arm64-v8a/",$core,".zip")
		Write-Output "Downloading $url"
		Android_downloadCore $url $core
	}
}
function Android_RetroArch_init(){
	$RetroArch_configFile="$Android_RetroArch_temp/retroarch.cfg"
	Remove-Item $RetroArch_configFile  -ErrorAction SilentlyContinue

	setMSG "RetroArch - Bezels & Filters"

	copyFromTo "$env:APPDATA/EmuDeck/backend/configs/RetroArch/" "$Android_RetroArch_temp/"
	copyFromTo "$env:APPDATA/EmuDeck/backend/android/configs/RetroArch/" "$Android_RetroArch_temp/"

	copyFromTo "$env:APPDATA/EmuDeck/backend/android/configs/Android/data/com.retroarch.aarch64/" "$Android_RetroArch_temp_android_data/"


	$path="$Android_RetroArch_temp/config"
	Get-ChildItem $path -Recurse -Filter *.cfg |
	Foreach-Object {
		$originFile=$_.FullName

		$origin="~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus/"
		$target="$Android_emusPath/RetroArch/overlays/pegasus/"

		sedFile $originFile $origin $target

		#Video Filters path
		$origin="/app/lib/retroarch/filters/video/"
		$target="$Android_emusPath/RetroArch/filters/video/"

		sedFile $originFile $origin $target

		setConfigRA "input_enable_hotkey_btn" 109 "$originFile"
		setConfigRA "input_hold_fast_forward_btn" 105 "$originFile"
		setConfigRA "input_load_state_btn" 102 "$originFile"
		setConfigRA "input_menu_toggle_gamepad_combo" 2 "$originFile"
		setConfigRA "input_quit_gamepad_combo" 4 "$originFile"
		setConfigRA "input_save_state_btn" 103 "$originFile"
		setConfigRA "input_exit_emulator_btn" 108 "$originFile"

	}

	setMSG "RetroArch - Shaders"
	Get-ChildItem $path -Recurse -Filter *.glslp |
	Foreach-Object {
		$originFile=$_.FullName

		$origin="/app/share/libretro/shaders/"
		$target=":/shaders/"
		sedFile $originFile $origin $target
	}
	$path="$Android_RetroArch_temp/config"
	Get-ChildItem $path -Recurse -Filter *.slangp |
	Foreach-Object {
		$originFile=$_.FullName

		$origin="/app/share/libretro/shaders/"
		$target=":/shaders/"
		sedFile $originFile $origin $target
	}

	#retroAchievements
	if ("$achievementsUserToken" -ne "" ){
		RetroArch_retroAchievementsSetLogin
		if ( "$achievementsHardcore" -eq "true" ){
			RetroArch_retroAchievementsHardCoreOn
		}else{
			RetroArch_retroAchievementsHardCoreOff
		}
	}

	#RA Bezels
	RetroArch_setBezels #needs to change

	#RA AutoSave
	if ( "$RAautoSave" -eq "true" ){
		RetroArch_autoSaveOn
	}else{
		RetroArch_autoSaveOff
	}


	#
	#New Shaders
	#Moved before widescreen, so widescreen disabled if needed.
	#

	RetroArch_setShadersCRT
	RetroArch_setShaders3DCRT
	RetroArch_setShadersMAT


	#
	#New Aspect Ratios
	#

	#Sega Games
	#Master System
	#Genesis
	#Sega CD
	#Sega 32X

	switch ($arSega){
	  32 {
		RetroArch_mastersystem_ar32;
		RetroArch_genesis_ar32;
		RetroArch_segacd_ar32
		RetroArch_sega32x_ar32
	  }
	  43 {
		RetroArch_mastersystem_ar43
		RetroArch_genesis_ar43
		RetroArch_segacd_ar43
		RetroArch_sega32x_ar43
		if ( "$RABezels" -eq "true"){
			if ("$doSetupRA" -eq "true" ){
			  RetroArch_mastersystem_bezelOn
			  RetroArch_genesis_bezelOn
			  RetroArch_segacd_bezelOn
			  RetroArch_sega32x_bezelOn
			}
		}
	  }
	}

	#Snes and NES
	switch ($arSnes){
	  87{
		RetroArch_snes_ar87
		RetroArch_nes_ar87
	  }
	  43{
		RetroArch_snes_ar43
		RetroArch_nes_ar43
		if ( "$RABezels" -eq "true" ){
			if( "$doSetupRA" -eq "true" ){
				RetroArch_snes_bezelOn
			}
		}
	  }
	}

	# Classic 3D Games
		#Dreamcast
		#PSX
		#Nintendo 64
		#Saturn
		#Xbox
	if ( "$arClassic3D" -eq 169 ){
			RetroArch_Beetle_PSX_HW_wideScreenOn
			RetroArch_Flycast_wideScreenOn
			RetroArch_dreamcast_bezelOff
			RetroArch_psx_bezelOff
			RetroArch_n64_wideScreenOn
			RetroArch_SwanStation_wideScreenOn
	}else{
		#"SET 4:3"
		RetroArch_Flycast_wideScreenOff
		RetroArch_n64_wideScreenOff
		RetroArch_Beetle_PSX_HW_wideScreenOff
		RetroArch_SwanStation_wideScreenOff


		if ( "$RABezels" -eq "true" ){
			if( "$doSetupRA" -eq "true" ){
			RetroArch_dreamcast_bezelOn
			RetroArch_n64_bezelOn
			RetroArch_psx_bezelOn
			}
		}
	}

	#Saves
	Android_RetroArch_setupSaves

	#Paths
	sedFile "$Android_RetroArch_temp_android_data/files/retroarch.cfg" "/storage/emulated/0" "$androidStoragePath"

	#Emu CFG
	Android_ADB_push $Android_RetroArch_temp /storage/emulated/0

	#Emu Android Data
	Android_ADB_push $Android_RetroArch_temp_android_data  /storage/emulated/0/Android/data/com.retroarch.aarch64

}
function Android_RetroArch_update(){
	Write-Output "NYI"
}
function Android_RetroArch_setEmulationFolder(){
	Write-Output "NYI"
}
function Android_RetroArch_setupSaves(){
	if ( $androidStoragePath -like "*-*" ){
		mkdir "$Android_temp_external/Emulation/saves/RetroArch/saves" -ErrorAction SilentlyContinue
		mkdir "$Android_temp_external/Emulation/saves/RetroArch/states" -ErrorAction SilentlyContinue
	}else{
		mkdir "$Android_temp_internal/Emulation/saves/RetroArch/saves" -ErrorAction SilentlyContinue
		mkdir "$Android_temp_internal/Emulation/saves/RetroArch/states"	 -ErrorAction SilentlyContinue
	}



}

function Android_RetroArch_setOverride($fileToCheck, $name, $key, $value){
	$path="$Android_RetroArch_temp/config"
	Get-ChildItem $path -Recurse -Filter $fileToCheck |
	Foreach-Object {
		$originFile=$_.FullName
		setConfigRA $key $value $originFile
	}
}

function Android_RetroArch_bezelOnAll(){
	$path="$Android_RetroArch_temp/config"
	Get-ChildItem $path -Recurse -Filter *.cfg |
	Foreach-Object {
		$originFile=$_.FullName
		setConfigRA "input_overlay_enable" "true" $originFile
	}
}

function Android_RetroArch_bezelOffAll(){
	$path="$Android_RetroArch_temp/config"
	Get-ChildItem $path -Recurse -Filter *.cfg |
	Foreach-Object {
		$originFile=$_.FullName
		setConfigRA "input_overlay_enable" "false" $originFile
	}
}

function Android_RetroArch_setupStorage(){
	Write-Output "NYI"
}

function Android_RetroArch_setupStorage(){
	Write-Output "NYI"
}
function Android_RetroArch_wipe(){
	Write-Output "NYI"
}
function Android_RetroArch_uninstall(){
	Remove-Item -path "$Android_RetroArch_temp"-recurse -force
	if($?){
		Write-Output "true"
	}
}
function Android_RetroArch_migrate(){
	Write-Output "NYI"
}
function Android_RetroArch_setABXYstyle(){
	Write-Output "NYI"
}
function Android_RetroArch_wideScreenOn(){
	Write-Output "NYI"
}
function Android_RetroArch_wideScreenOff(){
	Write-Output "NYI"
}
function Android_RetroArch_bezelOn(){
	Write-Output "NYI"
}
function Android_RetroArch_bezelOff(){
	Write-Output "NYI"
}
function Android_RetroArch_finalize(){
	Write-Output "NYI"
}
function Android_RetroArch_IsInstalled(){
	Write-Output "NYI"
}
function Android_RetroArch_resetConfig{
	Android_RetroArch_init
	if($?){
		Write-Output "true"
	}
}


function Android_RetroArch_wswanc_setConfig(){
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle Cygne"  "input_player1_analog_dpad_mode" "1"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle WonderSwan"  "input_player1_analog_dpad_mode" "1"
}
function Android_RetroArch_wswanc_bezelOn(){
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle Cygne"  "input_overlay_enable" "false"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle WonderSwan"  "input_overlay_enable" "false"
}
function Android_RetroArch_wswanc_bezelOff(){
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle Cygne"  "input_overlay_enable" "false"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle WonderSwan"  "input_overlay_enable" "false"
}
function Android_RetroArch_wswanc_MATshaderOn(){
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle Cygne"  "video_shader_enable" "true"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle Cygne"	"video_filter" "ED_RM_LINE"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle Cygne"	"video_smooth" "false"

	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle WonderSwan"  "video_shader_enable" "true"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle WonderSwan"	 "video_filter" "ED_RM_LINE"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle WonderSwan"	 "video_smooth" "false"
}

function Android_RetroArch_wswanc_MATshaderOff(){
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle Cygne"  "video_shader_enable" "false"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle Cygne"	"video_filter" "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle Cygne"	"video_smooth" "true"

	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle WonderSwan"  "video_shader_enable" "false"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle WonderSwan"	 "video_filter" "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride "wonderswancolor.cfg" "Beetle WonderSwan"	 "video_smooth" "true"
}

function Android_RetroArch_wswan_setConfig(){
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle Cygne"  "input_player1_analog_dpad_mode" "1"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle WonderSwan"  "input_player1_analog_dpad_mode" "1"
}
function Android_RetroArch_wswan_bezelOn(){
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle Cygne"  "input_overlay_enable" "false"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle WonderSwan"  "input_overlay_enable" "false"
}

function Android_RetroArch_wswan_bezelOff(){
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle Cygne"  "input_overlay_enable" "false"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle WonderSwan"  "input_overlay_enable" "false"
}

function Android_RetroArch_wswan_MATshaderOn(){
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle Cygne"  "video_shader_enable" "true"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle Cygne"	"video_filter" "ED_RM_LINE"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle Cygne"	"video_smooth" "false"

	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle WonderSwan"  "video_shader_enable" "true"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle WonderSwan"	 "video_filter" "ED_RM_LINE"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle WonderSwan"	 "video_smooth" "false"
}

function Android_RetroArch_wswan_MATshaderOff(){
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle Cygne"  "video_shader_enable" "false"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle Cygne"	"video_filter" "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle Cygne"	"video_smooth" "true"

	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle WonderSwan"  "video_shader_enable" "false"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle WonderSwan"	 "video_filter" "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride "wonderswan.cfg" "Beetle WonderSwan"	 "video_smooth" "true"
}

function Android_RetroArch_dolphin_emu_setConfig(){
	Android_RetroArch_setOverride "dolphin_emu.cfg" "dolphin_emu"  "video_driver" "gl"
	Android_RetroArch_setOverride "dolphin_emu.cfg" "dolphin_emu"  "video_driver" "gl"
}

function Android_RetroArch_PPSSPP_setConfig(){
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_auto_frameskip" "disabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_block_transfer_gpu" "enabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_button_preference" "Cross"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_cheats" "disabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_cpu_core" "JIT"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_disable_slow_framebuffer_effects" "disabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_fast_memory" "enabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_force_lag_sync" "disabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_frameskip" "Off"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_frameskiptype" "Number"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_gpu_hardware_transform" "enabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_ignore_bad_memory_access" "enabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_inflight_frames" "Up"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_internal_resolution" "1440x816"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_io_timing_method" "Fast"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_language" "Automatic"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_lazy_texture_caching" "disabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_locked_cpu_speed" "off"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_lower_resolution_for_effects" "Off"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_rendering_mode" "Buffered"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_retain_changed_textures" "disabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_software_skinning" "enabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_spline_quality" "Low"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_texture_anisotropic_filtering" "off"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_texture_deposterize" "disabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_texture_filtering" "Auto"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_texture_replacement" "enabled"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_texture_scaling_level" "Off"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_texture_scaling_type" "xbrz"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_texture_shader" "Off"
	Android_RetroArch_setOverride "psp.cfg" "PPSSPP"  "ppsspp_vertex_cache" "disabled"
}

function Android_RetroArch_pcengine_setConfig(){
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "input_player1_analog_dpad_mode" "1"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "input_player1_analog_dpad_mode" "1"
}
function Android_RetroArch_pcengine_bezelOn(){
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "aspect_ratio_index" "21"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "custom_viewport_height" "1200"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "custom_viewport_x" "0"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "input_overlay" "$Android_emusPath/RetroArch/overlays/pegasus/pcengine.cfg"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "input_overlay_aspect_adjust_landscape" "-0.150000"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "input_overlay_enable" "true"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "input_overlay_scale_landscape" "1.075000"

	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "aspect_ratio_index" "21"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "custom_viewport_height" "1200"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "custom_viewport_x" "0"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "input_overlay" "$Android_emusPath/RetroArch/overlays/pegasus/pcengine.cfg"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "input_overlay_aspect_adjust_landscape" "-0.150000"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "input_overlay_enable" "true"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "input_overlay_scale_landscape" "1.075000"

}

function Android_RetroArch_pcengine_bezelOff(){
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "input_overlay_enable" "false"

	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "input_overlay_enable" "false"
}

function Android_RetroArch_pcengine_CRTshaderOn(){
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "video_shader_enable" "true"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"	"video_filter" "ED_RM_LINE"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"	"video_smooth" "false"

	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"  "video_shader_enable" "true"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"	"video_filter" "ED_RM_LINE"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE"	"video_smooth" "false"
}

function Android_RetroArch_pcengine_CRTshaderOff(){
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"  "video_shader_enable" "false"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"	"video_filter" "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride "pcengine.cfg" "Beetle PCE Fast"	"video_smooth" '"true"'

	Android_RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'pcengine.cfg' 'Beetle PCE'	'video_smooth' '"true"'
}

function Android_RetroArch_amiga1200_CRTshaderOff(){
	Android_RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_smooth' '"true"'
}

function Android_RetroArch_amiga1200_CRTshaderOn(){
	Android_RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'amiga1200.cfg' 'PUAE'  'video_smooth' '"false"'
}

function Android_RetroArch_amiga1200_setUpCoreOpt(){
	Android_RetroArch_setOverride 'amiga1200.opt' 'PUAE'  'puae_model' '"A1200"'
}

function Android_RetroArch_nes_setConfig(){
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_nes_bezelOn(){
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/nes.cfg"
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_opacity' '"0.700000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_scale_landscape' '"1.070000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_aspect_adjust_landscape' '"0.100000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'video_scale_integer' '"false"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/nes.cfg"
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_opacity' '"0.700000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_scale_landscape' '"1.070000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_aspect_adjust_landscape' '"0.100000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'video_scale_integer' '"false"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'aspect_ratio_index' '"0"'
}

function Android_RetroArch_nes_bezelOff(){
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_nes_CRTshaderOn(){
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'	'video_smooth' '"false"'

	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'	'video_smooth' '"false"'
}

function Android_RetroArch_nes_CRTshaderOff(){
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'	'video_smooth' '"true"'

	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'	'video_smooth' '"true"'
}

function Android_RetroArch_nes_ar43(){
	#Android_RetroArch_nes_bezelOn
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'aspect_ratio_index' '"0"'
}

function Android_RetroArch_nes_ar87(){
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_scale_landscape' '"1.380000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'input_overlay_aspect_adjust_landscape' '"-0.170000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'aspect_ratio_index' '"15"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_scale_landscape' '"1.380000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'input_overlay_aspect_adjust_landscape' '"-0.170000"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'aspect_ratio_index' '"15"'
}

function Android_RetroArch_nes_ar32(){
	Android_RetroArch_setOverride 'nes.cfg' 'Nestopia'  'aspect_ratio_index' '"7"'
	Android_RetroArch_setOverride 'nes.cfg' 'Mesen'  'aspect_ratio_index' '"7"'
	Android_RetroArch_nes_bezelOff
}

function Android_RetroArch_Mupen64Plus_Next_setConfig(){
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_crop_overscan' '"false"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_smooth' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_auto_scale'  '"false"'
}

function  Android_RetroArch_n64_3DCRTshaderOn(){
	 Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_smooth' 'ED_RM_LINE'
 }

function Android_RetroArch_n64_3DCRTshaderOff(){
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'video_smooth' 'ED_RM_LINE'
}

function Android_RetroArch_n64_setConfig(){
	Android_RetroArch_n64_3DCRTshaderOff
}

function Android_RetroArch_lynx_setConfig(){
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_lynx_bezelOn(){
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/lynx.cfg"
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_opacity' '"0.700000"'
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_scale_landscape' '"1.055000"'
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'video_scale_integer' '"false"'

	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/lynx.cfg"
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_opacity' '"0.700000"'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_scale_landscape' '"1.055000"'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'video_scale_integer' '"false"'
}

function Android_RetroArch_lynx_bezelOff(){
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_lynx_MATshaderOn(){
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'	'video_smooth' '"false"'

	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'	'video_smooth' '"false"'
}

function Android_RetroArch_lynx_MATshaderOff(){
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'  'video_shader_enable' 'false'
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'lynx.cfg' 'Beetle Lynx'	'video_smooth' '"true"'

	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'  'video_shader_enable' 'false'
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'atarilynx.cfg' 'Handy'	'video_smooth' '"true"'
}


function Android_RetroArch_SameBoy_gb_setConfig(){
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_dark_filter_level' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_bootloader' '"enabled"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_colorization' '"internal"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_hwmode' '"Auto"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_internal_palette' '"GB'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_mode' '"Not'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_port' '"56400"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_1' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_10' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_11' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_12' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_2' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_3' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_4' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_5' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_6' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_7' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_8' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_link_network_server_ip_9' '"0"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_palette_twb64_1' '"TWB64'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_gb_palette_twb64_2' '"TWB64'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_mix_frames' '"disabled"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_rumble_level' '"10"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_show_gb_link_settings' '"disabled"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_turbo_period' '"4"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'gambatte_up_down_allowed' '"disabled"'
}

function Android_RetroArch_ngp_setConfig(){
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_ngp_bezelOn(){
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/ngpc.cfg"
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_aspect_adjust_landscape' '"-0.310000"'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_hide_in_menu' '"false"'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_scale_landscape' '"1.625000"'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_x_separation_portrait' '"-0.010000"'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_y_offset_landscape' '"-0.135000"'
}

function Android_RetroArch_ngp_bezelOff(){
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_ngp_MATshaderOn(){
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'	 'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'	 'video_smooth' '"false"'
}

function Android_RetroArch_ngp_MATshaderOff(){
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'  'video_shader_enable' 'false'
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'	 'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'ngp.cfg' 'Beetle NeoPop'	 'video_smooth' '"true"'
}

function Android_RetroArch_ngpc_setConfig(){
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_ngpc_bezelOn(){
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/ngpc.cfg"
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_aspect_adjust_landscape' '"-0.170000"'
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_scale_landscape' '"1.615000"'
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_x_separation_portrait' '"-0.010000"'
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_y_offset_landscape' '"-0.135000"'
}

function Android_RetroArch_ngpc_bezelOff(){
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_ngpc_MATshaderOn(){
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'	 'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'	 'video_smooth' '"false"'
}

function Android_RetroArch_ngpc_MATshaderOff(){
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'  'video_shader_enable' 'false'
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'	 'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'ngpc.cfg' 'Beetle NeoPop'	 'video_smooth' '"true"'
}

function Android_RetroArch_atari2600_setConfig(){
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_atari2600_bezelOn(){
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/atari2600.cfg"
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_overlay_aspect_adjust_landscape' '"0.095000"'
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'  'input_overlay_scale_landscape' '"1.070000"'
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'  'aspect_ratio_index' '"0"'
}

function Android_RetroArch_atari2600_bezelOff(){
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella' 'input_overlay_enable' '"false"'
}

function Android_RetroArch_atari2600_CRTshaderOn(){
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella' 'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'	'video_smooth' '"false"'
}

function Android_RetroArch_atari2600_CRTshaderOff(){
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella' 'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'atari2600.cfg' 'Stella'	'video_smooth' '"true"'
}

function Android_RetroArch_mame_setConfig(){
	Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME'  'cheevos_enable = "false"'
}

function Android_RetroArch_mame_bezelOn(){
	Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_mame_bezelOff(){
	Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_mame_CRTshaderOn(){
	Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'   'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'	'video_smooth' '"false"'

	Android_RetroArch_setOverride 'mame.cfg' 'MAME'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME'	'video_smooth' '"false"'
}

function Android_RetroArch_mame_CRTshaderOff(){
	Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'video_shader_enable' 'false'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'	'video_smooth' '"true"'

	Android_RetroArch_setOverride 'mame.cfg' 'MAME'  'video_shader_enable' 'false'
	Android_RetroArch_setOverride 'mame.cfg' 'MAME'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'mame.cfg' 'MAME'	'video_smooth' '"true"'
}

function Android_RetroArch_neogeo_bezelOn(){
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/neogeo.cfg"
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_hide_in_menu' '"false"'
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_scale_landscape' '"1.055000'
}

function Android_RetroArch_neogeo_bezelOff(){
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_neogeo_CRTshaderOn(){
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo' 'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'	'video_smooth' '"false"'
}

function Android_RetroArch_neogeo_CRTshaderOff(){
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo' 'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'neogeo.cfg' 'FinalBurn Neo'	'video_smooth' '"true"'
}

function Android_RetroArch_fbneo_bezelOn(){
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/neogeo.cfg"
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_hide_in_menu' '"false"'
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_scale_landscape' '"1.055000'
}

function Android_RetroArch_fbneo_bezelOff(){
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_fbneo_CRTshaderOn(){
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo' 'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'	'video_smooth' '"false"'
}

function Android_RetroArch_fbneo_CRTshaderOff(){
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo' 'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'fbneo.cfg' 'FinalBurn Neo'	'video_smooth' '"true"'
}


function Android_RetroArch_segacd_setConfig(){
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_segacd_bezelOn(){
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/segacd.cfg"
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_hide_in_menu' '"false"'
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.055000'
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"0"'

	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/segacd.cfg"
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_hide_in_menu' '"false"'
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.055000'
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"0"'
}
function Android_RetroArch_segacd_bezelOff(){
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_segacd_CRTshaderOn(){
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
}

function Android_RetroArch_segacd_CRTshaderOff(){
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
}


function Android_RetroArch_segacd_ar32(){
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	Android_RetroArch_segacd_bezelOff
}
function Android_RetroArch_segacd_ar43(){
	Android_RetroArch_setOverride 'segacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'megacd.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'
}

function Android_RetroArch_genesis_setConfig(){
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_genesis_bezelOn(){
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/genesis.cfg"
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.055000"'
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"0"'

	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/genesis.cfg"
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.055000"'
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"0"'

}


function Android_RetroArch_genesis_bezelOff(){
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_genesis_ar32(){
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	Android_RetroArch_genesis_bezelOff
}

function Android_RetroArch_genesis_ar43(){
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'
}

function Android_RetroArch_genesis_CRTshaderOn(){
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'	'video_smooth' '"false"'

	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'	'video_smooth' '"false"'
}

function Android_RetroArch_genesis_CRTshaderOff(){
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'genesis.cfg' 'Genesis Plus GX'	'video_smooth' '"true"'

	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'megadrive.cfg' 'Genesis Plus GX'	'video_smooth' '"true"'
}

function Android_RetroArch_gamegear_setConfig(){
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_gamegear_bezelOn(){
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/gg.cfg"
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_aspect_adjust_landscape' '"-0.115000"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.545000"'

	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/gg.cfg"
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_aspect_adjust_landscape' '"-0.115000"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_scale_landscape' '"1.545000"'
}

function Android_RetroArch_gamegear_bezelOff(){
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'

	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_gamegear_MATshaderOn(){
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'	'video_smooth' '"false"'

	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'	'video_smooth' '"false"'
}

function Android_RetroArch_gamegear_MATshaderOff(){
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'gamegear.cfg' 'Genesis Plus GX'	'video_smooth' '"true"'

	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'gamegear.cfg' 'Gearsystem'	'video_smooth' '"true"'
}

function Android_RetroArch_mastersystem_setConfig(){
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_mastersystem_bezelOn(){
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/mastersystem.cfg"
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay_scale_landscape' '"1.055000"'
}

function Android_RetroArch_mastersystem_bezelOff(){
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_mastersystem_ar32(){
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"7"'
	Android_RetroArch_mastersystem_bezelOff
}

function Android_RetroArch_mastersystem_CRTshaderOn(){
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'	'video_smooth' '"false"'
}

function Android_RetroArch_mastersystem_CRTshaderOff(){
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'	'video_smooth' '"true"'
}

function Android_RetroArch_mastersystem_ar43(){
	Android_RetroArch_setOverride 'mastersystem.cfg' 'Genesis Plus GX'  'aspect_ratio_index' '"21"'
}
function Android_RetroArch_sega32x_setConfig(){
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_player1_analog_dpad_mode' '"1"'
}
function Android_RetroArch_sega32x_bezelOn(){
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/sega32x.cfg"
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_hide_in_menu' '"false"'
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_scale_landscape' '"1.070000"'
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_aspect_adjust_landscape' '"0.095000"'
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'aspect_ratio_index' '"0"'
}

function Android_RetroArch_sega32x_bezelOff(){
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_sega32x_CRTshaderOn(){
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'	 'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'	 'video_smooth' '"false"'
}

function Android_RetroArch_sega32x_CRTshaderOff(){
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'	 'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'	 'video_smooth' '"true"'
}

function Android_RetroArch_sega32x_ar32(){
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'aspect_ratio_index' '"7"'
	Android_RetroArch_sega32x_bezelOff
}

function Android_RetroArch_sega32x_ar43(){
	Android_RetroArch_setOverride 'sega32x.cfg' 'PicoDrive'  'aspect_ratio_index' '"21"'
	Android_RetroArch_sega32x_bezelOff
}

#function Android_RetroArch_gba_bezelOn(){
#	#missing stuff?
#	Android_RetroArch_setOverride 'gba.cfg' 'mGBA'  'aspect_ratio_index' '"21"'
#}
function Android_RetroArch_gba_setConfig(){
	Android_RetroArch_setOverride 'gba.cfg' 'mGBA'  'input_player1_analog_dpad_mode' '"1"'
}
function Android_RetroArch_gba_MATshaderOn(){
	Android_RetroArch_setOverride 'gba.cfg' 'mGBA'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'gba.cfg' 'mGBA'	 'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'gba.cfg' 'mGBA'	 'video_smooth' '"false"'
}

function Android_RetroArch_gba_MATshaderOff(){
	Android_RetroArch_setOverride 'gba.cfg' 'mGBA'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'gba.cfg' 'mGBA'	 'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'gba.cfg' 'mGBA'	 'video_smooth' '"true"'
}

function Android_RetroArch_gb_bezelOn(){
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/gb.cfg"
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_scale_landscape' '"1.860000"'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_y_offset_landscape' '"-0.150000"'

	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/gb.cfg"
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_scale_landscape' '"1.860000"'
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_y_offset_landscape' '"-0.150000"'
}

function Android_RetroArch_gb_setConfig(){
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_gb_bezelOff(){
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'input_overlay_enable' '"false"'


	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_gb_MATshaderOn(){
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'	 'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'	 'video_smooth' '"false"'

	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'	 'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'	 'video_smooth' '"false"'
}

function Android_RetroArch_gb_MATshaderOff(){
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'  'video_shader_enable' 'false'
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'	 'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'gb.cfg' 'SameBoy'	 'video_smooth' '"true"'

	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'	 'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'gb.cfg' 'Gambatte'	 'video_smooth' '"true"'
}

function Android_RetroArch_SameBoy_gbc_setConfig(){
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'gambatte_gbc_color_correction' '"GBC'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'gambatte_gbc_color_correction_mode' '"accurate"'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'gambatte_gbc_frontlight_position' '"central"'
}


function Android_RetroArch_gbc_setConfig(){
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_gbc_bezelOn(){
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/gbc.cfg"
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_scale_landscape' '"1.870000"'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_y_offset_landscape' '"-0.220000"'

	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'aspect_ratio_index' '"21"'
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/gbc.cfg"
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_scale_landscape' '"1.870000"'
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_y_offset_landscape' '"-0.220000"'
}

function Android_RetroArch_gbc_bezelOff(){
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'input_overlay_enable' '"false"'


	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_gbc_MATshaderOn(){
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'	 'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'	 'video_smooth' '"false"'

	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'	 'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'	 'video_smooth' '"false"'
}

function Android_RetroArch_gbc_MATshaderOff(){
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'  'video_shader_enable' 'false'
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'	 'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'gbc.cfg' 'SameBoy'	 'video_smooth' '"true"'

	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'  'video_shader_enable' 'false'
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'	 'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'gbc.cfg' 'Gambatte'	 'video_smooth' '"true"'
}

function Android_RetroArch_n64_wideScreenOn(){
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-aspect' '"16:9 adjusted"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'aspect_ratio_index' '"1"'
	Android_RetroArch_n64_bezelOff
	Android_RetroArch_n64_3DCRTshaderOff
}

function Android_RetroArch_n64_wideScreenOff(){
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-aspect' '"4:3"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'aspect_ratio_index' '"0"'
	#Android_RetroArch_n64_bezelOn
}

function Android_RetroArch_n64_bezelOn(){
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/N64.cfg"
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_aspect_adjust_landscape' '"0.085000"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_scale_landscape' '"1.065000"'
}

function Android_RetroArch_n64_bezelOff(){
	Android_RetroArch_setOverride 'n64.cfg' 'Mupen64Plus-Next'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_atari800_setConfig(){
	Android_RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_atari800_bezelOn(){
	Android_RetroArch_setOverride 'atari800.cfg' 'Stella'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/atari800.cfg"
	Android_RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_hide_in_menu' '"true"'
	Android_RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_scale_landscape' '"1.175000"'
	Android_RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_aspect_adjust_landscape' '"0.000000"'
}

function Android_RetroArch_atari800_bezelOff(){
	Android_RetroArch_setOverride 'atari800.cfg' 'Stella'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_atari5200_setConfig(){
	Android_RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_atari5200_bezelOn(){
	Android_RetroArch_setOverride 'atari5200.cfg' 'Stella'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/atari5200.cfg"
	Android_RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_hide_in_menu' '"true"'
	Android_RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_scale_landscape' '"1.175000"'
	Android_RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_aspect_adjust_landscape' '"0.000000"'
}

function Android_RetroArch_atari5200_bezelOff(){
	Android_RetroArch_setOverride 'atari5200.cfg' 'Stella'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_dreamcast_bezelOn(){
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/Dreamcast.cfg"
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay_aspect_adjust_landscape' '"0.110000"'
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay_scale_landscape' '"1.054998"'
}

function Android_RetroArch_dreamcast_bezelOff(){
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'input_overlay_enable' '"false"'
}

#temporary
function Android_RetroArch_Flycast_bezelOff(){
	Android_RetroArch_dreamcast_bezelOff
}

function Android_RetroArch_Flycast_bezelOn(){
	Android_RetroArch_dreamcast_bezelOn
}

function Android_RetroArch_Beetle_PSX_HW_bezelOff(){
	Android_RetroArch_psx_bezelOff
}

function Android_RetroArch_Beetle_PSX_HW_bezelOn(){
	Android_RetroArch_psx_bezelOn
}

function  Android_RetroArch_dreamcast_3DCRTshaderOn(){
	 Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'	'video_smooth' 'ED_RM_LINE'
 }

function Android_RetroArch_dreamcast_setConfig(){
	Android_RetroArch_dreamcast_3DCRTshaderOff
}

function Android_RetroArch_dreamcast_3DCRTshaderOff(){
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'	'video_smooth' 'ED_RM_LINE'
}

function Android_RetroArch_saturn_setConfig(){
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_player1_analog_dpad_mode' '"1"'
	Android_RetroArch_saturn_3DCRTshaderOff
}

function Android_RetroArch_saturn_bezelOn(){
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/saturn.cfg"
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay_scale_landscape' '"1.070000"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay_aspect_adjust_landscape' '"0.095000"'

	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/saturn.cfg"
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay_scale_landscape' '"1.070000"'
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay_aspect_adjust_landscape' '"0.095000"'


	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/saturn.cfg"
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay_scale_landscape' '"1.070000"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay_aspect_adjust_landscape' '"0.095000"'

	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/saturn.cfg"
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay_scale_landscape' '"1.070000"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay_aspect_adjust_landscape' '"0.095000"'
}

function Android_RetroArch_saturn_bezelOff(){
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'input_overlay_enable' '"false"'
}

function  Android_RetroArch_saturn_3DCRTshaderOn(){
	 Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'	'video_smooth' 'ED_RM_LINE'

	 Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'	'video_smooth' 'ED_RM_LINE'

	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'	'video_smooth' 'ED_RM_LINE'

	 Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'	'video_smooth' 'ED_RM_LINE'
 }

function Android_RetroArch_saturn_3DCRTshaderOff(){
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'  'video_shader_enable' '"false"'

	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'saturn.cfg' 'Yabause'	'video_smooth' 'ED_RM_LINE'

	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'saturn.cfg' 'YabaSanshiro'	'video_smooth' 'ED_RM_LINE'

	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'saturn.cfg' 'Kronos'	'video_smooth' 'ED_RM_LINE'

	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'saturn.cfg' 'Beetle Saturn'	'video_smooth' 'ED_RM_LINE'
}

function Android_RetroArch_snes_setConfig(){
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_player1_analog_dpad_mode' '"1"'
}

function Android_RetroArch_snes_bezelOn(){
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/snes.cfg"
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_auto_scale' '"false"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_opacity' '"0.700000"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'video_scale_integer' '"false"'
}

function Android_RetroArch_snes_bezelOff(){
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_enable' '"false"'
}

function Android_RetroArch_snes_CRTshaderOn(){
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'video_shader_enable' '"true"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'	'video_smooth' '"false"'
}

function Android_RetroArch_snes_CRTshaderOff(){
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'	'video_filter' "$Android_emusPath/RetroArch/filters/video/Normal4x.filt"
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'	'video_smooth' '"true"'
}

function Android_RetroArch_snes_ar43(){
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_scale_landscape' '"1.055000"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_aspect_adjust_landscape' '"0"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/snes.cfg"
}

function Android_RetroArch_snes_ar87(){
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay' "$Android_emusPath/RetroArch/overlays/pegasus/snes87.cfg"
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_scale_landscape' '"1.380000"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'input_overlay_aspect_adjust_landscape' '"-0.170000"'
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'aspect_ratio_index' '"15"'
}

function Android_RetroArch_snes_ar32(){
	Android_RetroArch_setOverride 'snes.cfg' 'Snes9x'  'aspect_ratio_index' '"7"'
	Android_RetroArch_snes_bezelOff
}


#function Android_RetroArch_bsnes_hd_beta_bezelOn(){
# 	Android_RetroArch_setOverride 'sneshd.cfg' 'bsnes-hd beta'  'video_scale_integer' '"false"'
# }

function Android_RetroArch_melonDS_setUpCoreOpt(){
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_audio_bitrate' '"Automatic"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_audio_interpolation' '"None"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_boot_directly' '"enabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_console_mode' '"DS"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_dsi_sdcard' '"disabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_hybrid_ratio' '"2"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_hybrid_small_screen' '"Duplicate"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_block_size' '"32"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_branch_optimisations' '"enabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_enable' '"enabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_fast_memory' '"enabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_jit_literal_optimisations' '"enabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_opengl_better_polygons' '"enabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_opengl_filtering' '"nearest"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_opengl_renderer' '"enabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_opengl_resolution' '"5x native (1280x960)"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_randomize_mac_address' '"disabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_screen_gap' '"0"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_screen_layout' '"Hybrid Bottom"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_swapscreen_mode' '"Toggle"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_threaded_renderer' '"disabled"'
	Android_RetroArch_setOverride 'melonDS.opt' 'melonDS'  'melonds_touch_mode' '"Touch"'
}

function Android_RetroArch_melonDS_setConfig(){
	Android_RetroArch_setOverride 'nds.cfg' 'melonDS'  'rewind_enable' '"false"'
}

function Android_RetroArch_Mupen64Plus_Next_setUpCoreOpt(){
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-169screensize' '"1920x1080"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-43screensize' '"1280x960"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-alt-map' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-angrylion-multithread' '"all threads"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-angrylion-overscan' '"disabled"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-angrylion-sync' '"Low"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-angrylion-vioverlay' '"Filtered"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-aspect' '"4:3"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-astick-deadzone' '"15"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-astick-sensitivity' '"100"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-BackgroundMode' '"OnePiece"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-BilinearMode' '"standard"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-CorrectTexrectCoords' '"Auto"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-CountPerOp' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-CountPerOpDenomPot' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-cpucore' '"dynamic_recompiler"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-d-cbutton' '"C3"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-DitheringPattern' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-DitheringQuantization' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableCopyAuxToRDRAM' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableCopyColorToRDRAM' '"Async"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableCopyDepthToRDRAM' '"Software"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableEnhancedHighResStorage' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableEnhancedTextureStorage' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableFBEmulation' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableFragmentDepthWrite' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableHiResAltCRC' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableHWLighting' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableInaccurateTextureCoordinates' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableLegacyBlending' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableLODEmulation' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableN64DepthCompare' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableNativeResFactor' '"4"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableNativeResTexrects' '"Optimized"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableOverscan' '"Enabled"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableShadersStorage' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableTexCoordBounds' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-EnableTextureCache' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-ForceDisableExtraMem' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-FrameDuping' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-Framerate' '"Fullspeed"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-FXAA' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-GLideN64IniBehaviour' '"late"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-HybridFilter' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-IgnoreTLBExceptions' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-l-cbutton' '"C2"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-MaxHiResTxVramLimit' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-MaxTxCacheSize' '"8000"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-MultiSampling' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-OverscanBottom' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-OverscanLeft' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-OverscanRight' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-OverscanTop' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-pak1' '"memory"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-pak2' '"none"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-pak3' '"none"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-pak4' '"none"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-deinterlace-method' '"Bob"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-dither-filter' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-divot-filter' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-downscaling' '"disable"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-gamma-dither' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-native-tex-rect' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-native-texture-lod' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-overscan' '"0"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-super-sampled-read-back' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-super-sampled-read-back-dither' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-synchronous' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-upscaling' '"1x"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-vi-aa' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-parallel-rdp-vi-bilinear' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-r-cbutton' '"C1"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-rdp-plugin' '"gliden64"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-RDRAMImageDitheringMode' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-rsp-plugin' '"hle"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-ThreadedRenderer' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txCacheCompression' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txEnhancementMode' '"As Is"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txFilterIgnoreBG' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txFilterMode' '"None"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txHiresEnable' '"True"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-txHiresFullAlphaChannel' '"False"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-u-cbutton' '"C4"'
	Android_RetroArch_setOverride 'Mupen64Plus-Next.opt' 'Mupen64Plus-Next'  'mupen64plus-virefresh' '"Auto"'
}

function Android_RetroArch_Beetle_PSX_HW_setUpCoreOpt(){
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_adaptive_smoothing' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_analog_calibration' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_analog_toggle' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_aspect_ratio' '"corrected"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_cd_access_method' '"sync"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_cd_fastload' '"2x(native)"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_core_timing_fps' '"force_progressive"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_cpu_dynarec' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_cpu_freq_scale' '"100%(native)"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_crop_overscan' '"smart"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_crosshair_color_p1' '"red"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_crosshair_color_p2' '"blue"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_depth' '"16bpp(native)"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_display_internal_fps' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_display_vram' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_dither_mode' '"1x(native)"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_dump_textures' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_dynarec_eventcycles' '"128"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_dynarec_invalidate' '"full"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_enable_memcard1' '"enabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_enable_multitap_port1' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_enable_multitap_port2' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_filter' '"nearest"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_filter_exclude_2d_polygon' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_filter_exclude_sprite' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_frame_duping' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_gpu_overclock' '"1x(native)"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_gte_overclock' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_gun_cursor' '"cross"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_gun_input_mode' '"lightgun"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_image_crop' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_image_offset' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_image_offset_cycles' '"0"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_initial_scanline' '"0"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_initial_scanline_pal' '"0"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_internal_resolution' '"2x"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_last_scanline' '"239"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_last_scanline_pal' '"287"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_line_render' '"default"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_mdec_yuv' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_memcard_left_index' '"0"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_memcard_right_index' '"1"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_mouse_sensitivity' '"100%"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_msaa' '"1x"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_negcon_deadzone' '"0%"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_negcon_response' '"linear"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_override_bios' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pal_video_timing_override' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_2d_tol' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_mode' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_nclip' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_texture' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_pgxp_vertex' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_renderer' '"hardware"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_renderer_software_fb' '"enabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_replace_textures' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_scaled_uv_offset' '"enabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_shared_memory_cards' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_skip_bios' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_super_sampling' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_track_textures' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_use_mednafen_memcard0_method' '"libretro"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_widescreen_hack' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_widescreen_hack_aspect_ratio' '"16:9"'
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_wireframe' '"disabled"'
}

function Android_RetroArch_Flycast_setUpCoreOpt(){
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_allow_service_buttons' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_alpha_sorting' '"per-triangle (normal)"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_analog_stick_deadzone' '"15%"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_anisotropic_filtering' '"4"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_auto_skip_frame' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_boot_to_bios' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_broadcast' '"NTSC"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_cable_type' '"TV'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_custom_textures' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_delay_frame_swapping' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_digital_triggers' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_dump_textures' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_enable_dsp' '"enabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_enable_purupuru' '"enabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_enable_rttb' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_fog' '"enabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_force_wince' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_frame_skipping' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_gdrom_fast_loading' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_hle_bios' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_internal_resolution' '"960x720"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_language' '"English"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_lightgun1_crosshair' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_lightgun2_crosshair' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_lightgun3_crosshair' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_lightgun4_crosshair' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_mipmapping' '"enabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_oit_abuffer_size' '"512MB"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_per_content_vmus' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_pvr2_filtering' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_region' '"USA"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_screen_rotation' '"horizontal"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_show_lightgun_settings' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_show_vmu_screen_settings' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_texupscale' '"1"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_texupscale_max_filtered_texture_size' '"256"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_threaded_rendering' '"enabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_trigger_deadzone' '"0%"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_pixel_off_color' '"DEFAULT_OFF 01"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_pixel_on_color' '"DEFAULT_ON 00"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_screen_display' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_screen_opacity' '"100%"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_screen_position' '"Upper Left"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu1_screen_size_mult' '"1x"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_pixel_off_color' '"DEFAULT_OFF 01"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_pixel_on_color' '"DEFAULT_ON 00"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_screen_display' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_screen_opacity' '"100%"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_screen_position' '"Upper Left"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu2_screen_size_mult' '"1x"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_pixel_off_color' '"DEFAULT_OFF 01"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_pixel_on_color' '"DEFAULT_ON 00"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_screen_display' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_screen_opacity' '"100%"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_screen_position' '"Upper Left"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu3_screen_size_mult' '"1x"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_pixel_off_color' '"DEFAULT_OFF 01"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_pixel_on_color' '"DEFAULT_ON 00"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_screen_display' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_screen_opacity' '"100%"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_screen_position' '"Upper Left"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_vmu4_screen_size_mult' '"1x"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_volume_modifier_enable' '"enabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_widescreen_cheats' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_widescreen_hack' '"disabled"'
}

function Android_RetroArch_Gambatte_setUpCoreOpt(){
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_audio_resampler' '"sinc"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_dark_filter_level' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_bootloader' '"enabled"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_colorization' '"auto"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_hwmode' '"Auto"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_internal_palette' '"GB - DMG"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_mode' '"Not Connected"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_port' '"56400"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_1' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_10' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_11' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_12' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_2' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_3' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_4' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_5' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_6' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_7' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_8' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_link_network_server_ip_9' '"0"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_palette_pixelshift_1' '"PixelShift 01 - Arctic Green"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_palette_twb64_1' '"WB64 001 - Aqours Blue"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gb_palette_twb64_2' '"TWB64 101 - 765PRO Pink"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gbc_color_correction' '"GBC only"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gbc_color_correction_mode' '"accurate"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_gbc_frontlight_position' '"central"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_mix_frames' '"disabled"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_rumble_level' '"10"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_show_gb_link_settings' '"disabled"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_turbo_period' '"4"'
	Android_RetroArch_setOverride 'Gambatte.opt' 'Gambatte'  'gambatte_up_down_allowed' '"disabled"'
}

function Android_RetroArch_Nestopia_setUpCoreOpt(){
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_arkanoid_device' '"mouse"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_aspect' '"auto"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_dpcm' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_fds' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_mmc5' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_n163' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_noise' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_s5b' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_sq1' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_sq2' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_tri' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_vrc6' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_audio_vol_vrc7' '"100"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_blargg_ntsc_filter' '"disabled"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_button_shift' '"disabled"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_favored_system' '"auto"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_fds_auto_insert' '"enabled"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_genie_distortion' '"disabled"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_nospritelimit' '"disabled"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_overclock' '"1x"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_overscan_h' '"disabled"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_overscan_v' '"enabled"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_palette' '"cxa2025as"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_ram_power_state' '"0x00"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_select_adapter' '"auto"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_show_advanced_av_settings' '"disabled"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_show_crosshair' '"enabled"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_turbo_pulse' '"2"'
	Android_RetroArch_setOverride 'Nestopia.opt' 'Nestopia'  'nestopia_zapper_device' '"lightgun"'
}
function Android_RetroArch_bsnes_hd_beta_setUpCoreOpt(){
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_blur_emulation' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_coprocessor_delayed_sync' '"ON"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_coprocessor_prefer_hle' '"ON"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_cpu_fastmath' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_cpu_overclock' '"100"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_cpu_sa1_overclock' '"100"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_cpu_sfx_overclock' '"100"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_dsp_cubic' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_dsp_echo_shadow' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_dsp_fast' '"ON"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_entropy' '"Low"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_hotfixes' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ips_headered' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_bgGrad' '"4"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_igwin' '"outside"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_igwinx' '"128"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_mosaic' '"1x scale"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_perspective' '"on'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_scale' '"1x"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_strWin' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_supersample' '"none"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_widescreen' '"16:10"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_windRad' '"0"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsbg1' '"auto horz and vert"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsbg2' '"auto horz and vert"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsbg3' '"auto horz and vert"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsbg4' '"auto horz and vert"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsBgCol' '"auto"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsMarker' '"none"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsMarkerAlpha' '"1/1"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsMode' '"all"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_mode7_wsobj' '"safe"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_deinterlace' '"ON"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_fast' '"ON"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_no_sprite_limit' '"ON"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_no_vram_blocking' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_ppu_show_overscan' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_run_ahead_frames' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_sgb_bios' '"SGB1.sfc"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_video_aspectcorrection' '"OFF"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_video_gamma' '"100"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_video_luminance' '"100"'
	Android_RetroArch_setOverride 'bsnes-hd beta.opt' 'bsnes-hd beta'  'bsnes_video_saturation' '"100"'
}

function Android_RetroArch_Flycast_wideScreenOn(){
	Android_RetroArch_setOverride 'Flycast.opt' 	'Flycast'  	'reicast_widescreen_cheats' 	'"enabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 	'Flycast'  	'reicast_widescreen_hack' 	'"enabled"'
	Android_RetroArch_setOverride 'dreamcast.cfg' 	'Flycast'  	'aspect_ratio_index' 		'"1"'
	Android_RetroArch_dreamcast_bezelOff
	Android_RetroArch_dreamcast_3DCRTshaderOff
}

function Android_RetroArch_Flycast_wideScreenOff(){
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_widescreen_cheats' '"disabled"'
	Android_RetroArch_setOverride 'Flycast.opt' 'Flycast'  'reicast_widescreen_hack' '"disabled"'
	Android_RetroArch_setOverride 'dreamcast.cfg' 'Flycast'  'aspect_ratio_index' '"0"'
}

function Android_RetroArch_Beetle_PSX_HW_wideScreenOn(){
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_widescreen_hack' '"enabled"'
	Android_RetroArch_setOverride 'Beetle PSX.opt' 'Beetle PSX'  'beetle_psx_hw_widescreen_hack' '"enabled"'
	Android_RetroArch_psx_bezelOff
}

function Android_RetroArch_Beetle_PSX_HW_wideScreenOff(){
	Android_RetroArch_setOverride 'Beetle PSX HW.opt' 'Beetle PSX HW'  'beetle_psx_hw_widescreen_hack' '"disabled"'
	Android_RetroArch_setOverride 'Beetle PSX.opt' 'Beetle PSX'  'beetle_psx_hw_widescreen_hack' '"disabled"'
}


function Android_RetroArch_SwanStation_setConfig(){
	Android_RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_GPU.ResolutionScale' '"3"'
}

function Android_RetroArch_SwanStation_wideScreenOn(){
	Android_RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_GPU.WidescreenHack' '"true"'
	Android_RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_Display.AspectRatio' '"16:9"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation'  'aspect_ratio_index' '"1"'
	Android_RetroArch_psx_bezelOff
}

function Android_RetroArch_SwanStation_wideScreenOff(){
	Android_RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_GPU.WidescreenHack' '"false"'
	Android_RetroArch_setOverride 'SwanStation.opt' 'SwanStation'  'duckstation_Display.AspectRatio' '"auto"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation'  'aspect_ratio_index' '"0"'
}

function Android_RetroArch_psx_bezelOn(){
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay' '"~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus/psx.cfg"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay_aspect_adjust_landscape' '"0.100000"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW' 'input_overlay_scale_landscape' '"1.060000"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay' '"~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus/psx.cfg"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay_aspect_adjust_landscape' '"0.100000"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX' 'input_overlay_scale_landscape' '"1.060000"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation' 'aspect_ratio_index' '"0"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay' '"~/.var/app/org.libretro.RetroArch/config/retroarch/overlays/pegasus/psx.cfg"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay_aspect_adjust_landscape' '"0.100000"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay_enable' '"true"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation' 'input_overlay_scale_landscape' '"1.060000"'
}


function Android_RetroArch_psx_bezelOff(){
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX'  'input_overlay_enable' '"false"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation'  'input_overlay_enable' '"false"'
}

function  Android_RetroArch_psx_3DCRTshaderOn(){
	 Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'	'video_smooth' 'ED_RM_LINE'

	 Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX'	'video_smooth' 'ED_RM_LINE'

	 Android_RetroArch_setOverride 'psx.cfg' 'SwanStation'  'video_shader_enable' 'true'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation'	'video_smooth' 'ED_RM_LINE'
 }

function Android_RetroArch_psx_3DCRTshaderOff(){
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX HW'	'video_smooth' 'ED_RM_LINE'

	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'psx.cfg' 'Beetle PSX'	'video_smooth' 'ED_RM_LINE'

	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation'  'video_shader_enable' '"false"'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation'	'video_filter' 'ED_RM_LINE'
	Android_RetroArch_setOverride 'psx.cfg' 'SwanStation'	'video_smooth' 'ED_RM_LINE'
}

function Android_RetroArch_psx_setConfig(){
	Android_RetroArch_psx_3DCRTshaderOff
}


function Android_RetroArch_autoSaveOn(){
	setConfigRA "savestate_auto_load" "true" $Android_RetroArch_configFile
	setConfigRA "savestate_auto_save" "true" $Android_RetroArch_configFile
}
function Android_RetroArch_autoSaveOff(){
	setConfigRA "savestate_auto_load" "false" $Android_RetroArch_configFile
	setConfigRA "savestate_auto_save" "false" $Android_RetroArch_configFile
}

function Android_RetroArch_retroAchievementsOn(){
	setConfigRA 'cheevos_enable' 'true' "$Android_RetroArch_configFile"
	#Mame fix
	#Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'cheevos_enable' '"false"'
	#Android_RetroArch_setOverride 'mame.cfg' 'MAME'  'cheevos_enable' '"false"'
}
function Android_RetroArch_retroAchievementsOff(){
	setConfigRA 'cheevos_enable' 'false' "$Android_RetroArch_configFile"
	#Mame fix
	#Android_RetroArch_setOverride 'mame.cfg' 'MAME 2003-Plus'  'cheevos_enable' '"false"'
	#Android_RetroArch_setOverride 'mame.cfg' 'MAME'  'cheevos_enable' '"false"'
}

function Android_RetroArch_retroAchievementsHardCoreOn(){
	setConfigRA 'cheevos_hardcore_mode_enable' 'true' $Android_RetroArch_configFile
}
function Android_RetroArch_retroAchievementsHardCoreOff(){
	setConfigRA 'cheevos_hardcore_mode_enable' 'false' $Android_RetroArch_configFile
}

function Android_RetroArch_retroAchievementsSetLogin(){
	setConfigRA 'cheevos_token' $achievementsUserToken "$Android_RetroArch_configFile"
	setConfigRA 'cheevos_username' $achievementsUser "$Android_RetroArch_configFile"
	Android_RetroArch_retroAchievementsOn
}

function Android_RetroArch_setSNESAR(){
	if ( "$SNESAR" -eq 87 ){
		Android_RetroArch_snes_ar87
	}else{
		Android_RetroArch_snes_ar43
	}
}
function Android_RetroArch_setBezels(){
	if ( "$RABezels" -eq "true" ){
		Android_RetroArch_bezelOnAll
	}else{
		Android_RetroArch_bezelOffAll
	}
}
function Android_RetroArch_setShadersCRT(){
	if ( "$RAHandClassic2D" -eq "true" ){
		Android_RetroArch_CRTshaderOnAll
	}else{
		Android_RetroArch_CRTshaderOffAll
	}
}
function Android_RetroArch_setShaders3DCRT(){
	if ( "$RAHandClassic3D" -eq "true" ){
		Android_RetroArch_3DCRTshaderOnAll
	}else{
		Android_RetroArch_3DCRTshaderOffAll
	}
}
function Android_RetroArch_setShadersMAT(){
	if ( "$RAHandHeldShader" -eq "true" ){
		Android_RetroArch_MATshadersOnAll
	}else{
		Android_RetroArch_MATshadersOffAll
	}
}

function Android_RetroArch_MATshadersOnAll(){
	Android_RetroArch_wswanc_MATshaderOn
	Android_RetroArch_wswan_MATshaderOn
	Android_RetroArch_lynx_MATshaderOn
	Android_RetroArch_ngp_MATshaderOn
	Android_RetroArch_ngpc_MATshaderOn
	Android_RetroArch_gamegear_MATshaderOn
	Android_RetroArch_gba_MATshaderOn
	Android_RetroArch_gb_MATshaderOn
	Android_RetroArch_gbc_MATshaderOn
}

function Android_RetroArch_MATshadersOffAll(){
	Android_RetroArch_wswanc_MATshaderOff
	Android_RetroArch_wswan_MATshaderOff
	Android_RetroArch_lynx_MATshaderOff
	Android_RetroArch_ngp_MATshaderOff
	Android_RetroArch_ngpc_MATshaderOff
	Android_RetroArch_gamegear_MATshaderOff
	Android_RetroArch_gba_MATshaderOff
	Android_RetroArch_gb_MATshaderOff
	Android_RetroArch_gbc_MATshaderOff
}

function Android_RetroArch_3DCRTshaderOnAll{
	Android_RetroArch_n64_3DCRTshaderOn
	Android_RetroArch_dreamcast_3DCRTshaderOn
	Android_RetroArch_saturn_3DCRTshaderOn
	Android_RetroArch_psx_3DCRTshaderOn
}

function Android_RetroArch_3DCRTshaderOffAll{
	Android_RetroArch_n64_3DCRTshaderOff
	Android_RetroArch_dreamcast_3DCRTshaderOff
	Android_RetroArch_saturn_3DCRTshaderOff
	Android_RetroArch_psx_3DCRTshaderOff
}


function Android_RetroArch_CRTshaderOnAll(){
	Android_RetroArch_pcengine_CRTshaderOn
	Android_RetroArch_amiga1200_CRTshaderOn
	Android_RetroArch_nes_CRTshaderOn
	Android_RetroArch_atari2600_CRTshaderOn
	Android_RetroArch_mame_CRTshaderOn
	Android_RetroArch_neogeo_CRTshaderOn
	Android_RetroArch_fbneo_CRTshaderOn
	Android_RetroArch_segacd_CRTshaderOn
	Android_RetroArch_genesis_CRTshaderOn
	Android_RetroArch_mastersystem_CRTshaderOn
	Android_RetroArch_sega32x_CRTshaderOn
	Android_RetroArch_snes_CRTshaderOn

}

function Android_RetroArch_CRTshaderOffAll(){
	Android_RetroArch_pcengine_CRTshaderOff
	Android_RetroArch_amiga1200_CRTshaderOff
	Android_RetroArch_nes_CRTshaderOff
	Android_RetroArch_atari2600_CRTshaderOff
	Android_RetroArch_mame_CRTshaderOff
	Android_RetroArch_neogeo_CRTshaderOff
	Android_RetroArch_fbneo_CRTshaderOff
	Android_RetroArch_segacd_CRTshaderOff
	Android_RetroArch_genesis_CRTshaderOff
	Android_RetroArch_mastersystem_CRTshaderOff
	Android_RetroArch_sega32x_CRTshaderOff
	Android_RetroArch_snes_CRTshaderOff

}