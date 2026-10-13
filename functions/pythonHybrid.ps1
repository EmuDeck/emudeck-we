function py_run(){
	$printResult = $false
	$pyArgs = @($args)
	if ($pyArgs.Count -gt 0 -and $pyArgs[0] -eq "--print") {
		$printResult = $true
		$pyArgs = @($pyArgs | Select-Object -Skip 1)
	}
	$fn = $pyArgs[0]
	$pyArgs = @($pyArgs | Select-Object -Skip 1)
	$python = "$pyVenv\Scripts\python.exe"
	if (-not (Test-Path $python)) {
		$python = "python"
	}

	$argsJson = ConvertTo-Json -InputObject @($pyArgs | ForEach-Object { "$_" }) -Compress
	if (-not $PSNativeCommandArgumentPassing -or $PSNativeCommandArgumentPassing -eq "Legacy") {
		$argsJson = $argsJson -replace '(\\*)"', '$1$1\"'
	}

	$progressBar = (Get-Content -Path "$emudeckLogs\msg.log" -TotalCount 1 -ErrorAction SilentlyContinue) -split '#' | Select-Object -First 1
	$env:EMUDECK_PROGRESS = "$progressBar".Trim()
	$global:LASTEXITCODE = 1
	$pyOutput = & $python "$pythonBackend\api.py" --hybrid $fn $argsJson 2>&1 | ForEach-Object {
		if ($_ -is [System.Management.Automation.ErrorRecord]) {
			Add-Content -Path "$emudeckLogs\python.log" -Value "$_" -Encoding UTF8
		} else {
			$_
		}
	}
	$status = $LASTEXITCODE
	Remove-Item Env:EMUDECK_PROGRESS -ErrorAction SilentlyContinue

	if ($printResult) {
		try {
			$result = ($pyOutput | Select-Object -Last 1 | ConvertFrom-Json).result
		} catch {
			$result = $null
		}
		if ($result -is [string]) {
			Write-Output $result
		} elseif ($null -ne $result) {
			Write-Output (ConvertTo-Json -InputObject $result -Compress -Depth 20)
		}
	} elseif ($status -eq 0) {
		Write-Output "true"
	} else {
		Write-Output "false"
	}
	$global:LASTEXITCODE = $status
}
