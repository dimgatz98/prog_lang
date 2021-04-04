add_parent_if_checks(_, _, _, [], _, []).
add_parent_if_checks(First, First, _, NewCycle, _, NewCycle).
add_parent_if_checks(_, _, Cycle, Cycle, _, Cycle).
add_parent_if_checks(Node, _, _, [Node|Rest], Parent, [Parent | [Node|Rest]]).
add_parent_if_checks(_, _, _, Cycle, _, Cycle).

second_element([_,Y|_], Y).
first_element([H|_], H).

push_front([X,Y], List, [X,Y | List]).

last_element([X], X):-!.
last_element([_|T], X):-
    last_element(T, X).

dfs_help([], _, _, _, _, Cycle, First, Route, Answer):-
    Route = Cycle,
    Answer = First,
    !.

dfs_help([Parent|Ns], Graph, Current, Parent, Visited, Cycle, First, Route, Answer):-
    dfs_help(Ns, Graph, Current, Parent, Visited, Cycle, First, Route, Answer),
    !.

dfs_help([N|Ns], Graph, Current, Parent, Visited, Cycle, First, Route, Answer):-
    arg(N, Visited, VisResult),
    (
      VisResult =:= 1 ->
        (
          Current =:= First ->
            dfs_help(Ns, Graph, Current, Parent, Visited, Cycle, First, Route, Answer),
            !
          ;
            NewCycle = [Current|Cycle],
            dfs_help(Ns, Graph, Current, Parent, Visited, NewCycle, N, Route, Answer),
            !
        )
      ;
        dfs(N, Graph, Current, Visited, Cycle, First, NewFirst, NewCycle),
        !,
        dfs_help(Ns, Graph, Current, Parent, Visited, NewCycle, NewFirst, Route, Answer),
        !
    ).



dfs(Node, Graph, Parent, Visited, Cycle, First, NewFirst, FinalCycle):-
      arg(Node, Graph, Neighbors),
      setarg(Node, Visited, 1),
      !,
      dfs_help(Neighbors, Graph, Node, Parent, Visited, Cycle, First, NewCycle, NewFirst),
      !,
      add_parent_if_checks(Node, NewFirst, Cycle, NewCycle, Parent, FinalCycle).

create_graph([], _).
create_graph([First, Second | Rest], Graph):-
    arg(First, Graph, ListFirst),
    arg(Second, Graph, ListSecond),
    setarg(First, Graph, [Second | ListFirst]),
    setarg(Second, Graph, [First | ListSecond]),
    create_graph(Rest, Graph),
    !.

fix_graph(1, Graph):-
    setarg(1, Graph, []),
    !.

fix_graph(N, Graph):-
    setarg(N, Graph, []),
    NewTimes is N-1,
    fix_graph(NewTimes, Graph),
    !.


fix_visited(1, Visited):-
    setarg(1, Visited, 0),
    !.

fix_visited(N, Visited):-
    setarg(N, Visited, 0),
    NewTimes is N-1,
    fix_visited(NewTimes, Visited),
    !.

ctree_aux([], _, _, _, Sofar, Result):-
    Result is Sofar+1.
ctree_aux([Parent|Rest], Graph, Current, Parent, Sofar, Result):-
    ctree_aux(Rest, Graph, Current, Parent, Sofar, Result),
    !.
ctree_aux([N|Ns], Graph, Current, Parent, Sofar, Result):-
    ctree(N, Graph, Current, Temp),
    !,
    NewSofar is Temp+Sofar,
    ctree_aux(Ns, Graph, Current, Parent, NewSofar, Result),
    !.

ctree(Node, Graph, Parent, Result):-
    arg(Node, Graph, Neighbors),
    ctree_aux(Neighbors, Graph, Node, Parent, 0, Result).


checker([], _, _, _, _, Result, Result).
checker([N|Ns], Parent, Graph, AvoidLeft, N, Current, Result):-
    checker(Ns, Parent, Graph, AvoidLeft, N, Current, Result),
    !.
checker([N|Ns], Parent, Graph, N, AvoidRight, Current, Result):-
    checker(Ns, Parent, Graph, N, AvoidRight, Current, Result),
    !.
checker([N|Ns], Parent, Graph, AvoidLeft, AvoidRight, Current, Result):-
    ctree(N, Graph, Parent, Temp),
    NewCurrent is Current + Temp,
    checker(Ns, Parent, Graph, AvoidLeft, AvoidRight, NewCurrent, Result),
    !.

