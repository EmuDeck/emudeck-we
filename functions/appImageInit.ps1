function appImageInit(){
	if ($cloud_sync_status -eq $null) {
		setSetting "cloud_sync_status" "true"
	}
}