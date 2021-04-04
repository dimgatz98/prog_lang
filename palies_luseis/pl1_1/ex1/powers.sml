fun binary_list(0)   = []
  | binary_list(num) = num mod 2 :: binary_list(num div 2)

fun print_list x =
  let	fun pri nil = print "]\n"
   	    | pri (h::[]) = (print (Int.toString (h));  pri [])
        |pri (h::t) = (print (Int.toString (h)); print ","; pri t)
  in
  		  print "[";
  	    pri x
  end

fun search_first (x::xs) count =
  if x <> 0 then count
  else search_first (xs) count+1

fun fix_list [] = []
  | fix_list [a] = [a]
  | fix_list (x::xs) =
    let
      val (y::ys) = rev(x::xs)
      val taker = List.length(x::xs) - search_first (y::ys) 0
    in
      List.take((x::xs), taker)
    end



fun split [] = ([], [])
  | split [x] = ([x], [])
  | split (x1::x2::xs) =
      let
            val (ys, zs) = split xs
      in
            ((x1::ys), (x2::zs))
      end;

fun break_list((x::y::ys)) =
  if y = 0 then x::break_list(y::ys)
  else (x+2::y-1::ys)

fun sum [] = 0
  | sum (x::xs) = x+sum xs

fun solve(n,0) = binary_list(n)
  | solve(n,1) = break_list(binary_list(n))
  | solve(n,k) = if k > 1  then break_list(solve(n,k-1)) else []



fun parse file =
    let
	(* A function to read an integer from specified input. *)
        fun readInt input =
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

	(* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
	val t = readInt inStream
  val number = 2*t
	val _ = TextIO.inputLine inStream


	fun readInts 0 list1 = rev(list1)
	  | readInts i list1 = readInts (i - 1) (readInt inStream::list1)
    in
   	(t, split(readInts number []))
  end

fun answer(1, (n::[], k::[])) =
  if n >= k then
    let
     val  w = k-sum(binary_list(n))
    in
      print_list(fix_list(solve(n,w)))
    end
  else print_list([])
  | answer(t, (n::ns, k::ks)) =
  if n >= k then
    let
      val w = k-sum(binary_list(n))
    in
      (print_list(fix_list(solve(n,w))); answer(t-1,(ns,ks)))
    end
    else (print_list([]); answer(t-1, (ns,ks)))

fun powers2 fileName = answer(parse fileName)
