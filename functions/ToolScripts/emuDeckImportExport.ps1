function import_emudeck($items, $origin) {
	generate_pythonEnv | Out-Null
	$env:emulationPath = $emulationPath
	$env:ESDEscrapData = $ESDEscrapData
	$items = $items.Replace('"', '\"')
	#New gamelist folder location
	mkdir "$esdePath\ES-DE\gamelists"  -ErrorAction SilentlyContinue
	createSaveLink "$esdePath\ES-DE\gamelists" "$storagePath/es-de/gamelists"
	
	python "$emudeckBackend\tools\importExport.py" import_emudeck "$items" "$origin"
	return $LASTEXITCODE
}

function export_emudeck($items, $destination) {
	generate_pythonEnv | Out-Null
	$env:emulationPath = $emulationPath
	$env:ESDEscrapData = $ESDEscrapData
	$items = $items.Replace('"', '\"')
	#New gamelist folder location
	mkdir "$esdePath\ES-DE\gamelists"  -ErrorAction SilentlyContinue
	createSaveLink "$esdePath\ES-DE\gamelists" "$storagePath/es-de/gamelists"
	
	python "$emudeckBackend\tools\importExport.py" export_emudeck "$items" "$destination"
	return $LASTEXITCODE
}

function get_locations() {
	generate_pythonEnv *> $null
	python "$emudeckBackend\tools\importExport.py" get_locations
}
