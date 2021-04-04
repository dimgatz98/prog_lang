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
        val M = length (hd grid) - 1
        val N = length grid
    in
   	    (N,M,grid)
    end

fun X  (a, _) = a
fun Y  (_, a) = a

fun A (a, _, _) = a
fun B (_, a, _) = a
fun C (_, _, a) = a

fun FIRST (a, _, _, _) = a
fun SECOND (_, a, _, _) = a
fun THIRD (_, _, a, _) = a
fun FOURTH (_, _, _, a) = a


fun make_array (arr, list, row) =
  let
    fun array_aux (arr, [], _) = arr
      | array_aux (arr, [_], _) = arr
      | array_aux (arr, (x::xs), i) = (Array2.update(arr, row, i, x); array_aux(arr, xs, i+1))
  in
    array_aux (arr, list, 0)
  end

fun getTsiodrasCovidGrafeioAirports (arr, N, M) =
    let
        fun find (~1, ~1, final) = final
          | find (i, j, (tsiodras, covid, grafeio, airports)) =
              let
                  val cell = Array2.sub(arr, i, j)
                  val foundTsiodras =
                    if cell = #"S" then (i,j)
                    else tsiodras

                  val foundCovid =
                    if cell = #"W" then (i,j)
                    else covid

                  val foundGrafeio =
                    if cell = #"T" then (i,j)
                    else grafeio

                  val foundAirports =
                    if cell = #"A"
                    then ((i,j) :: airports)
                    else  airports

                  val next =
                    if j = M-1 andalso i <> N-1
                    then (i+1,0)
                    else if j = M-1 andalso i = N-1
                    then (~1,~1)
                    else (i,j+1)

            in
                find((#1 next), (#2 next), (foundTsiodras, foundCovid, foundGrafeio, foundAirports))
            end
    in
        find (0, 0, ((~1, ~1), (~1, ~1), (~1, ~1), []))
    end


fun make_array2D (arr, grid) =
    let
      fun array_2D_aux (arr, [], _) = arr
        | array_2D_aux (arr, (x::xs), i) = array_2D_aux (make_array (arr, x, i), xs, i+1)
    in
      array_2D_aux (arr, grid, 0)
    end

fun push_airports (_, _, _, [], _) = true
  | push_airports (q, times, visited, (x::xs), time) =
      if(Array2.sub(visited, X(x), Y(x)) = false) then
        let
          val _ = Queue.enqueue(q, (x, time))
          val _ = Array2.update(times, X(x), Y(x), time)
          val _ = Array2.update(visited, X(x), Y(x), true)
        in
          push_airports(q, times, visited, xs, time)
        end
      else push_airports(q, times, visited, xs, time)

fun get_neighbours(grid, position, N, M, visited) =
    let
        val down = (X(position) + 1, Y(position))
        val left = (X(position), Y(position) - 1)
        val right = (X(position), Y(position) + 1)
        val up = ( X(position) - 1, Y(position))

        val newUp =
          if ( X(up) >= 0  andalso (Array2.sub(grid, X(up), Y(up)) <> #"X") andalso (Array2.sub(visited, X(up), Y(up)) = false))
          then [(up,  #"U")]
          else []


        val newRight =
          if ( Y(right) < M  andalso (Array2.sub(grid, X(right), Y(right)) <> #"X") andalso (Array2.sub(visited, X(right), Y(right)) = false))
          then (right, #"R")::newUp
          else newUp


        val newLeft =
            if ( Y(left) >= 0  andalso (Array2.sub(grid, X(left), Y(left)) <> #"X") andalso (Array2.sub(visited, X(left), Y(left)) = false))
            then (left, #"L")::newRight
            else newRight

        val newDown =
            if ( X(down) < N  andalso (Array2.sub(grid, X(down), Y(down)) <> #"X") andalso (Array2.sub(visited, X(down), Y(down)) = false))
            then (down, #"D")::newLeft
            else newLeft


    in
        newDown
    end

fun push_neighbours_in_queue(_, _, _, _, _, [], activated, airports_time) = (activated, airports_time)
  | push_neighbours_in_queue(grid, q, times, visited, curr_time, (x::xs), activated, airports_time) =
    let
      val char = str(Y(x))
      val pos = X(x)
    in
      if(Array2.sub(grid, X(pos), Y(pos)) = #"A" andalso not(activated))
      then
          (Queue.enqueue(q, (pos, curr_time));
          Array2.update(times, X(pos), Y(pos), curr_time);
          Array2.update(visited, X(pos), Y(pos), true);
          push_neighbours_in_queue(grid, q, times, visited, curr_time, xs, true, curr_time+5))
      else
          (Queue.enqueue(q, (pos, curr_time));
          Array2.update(times, X(pos), Y(pos), curr_time);
          Array2.update(visited, X(pos), Y(pos), true);
          push_neighbours_in_queue(grid, q, times, visited, curr_time, xs, activated, airports_time))
    end

fun push_neighbours_find(_, _, _, _, _, _, []) = 1
 |  push_neighbours_find(grid, q, times, visited, curr_time, curr_path, (x::xs)) =
  let
      val pos = X(x)
      val char = str(Y(x))
  in
      if(Array2.sub(times, X(pos), Y(pos)) > curr_time + 1) then
          (Queue.enqueue(q, (pos, (curr_path ^ (char), curr_time+1)));
          Array2.update(visited, X(pos), Y(pos), true);
          push_neighbours_find(grid, q, times, visited, curr_time, curr_path, xs))
      else push_neighbours_find(grid, q, times, visited, curr_time, curr_path, xs)
  end

fun flood_fill(grid, times, visited, covid, airports, N, M) =
    let
      val q = Queue.mkQueue(): ((int * int)* int) Queue.queue
      val _ = Queue.enqueue(q, (covid, 0))
      val _ = Array2.update(visited, X(covid), Y(covid), true)

      fun flood_fill_aux (_, _, _, true) = 1
        | flood_fill_aux (entered, activated, airports_time, not_empty) =
              let
                val current = Queue.dequeue(q)
                val position = X(current)
                val current_time = Y(current)
                val NewEntered =
                  if(((current_time = airports_time-1) orelse (Queue.isEmpty(q)  andalso current_time <> 0)) andalso not(entered))
                  then push_airports(q, times, visited, airports, airports_time)
                  else false
                val neighbour_list = get_neighbours(grid, position, N, M, visited)
                val (NewActivated, NewAirportsTime) = push_neighbours_in_queue(grid, q, times, visited, current_time+2, neighbour_list, activated, airports_time)
              in
                flood_fill_aux (NewEntered, NewActivated, NewAirportsTime, Queue.isEmpty(q))
              end
    in
        flood_fill_aux(false, false, ~1, Queue.isEmpty(q))
    end


fun tsiodras_home (grid, times, visited, tsiodras, grafeio, N, M) =
    let
      val q = Queue.mkQueue(): ((int * int) * (string * int)) Queue.queue
      val _ = Queue.enqueue(q, (tsiodras, ("", 0)))

      fun tsiodras_aux(true) = (0, "whatever", false)
        | tsiodras_aux(not_empty) =
          let
            val front = Queue.dequeue(q)
            val position = X(front)
            val string_time = Y(front)
            val path = X(string_time)
            val current_time = Y(string_time)
            val neighbour_list = get_neighbours(grid, position, N, M, visited)
            val useless = push_neighbours_find(grid, q, times, visited, current_time, path, neighbour_list)
          in
            if(position = grafeio) then (current_time, path, true)
            else tsiodras_aux(Queue.isEmpty(q))
          end
    in
        tsiodras_aux(Queue.isEmpty(q))
    end

fun printGrid i N M grid =
      if (i >= N) then ()
      else
        (
          let
            fun printRow j M =
              if (j >= M + 1) then ()
              else (print (Int.toString(Array2.sub(grid, i, j))); print(" "); printRow (j+1) M)
          in
            printRow 0 M;
            print("\n");
            printGrid (i + 1) N M grid
          end
        )

fun  stayhome fileName =
    let
      val out = parse fileName;
      val N = A(out);
      val M = B(out);
      val grid = make_array2D (Array2.array(N, M, #"a"), (C(out)))
      val times = Array2.array(N, M, 2000010)
      val fill_visited = Array2.array(N, M, false)
      val path_visited = Array2.array(N, M, false)

      val points = getTsiodrasCovidGrafeioAirports(grid, N, M)
      val tsiodras = FIRST(points)
      val covid = SECOND(points)
      val grafeio = THIRD(points)
      val airports = FOURTH(points)

      val useless = flood_fill(grid, times, fill_visited, covid, airports, N, M)
      val solution = tsiodras_home(grid, times, path_visited, tsiodras, grafeio, N, M)
    in
      if(C(solution)) then print (Int.toString(A(solution)) ^ "\n" ^ (B(solution)) ^ "\n")
      else print("IMPOSSIBLE" ^ "\n")
      (*  printGrid 0 (N) (M-1) times*)
    end
