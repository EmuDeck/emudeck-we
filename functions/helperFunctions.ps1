function setSetting($old, $new) {
	$fileToCheck = "$userFolder\EmuDeck\settings.ps1"

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -ExpandProperty Line
	if ($line) {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$modifiedContents = $fileContents | ForEach-Object { $_.Replace($line, $newLine) }

		Set-Content -Path $fileToCheck -Value $modifiedContents

		Write-Host "Line '$line' changed to '$newLine'"
	} else {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$newLine += "`r`n"  # Agregar nueva línea al final del contenido
		Add-Content $fileToCheck $newLine

		Write-Host "New line '$newLine' created in $fileToCheck"
	}
}

function setSettingNoQuotes($file, $old, $new) {
	$fileToCheck = $file

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -ExpandProperty Line
	if ($line) {
		$newLine = -join($old, '=', $new)
		$modifiedContents = $fileContents | ForEach-Object { $_.Replace($line, $newLine) }

		Set-Content -Path $fileToCheck -Value $modifiedContents

		Write-Host "Line '$line' changed to '$newLine'"
	} else {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$newLine += "`r`n"  # Agregar nueva línea al final del contenido
		Add-Content $fileToCheck $newLine

		Write-Host "New line '$newLine' created in $fileToCheck"
	}
}

 function setConfig($old, $new, $fileToCheck){	

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line
	if ($line){
		$newLine=-join($old,'=',$new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)} -ErrorAction SilentlyContinue
	
		Set-Content -Path $fileToCheck -Value $modifiedContents
		Write-Output "Line $line changed to $newLine"
	}else{
		$newLine=-join($old,'=',$new)
		Add-Content $fileToCheck $newLine
		Write-Output "Line created on $fileToCheck"
	}

}

 function setConfigRA($old, $new, $fileToCheck){	

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line
	if ($line){
		$newLine=-join($old,' = ',$new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)} -ErrorAction SilentlyContinue
		
		Set-Content -Path $fileToCheck -Value $modifiedContents
		
		Write-Output "Line $line changed to $newLine"
	}else{
		$newLine=-join($old,' = ',$new)
		Add-Content $fileToCheck $newLine
		Write-Output "Line created on $fileToCheck"
	}


}


function customLocation(){
	$drives = (Get-PSDrive -PSProvider FileSystem).Root
	$winPath = showListDialog 'Select Destination' 'Please select where do you want to install EmuDeck:' $drives
	Start-Sleep -Seconds 0.5
	Write-Output $winPath;
}

function testLocationValid($mode, $path){
	if (!$path){
		Write-Output "Wrong"
	}else{
		Write-Output "Valid"
	}	
}

function escapeSedKeyword($input){
	Write-Output $input
}

function escapeSedValue($input){
	Write-Output $input
}

function changeLine($keyword, $replace, $file) {
	(Get-Content $file).replace($keyword, $replace) | Set-Content $file
}

function setMSG($message){
	$progressBarValue = Get-Content -Path $userFolder\AppData\Roaming\EmuDeck\msg.log -TotalCount 1 -ErrorAction SilentlyContinue
	$progressBarUpdate=[int]$progressBarValue+5

	#We prevent the UI to close if we have too much MSG, the classic eternal 99%
	if ( $progressBarUpdate -eq 95 ){
		$progressBarUpdate=90
	}
	"$progressBarUpdate" | Out-File -encoding ascii $userFolder\AppData\Roaming\EmuDeck\msg.log
	Write-Output $message
	Add-Content $userFolder\AppData\Roaming\EmuDeck\msg.log "# $message" -NoNewline
	Start-Sleep -Seconds 0.5
}



