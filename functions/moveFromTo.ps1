function moveFromTo($old, $new){
	robocopy "$old" $new /s /Move /IS /NFL /NDL /NJH /NJS /nc /ns /np
}