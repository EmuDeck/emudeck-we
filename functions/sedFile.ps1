function sedFile($file, $old, $new, $lineFilter){
	if ($lineFilter) {
		(Get-Content $file) | ForEach-Object { if ($_.Contains($lineFilter)) { $_.Replace($old, $new) } else { $_ } } | Set-Content $file -Encoding UTF8
	} else {
		(Get-Content $file).replace($old, $new) | Set-Content $file -Encoding UTF8
	}
	$content = Get-Content -Path $file -Raw
	$killBOM = New-Object System.Text.UTF8Encoding $false
	[System.IO.File]::WriteAllText($file, $content, $killBOM)
}