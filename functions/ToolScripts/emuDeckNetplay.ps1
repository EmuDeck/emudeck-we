function netplaySetIP(){
	$localIP = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4" -and $_.InterfaceAlias -ne "Loopback"}).IPAddress[0]
	$IPParts = $localIP.Split(".")
	$segment = $IPParts[0] + "." + $IPParts[1] + "." + $IPParts[2]
	$subnet = "$segment."
	$port = 55435
	$nethost = "none"
	netplaySetHost
	1..254 | ForEach-Object {
		$ip = $subnet + $_
		$tcpClient = New-Object System.Net.Sockets.TcpClient
		$tcpClient.SendTimeout = 2
		$tcpClient.ReceiveTimeout = 2
		$result = $tcpClient.BeginConnect($ip, $port, $null, $null)
		$wait = $result.AsyncWaitHandle.WaitOne(1, $false)
		if ($wait -eq $true -and $tcpClient.Connected) {
			netplaySetClient
			setSetting netplayIP "$ip"
		}
		$tcpClient.Close()
	}
}

function netplaySetHost(){
	setSetting netplayHost "true"
}

function netplaySetClient(){
	setSetting netplayHost "false"
}