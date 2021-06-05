read_input(File, N, Q) :-
        open(File, read, Stream),
        read_line(Stream, [N]),
        read_line(Stream, Q).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

element_in_list([], S, Answer) :- Answer = 0.
element_in_list([Elem|Rest], S, Answer) :-
    S = Elem -> Answer = 1, ! ; element_in_list(Rest, S, Answer).

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

solve([Elem|Rest], Rest1, Rest1Next, Answer, Set, NewSet):-
    Elem = [Moves, Queue, Stack],
    (
        (Stack = [], is_sorted(Queue) ) -> (Answer = Moves) ;
        (
            (
                not(Queue=[]) -> 
                solveQ([[Moves, Queue, Stack]|Rest], [Moves1, Queue1, Stack1]), 
                (member([Queue1, Stack1], Set) -> InList1 = 1 ; InList1 = 0), 
                (
                    InList1 = 0 -> 
                    Temp = [[Moves1, Queue1, Stack1] | Rest1], Temp2 = [[Queue1, Stack1]|Set] 
                    ; Temp = Rest1, Temp2 = Set
                ) ; Temp = Rest1, Temp2 = Set
            )
            ,
            (
                not(Stack=[]) -> solveS([[Moves, Queue, Stack]|Rest], [Moves2, Queue2, Stack2]), 
                (member([Queue2, Stack2], Set) -> InList2 = 1 ; InList2 = 0),
                    (
                        InList2 = 0 -> 
                        Rest1Next = [[Moves2, Queue2, Stack2] | Temp], NewSet = [[Queue2, Stack2]|Temp2] 
                        ; Rest1Next = Temp, NewSet = Temp2
                    ) ;Rest1Next = Temp, NewSet = Temp2
            )
        )
    ).

scan_list([], List2, Answer, Set) :-
    reverse(List2, NewList),
    scan_list(NewList, [], Answer, Set). 
scan_list(List1, List2, Answer, Set) :-
    List1 = [Elem|Rest1],
    solve(List1, List2, NewList2, Answer, Set, NewSet),
    Asnwer = [] -> scan_list(Rest1, NewList2, Answer, NewSet) ; !.
     
naive_sort(List,Sorted) :- permutation(List,Sorted),is_sorted(Sorted).
is_sorted([]).
is_sorted([_]).
is_sorted([X,Y|T]):-X=<Y,is_sorted([Y|T]).

qssort(File, Answer) :-
    set_prolog_stack(global, limit(100 000 000 000)),
    read_input(File, _, Q),
    (is_sorted(Q) -> Answer = 'empty'; scan_list([ [ [], Q, [] ] ], [], Answer0, []), reverse(Answer0, Answer1), atomics_to_string(Answer1, Answer) ),
    !.   