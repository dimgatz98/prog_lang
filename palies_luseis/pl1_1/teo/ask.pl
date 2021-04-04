zeros(0, 1).
zeros(1, 0).
zeros(n(X,Y,Z), Counter):-
    zeros(X, Z1),
    zeros(Y, Z2),
    zeros(Z, Z3),
    Counter is Z1+Z2+Z3.
ones(1, 1).
ones(0, 0).
ones(n(X,Y,Z), Counter):-
    ones(X, Z1),
    ones(Y, Z2),
    ones(Z, Z3),
    Counter is Z1+Z2+Z3.
fix_zeros(0, List, List).
fix_zeros(Number, Accum, List):-
    Newnum is Number-1,
    NewList = [0|Accum],
    fix_zeros(Newnum, NewList, List).
fix_ones(0, List, List).
fix_ones(Number, Accum, List):-
    Newnum is Number-1,
    NewList = [1|Accum],
    fix_ones(Newnum, NewList, List).
triadiko_01(n(X,Y,Z), Zs, Os):-
    zeros(n(X,Y,Z), Zeros),
    ones(n(X,Y,Z), Ones),
    fix_zeros(Zeros, [], Zs),
    !,
    fix_ones(Ones, [], Os),
    !.
count_odd_parity(Something, Count):-
    integer(Something),
    Count is 0.
count_odd_parity(n(X,Y,Z), Count):-
    integer(X),
    integer(Y),
    integer(Z),
    Count is ((X+Y+Z) mod 2),
    !.
count_odd_parity(n(X,Y,Z), Count):-
    count_odd_parity(X, C1),
    count_odd_parity(Y, C2),
    count_odd_parity(Z, C3),
    Count is C1+C2+C3.
