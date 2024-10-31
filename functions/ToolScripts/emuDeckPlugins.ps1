function Plugins_installPluginLoader(){

   if (Get-Command python -ErrorAction SilentlyContinue) {
      Write-Output "Python already installed."
   } else {
      Write-Host "Installing Python, please wait..."
      $PYinstaller = "python-3.11.0-amd64.exe"
      $url = "https://www.python.org/ftp/python/3.11.0/$PYinstaller"
      download $url $PYinstaller
      Start-Process "$temp\$PYinstaller" -Wait -Args "/passive InstallAllUsers=1 PrependPath=1 Include_test=0"
   }

    $url = getLatestReleaseURLGH 'emudeck/decky-loader-win' 'exe' '_noconsole'
    download $url "decky-loader-win.exe"
    cp "$temp/decky-loader-win.exe" "$toolsPath"


$scriptContent = @"
Move-Item -Path "$temp/decky-loader-win.exe" -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" -Force
"@
    startScriptWithAdmin -ScriptContent $scriptContent
    mkdir "$HOME/homebrew/plugins" -ErrorAction SilentlyContinue
    Start-Process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\decky-loader-win.exe"
    echo "true"
}

function Plugins_installEmuDecky(){
    echo "Installing EmuDecky"
    $url = getLatestReleaseURLGH 'EmuDeck/EmuDecky' 'zip'
    download $url "EmuDecky.zip"
    moveFromTo "$temp/EmuDecky" "$HOME/homebrew/plugins"

    if ( -not (Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\decky-loader-win.exe")){
       Plugins_installPluginLoader
    }else{
        echo "true"
    }


}

function Plugins_installDeckyRomLibrary(){
   echo "Installing Decky Rom Library"
   $url = getLatestReleaseURLGH "emudeck/decky-rom-library" "zip"
   download $url "retroLibrary.zip"
   moveFromTo "$temp/retroLibrary" "$HOME/homebrew/plugins"

   if ( -not (Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\decky-loader-win.exe")){
       Plugins_installPluginLoader
    }else{
        echo "true"
    }

}