function checkForFile($fileName){
	(Get-ChildItem -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck" -Filter ".ui-finished" -Recurse -ErrorAction SilentlyContinue -Force) -and (Write-Output "true") ; rm -fo $dir/$fileName
}


function getLatestReleaseURLGH($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

	$url = "https://api.github.com/repos/$Repository/releases/latest"

	$url = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty assets | 
		   Where-Object { $_.browser_download_url -Match $FindToMatch -and $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } | 
		   Select-Object -ExpandProperty browser_download_url | Select-Object -First 1
		   return $url

	return $url
}

function getReleaseURLGH($Repository, $FileType, $IgnoreText = "pepe"){

    $url = "https://api.github.com/repos/$Repository/releases?per_page=1"
    $apiData = Invoke-RestMethod -Uri $url

    $releaseURL = $apiData.assets |
        Where-Object { $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } |
        Select-Object -ExpandProperty browser_download_url 
	return $releaseURL
}

function check_internet_connection(){

	if ((Test-Connection 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue).StatusCode -eq 0) { return "true" } else { return "false" }

}

function changeController($device){
	Write-Output "NYI"
}


function showDialog($text){
    Add-Type -AssemblyName System.Windows.Forms

    # Create an instance of the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "EmuDeck"
    $form.Width = 300
    $form.Height = 100
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    # Disable the maximize button
    $form.MaximizeBox = $false

	# Set the form to be topmost
	$form.TopMost = $true

    # Create an instance of the control Label to show the text
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "$text"
    $label.AutoSize = $true
    $label.Left = ($form.Width - $label.Width) / 3
    $label.Top = ($form.Height - $label.Height) / 3

    # Add the Label control to the form
    $form.Controls.Add($label)

    # Show the form and the text
    $form.Show()
    return $form
}

function showListDialog($title, $subtitle, $options){
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	
	$form = New-Object System.Windows.Forms.Form
	$form.Text = $title
	$form.Size = New-Object System.Drawing.Size(300,200)
	$form.StartPosition = 'CenterScreen'
	
	$okButton = New-Object System.Windows.Forms.Button
	$okButton.Location = New-Object System.Drawing.Point(75,120)
	$okButton.Size = New-Object System.Drawing.Size(75,23)
	$okButton.Text = 'OK'
	$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$form.AcceptButton = $okButton
	$form.Controls.Add($okButton)
	
	$cancelButton = New-Object System.Windows.Forms.Button
	$cancelButton.Location = New-Object System.Drawing.Point(150,120)
	$cancelButton.Size = New-Object System.Drawing.Size(75,23)
	$cancelButton.Text = 'Cancel'
	$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
	$form.CancelButton = $cancelButton
	$form.Controls.Add($cancelButton)
	
	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,20)
	$label.Size = New-Object System.Drawing.Size(280,20)
	$label.Text = $subtitle
	$form.Controls.Add($label)
	
	$listBox = New-Object System.Windows.Forms.ListBox
	$listBox.Location = New-Object System.Drawing.Point(10,40)
	$listBox.Size = New-Object System.Drawing.Size(260,20)
	$listBox.Height = 80
	
	
	
	ForEach ($option in $options) { [void] $listBox.Items.Add($option) }
	
	$form.Controls.Add($listBox)
	
	$form.Topmost = $true
	
	$result = $form.ShowDialog()
	
	if ($result -eq [System.Windows.Forms.DialogResult]::OK)
	{
		return $listBox.SelectedItem
	}else{
		exit
	}
}

Function NewWPFDialog() {
	<#
	.SYNOPSIS
	This neat little function is based on the one from Brian Posey's Article on Powershell GUIs
	
	.DESCRIPTION
	  I re-factored a bit to return the resulting XaML Reader and controls as a single, named collection.

	.PARAMETER XamlData
	 XamlData - A string containing valid XaML data

	.EXAMPLE

	  $MyForm = New-WPFDialog -XamlData $XaMLData
	  $MyForm.Exit.Add_Click({...})
	  $null = $MyForm.UI.Dispatcher.InvokeAsync{$MyForm.UI.ShowDialog()}.Wait()

	.NOTES
	Place additional notes here.

	.LINK
	  http://www.windowsnetworking.com/articles-tutorials/netgeneral/building-powershell-gui-part2.html

	.INPUTS
	 XamlData - A string containing valid XaML data

	.OUTPUTS
	 a collection of WPF GUI objects.
  #>
	
	Param([Parameter(Mandatory = $True, HelpMessage = 'XaML Data defining a GUI', Position = 1)]
		[string]$XamlData)
	
	# Add WPF and Windows Forms assemblies
	try {
		Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase, system.windows.forms
	}
	catch {
		Throw 'Failed to load Windows Presentation Framework assemblies.'
	}
	
	# Create an XML Object with the XaML data in it
	[xml]$xmlWPF = $XamlData
	
	# Create the XAML reader using a new XML node reader, UI is the only hard-coded object name here
	Set-Variable -Name XaMLReader -Value @{ 'UI' = ([Windows.Markup.XamlReader]::Load((new-object -TypeName System.Xml.XmlNodeReader -ArgumentList $xmlWPF))) }

	# Create hooks to each named object in the XAML reader
	$Elements = $xmlWPF.SelectNodes('//*[@Name]')
	ForEach ( $Element in $Elements ) {
		$VarName = $Element.Name
		$VarValue = $XaMLReader.UI.FindName($Element.Name)
		$XaMLReader.Add($VarName, $VarValue)
	}

	return $XaMLReader
}


