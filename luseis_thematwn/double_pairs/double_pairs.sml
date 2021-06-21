fun exists (temp, []) = []
	| exists (temp, h::t) = if (h = (2 * temp) ) then [(temp, h)] 
							else 
							if (h > (2 * temp) ) then [] else (exists (temp, t) )

fun solve ([], res) = res
	| solve (h::t, res) = 
		let 
			val temp = res @ (exists (h, t) )
		in
			solve (t, temp)
		end

fun double_pairs l = solve (l, [])