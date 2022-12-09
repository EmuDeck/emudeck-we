function waitForWinRar(){
	While(1){
		$winrar = [bool](Get-Process Winrar -EA SilentlyContinue)
		if(!$winrar){
			break
		}
	}
}