Function NewPopUpWindow () {
	param(
		[string]
		$MessageText = "No Message Supplied")

	# This is the XaML that defines the GUI.
	$WPFXamL = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" Background="#FF0066CC" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" Padding="20" Margin="0">
	<Grid Name="grid">
		<Button Name="OKButton" Content="OK" HorizontalAlignment="Right" Margin="0,0,30,20" VerticalAlignment="Bottom" Width="75" Background="#FF0066CC" BorderBrush="White" Foreground="White" Padding="8,4"/>
		<TextBlock Name="Message" Margin="100,60,100,80" TextWrapping="Wrap" Text="_CONTENT_" FontSize="36"/>
	</Grid>
</Window>
'@

	# Build Dialog
	$WPFGui = NewWPFDialog -XamlData $WPFXaml
	$WPFGui.Message.Text = $MessageText
	$WPFGui.OKButton.Add_Click( { $WPFGui.UI.Close() })
	$null = $WPFGUI.UI.Dispatcher.InvokeAsync{ $WPFGui.UI.ShowDialog() }.Wait()
	
	#
	function ClosePopup() {
		$WPFGui.UI.Close()
	}
	
}

#NewPopUpWindow -MessageText "Hey there, I'm a pretty blue form"

function showYesNoDialog($title, $desc){

	Add-Type -AssemblyName System.Windows.Forms

	$result = [System.Windows.Forms.MessageBox]::Show(
		"$desc",
		"$title",
		[System.Windows.Forms.MessageBoxButtons]::YesNo
	)
	
	return $result

}

#$scriptContent = @"
#. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1; 
#Write-Host "I'm Admin"
#"@

#StartScriptWithAdmin -ScriptContent $scriptContent

function startScriptWithAdmin {
	param (
		[string]$ScriptContent
	)

	$tempScriptPath = [System.IO.Path]::GetTempFileName() + ".ps1"
	$ScriptContent | Out-File -FilePath $tempScriptPath -Encoding utf8 -Force
	
	$psi = New-Object System.Diagnostics.ProcessStartInfo
	$psi.Verb = "runas"
	$psi.FileName = "powershell.exe"
	$psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File ""$tempScriptPath"""
	[System.Diagnostics.Process]::Start($psi).WaitForExit()

	Remove-Item $tempScriptPath -Force
}

function createSymlink($source, $target) {	
if(testAdministrator){
	New-Item -ItemType SymbolicLink -Path "$source" -Target "$target"
}else{
	$scriptContent = @"
		. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1
		New-Item -ItemType SymbolicLink -Path "$source" -Target "$target"
"@
	
	startScriptWithAdmin -ScriptContent $scriptContent
}
}

function testAdministrator {
	$currentUser = New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())
	$isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
	return $isAdmin
}

function createSaveLink($simLinkPath, $emuSavePath){
	mkdir "$emuSavePath" -ErrorAction SilentlyContinue
	#Symlink?
		
	if(Test-Path -Path "$simLinkPath"){
			
		$folderInfo = Get-Item -Path $simLinkPath
		
		if ($folderInfo.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
			echo "Symlink already exists, we do nothing"
		} else {			
			#Check if we have space
			
			$userDrive=$emulationPath[0]		
			$destinationFree = (Get-PSDrive -Name $userDrive).Free
			$sizeInGB = [Math]::Round($destinationFree / 1GB)
			
			$originSize = (Get-ChildItem -Path "$simLinkPath" -Recurse | Measure-Object -Property Length -Sum).Sum
			$wshell = New-Object -ComObject Wscript.Shell
			
			if ( $originSize -gt $destinationFree ){			
				$Output = $wshell.Popup("You don't have enough space in your $userDrive drive, free at least $sizeInGB GB so we can migrate your saves")
				exit
			}				
		
			# We copy the saves to the Emulation/saves Folder adn create a backup
			echo "Migrating saves"
			#Move-Item -Path "$simLinkPath\*" -Destination $emuSavePath -Force						
			Copy-Item -Path "$simLinkPath\*" -Destination $emuSavePath -Recurse
			
			if ($?) {				
				$backupSuffix = "_bak"
				$backupName = -join($simLinkPath, $backupSuffix)						
				Rename-Item -Path "$simLinkPath" -NewName "$backupName"
			}
		}	
	}	

	createSymlink $simLinkPath $emuSavePath
}

