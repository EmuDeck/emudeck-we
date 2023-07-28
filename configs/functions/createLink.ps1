function createLink($source, $target){
	$WScriptObj = New-Object -ComObject ("WScript.Shell")
	$shortcut = $WscriptObj.CreateShortcut($target)
	$shortcut.TargetPath = $source
	$shortcut.WindowStyle = 1	
	$shortcut.Save()
}