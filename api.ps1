function API_pull($branchGIT){
	cd "$env:APPDATA\EmuDeck\backend\";
	Start-Transcript "$env:USERPROFILE/EmuDeck/logs/git.log";
		git reset --hard;
		git clean -fd;
		git checkout $branchGIT;
		git pull --allow-unrelated-histories -X theirs;
		appImageInit;
	Stop-Transcript;
}