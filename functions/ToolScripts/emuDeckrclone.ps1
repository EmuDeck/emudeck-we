$rclone_path="$toolsPath/rclone"
$rclone_bin="$rclone_path/rclone.exe"
$rclone_config="$rclone_path/rclone.conf"


function rclone_install($rclone_provider){	
	$rclone_releaseURL = getLatestReleaseURLGH 'rclone/rclone' 'zip' 'windows-amd64'
	download $rclone_releaseURL "rclone.zip"	
	
	$regex = '^.*\/(rclone-v\d+\.\d+\.\d+-windows-amd64\.zip)$'
	
	if ($rclone_releaseURL -match $regex) {
		
				$filename = $matches[1]
		
		$filename = $filename.Replace('.zip','')
		
		Rename-Item "temp\rclone\$filename" -NewName "rclone" 
		
		moveFromTo "temp/rclone/" "$toolsPath\"	
		Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\rclone\rclone.conf" -Destination "$toolsPath/rclone"
		rm -fo  "temp\rclone" -Recurse
	}

	& $rclone_bin config update "$rclone_provider" 
	
	setSetting "rclone_provider" "$rclone_provider"
	. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1
	
}

function rclone_downloadEmu($emuName, $path){	
	if (Test-Path "$rclone_bin") {
		& $rclone_bin sync -P -L "$rclone_provider`:Emudeck\saves\$emuName\" "$path"
	}
}

function rclone_uploadEmu($emuName, $path){	
  if (Test-Path "$rclone_bin") {	   
	  & $rclone_bin sync -P -L "$path" "$rclone_provider`:Emudeck\saves\$emuName\"
  }
}
