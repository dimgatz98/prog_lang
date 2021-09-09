unique([]).
	unique([Item | Rest]) :-
		not(member(Item, Rest)),
		unique(Rest).
