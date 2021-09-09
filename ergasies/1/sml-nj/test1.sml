let
val rec f =
	fn x => if null x then nil
	else (hd x + 3) :: f (tl x)
in
	f
end;