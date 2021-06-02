read_input(File, N, Q) :-
	    open(File, read, Stream),
	    read_line(Stream, [N]),
	    read_line(Stream, Q).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

move([Queue|R1], Stack, 'Q', [Queue|Stack], R1).
move(Queue, [Stack|R2], 'S', R2, L) :-
    reverse(Queue1, Queue),
    reverse([Stack|Queue1], L).

naive_sort(List,Sorted):-permutation(List,Sorted),is_sorted(Sorted).
is_sorted([]).
is_sorted([_]).
is_sorted([X,Y|T]):-X=<Y,is_sorted([Y|T]).

solve(Q, S, []) :- 
     S=[],
     is_sorted(Q). 

solve(Q, S, [Move|Moves]) :-
    move(Q, S, Move, NewS, NewQ),
    solve(NewQ, NewS, Moves).

qssort(File, Answer) :-
    read_input(File, _, Q),
    %naive_sort(Q, Sorted),
    %nb_setval(QSorted,Sorted),
    length(Answer0, _),
    solve(Q, [], Answer0),
    (Answer0=[] -> Answer = 'empty' ; atomics_to_string(Answer0,Answer)),
    !.
