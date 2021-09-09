fun loop_rooms filename = 
	let
		fun list_pop_front (h::xs) = 
			xs

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
		    
		fun squares_that_have_access (queue, [], count, square, x, y) = queue @ square|
			squares_that_have_access (queue, h::xs, count, square, x, y) =
				let 
					val l = queue @ square
				in
					if (count = 0)
						then if (h = "R") then squares_that_have_access (l, xs, (count + 1), [(x, (y - 1))], x, y)
						else squares_that_have_access (l, xs, count + 1, [], x, y)

					else if (count = 1)
						then if (h = "D") then squares_that_have_access (l, xs, (count + 1), [((x - 1), y)], x, y)
						else squares_that_have_access (l, xs, count + 1, [], x, y)

					else if (count = 2)
						then if (h = "L") then squares_that_have_access (l, xs, (count + 1), [(x, (y + 1))], x, y)
						else squares_that_have_access (l, xs, count + 1, [], x, y)

					else if (count = 3)
						then if (h = "U") then squares_that_have_access (l, xs, (count + 1), [((x + 1), y)], x, y)
						else squares_that_have_access (l, xs, count + 1, [], x, y)
					else
						l
				end

		fun split_at_space ([], acc) = acc|
			split_at_space (a::xs, acc) = 
			let 
				val temp = (acc @ String.tokens Char.isSpace a)
			in
				split_at_space (xs, temp)
			end

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

						fun create_2d_list (h::xs, acc, count) = 
							let
								val l2 = (acc @ [(split_at_letters (h, [], 0))] )
							in
								if count <> n - 1
									then create_2d_list (xs, l2, count + 1)
								else
									l2
							end
					in
						Array2.fromList (list_pop_front (create_2d_list (xs, [[]], 0) ) )
						(* create_2d_list (xs, 0) *)
					end
			in
				(n, m, create_array (xs) )
			end

		val temp = calc_input (split_at_space ((parse filename, []) ) );
		val n = #1 temp;
		val m = #2 temp;
		val arr = #3 temp;

		fun calc_winning_row_squares (n, m, row, count, acc, square) =
			let 

				val l = acc @ square

			in

				if count <> m
					then 
						
						if ((row = 0) andalso (Array2.sub(arr, row, count) = "U") ) 
							then calc_winning_row_squares (n, m, row, count + 1, l, [(row, count)])
						
						else if ((row = n - 1) andalso (Array2.sub(arr, row, count) = "D") )
							then calc_winning_row_squares (n, m, row, count + 1, l, [(row, count)])

						else
							calc_winning_row_squares (n, m, row, count + 1, l, [])

				else 
					if (row = 0)
						then 
							calc_winning_row_squares (n, m, n - 1, 0, l, [])

				else 
					l

			end

		fun calc_winning_col_squares (n, m, col, count, acc, square) = 
			let 

				val l = acc @ square

			in

				if count <> n
					then 
			
						if ((col = 0) andalso (Array2.sub(arr, count, col) = "L"))
							then calc_winning_col_squares (n, m, col, count + 1, l, [(count, col)] )
						
						else if ((col = m - 1) andalso (Array2.sub(arr, count, col) = "R") )
							then calc_winning_col_squares (n, m, col, count + 1, l, [(count, col)] )

						else
							calc_winning_col_squares (n, m, col, count + 1, l, [] )

				else if (col = 0)
					then calc_winning_col_squares (n, m, m - 1, 0, l, [])

				else
					l

			end

		fun calc_winning_squares (n, m, acc, square_list, count) = 
			let 
				val l = acc @ square_list
			in
				if count = 0
					then calc_winning_squares (n, m, l, (calc_winning_col_squares (n, m, 0, 0, [], [])), count + 1)
				else if count = 1
					then calc_winning_squares (n, m, l, (calc_winning_row_squares (n, m, 0, 0, [], [])), count + 1)
				
				else 
					l
			end

		val winning_list =  calc_winning_squares (n, m, [], [], 0);

		fun count_winning_squares ([], count) = count|
			count_winning_squares ((a, b)::xs, count) = 
				let
					fun winning_tree_nodes ([], count) = count|
						winning_tree_nodes ((a, b)::queue, count) =
							if (a = 0 andalso b = 0)
								then winning_tree_nodes (squares_that_have_access (queue, ["N", "N", Array2.sub(arr, a, b + 1), Array2.sub(arr, a + 1, b)], 0, [], a, b), count + 1)

							else if (a = n - 1 andalso b = m - 1)
								then winning_tree_nodes (squares_that_have_access (queue, [Array2.sub(arr, a, b - 1), Array2.sub(arr, a - 1, b), "N", "N"], 0, [], a, b), count + 1)

							else if (a = 0 andalso b = m - 1)
								then winning_tree_nodes (squares_that_have_access (queue, [Array2.sub(arr, a, b - 1), "N", "N", Array2.sub(arr, a + 1, b)], 0, [], a, b), count + 1)

							else if (a = n - 1 andalso b = 0)
								then winning_tree_nodes (squares_that_have_access (queue, ["N", Array2.sub(arr, a - 1, b), Array2.sub(arr, a, b + 1), "N"], 0, [], a, b), count + 1)

							else if a = 0
								then winning_tree_nodes (squares_that_have_access (queue, [Array2.sub(arr, a, b - 1), "N", Array2.sub(arr, a, b + 1), Array2.sub(arr, a + 1, b)], 0, [], a, b), count + 1)

							else if a = n - 1
								then winning_tree_nodes (squares_that_have_access (queue, [Array2.sub(arr, a, b - 1), Array2.sub(arr, a - 1, b), Array2.sub(arr, a, b + 1), "N"], 0, [], a, b), count + 1)

							else if b = 0
								then winning_tree_nodes (squares_that_have_access (queue, ["N", Array2.sub(arr, a - 1, b), Array2.sub(arr, a, b + 1), Array2.sub(arr, a + 1, b)], 0, [], a, b), count + 1)

							else if b = m - 1
								then winning_tree_nodes (squares_that_have_access (queue, [Array2.sub(arr, a, b - 1), Array2.sub(arr, a - 1, b), "N", Array2.sub(arr, a + 1, b)], 0, [], a, b), count + 1)

							else
								winning_tree_nodes (squares_that_have_access (queue, [Array2.sub(arr, a, b - 1), Array2.sub(arr, a - 1, b), Array2.sub(arr, a, b + 1), Array2.sub(arr, a + 1, b)], 0, [], a, b), count + 1)
					
					val counter = count + winning_tree_nodes([(a, b)], 0);
				in
					count_winning_squares (xs, counter)
				end
	in 
		print ((Int.toString (n*m - count_winning_squares (winning_list, 0) ) ) ^ "\n"); ()
	end