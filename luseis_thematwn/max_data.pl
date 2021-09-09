max(A, B, Res) :- A > B -> Res is A ; Res is B.

solve([], Max, Max).
solve([n(Val, L) | Rest], Temp, Max) :-
	(Temp > Val -> solve(L, Temp, Temp1), solve(Rest, Temp1, Max) ; solve(L, Val, Temp1) , solve(Rest, Temp1, Max) ).

depth([], Data, Counter, Res) :- Res is -1.
depth([n(Val, L) | Rest], Data, Counter, Res) :-
	Data = Val -> Res is Counter;
	depth(L, Data, Counter + 1, Temp1), depth(Rest, Data, Counter + 1, Temp2), max(Temp1, Temp2, Res).

max_data(Tree, Max) :- solve([Tree], 0, Max).
find_depth(Tree, Data, Depth) :- depth([Tree], Data, 0, Depth).