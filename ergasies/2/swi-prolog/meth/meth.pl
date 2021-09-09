read_input(File, M, N, Q) :-
    open(File, read, Stream),
    read_line(Stream, [M,N]),
    read_line(Stream, Q).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

addnum([],_,[]).
addnum([Q1|Rest1], N, [Q2|Rest2]):-
    Q2 is Q1+N,
    addnum(Rest1, N, Rest2).

signrev([],[]).
signrev([Q1|Rest1], [Q2|Rest2]):-
    Q2 is -Q1,
    signrev(Rest1, Rest2).

list_integral([],_,Int,Int).
list_integral([Q1|Rest1], Sum, Q2, FinalQ2):-
    NewSum is Sum + Q1,
    list_integral(Rest1, NewSum, [NewSum|Q2], FinalQ2).

same([],[]).
same([B|Q1],[C|Q2]):-
    B=C,
    same(Q1,Q2).

maxl([], FinalQ, _, FinalQ).
maxl([A|Rest], Q, Max, FinalQ):-
    NewMax is max(Max,A),
    maxl(Rest,[NewMax|Q],NewMax,FinalQ).

maxr(Q,FinalQ):-
    reverse(Q,[A|RevQ]),
    maxl([A|RevQ],[],A,Q1),
    reverse(Q1,FinalQ). 

minl1([], FinalQ, _, FinalQ).
minl1([A|Rest], Q, Min, FinalQ):-
    NewMin is min(Min,A),
    minl1(Rest,[NewMin|Q],NewMin,FinalQ).

minl([A|Q],FinalQ):- minl1([A|Q],[],A,FinalQ).  

move(Mr, Ml, _, I, J, 0):- same(Mr,Ml). 
move(Mr, Ml, Max, I, J, Max):- 
    Mr=[].

move([A|Mr], [B|Ml], Max, I, J, AbsMax):-
    (A>=B -> NextMr = Mr, NextMl = [B|Ml], Interval is I-J, NewI is I + 1, NewJ is J; NextMl = Ml, NextMr = [A|Mr], NewI is I, NewJ is J+1, Interval is 0),
    NewMax is max(Max, Interval),
    move(NextMr, NextMl, NewMax, NewI, NewJ, AbsMax).

longest(File, L):-
    read_input(File, D, N, Q),
    signrev(Q,NewQ),
    N1 is -N,
    addnum(NewQ, N1, NewQ1),
    list_integral(NewQ1,0,[],IntQ),
    reverse(IntQ,RevIntQ),
    last(RevIntQ,TSum),
    (TSum>=0 -> L is D ; maxr(RevIntQ,Mr), reverse(Mr,RevMr),  minl(RevIntQ,Ml), reverse(Ml,RevMl) ,move(RevMr,RevMl,0,0,0,L)),
    !.