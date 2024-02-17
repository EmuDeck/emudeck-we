collection: Nintendo 64
shortname: n64
extensions: bin, n64, u1, v64, z64, zip, 7z
launch: am start
  -n com.retroarch.aarch64/com.retroarch.browser.retroactivity.RetroActivityFuture
  -e ROM {file.path}
  -e LIBRETRO /data/data/com.retroarch.aarch64/cores/mupen64plus_next_gles3_libretro_android.so
  -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch.aarch64/files/retroarch.cfg
  -e IME com.android.inputmethod.latin/.LatinIME
  -e DATADIR /data/data/com.retroarch.aarch64
  -e APK /data/app/com.retroarch.aarch64-1/base.apk
  -e SDCARD /storage/emulated/0
  -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch.aarch64/files