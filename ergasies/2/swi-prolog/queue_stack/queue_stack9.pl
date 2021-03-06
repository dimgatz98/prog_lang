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

create_int_from_queue_stack([Queue, Stack], Res) :-
    atomics_to_string(Queue, S1), 
    atomics_to_string(Stack, S2),
    string_concat(S1, S2, S3),
    atom_number(S3, I),
    length(Queue, Len),
    Res is Len + I.

solveQ([[Moves, Queue, Stack]|Rest], [Moves1, Queue1, Stack1]) :-
    move(Queue, Stack, 'Q', Queue1, Stack1),
    Moves1=["Q"|Moves].

solveS([[Moves, Queue, Stack]|Rest], [Moves2, Queue2, Stack2]) :-
    move(Queue, Stack, 'S', Queue2, Stack2),
    Moves2=["S"|Moves].

solve([Elem|Rest], Rest1, Rest1Next, Answer, Set, NewSet) :- 
    Elem = [Moves, Queue, Stack],
    (
        (
            not(Queue=[]) -> solveQ([[Moves, Queue, Stack]|Rest], [Moves1, Queue1, Stack1]), 
                create_int_from_queue_stack([Queue1, Stack1], Res1),
                (
                    get_dict(Res1, Set, _) -> 
                        Temp = Rest1, Temp2 = Set ;
                        Temp = [[Moves1, Queue1, Stack1] | Rest1], put_dict(Set, [Res1 : 1], Temp2) 
                    
                ) ; Temp = Rest1, Temp2 = Set
        )
        ,
        (
            not(Stack=[]) -> solveS([[Moves, Queue, Stack]|Rest], [Moves2, Queue2, Stack2]), 
                create_int_from_queue_stack([Queue2, Stack2], Res2),
                (
                    get_dict(Res2, Temp2, _) ->
                        Rest1Next = Temp, NewSet = Temp2 ; 
                        Rest1Next = [[Moves2, Queue2, Stack2] | Temp], put_dict(Temp2, [Res2 : 1], NewSet) 
                ) ; Rest1Next = Temp, NewSet = Temp2
        )
    ).

scan_list([], List2, Answer, Set) :-
    reverse(List2, NewList), scan_list(NewList, [], Answer, Set).
scan_list(List1, List2, Answer, Set) :-
    List1 = [Elem|Rest1],
    Elem = [Moves, Queue, Stack],
    (
        (Stack = [], is_sorted(Queue) ) -> (Answer = Moves) 
        ;
        solve(List1, List2, NewList2, Answer, Set, NewSet),
        scan_list(Rest1, NewList2, Answer, NewSet)
    ).

is_sorted([]).
is_sorted([_]).
is_sorted([X,Y|T]):-X=<Y,is_sorted([Y|T]).

qssort(File, Answer) :-
    set_prolog_stack(global, limit(100 000 000 000)),
    read_input(File, _, Q),
    dict_create(Set, _, []),
    (is_sorted(Q) -> Answer = 'empty'; scan_list([ [ [], Q, [] ] ], [], Answer0, Set), reverse(Answer0, Answer1), atomics_to_string(Answer1, Answer) ),
    !.   