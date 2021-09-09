is_empty(List):- List = [].

move([Q|R1], S, q, NewS, NewQ) :-
    append(Q, S, NewS),
    append([], R1, NewQ).
move(Q, [S|R2], s, NewS, NewQ) :-
    append([], R2, NewS),
    append(Q, S, NewQ).

test([Q|R1], S, T) :-
	append([Q], S, T).