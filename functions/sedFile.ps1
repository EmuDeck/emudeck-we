function sedFile($file, $old, $new, $lineFilter){
	if (-not (Test-Path -LiteralPath $file)) { Write-Host "Not found: $file"; return }
	$lines = readConfigLines $file
	if ($lineFilter) {
		$lines = $lines | ForEach-Object { if ($_.Contains($lineFilter)) { $_.Replace($old, $new) } else { $_ } }
	} else {
		$lines = $lines | ForEach-Object { $_.Replace($old, $new) }
	}
	# sedFile has always written files without BOM
	writeConfigLines $file $lines -NoBom
}