read_input(File, N, Q) :-
	    open(File, read, Stream),
	    read_line(Stream, [N]),
	    read_line(Stream, Q).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

move([Q|R1], S, q, NewS, NewQ) :-
    append([Q], S, NewS),
    append([], R1, NewQ).
move(Q, [S|R2], s, NewS, NewQ) :-
    append([], R2, NewS),
    append(Q, [S], NewQ).

is_sorted([]).
is_sorted([_]).
is_sorted([X,Y|T]):-X=<Y,is_sorted([Y|T]).

solve(Q, S, []) :- 
	is_sorted(Q),
	S=[]. 
solve(Q, S, [Move|Moves]) :-
    move(Q, S, Move, NewS, NewQ),
    solve(NewQ, NewS, Moves).

longest(File, Answer) :-
    read_input(File, _, Q),
    length(Answer, _),
    solve(Q, [], Answer).   