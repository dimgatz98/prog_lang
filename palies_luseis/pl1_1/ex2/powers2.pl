read_input(File, Times, Testcases) :-
    open(File, read, Stream),
    read_lines(Stream, 1, [], T),
    take_head(T, Times),
    read_lines(Stream, Times, [], Testcases).

take_head([H], Result):-
    Result = H.
%%%%%%%%%%%%%%%%%%% FAST REVERSE FROM https://stackoverflow.com/questions/49217847/prolog-reversing-a-list-fast-method %%%%%%%%%%%%%%%%
%  reverse/2
%  reverse(List,Result)
%
%  Result will be the reversed list that gets returned
reverse_list(List,Result) :-
    reverse_three(List,[],Result).
%  reverse/3
%  reverse(List,Accumulator,ReverseList)
%
%  >> stop rule for recursion
%  -- checks whether initial List is empty (aka the reversing process is done)
%  -- returns the ReversedList if completed, otherwise carry ReverseList over throughout the next iteration
reverse_three([],ReversedList,ReversedList).
reverse_three([Head|Tail],RestTail,ReverseList) :-
    reverse_three(Tail,[Head|RestTail],ReverseList).


read_lines(_, 0, Result, Result).
read_lines(Stream, Times, List, Result):-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L),
    Newtimes is Times-1,
      append(List, L, NewList),
    read_lines(Stream, Newtimes, NewList, Result).


binlist(0,[0]).
binlist(1,[1]).
binlist(N,L):-
    N > 1,
    X is N mod 2,
    Y is N // 2,
    binlist(Y,L1),
    L = [X|L1],
    !.


lead([],[]).
lead([0|T],T2) :-
    lead(T,T2).
lead(Result, Result).

count_list([0], 0).
count_list([1], 1).
count_list([0|L], Num):-
    count_list(L, Num).
count_list([1|L], Num):-
    count_list(L, Num1),
    !,
    Num is Num1+1.


push_front(Item, List, [Item|List]).

change_first_and_reverse([H|T], Result):-
    H1 is H+2,
    %fast reverse in O(list_size)
    reverse_list([H1|T], Result).

break_list([0 | L2], Accumulator, Answer):-
    break_list(L2, [0|Accumulator], Answer).
break_list([H | L2], Accumulator, Answer) :-
        H1 is H-1,
        change_first_and_reverse(Accumulator, Accumulator1),
        append(Accumulator1, [H1|L2], Answer).

break_times(Result, 0, Result).
break_times([H|T], Times, Result):-
        NewTimes is Times-1,
        break_list(T, [H], Temp),
        break_times(Temp, NewTimes, Result),
        !.

fix_list(List, Result):-
    reverse_list(List, Temp),
    lead(Temp, Temp2),
    reverse_list(Temp2, Result).


testcase(N, K, Result):-
( K > N ->
    Result = []
    ;
    binlist(N, BinList),
    count_list(BinList, Checker),
    (
      Checker > K ->
        Result = []
      ;
      Remaining is K-Checker,
      break_times(BinList, Remaining, Result1),
      fix_list(Result1, Result),
      !
    )
).

solve_cases(1, [N,K], Answer):-
      testcase(N,K, Answer1),
      Answer = [Answer1].
solve_cases(T, [N,K | Testcases], Answer):-
      testcase(N,K, Temp),
      NewTests is T-1,
      solve_cases(NewTests, Testcases, NewAnswer),
      push_front(Temp, NewAnswer, Answer).

powers2(File, Answer):-
  read_input(File, Tests, Testcases),
  !,
  solve_cases(Tests, Testcases, Answer).
