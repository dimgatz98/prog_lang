
fun reverse xs =
  let
    fun rvrs (nil, z) = z
      | rvrs (y::ys, z) = rvrs (ys, y::z)
  in
    rvrs (xs, nil)
  end

fun double_pairs list =
    let
      fun dp_aux [] _ answer = answer
        | dp_aux _ [] answer = answer
        | dp_aux (x::xs) (y::ys) answer =
          if(x = 2*y) then dp_aux xs ys ((y,x)::answer)
          else if (x > 2*y) then dp_aux (x::xs) ys answer
          else dp_aux xs (y::ys) answer
    in
        reverse (dp_aux list list [])
    end
