function appImageInit(){

	#AutoFixes

	#Remove SRM BOM
	$userConfigsFile="$toolsPath\userData\userConfigurations.json"
	$content = Get-Content -Path $userConfigsFile -Raw

	# Crear un codificador para UTF-8 sin BOM
	$killBOM = New-Object System.Text.UTF8Encoding $false

	# Escribe el contenido de nuevo al archivo sin el BOM
	[System.IO.File]::WriteAllText($userConfigsFile, $content, $killBOM)


	autofix_betaCorruption
	autofix_cloudSyncLockfile
	autofix_raSavesFolders
	autofix_lnk
	autofix_ESDE
	autofix_dynamicParsers
	autofix_oldParsersBAT


	# Init functions
	setScreenDimensionsScale

	echo "true"

}
