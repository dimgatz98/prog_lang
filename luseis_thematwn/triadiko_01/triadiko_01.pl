count_ones(Tree, Temp, Count) :- 
	Tree = n(A, B, C),
	(A = 1 -> Temp1 is Temp + 1 ; (not(A = 0) -> count_ones(A, Temp, Temp1); Temp1 = Temp) ),
	(B = 1 -> Temp2 is Temp1 + 1 ; (not(B = 0) -> count_ones(B, Temp1, Temp2); Temp2 = Temp1) ),
	(C = 1 -> Temp3 is Temp2 + 1 ; (not(C = 0) -> count_ones(C, Temp2, Temp3); Temp3 = Temp2) ),
	Count = Temp3.

count_zeros(Tree, Temp, Count) :- 
	Tree = n(A, B, C),
	(A = 0 -> Temp1 is Temp + 1 ; (not(A = 1) -> count_ones(A, Temp, Temp1); Temp1 = Temp) ),
	(B = 0 -> Temp2 is Temp1 + 1 ; (not(B = 1) -> count_ones(B, Temp1, Temp2); Temp2 = Temp1) ),
	(C = 0 -> Temp3 is Temp2 + 1 ; (not(C = 1) -> count_ones(C, Temp2, Temp3); Temp3 = Temp2) ),
	Count = Temp3.

count_leaves(n(A,B,C), Temp, Count) :-
	(
		( (A = 0 ; A = 1) , (B = 0 ; B = 1) , (C = 0 ; C = 1) ) -> Temp3 is Temp + 1 ; 
		(not((A = 0 ; A = 1)) -> count_leaves(A, Temp, Temp1) ; Temp1 is Temp),
		(not((B = 0 ; B = 1)) -> count_leaves(B, Temp1, Temp2) ; Temp2 is Temp1),
		(not((C = 0 ; C = 1)) -> count_leaves(C, Temp2, Temp3) ; Temp3 is Temp2)
	),
	Count = Temp3.

count_odd_parity(Tree,Count) :-
	count_leaves(Tree, 0, Count).

create_list_ones(Count, L, 1) :-
    Temp = [1], create_list_ones(Count - 1, Temp, 0).
create_list_ones(Count, L, 0) :-
	Temp = [1|L], create_list_ones(Count - 1, Temp, 0).
create_list_ones(0,L,_).	

create_list_zeros(Count, L, 1) :-
    Temp = [0], create_list_zeros(Count - 1, Temp, 0).
create_list_zeros(Count, L, 0) :-
	Temp = [0|L], create_list_zeros(Count - 1, Temp, 0).
create_list_zeros(0,L,_).	

triadiko_01(Tree, Zeros, Ones) :- 
	count_ones(Tree, 0, Count1), 
	count_zeros(Tree, 0, Count2),
	create_list_ones(Count1, List1, 1),
	create_list_zeros(Count2, List2, 1),
	Zeros = List2,
	Ones = List1.