fun if_not_null_concat ([],[]) = []|
	if_not_null_concat (l1,l2) = l1@l2

fun f a = 
	if a = 1
		then a
	else if a = 2
		then a + 1
	else a + 2