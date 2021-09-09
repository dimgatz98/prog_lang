fun longest filename = 
	let
		fun parse fileName =
		    let
		  	    (* Open input fileName. *)
		      	val inStream = TextIO.openIn fileName

		        (* Reads lines until EOF and puts them in a list as char lists *)
		        fun readLines acc =
		          let
		            val newLineOption = TextIO.inputLine inStream
		          in
		            if newLineOption = NONE
		            then (rev acc)
		            else ( readLines ( valOf newLineOption :: acc ))
		        end;

		        val grid = readLines []
		    in
		   	    grid
		    end

		fun split_at_space ([], acc) = acc|
			split_at_space (a::xs, acc) = 
			let 
				val temp = (acc @ String.tokens Char.isSpace a)
			in
				split_at_space (xs, temp)
			end

		fun calc_input (M::N::xs, res) = 
			let
				val m = (valOf (Int.fromString M) );
				val n = (valOf (Int.fromString N) );
				val temp = Array.array (m, 0);
				fun calc_prefix ([], counter, res) = (n, m, temp, res)
				|	calc_prefix (h::xxs, counter, res) = 
						if counter = 0
							then if (valOf (Int.fromString h)) + n < 0
								then 
									(Array.update (temp, counter, (valOf (Int.fromString h)) + n ); calc_prefix (xxs, counter + 1, counter + 1 ) )
								else
									(Array.update (temp, counter, (valOf (Int.fromString h)) + n ); calc_prefix (xxs, counter + 1, res) )
						else	
							if Array.sub (temp, counter - 1) + (valOf (Int.fromString h) ) + n < 0
								then
									(Array.update (temp, counter, Array.sub(temp, counter - 1) + (valOf (Int.fromString h)) + n ); calc_prefix (xxs, counter + 1, counter + 1 ) )
								else
									(Array.update (temp, counter, Array.sub(temp, counter - 1) + (valOf (Int.fromString h)) + n ); calc_prefix (xxs, counter + 1, res) )
			in
				calc_prefix (xs, 0, 0)
			end

		fun max_from_beg (arr, acc, count, m) = 
			if count = 0
				then (Array.update (acc, count, Array.sub(arr, count)); max_from_beg (arr, acc, count + 1, m))
			else if count <> m
				then (Array.update (acc, count, Int.max(Array.sub(acc, count-1), Array.sub(arr, count) ) ); max_from_beg (arr, acc, count + 1, m))
			else
				acc	

		fun min_from_end (arr, acc, count, m) = 
			if count = m - 1
					then (Array.update (acc, count, Array.sub(arr, count)); min_from_end (arr, acc, count - 1, m))
			else if count <> 0
				then (Array.update (acc, count, Int.min(Array.sub(acc, count + 1), Array.sub(arr, count) ) ); min_from_end (arr, acc, count - 1, m))
			else
				(Array.update (acc, count, Int.min(Array.sub(acc, count + 1), Array.sub(arr, count) ) ); acc)

		val data = parse filename
		val arr = split_at_space (data, [])
		val temp = calc_input(arr, 0)
		val n = (#1 temp)
		val m = (#2 temp)
		val prefix_arr = (#3 temp)
		val res = (#4 temp);
		val min_arr = min_from_end (prefix_arr, Array.array(m, 0), m - 1, m)
		val max_arr = max_from_beg (prefix_arr, Array.array(m, 0), 0, m)
		fun find_max_subseq (min_arr, max_arr, m, i, j, res) =
			if (i = m orelse j = m)
				then res
			else
				if Array.sub(min_arr, j) - Array.sub(max_arr, i) <= 0
					then if res < j - i then (find_max_subseq (min_arr, max_arr, m, i, j + 1, j - i))
					else (find_max_subseq (min_arr, max_arr, m, i, j + 1, res))
				else (find_max_subseq (min_arr, max_arr, m, i + 1, j, res))
	in
		(print(((Int.toString (find_max_subseq (min_arr, max_arr, m, 0, 0, res) ) ) ^ "\n") ); () )
	end