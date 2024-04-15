function netplaySetIP(){

	$activeInterfaceIndex = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object -Property Metric | Select-Object -First 1 -ExpandProperty InterfaceIndex

	$ipv4Address = Get-NetIPConfiguration | Where-Object {$_.InterfaceIndex -eq $activeInterfaceIndex} | Select-Object -ExpandProperty IPv4Address
	$localIP = $ipv4Address.IPAddress
	$IPParts = $localIP.Split(".")
	$segment = $IPParts[0] + "." + $IPParts[1] + "." + $IPParts[2]
	$subnet = "$segment."
	$port = 55435
	2..255 | ForEach-Object {
		$ip = "$segment.$_"
		Write-Host $ip  # Imprimir la IP que se está probando

		$ping = New-Object System.Net.NetworkInformation.Ping
		try {
			$result = $ping.Send($ip, 1)  # 5 ms de tiempo de espera
			if ($result.Status -eq 'Success') {
				"Host is reachable."
				try {
					$tcpclient = New-Object System.Net.Sockets.TcpClient
					$tcpclient.Connect("$ip", $port)
					if ($tcpclient.Connected) {
						"Port $port is open."
						setSetting "netplayCMD" "-C $ip"
						break
					}
					$tcpclient.Close()
				} catch {
					"Port $port is closed or unreachable."
				}
			} else {
				"Host is unreachable."
			}
		} catch {
			"Failed to ping due to an error."
		}

	}

}