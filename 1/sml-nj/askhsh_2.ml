#load "bigarray.cma";;
#load "str.cma";;

let split_at_space l = Str.split (Str.regexp "[ \n\r\x0c\t]+") l;;

let rec arr_from_list (arr, l, n, m, count_x) = 
	let rec set_line (arr, h, n, m, count_x, count_y) = 
		match h with
		| x::xs -> if count_y <> m
					then ((arr.{count_x, count_y} <- x); (set_line (arr, xs, n, m, count_x, count_y + 1) ) )
				   else
				   	()
		| [] -> ()
	in
	match l with
		| h::xs -> if count_x <> n
					then (set_line(arr, h, n, m, count_x, 0); (arr_from_list (arr, xs, n, m, count_x + 1) ) )
				  else
				  	arr
		|[] -> arr;;

let calc_n_m ls = match ls with 
	| n::m::xs -> (n, m, xs);;

let list_pop_front l = match l with | [] -> [] | (x::xs) -> xs;;

let get_1_3 (a, _, _) = a;;
let get_2_3 (_, a, _) = a;;
let get_3_3 (_, _, a) = a;;
let get_1_2 (a, _) = a;;
let get_2_2 (_, a) = a;;

let rec calc_input (n, m, ls) =			
	let arr = Bigarray.Array2.create Bigarray.char Bigarray.c_layout n m in
	let rec create_array (xs) =
		let rec split_at_letters (h, acc, count) = 
			let l = acc @ [h.[count] ] in
			if count <> m - 1
				then split_at_letters (h, l, count + 1)
			else
				l
		in

		let rec create_2d_list (lis, acc, count) = match lis with 
			| h::xs -> 
				let l2 = (acc @ [(split_at_letters (h, [], 0))] ) in
				if count <> n - 1
					then create_2d_list (xs, l2, count + 1)
				else
					l2
		in
		arr_from_list (arr, list_pop_front (create_2d_list (xs, [[]], 0) ), n, m, 0)
	in		
	(create_array (ls); arr);;

let string_to_char l = 
	let explode s =
	    let rec exp i l =
	    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
	    exp (String.length s - 1) []
	in
	match (explode l) with 
	| x::xs -> x;;

let parse fileName =
  	let inStream = open_in fileName in
    let size = in_channel_length inStream in
	let buf = String.create size in
	really_input inStream buf 0 size;
    close_in inStream;
	    buf;;

let rec squares_that_have_access (arr, queue, lis, count, square, x, y) = 
	match lis with 
		|[] -> (queue @ square)
		| (h::xs) ->
			let l = (queue @ square) in
				if (count = 0)
					then if (h = 'R') then squares_that_have_access (arr, l, xs, (count + 1), [(x, (y - 1))], x, y)
					else squares_that_have_access (arr, l, xs, count + 1, [], x, y)

				else if (count = 1)
					then if (h = 'D') then squares_that_have_access (arr, l, xs, (count + 1), [((x - 1), y)], x, y)
					else squares_that_have_access (arr, l, xs, count + 1, [], x, y)

				else if (count = 2)
					then if (h = 'L') then squares_that_have_access (arr, l, xs, (count + 1), [(x, (y + 1))], x, y)
					else squares_that_have_access (arr, l, xs, count + 1, [], x, y)

				else if (count = 3)
					then if (h = 'U') then squares_that_have_access (arr, l, xs, (count + 1), [((x + 1), y)], x, y)
					else squares_that_have_access (arr, l, xs, count + 1, [], x, y)
				else
					l;;

let rec calc_winning_row_squares (arr, n, m, row, count, acc, square) =
	let l = acc @ square in
		if count <> m
				then 
					if ((row = 0) && (arr.{row, count} = 'U') ) 
						then calc_winning_row_squares (arr, n, m, row, count + 1, l, [(row, count)])
					
					else if ((row = n - 1) && (arr.{row, count} = 'D') )
						then calc_winning_row_squares (arr, n, m, row, count + 1, l, [(row, count)])

					else
						calc_winning_row_squares (arr, n, m, row, count + 1, l, [])

			else 
				if (row = 0)
					then 
						calc_winning_row_squares (arr, n, m, n - 1, 0, l, [])

			else 
				l;;

