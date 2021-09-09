floor(node(X, leaf, leaf),K,Res,Res).
floor(node(X,L,R),K,F,Res):-
	K=X -> Res=X;
	K<X -> (not(L=leaf) -> floor(L,K,F,Res) ; Res is F);
	NewF is max(X,F),
	(not(R=leaf) -> floor(R,K,NewF,Res) ; Res is F).