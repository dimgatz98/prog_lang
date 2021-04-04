emptyQ(L-L).  /* Checks if queue is empty */

% returns the head of the list as the first arguement and
% the rest of the queue as the third arguement
popQ(Head, [Head|Tail]-X, Tail-X).

/* Pushes Element into Queue to create New_Queue */
pushQueue(Element, Queue, New_Queue) :-
    Last = [Element|T]-T,
    dapp(Queue, Last, New_Queue).

dapp(A-B, B-C, A-C).

%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%
read_input(File, N, Q) :-
    open(File, read, Stream),
    read_number(Stream, [N]),
    read_queries(Stream, N, Q, []).

read_number(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(L, ' ', Atom).

read_queries(_,0,Q,Acc) :-
    reverse(Acc, Q),
    !.

read_queries(Stream,N,Q,Acc) :-
    read_line(Stream, [String]),
    string_to_list(String, L),
    get_tail_and_list(L, [], SecondList, FirstList),
    string_to_list(First, FirstList),
    string_to_list(Second, [SecondList]),
    QuerriesLeft is N-1,
    read_queries(Stream,QuerriesLeft,Q,[Second, First |Acc]).
%%%%%%%%%%%%%%% END OF INPUT%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% HELPERS %%%%%%%%%%%%%%%%%%%

complement_list([], Acc, Result):-
    reverse(Acc, Result).
complement_list([H|T], Acc, Result):-
  (   H =:= 65 -> NewH is 85
  ;   H =:= 71 -> NewH is 67
  ;   H =:= 67 -> NewH is 71
  ;   NewH is 65
  ),
  NewAcc = [NewH | Acc],
  complement_list(T, NewAcc, Result),
  !.


complement(First, NewFirst):-
    string_to_list(First, List),
    complement_list(List,[], NewList),
    !,
    string_to_list(NewFirst, NewList).

%fast reverse
reverse(List,Result) :-
    reverse(List,[],Result).
reverse([],ReversedList,ReversedList).
reverse([Head|Tail],RestTail,ReverseList) :-
     reverse(Tail,[Head|RestTail],ReverseList).

reverse_string(String, Reverse):-
    string_to_list(String, List),
    reverse(List, NewList),
    string_to_list(Reverse, NewList).


add_if_safe(First, Second, Encountered, NewFirst, NewSecond, NewEncountered, Checker):-
    string_to_list(First, ListFirst),
    string_to_list(Second, [HeadSecond|TailSecond]),
    get_tail_and_list(ListFirst, [], ToBeAdded, FinalListFirst),
    (
      ToBeAdded =:= HeadSecond ->
          NewSecondList = [ToBeAdded | [HeadSecond | TailSecond]],
          string_to_list(NewFirst, FinalListFirst),
          string_to_list(NewSecond, NewSecondList),
          Checker = 0,
          NewEncountered = Encountered
    ;
      get_assoc(ToBeAdded, Encountered, _) ->
        Checker = 1,
        NewEncountered = Encountered
    ;
      NewSecondList = [ToBeAdded | [HeadSecond | TailSecond]],
      put_assoc(ToBeAdded, Encountered, 1, NewEncountered),
      string_to_list(NewFirst, FinalListFirst),
      string_to_list(NewSecond, NewSecondList),
      Checker = 0
    ).

get_tail_and_list([Tail], Acc, Tail, List):-
    reverse(Acc, List),
    !.
get_tail_and_list([H|T], Acc, Tail, List):-
    NewAcc = [H | Acc],
    get_tail_and_list(T, NewAcc, Tail, List).

%%%%%%%%%%%%% MAIN FROM HERE %%%%%%%%%%%%


main(StartLeft, StartRight, Moves):-
  empty_assoc(Empty_encountered),
  %%TODO: PUT FIRST STARTRIGHT CHAR INTO ASSOCIATION LIST
  string_to_list(StartRight, [HeadAssoc | _]),
  put_assoc(HeadAssoc, Empty_encountered, 1, FinalEncountered),
  Queue = [[state(StartLeft, StartRight), FinalEncountered, []]| X]-X,
  empty_assoc(Empty_Visited),
  hash_term( state(StartLeft, StartRight), Value ),
  put_assoc( Value, Empty_Visited, state(StartLeft, StartRight), Visited),
  find(Queue, Visited, "", Moves),
  !.

same(X,X).

find(Queue, _, Goal, Moves) :-
    popQ([state(Goal, _), _, MMoves], Queue, _),
    reverse(MMoves, FinalMoves),
    Moves = ['p'|FinalMoves],
    !.

find(Queue,Visited,Goal,Moves):-
    popQ([state(First, Second), Encountered, CurrMoves], Queue,Pop_Queue),
    add_pos(state(First, Second), Encountered, CurrMoves, Pop_Queue, Visited, 'c', Queue_1, Visited_1),
    add_pos(state(First, Second), Encountered, CurrMoves, Queue_1, Visited_1, 'p', Queue_2, Visited_2),
    add_pos(state(First, Second), Encountered, CurrMoves, Queue_2, Visited_2, 'r', Final_Queue, Final_Visited),
    find(Final_Queue, Final_Visited, Goal, Moves),
    !.

add_pos(state(First, Second), Encountered, Moves, Curr_Queue, Curr_Visited, 'c', Next_Queue, Next_Visited):-
    complement(First, NewFirst),
    State = state(NewFirst, Second),
    hash_term(State, Key),
    (
      get_assoc(Key, Curr_Visited, _) ->
        Next_Queue = Curr_Queue,
        Next_Visited = Curr_Visited
      ;
        put_assoc(Key, Curr_Visited, State, Next_Visited),
        pushQueue([State, Encountered, ['c' | Moves]], Curr_Queue, Next_Queue)
    ).


add_pos(state(First, Second), Encountered, Moves, Curr_Queue, Curr_Visited, 'r', Next_Queue, Next_Visited):-
    reverse_string(Second, NewSecond),
    State = state(First, NewSecond),
    hash_term(State, Key),
    (
      get_assoc(Key, Curr_Visited, _) ->
        Next_Queue = Curr_Queue,
        Next_Visited = Curr_Visited
      ;
        put_assoc(Key, Curr_Visited, State, Next_Visited),
        pushQueue([State, Encountered, ['r' | Moves]], Curr_Queue, Next_Queue)
    ).


add_pos(state(First, Second), Encountered, Moves, Curr_Queue, Curr_Visited, 'p', Next_Queue, Next_Visited):-
    add_if_safe(First, Second, Encountered, NewFirst, NewSecond, NewEncountered, Checker),
    State = state(NewFirst, NewSecond),
    hash_term(State, Key),
    (
      get_assoc(Key, Curr_Visited, _) ->
        Next_Queue = Curr_Queue,
        Next_Visited = Curr_Visited
      ;
      Checker =:= 1 ->
        Next_Queue = Curr_Queue,
        Next_Visited = Curr_Visited
      ;
        put_assoc(Key, Curr_Visited, State, Next_Visited),
        pushQueue([State, NewEncountered, ['p' | Moves]], Curr_Queue, Next_Queue)
    ).

solve_cases(1, [LastFirst, LastSecond], Accumulator, Result):-
    main(LastFirst, LastSecond, Moves),
    string_to_list(Almost, Moves),
    atom_string(FinalMoves, Almost),
    FinalAccum = [FinalMoves | Accumulator],
    reverse(FinalAccum, Result),
    !.

solve_cases(Times, [CurrentFirst, CurrentSecond |Next], Accumulator, Result):-
    main(CurrentFirst, CurrentSecond, Moves),
    string_to_list(Almost, Moves),
    atom_string(StringMoves, Almost),
    NewAccum = [StringMoves | Accumulator],
    NewTimes is Times-1,
    solve_cases(NewTimes, Next, NewAccum, Result),
    !.

vaccine(File, Answer):-
    read_input(File, N, Q),
    !,
    solve_cases(N, Q, [], Answer),
    !.
