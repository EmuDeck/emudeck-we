clear

#
##
###
#### Vars
###
##
#

$PSversionMajor = $PSVersionTable.PSVersion.Major
$PSversionMinor = $PSVersionTable.PSVersion.Minor
$PSversion = "$PSversionMajor$PSversionMinor"
$osInfo = (systeminfo | findstr /B /C:"OS Name") | ForEach-Object { $_ -replace 'OS Name:', '' }


#
##
###
#### Functions
###
##
#

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

function confirmDialog {
	param (
		[string]$TitleText = "Do you want to continue?",
		[string]$MessageText = "",
		[string]$OKButtonText = "Continue",
		[string]$CancelButtonText = "Cancel"
	)
	# This is the XAML that defines the GUI.
	$WPFXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Title="Popup" AllowsTransparency="True" Background="Transparent"  Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" MaxWidth="600" Padding="20" Margin="0" Topmost="True">
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

function getLatestReleaseURLGH($Repository, $FileType, $FindToMatch, $IgnoreText = "pepe"){

	$url = "https://api.github.com/repos/$Repository/releases/latest"

	$url = Invoke-RestMethod -Uri $url | Select-Object -ExpandProperty assets |
		   Where-Object { $_.browser_download_url -Match $FindToMatch -and $_.browser_download_url -like "*.$FileType" -and $_.browser_download_url -notlike "*$IgnoreText*" } |
		   Select-Object -ExpandProperty browser_download_url | Select-Object -First 1
		   return $url

	return $url
}

function startScriptWithAdmin {
	param (
		[string]$ScriptContent
	)

	#$scriptContent = @"
	#. "$env:APPDATA\EmuDeck\backend\functions\all.ps1";
	#Write-Host "I'm Admin"
	#"@

	$tempScriptPath = [System.IO.Path]::GetTempFileName() + ".ps1"
	$ScriptContent | Out-File -FilePath $tempScriptPath -Encoding utf8 -Force

	$psi = New-Object System.Diagnostics.ProcessStartInfo
	$psi.Verb = "runas"
	$psi.FileName = "powershell.exe"
	$psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File ""$tempScriptPath"""
	[System.Diagnostics.Process]::Start($psi).WaitForExit()

	Remove-Item $tempScriptPath -Force
}

function download($url, $file) {

	$wc = New-Object net.webclient
	$temp = Join-Path "$env:USERPROFILE" "Downloads"
	$destination="$temp/$file"
	mkdir $temp -ErrorAction SilentlyContinue

	$wc.Downloadfile($url, $destination)

	Write-Host "Done!" -NoNewline -ForegroundColor green -BackgroundColor black
}

if ($osInfo -contains "Windows 10 Home") {
	$developerModeStatus = Get-WindowsDeveloperLicense
	if ($developerModeStatus.DeveloperLicense) {
		Write-Host "Developer Mode detected..."
	} else {
		confirmDialog -TitleText "Windows 10 Home Detected" -MessageText "You need to enable Developer mode inside your Windows Settings to install EmuDeck."
		exit
	}
}



if( (Get-DnsClientServerAddress).ServerAddresses[0] -ne '1.1.1.1' -and (Get-DnsClientServerAddress).ServerAddresses[0] -ne '8.8.8.8' ){


	$result = yesNoDialog -TitleText "Slow DNS Detected" -MessageText "We've detected slow DNS, this might make EmuDeck to get stuck on install. Do you want us to change them for faster ones? 1.1.1.1 (CloudFlare) and 8.8.8.8 (Google)" -OKButtonText "Yes" -CancelButtonText "No"

	if ($result -eq "OKButton") {
	$scriptContent = @"
		Set-DnsClientServerAddress -ServerAddresses "8.8.8.8", "1.1.1.1"  -InterfaceIndex (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).InterfaceIndex
"@
		startScriptWithAdmin -ScriptContent $scriptContent
	}

}



if ( $PSversion -lt 51 ){
	clear
	Write-Host "Updating PowerShell to 5.1" -ForegroundColor white
	Write-Host ""
	Write-Host " Downloading .NET..."
	download "https://go.microsoft.com/fwlink/?linkid=2088631" "dotNet.exe"
	$temp = Join-Path "$env:USERPROFILE" "Downloads"
	&"$temp/dotNet.exe"
	rm -fo -r "$temp/dotNet.exe"

	Write-Host ""
	Write-Host " Downloading WMF 5.1..."
	download "https://go.microsoft.com/fwlink/?linkid=839516" "wmf51.msu"

	$temp = Join-Path "$env:USERPROFILE" "Downloads"
	&"$temp/wmf51.msu"
	rm -fo -r "$temp/wmf51.msu"

	Write-Host ""
	Write-Host " If the WMF installation fails please restart Windows and run the installer again"  -ForegroundColor white
	Read-Host -Prompt "Press ENTER to continue or CTRL+C to quit"
	clear
	Write-Host "PowerShell updated to 5.1" -ForegroundColor white
}

	$FIPSAlgorithmPolicy = Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy
	$EnabledValue = $FIPSAlgorithmPolicy.Enabled

	if($EnabledValue -eq 1){
		Write-Host "Windows FIPS detected, we need to turn it off so cloudSync can be used, after that the computer will restart. Once back in the desktop just run this installer again. You can read about FIPS here and why is better to disable it: https://techcommunity.microsoft.com/t5/microsoft-security-baselines/why-we-re-not-recommending-fips-mode-anymore/ba-p/701037" -ForegroundColor white
		Read-Host -Prompt "Press ENTER to apply the fix and restart"
$scriptContent = @"
Set-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy -name Enabled -value 0; Restart-Computer -Force
"@
			startScriptWithAdmin -ScriptContent $scriptContent
	}
#
##
###
#### Start the party
###
##
#

Write-Host "Installing EmuDeck WE Dependencies" -ForegroundColor white
Write-Host ""
$temp = Join-Path "$env:USERPROFILE" "Downloads"
if (Get-Command git -ErrorAction SilentlyContinue) {
   Write-Output "GIT already installed."
} else {
	$url_emudeck = getLatestReleaseURLGH 'git-for-windows/git' 'exe' '64-bit'
	download $url_emudeck "git_install.exe"

	Write-Host " Installing GIT, please wait..."
	$installDir="$env:ProgramFiles\Git\"
	Start-Process "$temp\git_install.exe" -Wait -Args "/VERYSILENT /INSTALLDIR=\$installDir"
}


if (Get-Command python -ErrorAction SilentlyContinue) {
   Write-Output "Python already installed."
} else {
   Write-Host "Installing Python, please wait..."
   $PYinstaller = "python-3.11.0-amd64.exe"
   $url = "https://www.python.org/ftp/python/3.11.0/$PYinstaller"
   download $url $PYinstaller
   Start-Process "$temp\$PYinstaller" -Wait -Args "/passive InstallAllUsers=1 PrependPath=1 Include_test=0"
}


Write-Host "Downloading EmuDeck..." -ForegroundColor white
Write-Host ""
$url_emudeck = getLatestReleaseURLGH 'EmuDeck/emudeck-electron-beta' 'exe' 'emudeck'
download $url_emudeck "emudeck_install.exe"
Write-Host " Launching EmuDeck Installer, please wait..."
&"$temp/emudeck_install.exe"
