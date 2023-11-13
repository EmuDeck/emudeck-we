function setSetting($old, $new){
	$fileToCheck = "$userFolder\EmuDeck\settings.ps1"

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -ExpandProperty Line
	if ($line) {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$modifiedContents = $fileContents | ForEach-Object { $_.Replace($line, $newLine) }

		echo $modifiedContents > $fileToCheck

		Write-Host "Line '$line' changed to '$newLine'"
	} else {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$newLine += "`r`n"  # Agregar nueva línea al final del contenido
		Add-Content $fileToCheck $newLine -Encoding UTF8

		Write-Host "New line '$newLine' created in $fileToCheck"
	}
}

function setSettingNoQuotes($file, $old, $new){
	$fileToCheck = $file

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -ExpandProperty Line
	if ($line) {
		$newLine = -join($old, '=', $new)
		$modifiedContents = $fileContents | ForEach-Object { $_.Replace($line, $newLine) }

		echo $modifiedContents > $fileToCheck

		Write-Host "Line '$line' changed to '$newLine'"
	} else {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$newLine += "`r`n"  # Agregar nueva línea al final del contenido
		Add-Content $fileToCheck $newLine -Encoding UTF8

		Write-Host "New line '$newLine' created in $fileToCheck"
	}
}

 function setConfig($old, $new, $fileToCheck){

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line
	if ($line){
		$newLine=-join($old,'=',$new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line,$newLine)} -ErrorAction SilentlyContinue

		echo $modifiedContents > $fileToCheck
		Write-Output "Line $line changed to $newLine"
	}else{
		$newLine=-join($old,'=',$new)
		Add-Content $fileToCheck $newLine -Encoding UTF8
		Write-Output "Line created on $fileToCheck"
	}

}

function setConfigRA($old, $new, $fileToCheck){
	$fileContents = Get-Content $fileToCheck -Encoding UTF8
	$line = $fileContents | Select-String $old | Select-Object -First 1 -ExpandProperty Line

	if ($line){
		$newLine = -join($old, ' = ', $new)
		$modifiedContents = $fileContents | ForEach-Object {$_.Replace($line, $newLine)} -ErrorAction SilentlyContinue

		$modifiedContents | Set-Content $fileToCheck -Encoding UTF8

		Write-Output "Line $line changed to $newLine"
	} else {
		$newLine = -join($old, ' = ', $new)
		Add-Content -Path $fileToCheck -Value $newLine -Encoding UTF8
		Write-Output "Line created on $fileToCheck"
	}
}

