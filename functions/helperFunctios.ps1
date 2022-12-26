 function setSetting($old, $new){

	$fileToCheck = "$userFolder\EmuDeck\settings.ps1"

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -ExpandProperty Line
	$newLine=-join('$',$old,'=',$new)
	$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)}

	Set-Content -Path $fileToCheck -Value $modifiedContents

	echo "Line $line changed to $newLine"

}