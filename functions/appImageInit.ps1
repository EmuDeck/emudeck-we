function appImageInit(){

	$PFPath="$env:ProgramFiles (x86)\Steam\controller_base\templates\"
	Copy-Item -Path "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\steam-input\*" -Destination $PFPath -Recurse

}