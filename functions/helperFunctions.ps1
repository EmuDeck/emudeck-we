function setSetting($old, $new){
	$fileToCheck = "$userFolder\EmuDeck\settings.ps1"

	$fileContents = Get-Content $fileToCheck
	$line = $fileContents | Select-String $old | Select-Object -ExpandProperty Line
	if ($line) {
		$newLine = -join('$', $old, '=', '"', $new, '"')
		$modifiedContents = $fileContents | ForEach-Object { $_.Replace($line, $newLine) }

		$modifiedContents | Set-Content $fileToCheck -Encoding UTF8

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

		$modifiedContents | Set-Content $fileToCheck -Encoding UTF8

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

		$modifiedContents | Set-Content $fileToCheck -Encoding UTF8
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

function getLocations {
	$drives = Get-WmiObject -Class Win32_DiskDrive

	$driveInfo = @()

	$networkDrives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=4"
	foreach ($networkDrive in $networkDrives) {
		$name = $networkDrive.VolumeName
		$size = if ($networkDrive.Size) { [math]::Round($networkDrive.Size / 1GB, 2) } else { $null }
		# Verificar si hay espacio disponible antes de agregar al array
		if ($size -ne $null) {
			$driveInfo += @{
				name   = $name
				size   = $size
				type   = "Network"
				letter = $networkDrive.DeviceID
			}
		}
	}

	foreach ($drive in $drives) {
		$driveType = "Unknown"
		if ($drive.MediaType -eq "Fixed hard disk media") {
			$driveType = "Internal"
		} elseif ($drive.MediaType -eq "Removable media") {
			$driveType = "External"
		}

		$logicalDisks = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($drive.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition"
		foreach ($logicalDisk in $logicalDisks) {
			$partitions = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($logicalDisk.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition"
			foreach ($partition in $partitions) {
				$name = $drive.Model
				$size = if ($drive.Size) { [math]::Round($drive.Size / 1GB, 2) } else { $null }
				# Verificar si hay espacio disponible antes de agregar al array
				if ($size -ne $null) {
					$driveInfo += @{
						name   = $name
						size   = $size
						type   = $driveType
						letter = $partition.DeviceID
					}
				}
			}
		}
	}

	$driveInfo = $driveInfo | Sort-Object -Property letter

	$jsonArray = @()
	foreach ($info in $driveInfo) {
		$jsonArray += $info | ConvertTo-Json
	}

	$json = "[" + ($jsonArray -join ",") + "]"

	if ($json -eq "[]"){
		$json = '[{ "type":  "Internal", "letter":  "C:", "name":  "harddisk SSD", "size": 999 }]'
	}

	Write-Host $json
}



function customLocation(){
	Add-Type -AssemblyName System.Windows.Forms

	# Crear el selector de directorios
	$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
	$folderBrowser.Description = "Select a folder"
	$folderBrowser.ShowNewFolderButton = $true

	# Mostrar el selector y capturar la carpeta seleccionada
	if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
		$selectedFolder = $folderBrowser.SelectedPath
		Write-Host "$selectedFolder"
	} else {
		Write-Host "C:\"
	}
}

function testLocationValid($mode, $path){

	$globPath = $path[0] +":"

	$driveInfo = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='$globPath'"
	if ($driveInfo.DriveType -eq 4) {
		Write-Host "Valid"
	}else{
		rm -fo -r "$globPath\test"
		$null = New-Item -ItemType Junction -Path "$globPath\test" -Target "$env:APPDATA\EmuDeck\backend" -Force
		if($?){
			rm -fo -r "$globPath\test"
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
	(Get-ChildItem -Path "$env:APPDATA\EmuDeck" -Filter ".ui-finished" -Recurse -ErrorAction SilentlyContinue -Force) -and (Write-Output "true") ; rm -fo -r $dir/$fileName
}


function getLatestReleaseURLGH($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

	$url = "https://api.github.com/repos/$Repository/releases/latest"

	$url = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty assets |
		   Where-Object { $_.browser_download_url -Match $FindToMatch -and $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } |
		   Select-Object -ExpandProperty browser_download_url | Select-Object -First 1
		   return $url

	return $url
}

function getLatestReleaseVersion($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

	$url = "https://api.github.com/repos/$Repository/releases/latest"

	$name = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty name | Select-Object -First 1
		   return $name

	return $name
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
		[string]$OKButtonText = "Continue",
		[string]$CancelButtonText = "Cancel",
		[string]$Position = "CenterScreen"
	)
	# This is the XAML that defines the GUI.
	$WPFXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
	xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
	Title="Popup" AllowsTransparency="True" Background="Transparent"  Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="$Position" SizeToContent="WidthAndHeight" WindowStyle="None" MaxWidth="600" Padding="20" Margin="0" Topmost="True">
	<Border CornerRadius="10" BorderBrush="#222" BorderThickness="2" Background="#222">
	 <Grid Name="grid">
				<ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
					<StackPanel>
						<Border Margin="20,10,0,20" Background="Transparent">
							<TextBlock Name="Title" Margin="0,10,0,10" TextWrapping="Wrap" Text="_TITLE_" FontSize="24" FontWeight="Bold" HorizontalAlignment="Left"/>
						</Border>
						<Border Margin="20,0,20,0" Background="Transparent">
							<TextBlock Name="Message" Margin="0,0,0,20" TextWrapping="Wrap" Text="_CONTENT_" FontSize="18"/>
						</Border>
						<StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
							<Border CornerRadius="20" BorderBrush="#5bf" BorderThickness="1" Background="#5bf" Margin="0,0,10,20" >
								<Button Name="OKButton" BorderBrush="Transparent" Content="_OKBUTTONTEXT_" Background="Transparent" FontSize="16" Foreground="White">
									<Button.Style>
										<Style TargetType="Button">
											<Setter Property="Background" Value="#5bf" />
											<Setter Property="Template">
												<Setter.Value>
													<ControlTemplate TargetType="Button">
														<Border CornerRadius="20" Background="{TemplateBinding Background}" BorderThickness="1" Margin="16,8,16,8">
															<ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
														</Border>
														<ControlTemplate.Triggers>
															<Trigger Property="IsMouseOver" Value="True">
																<Setter Property="Background" Value="#fff" />
															</Trigger>
														</ControlTemplate.Triggers>
													</ControlTemplate>
												</Setter.Value>
											</Setter>
										</Style>
									</Button.Style>
								</Button>
							</Border>
						</StackPanel>
					</StackPanel>
				</ScrollViewer>
			</Grid>
	</Border>
</Window>
"@

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
		[string]$OKButtonText = "Continue",
		[string]$CancelButtonText = "Cancel",
		[bool]$ShowCancelButton = $true

	)
	# This is the XAML that defines the GUI.

	$WPFXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" AllowsTransparency="True" Background="Transparent" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" MaxWidth="600" Padding="20" Margin="0" Topmost="True">
<Border CornerRadius="10" BorderBrush="#222" BorderThickness="2" Background="#222">
 <Grid Name="grid">
			<ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
				<StackPanel>
					<Border Margin="20,10,0,20" Background="Transparent">
						<TextBlock Name="Title" Margin="0,10,0,10" TextWrapping="Wrap" Text="_TITLE_" FontSize="24" FontWeight="Bold" HorizontalAlignment="Left"/>
					</Border>
					<Border Margin="20,0,20,0" Background="Transparent">
						<TextBlock Name="Message" Margin="0,0,0,20" TextWrapping="Wrap" Text="_CONTENT_" FontSize="18"/>
					</Border>
					<Border Margin="20,0,20,20" Background="Transparent">
					<StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
						<Border CornerRadius="20" BorderBrush="#5bf" BorderThickness="1" Background="#5bf" Margin="0,0,10,0" >
							<Button Name="OKButton" BorderBrush="Transparent" Content="_OKBUTTONTEXT_" Background="Transparent" FontSize="16" Foreground="White">
								<Button.Style>
									<Style TargetType="Button">
										<Setter Property="Background" Value="#5bf" />
										<Setter Property="Template">
											<Setter.Value>
												<ControlTemplate TargetType="Button">
													<Border CornerRadius="20" Background="{TemplateBinding Background}" BorderThickness="1" Margin="16,8,16,8">
														<ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
													</Border>
													<ControlTemplate.Triggers>
														<Trigger Property="IsMouseOver" Value="True">
															<Setter Property="Background" Value="#fff" />
														</Trigger>
													</ControlTemplate.Triggers>
												</ControlTemplate>
											</Setter.Value>
										</Setter>
									</Style>
								</Button.Style>
							</Button>
						</Border>
						<Border CornerRadius="20" BorderBrush="#666" BorderThickness="1" Background="#666">
							<Button Name="CancelButton" Content="_CANCELBUTTONTEXT_" Margin="0"  Background="Transparent" BorderBrush="Transparent" FontSize="16" Foreground="White">
								<Button.Style>
									<Style TargetType="Button">
										<Setter Property="Background" Value="#666" />
										<Setter Property="Template">
											<Setter.Value>
												<ControlTemplate TargetType="Button">
													<Border CornerRadius="20" Background="{TemplateBinding Background}" BorderThickness="1" Margin="16,8,16,8">
														<ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
													</Border>
													<ControlTemplate.Triggers>
														<Trigger Property="IsMouseOver" Value="True">
															<Setter Property="Background" Value="#fff" />
														</Trigger>
													</ControlTemplate.Triggers>
												</ControlTemplate>
											</Setter.Value>
										</Setter>
									</Style>
								</Button.Style>
							</Button>
						</Border>
					</StackPanel>
					</Border>
				</StackPanel>
			</ScrollViewer>
		</Grid>
</Border>
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
		[string]$OKButtonText = "Continue",
		[string]$CancelButtonText = "Cancel"
	)

	# This is the XAML that defines the GUI.
	$WPFXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" AllowsTransparency="True" Background="Transparent" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" MaxWidth="600" Padding="20" Margin="0" Topmost="True">
	<Border CornerRadius="10" BorderBrush="#222" BorderThickness="2" Background="#222">
		<Grid Name="grid">
			<ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
				<StackPanel>
					<Border Margin="20,10,0,20" Background="Transparent">
						<TextBlock Name="Title" Margin="0,10,0,10" TextWrapping="Wrap" Text="_TITLE_" FontSize="24" FontWeight="Bold" HorizontalAlignment="Left"/>
					</Border>
					<Border Margin="20,0,20,20" Background="Transparent">
						<TextBlock Name="Message" Margin="0,0,0,20" TextWrapping="Wrap" Text="_CONTENT_" FontSize="18"/>
					</Border>
				</StackPanel>
			</ScrollViewer>
		</Grid>
	</Border>
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
		[string]$OKButtonText = "Continue",
		[string]$CancelButtonText = "Cancel"
	)

	# This is the XAML that defines the GUI.
	$WPFXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" AllowsTransparency="True" Background="Transparent" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" MaxWidth="600" Padding="20" Margin="0" Topmost="True">
	<Border CornerRadius="10" BorderBrush="#222" BorderThickness="2" Background="#222">
		<Grid Name="grid">
			<ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
				<StackPanel>
					<Border Margin="20,10,0,20" Background="Transparent">
						<TextBlock Name="Title" Margin="0,10,0,10" TextWrapping="Wrap" Text="_TITLE_" FontSize="24" FontWeight="Bold" HorizontalAlignment="Left"/>
					</Border>
					<Border Margin="20,0,20,20" Background="Transparent">
						<TextBlock Name="Message" Margin="0,0,0,20" TextWrapping="Wrap" Text="_CONTENT_" FontSize="18"/>
					</Border>
				</StackPanel>
			</ScrollViewer>
		</Grid>
	</Border>
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
		[string]$OKButtonText = "Continue",
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
		Title="Popup" AllowsTransparency="True" Background="Transparent"  Foreground="#00FFFFFF" ResizeMode="NoResize" WindowStartupLocation="Manual" Width="50" Height="50" Top="$top" Left="$left" WindowStyle="None" MaxWidth="50" Padding="0" Margin="0" Topmost="True" AllowsTransparency="True">
	<Border CornerRadius="10" BorderBrush="#222" BorderThickness="2" Background="#222">
		<Grid Name="grid">
			<ScrollViewer VerticalScrollBarVisibility="Disabled" HorizontalScrollBarVisibility="Disabled">
				<StackPanel>
					<Image Name="Picture" Width="50"  Height="50"/>
				</StackPanel>
			</ScrollViewer>
		</Grid>
	</Border>
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
				rm -fo -r $simLinkPath
				New-Item -ItemType Junction -Path "$simLinkPath"  -Target "$emuSavePath"
			}else{
				echo "Symlink already exists, we do nothing since this is a network installation"
			}
		} else {
			#Check if we have space

			#$userDrive=(Get-Item "$emulationPath").PSDrive.Name
			#$destinationFree = (Get-PSDrive -Name $userDrive).Free
			#$sizeInGB = [Math]::Round($destinationFree / 1GB)

			#$originSize = (Get-ChildItem -Path "$simLinkPath" -Recurse | Measure-Object -Property Length -Sum).Sum
			#$wshell = New-Object -ComObject Wscript.Shell

			#if ( $originSize -gt $destinationFree ){
			#	$Output = $wshell.Popup("You don't have enough space in your $userDrive drive, free at least $sizeInGB GB so we can migrate your saves")
			#	exit
			#}

			# We copy the saves to the Emulation/saves Folder and we create a backup
			echo "Creating saves symlink"
			$originalFolderName = Split-Path $simLinkPath -Leaf
			$newFolderName = Split-Path $emuSavePath -Leaf
			$emuSaveParent = Split-Path $emuSavePath -Parent

			rmdir "$emuSavePath" -ErrorAction SilentlyContinue
			Move-Item -Path "$simLinkPath" -Destination $emuSaveParent -Force
			Rename-Item -Path "$emuSaveParent\$originalFolderName" -NewName  $newFolderName -Force

   			#Copy-Item -Path "$simLinkPath\*" -Destination $emuSavePath -Recurse -Force

			if ($?) {
				if ($networkInstallation -eq "false"){
					$backupSuffix = "_bak"
					$backupName = -join($simLinkPath, $backupSuffix)
					Rename-Item -Path "$simLinkPath" -NewName "$backupName"  -ErrorAction SilentlyContinue
				}
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

	# Obtener el tamaño de la pantalla
	$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
	$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

	$form.Width = $screenWidth
	$form.Height = $screenHeight

# 	$pictureBox = New-Object Windows.Forms.PictureBox
# 	$pictureBox.Image = [System.Drawing.Image]::FromFile("$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/img/logo.png")
# 	$pictureBox.SizeMode = [Windows.Forms.PictureBoxSizeMode]::CenterImage
# 	$pictureBox.Dock = [Windows.Forms.DockStyle]::Fill
#
# 	$form.Controls.Add($pictureBox)
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
	  Title="Popup" AllowsTransparency="True" Background="Transparent" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="Manual"
	  Width="$WindowWidth" Height="$WindowHeight" Left="$WindowLeft" Top="$WindowTop" WindowStyle="None" Topmost="True">
	<Border CornerRadius="10" BorderBrush="#222" BorderThickness="2" Background="#000000">
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
	</Border>
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
	$steamInstallPath = $steamInstallPath.Replace("/", "\")
	$steamArguments = "$silent"
	Start-Process -FilePath "$steamInstallPath\Steam.exe" -ArgumentList $steamArguments
}

function killBOM($file){
	$content = Get-Content -Path $file -Raw
	$killBOM = New-Object System.Text.UTF8Encoding $false
	[System.IO.File]::WriteAllText($file, $content, $killBOM)
}


function setResolutions(){
	. "$userFolder\EmuDeck\settings.ps1"
	#Cemu_setResolution
	Citra_setResolution $citraResolution
	Dolphin_setResolution $dolphinResolution
	DuckStation_setResolution $duckstationResolution
	#Flycast_setResolution
	#MAME_setResolution
	melonDS_setResolution $melondsResolution
	#mGBA_setResolution
	PCSX2QT_setResolution $pcsx2Resolution
	#PPSSPP_setResolution
	#Primehack_setResolution
	#RetroArch_setResolution
	RPCS3_setResolution $rpcs3Resolution
	Ryujinx_setResolution $yuzuResolution
	#ScummVM_setResolution
	#SuperModel_setResolution
	#Template_setResolution
	#Vita3K_setResolution
	#Xemu_setResolution $xemuResolution
	#Xenia_setResolution $xeniaResolution
	Yuzu_setResolution $yuzuResolution
}



function getEmuRepo($emuName){

	switch ( $emuName )
	{
		"cemu" { $repo="cemu-project/Cemu" }
		"citra" { $repo="citra-emu/citra-nightly" }
		"dolphin" { $repo="shiiion/dolphin" }
		"duckstation" { $repo="stenzek/duckstation" }
		"flycast" { $repo="flyinghead/flycast" }
		"MAME" { $repo="mamedev\mame" }
		"melonDS" { $repo="melonDS-emu/melonDS" }
		"mgba" { $repo="mgba-emu/mgba" }
		"pcsx2" { $repo="pcsx2/pcsx2" }
		"primehack" { $repo="shiiion/dolphin" }
		"rpcs3" { $repo="RPCS3/rpcs3-binaries-win" }
		"ryujinx" { $repo="Ryujinx/release-channel-master" }
		"vita3K" { $repo="Vita3K/Vita3K" }
		"xemu" { $repo="xemu-project/xemu" }
		"xenia" { $repo="xenia-canary/xenia-canary" }
		"yuzu" { $repo="yuzu-emu/yuzu-mainline" }
		default { $repo = "none" }
	}
	return $repo
}


function getLatestVersionGH($repository){

	$url = "https://api.github.com/repos/$repository/releases/latest"

	$id = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty id | Select-Object -First 1
		   return $id

	return $id
}


function saveLatestVersionGH($emuName){
	if ( check_internet_connection -eq 'true' ){
		$repo = getEmuRepo $emuName

		if( $repo -eq "none" ){
			echo "no autoupdate"
		}else{
			$emuVersion = getLatestVersionGH $repo
			# JSON file path
			$jsonFilePath = "$env:USERPROFILE\EmuDeck\emu_versions.json"

			$test=Test-Path -Path $jsonFilePath
			if($test){
				echo "file found"
			}else{
				"{}" | Set-Content -Path $rutaArchivo
			}

			# Read the content of the JSON file
			$jsonContent = Get-Content -Path $jsonFilePath | ConvertFrom-Json

			# Check if the key exists
			if ($jsonContent.PSObject.Properties[$emuName]) {
				# The key exists, change its value
				$jsonContent.$emuName = $emuVersion
			} else {
				# The key doesn't exist, create it with a new value
				$jsonContent | Add-Member -MemberType NoteProperty -Name $emuName -Value $emuVersion
			}

			# Convert the modified JSON object back to JSON format
			$modifiedJson = $jsonContent | ConvertTo-Json -Depth 10

			# Save the modified JSON back to the file
			$modifiedJson | Set-Content -Path $jsonFilePath
		}
	}
}


function isLatestVersionGH($emuName){

	if ( check_internet_connection -eq 'true' ){
		$repo = getEmuRepo $emuName

		if( $repo -eq "none" ){
			echo "no autoupdate"
		}else{
			$emuVersion = getLatestVersionGH $repo

			# JSON file path
			$jsonFilePath = "$env:USERPROFILE\EmuDeck\emu_versions.json"

			$test=Test-Path -Path $jsonFilePath
			if($test){
				echo "file found"
			}else{
				"{}" | Set-Content -Path $rutaArchivo
			}

			# Read the content of the JSON file
			$jsonContent = Get-Content -Path $jsonFilePath | ConvertFrom-Json

			# Check if the key exists
			if ($jsonContent.PSObject.Properties[$emuName]) {

				# The key exists, check if it's the same value
				if( $jsonContent.$emuName -ne $emuVersion ){
					$jsonContent.$emuName = $emuVersion
					$latest="false"
				}else{
					$latest="true"
				}
			} else {
				# The key doesn't exist, create it with a new value
				$jsonContent | Add-Member -MemberType NoteProperty -Name $emuName -Value "$emuVersion"
				$latest="true"
			}
			if ($latest -eq "false"){

				#Ask the user to update

				$capitalizedEmuName= $emuName.Substring(0,1).ToUpper() + $emuName.Substring(1).ToLower()

				$result = yesNoDialog -TitleText "New Update" -MessageText "We've detected an update for $capitalizedEmuName. Do you want to update?" -OKButtonText "Yes" -CancelButtonText "No"

				if ($result -eq "OKButton") {
					# Convert the modified JSON object back to JSON format
					$modifiedJson = $jsonContent | ConvertTo-Json -Depth 10

					# Save the modified JSON back to the file
					$modifiedJson | Set-Content -Path $jsonFilePath

					& "${emuName}_Install"
				}

			}else{
				$modifiedJson = $jsonContent | ConvertTo-Json -Depth 10

				# Save the modified JSON back to the file
				$modifiedJson | Set-Content -Path $jsonFilePath

			}

			Write-Host "Latest version=$latest"
		}
	}


}



function storePatreonToken($token){
	mkdir "$savesPath" -ErrorAction SilentlyContinue
	$token | Set-Content -Path "$savesPath/.token" -Encoding UTF8
	if (Test-Path "$cloud_sync_bin") {
		& $cloud_sync_bin --progress copyto --fast-list --checkers=50 --transfers=50 --low-level-retries 1 --retries 1 "$savesPath/.token" "$cloud_sync_provider`:$cs_user`Emudeck\saves\.token"
	}else{
		echo "NOPE"
	}
}

function startCompressor(){
	Start-Process cmd -ArgumentList "/k powershell -ExecutionPolicy Bypass -NoProfile -File `"$toolsPath/chdconv/chddeck.ps1`""
}