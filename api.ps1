function API_pull($branchGIT){
	Start-Transcript "$env:USERPROFILE/EmuDeck/logs/git.log";
		cd "$env:APPDATA\EmuDeck\backend\";
		git reset --hard;
		git clean -fd;
		git checkout $branchGIT;
		git pull --allow-unrelated-histories -X theirs;
		appImageInit;
	Stop-Transcript;
}