odd_permutation(Xs, Ys):-
	permute(Xs, Ys),
	sign_of_product_of_differences(Xs, 1, D),
	sign_of_product_of_differences(Ys, 1, E),
	D =\= E.

sign_of_product_of_differences([], D, D).
sign_of_product_of_differences([Y|Xs], D0, D):-
	sign_of_product_of_differences_1(Xs, Y, D0, D1),
	sign_of_product_of_differences(Xs, D1, D).

sign_of_product_of_differences_1([], _, D, D).
sign_of_product_of_differences_1([X|Xs], Y, D0, D):-
	Y =\= X,
	D1 is D0 * (Y - X) // abs(Y - X),
	sign_of_product_of_differences_1(Xs, Y, D1, D).

permute([], []).
permute([X|Xs], Ys1):-
	permute(Xs, Ys),
	select(X, Ys1, Ys).