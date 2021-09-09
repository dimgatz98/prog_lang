read_input(File, N, Q) :-
	    open(File, read, Stream),
	    read_line(Stream, [N]),
	    read_line(Stream, Q).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).


move([], Stack, 'Q', [], Stack).
move(Queue, [], 'S', Queue, []).
move([Queue|R1], Stack, 'Q', R1, [Queue|Stack]).
move(Queue, [Stack|R2], 'S', L, R2) :-
    reverse(Queue1, Queue),
    reverse([Stack|Queue1], L).

split_list([A,B,C],A,B,C).

solveQ([[Moves, Queue, Stack]|Rest], [Moves1, Queue1, Stack1]):-
    move(Queue, Stack, 'Q', Queue1, Stack1),
    Moves1=["Q"|Moves].

solveS([[Moves, Queue, Stack]|Rest], [Moves2, Queue2, Stack2]):-
    move(Queue, Stack, 'S', Queue2, Stack2),
    Moves2=["S"|Moves].

solve([Elem|Rest], Rest1, Rest1Next, Answer):-
    Elem = [Moves, Queue, Stack],
    (
        (Stack = [], is_sorted(Queue) ) -> (Answer = Moves) ;
        (
            (
                not(Queue=[]) -> solveQ([[Moves, Queue, Stack]|Rest], [Moves1, Queue1, Stack1]), 
                Temp = [[Moves1, Queue1, Stack1] | Rest1] ; Temp = Rest1
            )
            ,
            (
                not(Stack=[]) -> solveS([[Moves, Queue, Stack]|Rest], [Moves2, Queue2, Stack2]), 
                Rest1Next = [[Moves2, Queue2, Stack2] | Temp] ; Rest1Next = Temp
            )
        )
    ).
scan_list([], List2, NewList2, Answer).
scan_list(List1, List2, NewList2, Answer) :-
    List1 = [Elem|Rest1],
    solve(List1, List2, NewList2, Answer),
    (Answer = [] -> scan_list(Rest1, NewList2, NewList2, Answer)  ; !).

scan(List1, List2, Answer) :-
    scan_list(List1, List2, NewList2, Answer),
    Answer = [] -> scan(NewList2, [], Answer) ; !. 
  
naive_sort(List,Sorted) :- permutation(List,Sorted),is_sorted(Sorted).
is_sorted([]).
is_sorted([_]).
is_sorted([X,Y|T]):-X=<Y,is_sorted([Y|T]).

qssort(File, Answer) :-
    read_input(File, _, Q),
    (is_sorted(Q) -> Answer = 'empty'; scan([ [ [], Q, [] ] ], [], Answer0), reverse(Answer0, Answer1), atomics_to_string(Answer1, Answer) ),
    !.