function moveFromTo($old,$new){
	robocopy "$old" $new /s /Move /NFL /NDL /NJH /NJS /nc /ns /np
}