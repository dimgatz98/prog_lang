fun bidlist [] = []
	| bidlist ((k,v)::rest) = 
		let fun insert 0 v [] = [v]
		| insert k v [] = 0 :: insert (k-1) v []
		| insert 0 v (x::r) = (x+v) :: r
		| insert k v (x::r) = x :: insert (k-1) v r
		in insert k v (bidlist rest) 
		end

fun add_elems 0 L = []
	|add_elems n (first::L) = first::add_elems (n-1) L

fun get_rest 0 L = L
	|get_rest n (first::L) = get_rest (n-1) L

fun reconstruct [] = []
	|reconstruct (n::rest) =  (add_elems (n+1) (n::rest) ) :: reconstruct (get_rest n rest) 
