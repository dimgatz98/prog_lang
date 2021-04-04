%fast reverse: https://stackoverflow.com/questions/49217847/prolog-reversing-a-list-fast-method
reverse(List,Result) :-
    reverse(List,[],Result).
reverse([],ReversedList,ReversedList).
reverse([Head|Tail],RestTail,ReverseList) :-
    reverse(Tail,[Head|RestTail],ReverseList).


prime_start([], []).
%prime_start([H], S):-
%  (
%    isPrime(H) ->
%      S = [H]
%    ;
%      S = []
%  ).
prime_start([H|T], S):-
  prime_start_aux([H|T], [], [], S).

%First element of accumulator contains all non-prime leading elements so we cut it out
%If there is only the first, element, we print an empty list
prime_start_aux([], Accum, [], S):-
    reverse(Accum, [_|Tail]),
    S = Tail.
prime_start_aux([], Accum, CurrentList, S):-
   reverse(CurrentList, NewList),
   AlmostThere = [NewList | Accum],
   reverse(AlmostThere, [_|Tail]),
   S = Tail.
prime_start_aux([H|T], [], CurrentList, S):-
      not(prime(H)),
      prime_start_aux(T, [], CurrentList, S),
      !.
prime_start_aux([H|T], Accum, CurrentList, S):-
      not(Accum = []),
      NewList = [H | CurrentList],
      prime_start_aux(T, Accum, NewList, S).
prime_start_aux([H|T], Accum, CurrentList, S):-
        prime(H),
        reverse(CurrentList, NewList),
        NewAccum = [NewList | Accum],
        prime_start_aux(T, NewAccum, [H], S).
