def sliding(A, K):
	d = {}
	for i in range(len(A) - K + 1):
		if(sum(A[i:i+K]) in d):
			d[sum(A[i:i+K])] += 1
		else:
			d[sum(A[i:i+K])] = 1

	temp_max = -1
	for k, v in d.items():
		if(v > temp_max):
			temp_max = v
			temp_max_k = k
		elif(v == temp_max):
			if(k > temp_max_k):
				temp_max_k = k

	return (temp_max_k, temp_max)

print(sliding([1, 4, 2, 3, 2, 1, 3, 4, 2], 4) )