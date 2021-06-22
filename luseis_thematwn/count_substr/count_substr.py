def count_substr(S,K):
	subs=set()
	for ind in range(len(S) - K + 1): 
	    subs.add(S[ind:ind+K])
	print(subs)
	return len(subs)

print(count_substr("banana",2))
print(count_substr("helloworld",3))