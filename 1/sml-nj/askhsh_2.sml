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

fun print_list_of_lists [[]] = ()|
	print_list_of_lists (h::xs) = 
		(print_list h; print_list_of_lists xs)

fun split_and_print_list [] = (print "\n"; ())
	|split_and_print_list (a :: xs) =
		((print (a ^ " ") ); split_and_print_list xs);

fun split_at_space ([], acc) = acc|
	split_at_space (a::xs, acc) = 
	let 
		val temp = (acc @ String.tokens Char.isSpace a)
	in
		split_at_space (xs, temp)
	end

fun calc_input (N::M::xs) = 
	let 
		val n = (valOf (Int.fromString N) );
		val m = (valOf (Int.fromString M) );
		
		fun create_array (xs) =
			let
				fun split_at_letters (h, acc, count) = 
					let
						val l = (acc @ (String.tokens Char.isSpace (substring (h, count, 1) ) ) ) 
					in
						if count <> m - 1
							then split_at_letters (h, l, count + 1)
						else
							l
					end

				fun create_2d_list (h::xs, h2::acc, count) = 
					let
						val l2 = (acc @ [(split_at_letters (h, [], 0))] )
					in
						if count <> n - 1
							then create_2d_list (xs, l2, count + 1)
						else
							l2
					end
			in
				(*print_list_of_lists (create_2d_list (xs, [[]], 0))*)
				Array2.fromList (create_2d_list (xs, [[]], 0))
				(* create_2d_list (xs, 0) *)
			end
	in
		(n, m, create_array (xs))
	end