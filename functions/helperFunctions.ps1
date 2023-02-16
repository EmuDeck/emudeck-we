 function setSetting($old, $new){

	$fileToCheck = "$userFolder\emudeck\settings.ps1"

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -ExpandProperty Line
	if ($line){
		$newLine=-join('$',$old,'=','"',$new,'"')
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)}
	
		Set-Content -Path $fileToCheck -Value $modifiedContents
	
		echo "Line $line changed to $newLine"
	}else{
		echo "Line not found on $fileToCheck"
	}

}

 function setConfig($old, $new, $fileToCheck){	

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line
	if ($line){
		$newLine=-join($old,'=',$new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)} -ErrorAction SilentlyContinue
	
		Set-Content -Path $fileToCheck -Value $modifiedContents
		echo "Line $line changed to $newLine"
	}else{
		echo "Line not found on $fileToCheck"
	}

}

 function setConfigRA($old, $new, $fileToCheck){	

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line
	if ($line){
		$newLine=-join($old,' = ',$new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)} -ErrorAction SilentlyContinue
		
		Set-Content -Path $fileToCheck -Value $modifiedContents
		
		echo "Line $line changed to $newLine"
	}else{
		echo "Line not found on $fileToCheck"
	}


}


function customLocation(){
	$drives = (Get-PSDrive -PSProvider FileSystem).Root
	$winPath = showListDialog 'Select Destination' 'Please select where do you want to install EmuDeck:' $drives
	echo $winPath;
}

function testLocationValid(){
	echo "Valid"
}

function escapeSedKeyword($input){
	echo $input
}

function escapeSedValue($input){
	echo $input
}

function changeLine($keyword, $replace, $file) {
	(Get-Content $file).replace($keyword, $replace) | Set-Content $file
}

function setMSG($message){
	$progressBarValue = Get-Content -Path $userFolder\AppData\Roaming\EmuDeck\msg.log -TotalCount 1 -ErrorAction SilentlyContinue
	$progressBarUpdate=[int]$progressBarValue+5

	#We prevent the UI to close if we have too much MSG, the classic eternal 99%
	if ( $progressBarUpdate -eq 95 ){
		$progressBarUpdate=90
	}
	"$progressBarUpdate" | Out-File -encoding ascii $userFolder\AppData\Roaming\EmuDeck\msg.log
	echo $message
	Add-Content $userFolder\AppData\Roaming\EmuDeck\msg.log "# $message" -NoNewline
	Start-Sleep -Seconds 0.5
}



function checkForFile($fileName){
	(Get-ChildItem -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck" -Filter ".ui-finished" -Recurse -ErrorAction SilentlyContinue -Force) -and (echo "true") ; rm -fo $dir/$fileName
}