let rec calc_winning_col_squares (arr, n, m, col, count, acc, square) = 
	let l = acc @ square in
		if count <> n
			then 
	
				if ((col = 0) && (arr.{count, col} = 'L'))
					then calc_winning_col_squares (arr, n, m, col, count + 1, l, [(count, col)] )
				
				else if ((col = m - 1) && (arr.{count, col} = 'R') )
					then calc_winning_col_squares (arr, n, m, col, count + 1, l, [(count, col)] )

				else
					calc_winning_col_squares (arr, n, m, col, count + 1, l, [] )

		else if (col = 0)
			then calc_winning_col_squares (arr, n, m, m - 1, 0, l, [])

		else
			l;;

let rec calc_winning_squares (arr, n, m, acc, square_list, count) = 
	let l = acc @ square_list in
		if count = 0
			then calc_winning_squares (arr, n, m, l, (calc_winning_col_squares (arr, n, m, 0, 0, [], [])), count + 1)
		else if count = 1
			then calc_winning_squares (arr, n, m, l, (calc_winning_row_squares (arr, n, m, 0, 0, [], [])), count + 1)
		
		else 
			l;;

let rec count_winning_squares (arr, n, m, l, count) = 
	match l with 
		|[] -> count
		| (a, b)::xs -> 
			let rec winning_tree_nodes (lid, count) = match lid with 
				|[] -> count
				| (a, b)::queue  ->
					if (a = 0 && b = 0)
						then winning_tree_nodes (squares_that_have_access (arr, queue, ['N'; 'N'; arr.{a, b + 1}; arr.{a + 1, b}], 0, [], a, b), count + 1)

					else if (a = n - 1 && b = m - 1)
						then winning_tree_nodes (squares_that_have_access (arr, queue, [arr.{a, b - 1}; arr.{a - 1, b}; 'N'; 'N'], 0, [], a, b), count + 1)

					else if (a = 0 && b = m - 1)
						then winning_tree_nodes (squares_that_have_access (arr, queue, [arr.{a, b - 1}; 'N'; 'N'; arr.{a + 1, b}], 0, [], a, b), count + 1)

					else if (a = n - 1 && b = 0)
						then winning_tree_nodes (squares_that_have_access (arr, queue, ['N'; arr.{a - 1, b}; arr.{a, b + 1}; 'N'], 0, [], a, b), count + 1)

					else if a = 0
						then winning_tree_nodes (squares_that_have_access (arr, queue, [arr.{a, b - 1}; 'N'; arr.{a, b + 1}; arr.{a + 1, b}], 0, [], a, b), count + 1)

					else if a = n - 1
						then winning_tree_nodes (squares_that_have_access (arr, queue, [arr.{a, b - 1}; arr.{a - 1, b}; arr.{a, b + 1}; 'N'], 0, [], a, b), count + 1)

					else if b = 0
						then winning_tree_nodes (squares_that_have_access (arr, queue, ['N'; arr.{a - 1, b}; arr.{a, b + 1}; arr.{a + 1, b}], 0, [], a, b), count + 1)

					else if b = m - 1
						then winning_tree_nodes (squares_that_have_access (arr, queue, [arr.{a, b - 1}; arr.{a - 1, b}; 'N'; arr.{a + 1, b}], 0, [], a, b), count + 1)

					else
						winning_tree_nodes (squares_that_have_access (arr, queue, [arr.{a, b - 1}; arr.{a - 1, b}; arr.{a, b + 1}; arr.{a + 1, b}], 0, [], a, b), count + 1)
		in	
			let counter = count + winning_tree_nodes([(a, b)], 0) in
			count_winning_squares (arr, n, m, xs, counter);;



let loop_rooms filename =
	let temp = calc_n_m (split_at_space (parse filename) )  in 
	let n = (int_of_string (get_1_3 temp) ) in 
	let m = (int_of_string (get_2_3 temp) ) in 
	let arr = calc_input (n, m, (get_3_3 temp) ) in
	let winning_list =  calc_winning_squares (arr, n, m, [], [], 0) in 
	Printf.printf "%d%s" (n*m - count_winning_squares (arr, n, m, winning_list, 0) ) "\n"
;;