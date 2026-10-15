function API_pull($branchGIT){
	Start-Transcript "$env:APPDATA/emudeck/logs/git.log";
		cd "$env:APPDATA\EmuDeck\backend\";
		git fetch --depth=1 origin $branchGIT;
		if ($?) {
			git checkout -f -B $branchGIT FETCH_HEAD;
			git reset --hard FETCH_HEAD;
		} else {
			git reset --hard;
		}
		git clean -fd;
		appImageInit;
	Stop-Transcript;
}

function API_optional_parsers(){
	echo "true"
}