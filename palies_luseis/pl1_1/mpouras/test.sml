(*fun s ls =
  let fun c [] a = a
        | c [_] a = a
        | c (x :: r) a = c r (r :: a)
  in
    c ls [ls]
  end
*)
  fun s ls =
  let fun c [] a = a
  | c (x :: r) a = c r ((x::r) :: a)
  in  c ls []
  end
