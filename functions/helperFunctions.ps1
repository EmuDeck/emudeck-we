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

#	# Get a list of all logical drives in the system
#	$drives = Get-WmiObject -Class Win32_LogicalDisk
#	
#	# Filter internal and removable drives
#	$internalDrives = $drives | Where-Object { $_.DriveType -eq 3 }  # 3 represents internal drives
#	$removableDrives = $drives | Where-Object { $_.DriveType -eq 2 }  # 2 represents removable drives
#	
#	# Display drive letters for internal drives
#	Write-Host "Internal Hard Drives:"
#	$internalDrives | ForEach-Object { $_.DeviceID } | Sort-Object | Format-Table -AutoSize
#	
#	# Display drive letters for removable drives (e.g., SD cards)
#	Write-Host "Removable Drives (e.g., SD Cards):"
#	$removableDrives | ForEach-Object { $_.DeviceID } | Sort-Object | Format-Table -AutoSize

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


#Used in the appimage only
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

function getReleaseURLGH($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

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


function confirmDialog {
	param (
		[string]$TitleText = "Do you want to continue?",
		[string]$MessageText = "",
		[string]$OKButtonText = "OK",
		[string]$CancelButtonText = "Cancel"
	)
	# This is the XAML that defines the GUI.
	$WPFXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" Background="#FF0066CC" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" MaxWidth="600" Padding="20" Margin="0" Topmost="True">
 <Grid Name="grid">
			<ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
				<StackPanel>
					<Border Margin="20,20,0,20" Background="Transparent">
						<TextBlock Name="Title" Margin="0,10,0,10" TextWrapping="Wrap" Text="_TITLE_" FontSize="24" FontWeight="Bold" HorizontalAlignment="Left"/>
					</Border>
					<Border Margin="20,0,20,0" Background="Transparent">
						<TextBlock Name="Message" Margin="0,0,0,20" TextWrapping="Wrap" Text="_CONTENT_" FontSize="18"/>
					</Border>
					<Border Margin="20,0,20,20" Background="Transparent">
					<StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
						<Button Name="OKButton" Content="_OKBUTTONTEXT_" Margin="5" Width="75" Background="#FF0066CC" BorderBrush="White" Foreground="White" Padding="8,4"/>
					</StackPanel>
					</Border>
				</StackPanel>
			</ScrollViewer>
		</Grid>
</Window>
'@

	# Build Dialog
	$WPFGui = NewWPFDialog -XamlData $WPFXaml
	$WPFGui.Message.Text = $MessageText
	$WPFGui.Title.Text = $TitleText
	$WPFGui.Message.Text = $MessageText

	$WPFGui.OKButton.Content = $OKButtonText

	# Add the script block to the button's Click event
	$WPFGui.OKButton.Add_Click($buttonClickEvent)

	# Create a variable to hold the result
	$global:Result = $null

	# Show the dialog
	$null = $WPFGUI.UI.Dispatcher.InvokeAsync{ $WPFGui.UI.ShowDialog() }.Wait()

	# Return the result
	return $global:Result
}


function yesNoDialog {
	param (
		[string]$TitleText = "Do you want to continue?",
		[string]$MessageText = "",
		[string]$OKButtonText = "OK",
		[string]$CancelButtonText = "Cancel",
		[bool]$ShowCancelButton = $true
		
	)
	# This is the XAML that defines the GUI.
	$WPFXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" Background="#FF0066CC" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" MaxWidth="600" Padding="20" Margin="0" Topmost="True">
 <Grid Name="grid">
			<ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
				<StackPanel>
					<Border Margin="20,20,0,20" Background="Transparent">
						<TextBlock Name="Title" Margin="0,10,0,10" TextWrapping="Wrap" Text="_TITLE_" FontSize="24" FontWeight="Bold" HorizontalAlignment="Left"/>
					</Border>
					<Border Margin="20,0,20,0" Background="Transparent">
						<TextBlock Name="Message" Margin="0,0,0,20" TextWrapping="Wrap" Text="_CONTENT_" FontSize="18"/>
					</Border>
					<Border Margin="20,0,20,20" Background="Transparent">
					<StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
						<Button Name="OKButton" Content="_OKBUTTONTEXT_" Margin="5" Width="75" Background="#FF0066CC" BorderBrush="White" Foreground="White" Padding="8,4"/>
						<Button Name="CancelButton" Content="_CANCELBUTTONTEXT_" Margin="5" Width="75" Background="#FF0066CC" BorderBrush="White" Foreground="White" Padding="8,4"/>
					</StackPanel>
					</Border>
				</StackPanel>
			</ScrollViewer>
		</Grid>
</Window>
'@

	# Build Dialog
	$WPFGui = NewWPFDialog -XamlData $WPFXaml
	$WPFGui.Message.Text = $MessageText
	$WPFGui.Title.Text = $TitleText
	$WPFGui.Message.Text = $MessageText

	$WPFGui.OKButton.Content = $OKButtonText
	$WPFGui.CancelButton.Content = $CancelButtonText

	# Create a script block to handle the button click event
	$buttonClickEvent = {
		param($sender, $e)
		$global:Result = $sender.Name
		$WPFGui.UI.Close()
	}

	# Add the script block to the button's Click event
	$WPFGui.OKButton.Add_Click($buttonClickEvent)
	
	# Create a script block to handle the button click event for "Cancel" button
	$cancelButtonClickEvent = {
		param($sender, $e)
		$global:Result = $sender.Name  # Set the Result to the name of the clicked button ("CancelButton")
		$WPFGui.UI.Close()
	}
	
	# Add the script block to the "Cancel" button's Click event
	$WPFGui.CancelButton.Add_Click($cancelButtonClickEvent)

	# Create a variable to hold the result
	$global:Result = $null

	# Show the dialog
	$null = $WPFGUI.UI.Dispatcher.InvokeAsync{ $WPFGui.UI.ShowDialog() }.Wait()

	# Return the result
	return $global:Result
}

function cleanDialog {
	param (
		[string]$TitleText = "Do you want to continue?",
		[string]$MessageText = "",
		[string]$OKButtonText = "OK",
		[string]$CancelButtonText = "Cancel"
	)

	# This is the XAML that defines the GUI.
	$WPFXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" Background="#FF0066CC" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" MaxWidth="600" Padding="20" Margin="0" Topmost="True">
	<Grid Name="grid">
		<ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
			<StackPanel>
				<Border Margin="20,20,0,20" Background="Transparent">
					<TextBlock Name="Title" Margin="0,10,0,10" TextWrapping="Wrap" Text="_TITLE_" FontSize="24" FontWeight="Bold" HorizontalAlignment="Left"/>
				</Border>
				<Border Margin="20,0,20,20" Background="Transparent">
					<TextBlock Name="Message" Margin="0,0,0,20" TextWrapping="Wrap" Text="_CONTENT_" FontSize="18"/>
				</Border>
			</StackPanel>
		</ScrollViewer>
	</Grid>
</Window>
"@

	# Build Dialog
	$WPFGui = NewWPFDialog -XamlData $WPFXaml
	$WPFGui.Title.Text = $TitleText
	$WPFGui.Message.Text = $MessageText

	# Show the dialog
	$null = $WPFGui.UI.Dispatcher.InvokeAsync{ $WPFGui.UI.Show() }.Wait()	

	# Return the UI
	return $WPFGui.UI
}

function cleanDialogBottomRight {
	param (
		[string]$TitleText = "Do you want to continue?",
		[string]$MessageText = "",
		[string]$OKButtonText = "OK",
		[string]$CancelButtonText = "Cancel"
	)

	# This is the XAML that defines the GUI.
	$WPFXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" Background="#FF0066CC" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" MaxWidth="600" Padding="20" Margin="0" Topmost="True">
	<Grid Name="grid">
		<ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
			<StackPanel>
				<Border Margin="20,20,0,20" Background="Transparent">
					<TextBlock Name="Title" Margin="0,10,0,10" TextWrapping="Wrap" Text="_TITLE_" FontSize="24" FontWeight="Bold" HorizontalAlignment="Left"/>
				</Border>
				<Border Margin="20,0,20,20" Background="Transparent">
					<TextBlock Name="Message" Margin="0,0,0,20" TextWrapping="Wrap" Text="_CONTENT_" FontSize="18"/>
				</Border>
			</StackPanel>
		</ScrollViewer>
	</Grid>
</Window>
"@

	# Build Dialog
	$WPFGui = NewWPFDialog -XamlData $WPFXaml
	$WPFGui.Title.Text = $TitleText
	$WPFGui.Message.Text = $MessageText

	# Show the dialog
	$null = $WPFGui.UI.Dispatcher.InvokeAsync{ $WPFGui.UI.Show() }.Wait()	

	# Return the UI
	return $WPFGui.UI
}

function cloudDialog {
	param (
		[string]$TitleText = "",
		[string]$MessageText = "",
		[string]$Img = "",
		[string]$OKButtonText = "OK",
		[string]$CancelButtonText = "Cancel"
	)
	
	Add-Type -AssemblyName System.Windows.Forms
	
	$screen = [System.Windows.Forms.Screen]::PrimaryScreen
	$width = $screen.Bounds.Width
	$height = $screen.Bounds.Height
	
	$top = 20
	$left = $width - 60

	# This is the XAML that defines the GUI.
	$WPFXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" Background="Transparent" Foreground="#00FFFFFF" ResizeMode="NoResize" WindowStartupLocation="Manual" Width="50" Height="50" Top="$top" Left="$left" WindowStyle="None" MaxWidth="50" Padding="0" Margin="0" Topmost="True" AllowsTransparency="True">
	<Grid Name="grid">
		<ScrollViewer VerticalScrollBarVisibility="Disabled" HorizontalScrollBarVisibility="Disabled">
			<StackPanel>
				<Image Name="Picture" Width="50"  Height="50"/>
			</StackPanel>
		</ScrollViewer>
	</Grid>
</Window>
"@



	# Build Dialog
	$WPFGui = NewWPFDialog -XamlData $WPFXaml
	$WPFGui.Picture.Source = $Img

	# Show the dialog
	$null = $WPFGui.UI.Dispatcher.InvokeAsync{ $WPFGui.UI.Show() }.Wait()	

	# Return the UI
	return $WPFGui.UI
}


function startScriptWithAdmin {
	param (
		[string]$ScriptContent
	)
	
	#$scriptContent = @"
	#. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1; 
	#Write-Host "I'm Admin"
	#"@
	
	#StartScriptWithAdmin -ScriptContent $scriptContent

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
#target is the real folder, source is the simlink because...windows
mkdir "$target" -ErrorAction SilentlyContinue
if(testAdministrator -eq $true){
	New-Item -ItemType SymbolicLink -Path "$source" -Target "$target" -ErrorAction SilentlyContinue
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
		
			# We copy the saves to the Emulation/saves Folder and we create a backup
			echo "Creating saves symlink"
			#Move-Item -Path "$simLinkPath\*" -Destination $emuSavePath -Force						
			Copy-Item -Path "$simLinkPath\*" -Destination $emuSavePath -Recurse
			
			if ($?) {				
				$backupSuffix = "_bak"
				$backupName = -join($simLinkPath, $backupSuffix)						
				Rename-Item -Path "$simLinkPath" -NewName "$backupName"  -ErrorAction SilentlyContinue
			}
			createSymlink $simLinkPath $emuSavePath
		}	
	}else{
		createSymlink $simLinkPath $emuSavePath
	}
	
}


