function sedFile($file, $old, $new){
	(Get-Content $file).replace($old, $new) | Set-Content $file -Encoding UTF8
	$content = Get-Content -Path $file -Raw
	$killBOM = New-Object System.Text.UTF8Encoding $false
	[System.IO.File]::WriteAllText($file, $content, $killBOM)
}