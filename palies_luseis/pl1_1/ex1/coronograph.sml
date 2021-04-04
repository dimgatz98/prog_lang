structure seen = BinaryMapFn(struct
    type ord_key = int
    val compare = Int.compare
  end);


fun print_list [] = print("\n")
  |  print_list (x::[]) = (print(Int.toString(x)); print_list([]))
  |  print_list (x::xs) = (print(Int.toString(x)); print(" "); print_list(xs))

  fun halve nil = (nil, nil)
  |   halve [a] = ([a], nil)
  |   halve (a :: b :: cs) =
        let
          val (x, y) = halve cs
        in
          (a :: x, b :: y)
        end;

  fun merge (nil, ys) = ys
  |   merge (xs, nil) = xs
  |   merge (x :: xs, y :: ys) =
        if (x < y) then x :: merge(xs, y :: ys)
        else y :: merge(x :: xs, ys);

  fun mergeSort nil = nil
  |   mergeSort [a] = [a]
  |   mergeSort theList =
        let
          val (x, y) = halve theList
        in
          merge(mergeSort x, mergeSort y)
        end;



fun X (x, _, _) = x
fun Y (_, x, _) = x
fun Z (_, _, x) = x

structure adjacency_list = BinaryMapFn(struct
    type ord_key = int
    val compare = Int.compare
  end);


fun init_adj N =
    let
      fun adj_aux (1, list) = adjacency_list.insert(list, 1, [])
        | adj_aux (M, list) = adj_aux ((M-1), adjacency_list.insert(list, M, []))
    in
        adj_aux (N, adjacency_list.empty)
    end

fun insert_adj (a, b, adj_list) =
  let
    val helplist = adjacency_list.insert(adj_list, a, (b :: Option.valOf(adjacency_list.find(adj_list, a))))
  in
    adjacency_list.insert(helplist, b, (a :: Option.valOf(adjacency_list.find(helplist,b))))
  end


fun get_list (x, list) = valOf(adjacency_list.find(list, x))

fun found (n, visited) = (seen.find(visited, n) <> NONE)



fun dfs (node, map, parent, visited, cycle, first) =
    let
      val (n::ns) = get_list(node, map)
      fun dfs_help([], _, _, _, v, [], f) = (v,[], f)
        | dfs_help([], _, _, _, v, c, f) = (v,c,f)
        | dfs_help((y::ys), m, curr, p, v, c, f) =
          let
            val foundd = found(y,v)
          in
            if(foundd andalso y = p) then dfs_help(ys, m, curr, p, v, c, f)
            else if (foundd andalso y <> p) then
              if(curr <> f) then dfs_help(ys, m, curr, p, v, curr::c, y)
              else dfs_help(ys, m, curr, p, v, c ,f)
            else
              let
                val (vis,cyc, first) = dfs(y, m, curr, v, c, f)
              in
                  dfs_help(ys, m, curr, p, vis, cyc, first)
              end
          end
    in
      let
        val (arr, rou, fi) =  dfs_help((n::ns), map, node, parent, seen.insert(visited, node, 0), cycle, first)
      in
        if(not(List.null(rou)) andalso rou <> cycle andalso node <> fi andalso List.hd(rou) = node) then (arr,parent::rou, fi)
        else (arr,rou,fi)
      end
    end


fun  ctree([], _, _) = 0
   | ctree(x::[], map, parent) =
    let
      val (n::ns) = get_list(x, map)
      fun counter([], _, _, _) = 1
        | counter([y], mp, cur, par) =
          if(y <> par) then (1+ctree(y::[], mp, cur))
          else 1
        | counter((y::ys), mp, cur, par) =
            if(y <> par) then (ctree(y::[], mp, cur) + counter(ys, mp, cur, par))
            else counter(ys, mp, cur, par)
    in
      counter((n::ns), map, x, parent)
    end



fun count_aux(x, map, avoid1, avoid2) =
    let
      val (n::ns) = get_list(x, map)
      fun checker([], _, _, _, _, sum) = sum
        | checker(y::ys, parent, m, a1, a2, sum) =
      if(y <> a1 andalso y <> a2) then
        let
          val newsum = (sum+ctree(y::[], m , parent))
        in
          checker(ys, x, m, a1, a2, newsum)
        end
      else checker(ys, x, m, a1, a2, sum)
    in
        checker(n::ns, x, map, avoid1, avoid2, 1)
    end

fun count([], map, avoid1, avoid2, original_head) = []
  | count([x], map, avoid1, avoid2, original_head) = count_aux(x, map, avoid1, avoid2) :: count([], map, x, x, original_head)
  | count((x::y::[]), map, avoid1, avoid2, original_head) = count_aux(x, map, avoid1, avoid2) :: count([y], map, x, original_head, original_head)
  | count((x::xs), map, avoid1, avoid2, original_head) = count_aux(x, map, avoid1, avoid2) :: count(xs, map, x, List.nth(xs, 1), original_head)



fun parse file =
    let
  	(* A function to read an integer from specified input. *)
        fun readInt input =
  	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

  	(* Open input file. *)
      	val inStream = TextIO.openIn file

          (* Read an integer (number of countries) and consume newline. *)
  	    val t = readInt inStream
  	    val _ = TextIO.inputLine inStream

      fun make_list (0, list) = list
        | make_list (M, list) =
          let
            val a = readInt inStream
            val b = readInt inStream
            val adj = insert_adj(a,b,list)
          in
            make_list(M-1, adj)
          end

      fun readUseless(0) = adjacency_list.insert(adjacency_list.empty, 1, [0])
        | readUseless(M) =
          let
            val a = readInt inStream
            val b = readInt inStream
          in
            readUseless(M-1)
          end

      fun readtotal (0, list) = rev list
        | readtotal(t, list) =
        let
          val N = readInt inStream
          val M = readInt inStream
          val (a,b,c) = if(N = M) then (N, M, make_list(M, init_adj(N)))
                        else (N, M, readUseless(M))
          val newlist = ((a,b,c) :: list)
        in
          readtotal(t-1, newlist)
        end
    in
     	readtotal(t, [])
    end

fun solve [x] =
  if(X(x) <> Y(x)) then (print("NO CORONA\n"))
  else
    let
      val resulting = dfs(1, Z(x), 0, seen.empty, [], ~1)
    in
      if(X(x) <> seen.numItems(X(resulting))) then (print("NO CORONA\n"))
      else (print("CORONA "); print(Int.toString(List.length(Y(resulting)))); print("\n");  print_list(mergeSort(count(Y(resulting), Z(x), List.last(Y(resulting)), List.nth(Y(resulting), 1), List.hd(Y(resulting))))))
    end
  | solve (x::xs) =
    if(X(x) <> Y(x)) then (print("NO CORONA\n"); solve(xs))
    else
      let
        val resulting = dfs(1, Z(x), 0, seen.empty, [], ~1)
      in
        if(X(x) <> seen.numItems(X(resulting))) then (print("NO CORONA\n"); solve(xs))
        else (print("CORONA "); print(Int.toString(List.length(Y(resulting)))); print("\n"); print_list(mergeSort(count(Y(resulting), Z(x), List.last(Y(resulting)), List.nth(Y(resulting), 1), List.hd(Y(resulting))))); solve(xs))
      end
fun coronograph fileName = solve(parse fileName)
