function appImageInit(){
	if ($cloud_sync_status -ne $null) {
		setSetting "cloud_sync_status" "true"
	}
}