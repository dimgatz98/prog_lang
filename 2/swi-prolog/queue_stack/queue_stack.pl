read_input(File, N, Q) :-
    open(File, read, Stream),
    read_line(Stream, [N]),
    read_line(Stream, Q).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

move([Queue|R1], Stack, 'Q', NewS, NewQ) :-
    append([Queue], Stack, NewS),
    append([], R1, NewQ).
move(Queue, [Stack|R2], 'S', NewS, NewQ) :-
    append([], R2, NewS),
    append(Queue, [Stack], NewQ).

naive_sort(List,Sorted):-permutation(List,Sorted),is_sorted(Sorted).
is_sorted([]).
is_sorted([_]).
is_sorted([X,Y|T]):-X=<Y,is_sorted([Y|T]).

solve(Q, S, []) :- 
    is_sorted(Q),
    S=[]. 

solve(Q, S, [Move|Moves]) :-
    move(Q, S, Move, NewS, NewQ),
    solve(NewQ, NewS, Moves).

qssort(File, Answer) :-
    %statistics(runtime,[Start|_]),
    read_input(File, _, Q),
    length(Answer0, _),
    solve(Q, [], Answer0),
    (Answer0=[] -> Answer = 'empty' ; atomics_to_string(Answer0,Answer)),
    %statistics(runtime,[Stop|_]),
    %Runtime is Stop-Start,
    %writeln(Runtime),
    !.