unoddsum(n(T1, T2, T3), Term) :- 
	( (T1 =/= n(T11,T12,T13) ,T2 =/= n(T21,T22,T23) ,T3 =/= n(T31,T32,T33) ) 
		->  ((Temp is (T1 + T2 + T3) mod 2, Temp = 1) -> Term = 17 ; Term = n(T1, T2, T3) ) ; 
		Term = n(NT1,NT2,NT3),
		(T1 = n(T11,T12,T13) -> unoddsum(T1, NT1) ;
		(T2 = n(T21,T22,T23) -> unoddsum(T2, NT2) ;
		(T3 = n(T31,T32,T33) -> unoddsum(T3, NT3) ) ) )	
	).