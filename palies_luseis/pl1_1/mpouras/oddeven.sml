(*
  We check each element, keeping a current counter and a max value
  First pattern is only useful for empty lists
  Second pattern calculates result based on last element and maxSoFar
  Third pattern is general case
*)
fun oddeven list =
  let
    fun oddeven_aux [] _ _ maxSoFar = maxSoFar
      | oddeven_aux [x] wantedMod currentResult maxSoFar =
            if(x mod 2 = wantedMod) then
              let
                val newResult = currentResult+1
              in
                if(newResult > maxSoFar) then newResult
                else maxSoFar
              end
            else if (maxSoFar > 0) then maxSoFar
            else 1
      | oddeven_aux (x::xs) wantedMod currentResult maxSoFar =
              if(x mod 2 = wantedMod) then
                let
                  val newResult = currentResult+1
                in
                  if(newResult > maxSoFar) then oddeven_aux (xs) ((x+1) mod 2) newResult newResult
                  else oddeven_aux (xs) ((x+1) mod 2) newResult maxSoFar
                end
              else oddeven_aux (xs) ((x+1) mod 2) 1 maxSoFar (* Here x+1 mod 2 is irrelevant as it will change *)
  in
      oddeven_aux list 0 0 0
  end
