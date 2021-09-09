datatype tree = Empty | Node of tree * int * tree

fun trim Node (Empty, val, Empty) = []
| trim (Node (Node (l, val, r), _, Empty ) ) acc = 
		[Node (l, val, r) :: trim (Node (l, val, r)] :: acc
| trim (Node (Empty, _, Node (l, val, r) ) ) acc = 
		[Node (l, val, r)::trim (Node (l, val, r) )] :: acc
| trim (Node (Node (l1, val1, r1), _, Node (l2, val2, r2) ) ) acc = 
		if (val1 mod 2) <> (val2 mod 2) 
		then [Node (l1, val1, r1) :: trim (Node (l1, val1, r1) acc)  ] :: [Node (l2, val1, r2) :: (trim (Node (l2, val2, r2) acc) ) ] :: acc
		else [(trim (Node (l1, val1, r1) acc) ) :: (trim (Node (l2, val2, r2) acc) ) ] :: acc