count_aux(X, Graph, AvoidLeft, AvoidRight, Result):-
    arg(X, Graph, Neighbors),
    checker(Neighbors, X, Graph, AvoidLeft, AvoidRight, 1, Result),
    !.

count_trees([], _, _, _, _, _, Answer, Answer).
count_trees([H], Graph, AvoidLeft, AvoidRight, _, Current, Result):-
    count_aux(H, Graph, AvoidLeft, AvoidRight, Temp),
    Result = [Temp|Current].
count_trees([X,Y], Graph, AvoidLeft, AvoidRight, Original, Current, Result):-
    count_aux(X, Graph, AvoidLeft, AvoidRight, Temp),
    NewAnswer = [Temp|Current],
    count_trees([Y], Graph, X, Original, Original, NewAnswer, Result),
    !.
count_trees([H|T], Graph, AvoidLeft, AvoidRight, Original, Current, Result):-
    count_aux(H, Graph, AvoidLeft, AvoidRight, Temp),
    NewAnswer = [Temp|Current],
    second_element(T, NewAvoid),
    count_trees(T, Graph, H, NewAvoid, Original, NewAnswer, Result),
    !.

check_visited(_, 0, 1).
check_visited(Visited, Position, SeenAll):-
    arg(Position, Visited, Temp),
    (
      Temp =:= 0 ->
          SeenAll = 0,
          !
      ;
      NewPosition is Position-1,
      check_visited(Visited, NewPosition, SeenAll),
      !
    ).


solve_case(Graph, Visited, N, N, List, Answer):-
    fix_graph(N, Graph),
    fix_visited(N, Visited),
    create_graph(List, Graph),
    !,
    dfs(1, Graph, 0, Visited, [], -1, Starter, Cycle),
    !,
    check_visited(Visited, N, SeenAll),
    (
      SeenAll =:= 1 ->
        second_element(Cycle, AvoidRight),
        last_element(Cycle, AvoidLeft),
        count_trees(Cycle, Graph, AvoidLeft, AvoidRight, Starter, [], Result),
        length(Result, Size),
        msort(Result, Sorted),
        Answer = [[Size, Sorted]],
        !
      ;
        Answer = ["'NO CORONA'"],
        !
    ).
solve_case(_, _, _, _, _, ["'NO CORONA'"]).

solve_exercise(Graph, Visited, 1, [N,M, List], Accum, Answer):-
      solve_case(Graph, Visited, N,M,List, Temp),
      !,
      append(Accum, Temp, Answer).
solve_exercise(Graph, Visited, T, [N,M, List| Rest],Accum, Answer):-
      solve_case(Graph, Visited, N,M,List, Temp),
      !,
      NewTests is T-1,
      append(Accum, Temp, NewAccum),
      solve_exercise(Graph, Visited, NewTests, Rest, NewAccum, Answer),
      !.

%%%%%%%%%%%%%%%%%%%%% FOR TESTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
read_input(Graph, Visited, File, Answer) :-
    open(File, read, Stream),
    read_test(Stream, 1, [], T),
    take_head(T, Times),
    read_sizes(Graph, Visited, Stream, Times, [], Answer).

take_head([H], Result):-
    Result = H.

read_sizes(_, _, _, 0, Result, Result).
read_sizes(Graph, Visited, Stream, Times, Accum, Answer):-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L),
    second_element(L, M),
    first_element(L, N),
    read_lines(Stream, M, [], Testcase),
    Newtimes is Times-1,
    solve_case(Graph, Visited, N, M, Testcase, NewAnswer),
    append(Accum, NewAnswer, NewAccum),
    read_sizes(Graph, Visited, Stream, Newtimes, NewAccum, Answer).

read_lines(_, 0, Result, Result).
read_lines(Stream, Times, List, Result):-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L),
    Newtimes is Times-1,
    push_front(L, List, NewList),
    read_lines(Stream, Newtimes, NewList, Result).

read_test(_, 0, Result, Result).
read_test(Stream, Times, List, Result):-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L),
    Newtimes is Times-1,
    append(List, L, NewList),
    read_test(Stream, Newtimes, NewList, Result).


coronograph(File, Answer):-
    functor(Visited, array, 1000000),
    functor(Graph, array, 1000000),
    !,
    read_input(Graph, Visited, File, Answer),
    !.
