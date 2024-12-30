#Global vars
$Android_ADB_path = "$env:APPDATA\emudeck\android\platform-tools"
$Android_ADB_url = "https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
$Android_folder="$env:APPDATA/emudeck/android/"
$Android_temp_android_data="$env:APPDATA/emudeck/android/temp/CopyToInternal/Android/data"
$Android_temp_internal="$env:APPDATA/emudeck/android/temp/CopyToInternal"
$Android_temp_external="$env:APPDATA/emudeck/android/temp/CopyToSDCARD"
$Android_emusPath="/storage/emulated/0"
$env:PATH += ";$Android_ADB_path"
