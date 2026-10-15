$splashXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        WindowStyle="None" ResizeMode="NoResize" WindowState="Maximized"
        Background="Black" ShowInTaskbar="False" Cursor="None">
	<StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
		<Grid Width="64" Height="64" RenderTransformOrigin="0.5,0.5">
			<Grid.RenderTransform>
				<RotateTransform x:Name="Spin" Angle="0"/>
			</Grid.RenderTransform>
			<Ellipse Stroke="#33FFFFFF" StrokeThickness="6"/>
			<Ellipse Stroke="White" StrokeThickness="6" StrokeDashArray="8 100" StrokeDashCap="Round"/>
		</Grid>
		<TextBlock x:Name="Label" Foreground="#CCFFFFFF" FontSize="20" Margin="0,24,0,0" HorizontalAlignment="Center"/>
	</StackPanel>
</Window>
'@

function showSplash($text){
	try {
		$sync = [hashtable]::Synchronized(@{ Close = $false; Text = $text; Xaml = $splashXaml })
		$runspace = [runspacefactory]::CreateRunspace()
		$runspace.ApartmentState = "STA"
		$runspace.Open()
		$runspace.SessionStateProxy.SetVariable("sync", $sync)
		$ps = [powershell]::Create()
		$ps.Runspace = $runspace
		$ps.AddScript({
			Add-Type -AssemblyName PresentationFramework
			$window = [Windows.Markup.XamlReader]::Parse($sync.Xaml)
			$window.FindName("Label").Text = $sync.Text
			$animation = New-Object System.Windows.Media.Animation.DoubleAnimation(0, 360, [TimeSpan]::FromSeconds(1))
			$animation.RepeatBehavior = [System.Windows.Media.Animation.RepeatBehavior]::Forever
			$window.FindName("Spin").BeginAnimation([System.Windows.Media.RotateTransform]::AngleProperty, $animation)
			$started = Get-Date
			$timer = New-Object System.Windows.Threading.DispatcherTimer
			$timer.Interval = [TimeSpan]::FromMilliseconds(200)
			$timer.Add_Tick({
				if ($sync.Close -or ((Get-Date) - $started).TotalSeconds -gt 60) {
					$timer.Stop()
					$window.Close()
				}
			})
			$timer.Start()
			$window.ShowDialog() | Out-Null
		}) | Out-Null
		return @{ Sync = $sync; PS = $ps; Handle = $ps.BeginInvoke(); Runspace = $runspace }
	} catch {
		return $null
	}
}

function closeSplash($splash){
	if (-not $splash) {
		return
	}
	try {
		$splash.Sync.Close = $true
		$splash.PS.EndInvoke($splash.Handle) | Out-Null
		$splash.PS.Dispose()
		$splash.Runspace.Dispose()
	} catch {
	}
}

function openDesktop(){
	if (Get-Process -Name "explorer" -ErrorAction SilentlyContinue) {
		return
	}
	$splash = showSplash "Loading Desktop..."
	Start-Process explorer.exe
	try {
		Add-Type -Namespace EmuDeck -Name Win32 -MemberDefinition '[DllImport("user32.dll")] public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);'
		$timeout = (Get-Date).AddSeconds(30)
		while ([EmuDeck.Win32]::FindWindow("Shell_TrayWnd", $null) -eq [IntPtr]::Zero -and (Get-Date) -lt $timeout) {
			Start-Sleep -Milliseconds 500
		}
	} catch {
	}
	closeSplash $splash
}

function bigPictureIsOpen(){
	return [bool](Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like "*Big Picture*" })
}

function steamIsRunning(){
	return [bool](Get-Process -Name "steam" -ErrorAction SilentlyContinue)
}

$splash = $null
try {
	$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue).SteamPath
	if (-not $steamPath) {
		$steamPath = "${env:ProgramFiles(x86)}\Steam"
	}
	$steamExe = Join-Path $steamPath.Replace("/", "\") "Steam.exe"

	if (Test-Path $steamExe) {
		$splash = showSplash "Starting Steam..."
		Start-Process -FilePath $steamExe -ArgumentList "-bigpicture" -WindowStyle Hidden

		$timeout = (Get-Date).AddMinutes(2)
		while (-not (bigPictureIsOpen) -and (steamIsRunning) -and (Get-Date) -lt $timeout) {
			Start-Sleep -Seconds 2
		}
		closeSplash $splash
		$splash = $null

		while ((bigPictureIsOpen) -and (steamIsRunning)) {
			Start-Sleep -Seconds 2
		}
	}
} catch {
}

closeSplash $splash
openDesktop
