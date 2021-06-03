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
move([Queue|R1], Stack, 'Q', [Queue|Stack], R1).
move(Queue, [Stack|R2], 'S', R2, L) :-
    reverse(Queue1, Queue),
    reverse([Stack|Queue1], L).

split_list([A,B,C],A,B,C).

solve([Tuple|Rest], Ans) :-
    split_list(Tuple, Move, Queue, Stack),
    (
        (
            not(Queue = []) -> 
                    move(Queue, Stack, 'Q', NewQueue1, NewStack1),
                    append(Move, ["Q"], NewMove1),  
                    append(Rest, [ [NewMove1, NewQueue1, NewStack1] ], NewRest1) ;
                    NewRest1 = Rest, NewStack1 = Stack, NewQueue1 = Queue 
        )
        ,
        (
            NewStack1 = [], is_sorted(NewQueue1) -> 
                Ans = NewMove1 ;
                (
                    not(Stack = []) -> 
                        move(Queue, Stack, 'S', NewQueue2, NewStack2),
                        append(Move, ["S"], NewMove2),
                        append(NewRest1, [ [NewMove2, NewQueue2, NewStack2] ], NewRest2), 
                        (
                           NewStack2 = [], is_sorted(NewQueue2) -> Ans = NewMove2 ;
                           solve(NewRest2, Ans)
                        )
                        ;
                        (
                           solve(NewRest1, Ans)
                        )    
                )            
        ) 
            
    ).    

naive_sort(List,Sorted) :- permutation(List,Sorted),is_sorted(Sorted).
is_sorted([]).
is_sorted([_]).
is_sorted([X,Y|T]):-X=<Y,is_sorted([Y|T]).

qssort(File, Answer) :-
    read_input(File, _, Q),
    solve([ [[],Q, []] ], Answer0), atomics_to_string(Answer0, Answer), !.