function getLocations() {
	$drives = Get-WmiObject -Class Win32_DiskDrive

	$driveInfo = @()

	$networkDrives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=4"
	foreach ($networkDrive in $networkDrives) {
		$driveInfo += @{
			name = $networkDrive.VolumeName
			size = [math]::Round($networkDrive.Size / 1GB, 2)
			type = "Network"
			letter = $networkDrive.DeviceID
		}
	}

	foreach ($drive in $drives) {
		$driveType = "Unknown"
		if ($drive.MediaType -eq "Fixed hard disk media") {
			$driveType = "Internal"
		} elseif ($drive.MediaType -eq "Removable media") {
			$driveType = "External"
		}

		$driveLetter = $null
		$logicalDisks = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($drive.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition"
		foreach ($logicalDisk in $logicalDisks) {
			$partitions = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($logicalDisk.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition"
			foreach ($partition in $partitions) {
				$driveLetter = $partition.DeviceID
			}
		}

		$driveInfo += @{
			name = $drive.Model
			size = [math]::Round($drive.Size / 1GB, 2)
			type = $driveType
			letter = $driveLetter
		}
	}

	$driveInfo = $driveInfo | Sort-Object -Property letter

	$jsonArray = @()
	foreach ($info in $driveInfo) {
		$jsonArray += $info | ConvertTo-Json
	}

	$json = "[" + ($jsonArray -join ",") + "]"

	Write-Host $json
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

	$globPath = $path[0] +":"

	$driveInfo = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='$globPath'"
	if ($driveInfo.DriveType -eq 4) {
		Write-Host "Valid"
	}else{
		rm -fo "$globPath\test" -Recurse
		$null = New-Item -ItemType Junction -Path "$globPath\test" -Target "$env:APPDATA\EmuDeck\backend" -Force
		if($?){
			rm -fo "$globPath\test" -Recurse
			Write-Output "Valid"
		} else {
			Write-Output "Wrong"
		}

	}
}

function escapeSedKeyword($input){
	Write-Output $input
}

function escapeSedValue($input){
	Write-Output $input
}

function changeLine($Keyword,$Replace,$File) {

	Write-Host "Updating: $File - $Keyword to $Replace"

	$Content = Get-Content $File
	$NewContent = @()

	foreach ($line in $Content) {
		if ($line -match "^$Keyword") {
			$NewContent += $Replace
		} else {
			$NewContent += $line
		}
	}

	$NewContent | Set-Content $File -Encoding UTF8
}

function setMSG($message){
	$progressBarValue = Get-Content -Path "$userFolder\AppData\Roaming\EmuDeck\msg.log" -TotalCount 1 -ErrorAction SilentlyContinue
	if ($progressBarValue -match '^\d+$') {
		$progressBarUpdate = [int]$progressBarValue + 5
	}
	#We prevent the UI to close if we have too much MSG, the classic eternal 99%
	if ( $progressBarUpdate -eq 95 ){
		$progressBarUpdate=90
	}
	"$progressBarUpdate" | Out-File -encoding ascii "$userFolder\AppData\Roaming\EmuDeck\msg.log"
	Write-Output $message
	Add-Content "$userFolder\AppData\Roaming\EmuDeck\msg.log" "# $message" -NoNewline -Encoding UTF8
	Start-Sleep -Seconds 0.5
}


#Used in the appimage only
function checkForFile($fileName){
	(Get-ChildItem -Path "$env:APPDATA\EmuDeck" -Filter ".ui-finished" -Recurse -ErrorAction SilentlyContinue -Force) -and (Write-Output "true") ; rm -fo $dir/$fileName
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

function startLog($funcName){

	Start-Transcript "$env:USERPROFILE/EmuDeck/logs/$funcName.log"

}

function startLogBG($funcName, $folder){

	Start-Transcript "$folder/EmuDeck/logs/$funcName.log"

}

function stopLog(){

    Stop-Transcript
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

	# Create a script block to handle the button click event
	$buttonClickEvent = {
		param($sender, $e)
		$global:Result = $sender.Name
		$WPFGui.UI.Close()
	}

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
	$tempScriptPath = [System.IO.Path]::GetTempFileName() + ".ps1"
	$ScriptContent | Out-File -FilePath $tempScriptPath -Encoding utf8 -Force

	$psi = New-Object System.Diagnostics.ProcessStartInfo
	$psi.Verb = "runas"
	$psi.FileName = "powershell.exe"
	$psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File ""$tempScriptPath"""
	[System.Diagnostics.Process]::Start($psi).WaitForExit()

	Remove-Item $tempScriptPath -Force
}

function createSymlink($source, $target){
#target is the real folder, source is the simlink because...windows
mkdir "$target" -ErrorAction SilentlyContinue
#
if ($networkInstallation -eq "false"){
	New-Item -ItemType Junction -Path "$source"  -Target "$target" -ErrorAction SilentlyContinue
} else {

if(testAdministrator -eq $true){
	New-Item -ItemType SymbolicLink -Path "$source" -Target "$target" -ErrorAction SilentlyContinue
}else{
	$scriptContent = @"
		. "$env:APPDATA\EmuDeck\backend\functions\all.ps1"
		New-Item -ItemType SymbolicLink -Path "$source" -Target "$target" -ErrorAction SilentlyContinue
"@

	startScriptWithAdmin -ScriptContent $scriptContent
}
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
			if ($networkInstallation -eq "false"){
				echo "Symlink already exists, we delete it and make it a junction"
				rm -fo $simLinkPath -Recurse
				New-Item -ItemType Junction -Path "$simLinkPath"  -Target "$emuSavePath"
			}else{
				echo "Symlink already exists, we do nothing since this is a network installation"
			}
		} else {
			#Check if we have space

			$userDrive=(Get-Item "$emulationPath").PSDrive.Name
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
			Copy-Item -Path "$simLinkPath\*" -Destination $emuSavePath -Recurse -Force

			if ($?) {
				$backupSuffix = "_bak"
				$backupName = -join($simLinkPath, $backupSuffix)
				Rename-Item -Path "$simLinkPath" -NewName "$backupName"  -ErrorAction SilentlyContinue
			}
			createSymlink $simLinkPath $emuSavePath
		}
	}else{
		createSymlink $simLinkPath $emuSavePath
		#cloud_sync_save_hash "$emuSavePath"
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

function setScreenDimensionsScale(){
	Add-Type -Assembly System.Windows.Forms;
	# $Scale may no longer be necessary since Windows.Forms.Screen outputs pre-scaled resolutions.
	# Consider removing it if it is not used anymore.
	$Scale = getScreenScale;
	# No need to check orientation of screen, again Windows.Forms handles this.
	$ScreenHeight = ([System.Windows.Forms.Screen]::PrimaryScreen.bounds.Height)*$Scale;
	$ScreenWidth = ([System.Windows.Forms.Screen]::PrimaryScreen.bounds.Width)*$Scale;
	# Storing the raw resolution (IE, unscaled)
	setSetting "ScreenWidth" "$ScreenWidth"
	setSetting "ScreenHeight" "$ScreenHeight"
	setSetting "Scale" "$Scale"
	. "$env:USERPROFILE\EmuDeck\settings.ps1"
}

function fullScreenToast {

	[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	$form = New-Object Windows.Forms.Form
	$form.Text = "Popup"
	$form.WindowState = [Windows.Forms.FormWindowState]::Maximized
	$form.FormBorderStyle = [Windows.Forms.FormBorderStyle]::None
	$form.BackColor = [System.Drawing.Color]::Black
	$pictureBox = New-Object Windows.Forms.PictureBox
	$pictureBox.Image = [System.Drawing.Image]::FromFile("$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/img/logo.png")  # Reemplaza "RutaDelGif.gif" con la ruta a tu GIF animado
	$pictureBox.SizeMode = [Windows.Forms.PictureBoxSizeMode]::CenterImage
	$pictureBox.Dock = [Windows.Forms.DockStyle]::Fill  # Para que el PictureBox ocupe todo el formulario
	$form.Controls.Add($pictureBox)
	$form.Show()
	return $form
}

function steamToast {
  param (
	[string]$TitleText = "CloudSync",
	[string]$MessageText = ""
  )

  #$ScreenWidth= 1920
  #$ScreenHeight= 1200
  #$Scale=2


  $WindowWidth = 400
  $WindowHeight = 80
  $Margin = 25

  $WindowLeft = $ScreenWidth/$Scale - $WindowWidth - $Margin
  $WindowTop = $ScreenHeight/$Scale  - $WindowHeight - $Margin

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

function getScreenScale(){
Add-Type @'
  using System;
  using System.Runtime.InteropServices;
  using System.Drawing;

  public class DPI {
	[DllImport("gdi32.dll")]
	static extern int GetDeviceCaps(IntPtr hdc, int nIndex);

	public enum DeviceCap {
	  VERTRES = 10,
	  DESKTOPVERTRES = 117
	}

	public static float scaling() {
	  Graphics g = Graphics.FromHwnd(IntPtr.Zero);
	  IntPtr desktop = g.GetHdc();
	  int LogicalScreenHeight = GetDeviceCaps(desktop, (int)DeviceCap.VERTRES);
	  int PhysicalScreenHeight = GetDeviceCaps(desktop, (int)DeviceCap.DESKTOPVERTRES);

	  return (float)PhysicalScreenHeight / (float)LogicalScreenHeight;
	}
  }
'@ -ReferencedAssemblies 'System.Drawing.dll'

return [Math]::round([DPI]::scaling(), 2)
}


function zipLogs(){

	$logsFolder = Join-Path $env:USERPROFILE "emudeck\logs"
	$settingsFile = Join-Path $env:USERPROFILE "emudeck\settings.ps1"


	$zipOutput = "$env:USERPROFILE\Desktop\emudeck_logs.7z"

	& $7z a -t7z $zipOutput $logsFolder $settingsFile -bso0
	if ($LastExitCode -eq 0) {
		Write-Host "true"
	} else {
		Write-Host "false"
	}

}

function hideMe(){
$ShowWindowAsyncCode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
  $ShowWindowAsync = Add-Type -MemberDefinition $ShowWindowAsyncCode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru

  $hwnd = (Get-Process -PID $pid).MainWindowHandle
  if ($hwnd -ne [System.IntPtr]::Zero) {
	# When you got HWND of the console window:
	# (It would appear that Windows Console Host is the default terminal application)
	$ShowWindowAsync::ShowWindowAsync($hwnd, 0)
  } else {
	# When you failed to get HWND of the console window:
	# (It would appear that Windows Terminal is the default terminal application)

	# Mark the current console window with a unique string.
	$UniqueWindowTitle = New-Guid
	$Host.UI.RawUI.WindowTitle = $UniqueWindowTitle
	$StringBuilder = New-Object System.Text.StringBuilder 1024

	# Search the process that has the window title generated above.
	$TerminalProcess = (Get-Process | Where-Object { $_.MainWindowTitle -eq $UniqueWindowTitle })
	# Get the window handle of the terminal process.
	# Note that GetConsoleWindow() in Win32 API returns the HWND of
	# powershell.exe itself rather than the terminal process.
	# When you call ShowWindowAsync(HWND, 0) with the HWND from GetConsoleWindow(),
	# the Windows Terminal window will be just minimized rather than hidden.
	$hwnd = $TerminalProcess.MainWindowHandle
	if ($hwnd -ne [System.IntPtr]::Zero) {
	  $ShowWindowAsync::ShowWindowAsync($hwnd, 0)
	} else {
	  Write-Host "Failed to hide the console window."
	}
  }
 }

function checkAndStartSteam(){
	$steamRunning = Get-Process -Name "Steam" -ErrorAction SilentlyContinue
	if (!$steamRunning) {
		startSteam "-silent"
	}
}

function startSteam($silent){
	$steamRegPath = "HKCU:\Software\Valve\Steam"
	$steamInstallPath = (Get-ItemProperty -Path $steamRegPath).SteamPath
	$steamInstallPath = $steamInstallPath.Replace("/", "\\")
	$steamArguments = "$silent"
	Start-Process -FilePath "$steamInstallPath\Steam.exe" -ArgumentList $steamArguments
}


function setResolutions(){
	Cemu_setResolution
	Citra_setResolution
	Dolphin_setResolution
	DuckStation_setResolution
	Flycast_setResolution
	MAME_setResolution
	melonDS_setResolution
	mGBA_setResolution
	PCSX2QT_setResolution
	PPSSPP_setResolution
	Primehack_setResolution
	RetroArch_setResolution
	RPCS3_setResolution
	Ryujinx_setResolution
	ScummVM_setResolution
	SuperModel_setResolution
	Template_setResolution
	Vita3K_setResolution
	Xemu_setResolution
	Xenia_setResolution
	Yuzu_setResolution
}