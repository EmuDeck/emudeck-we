function sedFile($file, $old, $new){
	(Get-Content $file).replace($old, $new) | Set-Content $file
}