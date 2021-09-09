fun find_max ([], max) = max
| find_max ((key, value)::t, max) = 
		if (max > key) then find_max (t, max) else find_max (t, key)
	
fun count_values ([], count, res) = res
| count_values ( (key,value)::t, count, res) = 
		if key = count then (count_values (t, count, res + value) ) else (count_values (t, count, res) )
	
fun solve (l, acc, count) = 
	let 
		val temp = (count_values (l, count, 0) ) :: acc 
	in
		if count >= 0 then solve (l, temp, count - 1) else acc
	end

fun bidlist l = (solve (l, [], find_max (l, 0)) )