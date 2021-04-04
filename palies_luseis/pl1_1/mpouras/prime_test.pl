prime(2).
prime(3).
prime(5).
prime(7).
prime(11).
prime(13).
prime(17).
prime(19).

prime_start([],S) :- S=[].
prime_start([H|T],S) :-
	( prime(H) -> 
		L1 = [H|_],
		append(L1,L2,[H|T]),
		( L2 = [] -> S = [H|T]
		; L2 = [H2|_],
		  prime(H2),
		  prime_start(L2,S1),
		  S=[L1|[S1]]
		)
	; prime_start(T,S)
	).	
