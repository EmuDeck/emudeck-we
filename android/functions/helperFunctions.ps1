function Get-ShellProxy
{
	if( -not $global:ShellProxy)
	{
		$global:ShellProxy = new-object -com Shell.Application
	}
	$global:ShellProxy
}

function Get-Phone
{
	$shell = Get-ShellProxy
	$shellItem = $shell.NameSpace(17).self
	# Obtenemos el nombre del teléfono
	$phone = $shellItem.GetFolder.items() | where { $_.path -like "::*" }
	return $phone
}

function Get-CustomFolder
{
	param($origin)
	$shell = New-Object -ComObject shell.application
	$customFolderPath = "shell:::{59031a47-3f72-44a7-89c5-5595fe6b30ee}\emudeck\android\temp\$origin"
	$customFolder = $shell.Namespace($customFolderPath)

	if ($customFolder -ne $null) {
		$customFolderItem = $customFolder.Self
		return $customFolderItem
	} else {
		Write-Host "La carpeta personalizada no se encontró."
		return $null
	}
}

function Get-Folder
{
	param(
		$parent,
		$path
	)
	return $parent.GetFolder.items() | where { $_.Name -eq $path }
}

function Move-To-MTP
{
	param(
		$parent,
		$path,
		$finish
	)
	$customFolderItem = Get-CustomFolder -origin $parent
	$phone = Get-Phone
	$phoneInternal = Get-Folder -parent $phone -path $path
	$destinationFolderPath=$phoneInternal
	$items = @( $customFolderItem.GetFolder.items())
	if ($items)
	{
		$totalItems = $items.count
		if ($totalItems -gt 0)
		{
			# If destination path doesn't exist, create it only if we have some items to move
			if (-not (test-path $destinationFolderPath) )
			{
				$created = new-item -itemtype directory -path $destinationFolderPath
			}

			Write-Verbose "Processing Path : $phoneName\$phoneFolderPath"
			Write-Verbose "Moving to : $destinationFolderPath"

			$shell = Get-ShellProxy
			$destinationFolder = $shell.Namespace($destinationFolderPath).self
			$count = 0;
			foreach ($item in $items)
			{
				$fileName = $item.Name

				# ++$count
				# $percent = [int](($count * 100) / $totalItems)
				# Write-Progress -Activity "Processing Files in $phoneName\$phoneFolderPath" `
				# 	-status "Processing File ${count} / ${totalItems} (${percent}%)" `
				# 	-CurrentOperation $fileName `
				# 	-PercentComplete $percent

				# Check the target file doesn't exist:
				$targetFilePath = join-path -path $destinationFolderPath -childPath $fileName
				$destinationFolderPath.Path

				$destinationFolder.GetFolder.MoveHere($item)
			}

		}
	}
}

function Android_getLatestReleaseURLGH($Repository, $FileType, $FindToMatch = "", $IgnoreText = "pepe"){

$url = "https://api.github.com/repos/$Repository/releases/latest"

	# Fetch JSON content from the URL
	$jsonString = Invoke-RestMethod -Uri $url

	# Find the first asset with .apk extension
	$firstApkAsset = $jsonString.assets | Where-Object { $_.browser_download_url -like "*$FileType" -and $_.browser_download_url -like "*$FindToMatch" -and $_.browser_download_url -notlike "*$IgnoreText*" } | Select-Object -First 1

	# Check if a matching asset was found
	if ($firstApkAsset) {
		$downloadUrl = $firstApkAsset.browser_download_url
		Write-Output $downloadUrl
	} else {
		Write-Host "No matching asset found."
	}
}
