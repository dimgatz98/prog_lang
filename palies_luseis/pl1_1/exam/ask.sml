fun reconstruct list =
    let
      fun reconstruct_aux [] _ _ acc = rev acc
        | reconstruct_aux [0] _ _ acc = rev ([0]::acc)

        | reconstruct_aux (x::xs) 0 [] acc =
            reconstruct_aux xs x (x::[]) acc
        | reconstruct_aux (x::xs) 0 [0] acc =
            reconstruct_aux xs x (x::[]) ([0]::acc)
            
        | reconstruct_aux (x::xs) 1 curr_list acc =
            reconstruct_aux xs 0 [] ((rev (x::curr_list))::acc)
        | reconstruct_aux (x::xs) n curr_list acc =
            reconstruct_aux xs (n-1) (x::curr_list) acc
   in
    reconstruct_aux list 0 [] []
   end
