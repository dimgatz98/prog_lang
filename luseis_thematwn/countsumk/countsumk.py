def countsumk(A, K):
	res = 0
	sum_A = {0:0}
	temp_sum = 0
	sum_list = []

	for i in range(len(A)):
		temp_sum += A[i]
		sum_list.append(temp_sum)
		sum_A[temp_sum] = i
 
	for i, x  in enumerate(sum_list):
		if(x - K in sum_A):
			if(sum_A[x - K] < i):
				res += 1

	return res 

print(countsumk([2,1,2,3,1,-1], 5) )