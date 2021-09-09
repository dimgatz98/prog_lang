def f(a):
	l = list(a)
	s = sum(l)
	return [float(x) / float(s) for x in l]

print(f(x * x for x in range(4) ) )