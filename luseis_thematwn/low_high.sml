fun enum low high acc =
  let 
    val temp1 = low + 1
    val temp2 = acc @ [temp1]
  in
    if low < high then
      enum temp1 high temp2 
    else
      acc
  end