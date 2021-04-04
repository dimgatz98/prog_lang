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

fun print_list [] = print "\n"|
	print_list (a::xs) = (print (a ^  " "); print_list xs); 

fun split_and_print_list [] = (print "\n"; ())
	|split_and_print_list (a :: xs) =
		((print (a ^ " ") ); split_and_print_list xs);

fun get_first_gap (arr, len, idx) =
        if idx >= len then idx
        else if Array.sub(arr, idx) then get_first_gap (arr, len, (idx + 1) )
        else idx

fun append (acc, []) = ()|
	append (acc, h::xs) = (h :: acc; append (acc, xs) );

fun split_at_space ([], acc) = acc|
	split_at_space (a::xs, acc) = 
	let 
		val temp = (acc @ String.tokens Char.isSpace a)
	in
		split_at_space (xs, temp)
	end

fun calc_input (M::N::xs) = 
	let
		val m = (valOf (Int.fromString M) );
		val n = (valOf (Int.fromString N) );
		val temp = Array.array (m, 0);
		fun calc_prefix ([], counter) = ()
		|	calc_prefix (h::xxs, counter) = 
				if counter = 0
					then (Array.update (temp, counter, (valOf (Int.fromString h)) ); calc_prefix (xxs, counter + 1))
				else	
					(Array.update (temp, counter, Array.sub(temp, counter - 1) + (valOf (Int.fromString h)) ); calc_prefix (xxs, counter + 1))
	in
		calc_prefix (xs, 0);
		temp
	end

fun max_from_beg (arr, acc, count, m) = 
		if count = 0
			then (Array.update (acc, count, Array.sub(arr, count)); max_from_beg (arr, acc, count + 1, m))
		else if count <> m
			then (Array.update (acc, count, Int.max(Array.sub(acc, count-1), Array.sub(arr, count) ) ); max_from_beg (arr, acc, count + 1, m))
		else
			acc
		