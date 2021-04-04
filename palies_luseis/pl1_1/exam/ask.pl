max_data(n(Data, List), Max):-
    max_data(n(Data, List), 0, Max).

%We want to avoid [] pattern matching with List so we use a cut
max_data(n(Data, []), MaxSoFar, Answer):-
    Answer is max(Data, MaxSoFar),
    !.
max_data(n(Data, List), MaxSoFar, Answer):-
    NewMax is max(Data, MaxSoFar),
    max_data(List, NewMax, Answer).
max_data([H], MaxSoFar, Answer):-
    max_data(H, MaxSoFar, Answer),
    !.
%We want to avoid [] pattern matching with T so we use a cut
max_data([H|T], MaxSoFar, Answer):-
    max_data(H, MaxSoFar, Tempans),
    max_data(T, Tempans, Answer).

find_depth(n(Data, List), Number, Depth):-
    find_depth(n(Data, List), Number, 1, Depth).

find_depth(n(Data, _), Data, CurrDepth, CurrDepth).
find_depth(n(_, List), Number, CurrDepth, Depth):-
    NewDepth is CurrDepth+1,
    find_depth(List, Number, NewDepth, Depth).
%When we reach a leaf fail (to backtrack)
find_depth([], _, _, _):- fail.
%Same case with max_data for the cut
find_depth([H], Number, CurrDepth, Depth):-
    find_depth(H, Number, CurrDepth, Depth),
    !.
find_depth([H|T], Number, CurrDepth, Depth):-
    find_depth(H, Number, CurrDepth, Depth);
    find_depth(T, Number, CurrDepth, Depth).