function toastNotification {
	param(
		[string]$Title,
		[string]$Message,
		[string]$img
	)

	#Specify Launcher App ID
	$LauncherID = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe"

	#Load Assemblies
	[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
	[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

	#Build XML Template
	$ToastTemplate = @"
<toast activationType="foreground">
	<duration value="0.5"/>
	<visual>
		<binding template="ToastImageAndText03">
			<text id="1">$Title</text>
			<text id="2">$Message</text>
			<image id="1" src="$img" />
		</binding>
	</visual>
</toast>
"@

	#Prepare XML
	$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
	$ToastXml.LoadXml($ToastTemplate)

    # Prepare and Create Toast
	$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXml)
	
	# Create a scheduled trigger to remove the notification after a delay
	$Trigger = New-ScheduledTaskTrigger -Once -At ([System.DateTime]::Now.AddSeconds(2))
	Register-ScheduledTask -Trigger $Trigger -Action { Unregister-ScheduledTask -TaskName "RemoveNotificationTask" } -TaskName "RemoveNotificationTask" -Force
	
	# Show the toast notification
	[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($LauncherID).Show($ToastMessage)

}

function steamToast {
  param (
	[string]$TitleText = "CloudSync",
	[string]$MessageText = ""
  )

  $ScreenWidth =  (Get-WmiObject -Class Win32_VideoController).CurrentHorizontalResolution;
  $ScreenHeight =  (Get-WmiObject -Class Win32_VideoController).CurrentVerticalResolution;
  $monitor = Get-WmiObject -Namespace "root\wmi" -Class "WmiMonitorBasicDisplayParams"
  
  if ($monitor.CurrentOrientation -ne 1) {
	$ScreenWidth = $ScreenHeight
	$ScreenHeight = $ScreenWidth
  }

  $WindowWidth = 400
  $WindowHeight = 80 
  $Margin = 50 

  $WindowLeft = $ScreenWidth - $WindowWidth - $Margin
  $WindowTop = $ScreenHeight - $WindowHeight - $Margin

  $WPFXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
	  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
	  Title="Popup" Background="#000000" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="Manual"
	  Width="$WindowWidth" Height="$WindowHeight" Left="$WindowLeft" Top="$WindowTop" WindowStyle="None" Topmost="True">
	<Grid Name="grid">
	  <ScrollViewer VerticalScrollBarVisibility="Disabled" HorizontalScrollBarVisibility="Disabled">
		<StackPanel>
		  <Border Margin="10,10,10,10" Background="#000000">
			<StackPanel Orientation="Horizontal">
			  <Image Source="$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/tools/cloudSync/steamdecklogo.png" Width="50" Height="50" VerticalAlignment="Center" Margin="0,0,10,0" />
			  <StackPanel Orientation="Vertical">
				<TextBlock Name="Title" Margin="0,0,0,0" Text="_TITLE_" FontSize="16" FontWeight="Bold" HorizontalAlignment="Left"/>
				<TextBlock Name="Message" Margin="0,0,0,0" TextWrapping="Wrap"  HorizontalAlignment="Left" Text="_CONTENT_" FontSize="12"/>
			  </StackPanel>
			</StackPanel>
		  </Border>
		</StackPanel>
	  </ScrollViewer>
	</Grid>
  </Window>
"@


  $WPFGui = NewWPFDialog -XamlData $WPFXaml
  $WPFGui.Title.Text = $TitleText
  $WPFGui.Message.Text = $MessageText

  $null = $WPFGui.UI.Dispatcher.InvokeAsync{ $WPFGui.UI.Show() }.Wait()

  return $WPFGui.UI
}