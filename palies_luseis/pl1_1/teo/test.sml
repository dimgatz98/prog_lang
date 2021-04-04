fun c ls =
  let
      fun d [] n maxSoFar = maxSoFar
        | d (42 :: t) n maxSoFar = d t (n + 1) (Int.max (n+1, maxSoFar))
        | d (h :: t) n maxSoFar = d t 0 maxSoFar
  in
      d ls 0 0
  end
