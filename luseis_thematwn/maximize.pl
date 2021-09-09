find_max(n(T1,T2,T3), TempMax, Res) :- 
	(T1 = n(T11, T12, T13) -> maximize(T1, TempMax, Res1); TempMax1 is max(TempMax, T1)),
	(T2 = n(T21, T22, T23) -> maximize(T2, TempMax, Res2); TempMax2 is max(TempMax1, T2)),
	(T3 = n(T31, T32, T33) -> maximize(T3, TempMax, Res3); TempMax3 is max(TempMax2, T3)),
	Res is TempMax3.

construct_max_tree(n(T1,T2,T3), n(MT1, MT2, MT3), Max) :-
	(T1 = n(T11, T12, T13) -> construct_max_tree(T1, MT1); MT1 is Max ),
	(T2 = n(T21, T22, T23) -> construct_max_tree(T2, MT2); MT2 is Max ),
	(T3 = n(T31, T32, T33) -> construct_max_tree(T3, MT3); MT3 is Max ).

maximize(Tree, MaxTree) :- find_max(Tree, 0, Res), construct_max_tree(Tree, MaxTree, Res).