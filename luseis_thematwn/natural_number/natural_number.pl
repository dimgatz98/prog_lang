natural_number(0).
natural_number(s(X)) :- natural_number(X).

difference(0, Y, Z, G) :- Z = Y, G is 2.
difference(X, 0, Z, G) :- Z = X, G is 1.
difference(0, 0, Z, G) :- Z is 0, G is 1.
difference(X, Y, Z, G) :- X = s(NewX), Y = s(NewY), difference(NewX, NewY, Z, G).

gcd(0, X, Z) :- Z = natural_number(X).
gcd(X, 0, Z) :- Z = natural_number(X).
gcd(X, Y, Z) :- difference(X, Y, New, G), 
				(G = 2 -> gcd(X, New, Z) ; gcd(New, Y, Z) ).