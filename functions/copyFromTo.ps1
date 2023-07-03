function copyFromTo($old,$new){
	robocopy "$old" "$new" /s /NFL /NDL /NJH /NJS /nc /ns /np 
}
