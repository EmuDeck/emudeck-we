function netplaySetIP(){

	$activeInterfaceIndex = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object -Property Metric | Select-Object -First 1 -ExpandProperty InterfaceIndex

	$ipv4Address = Get-NetIPConfiguration | Where-Object {$_.InterfaceIndex -eq $activeInterfaceIndex} | Select-Object -ExpandProperty IPv4Address
	$localIP = $ipv4Address.IPAddress
	$IPParts = $localIP.Split(".")
	$segment = $IPParts[0] + "." + $IPParts[1] + "." + $IPParts[2]
	$subnet = "$segment."


	for ($i = 2; $i -lt 255; $i++) {
		$ip = "$subnet$i"
		$isConnected = [System.Net.Sockets.TcpClient]::new().ConnectAsync($ip, 55435).Wait(50)

 	   if ($isConnected) {
			setSetting "netplayCMD" "-C $ip"
			return $ip
		}
	}
}