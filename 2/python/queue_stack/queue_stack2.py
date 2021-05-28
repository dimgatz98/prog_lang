import sys

def is_found(move, queue):
	l = len(queue)
	sorted_queue = queue.copy()
	sorted_queue.sort()
	q = queue.copy()
	s = []
	for i in move:
		if(i == "S" and len(s) == 0):
			return -1
		if(i == "Q" and len(q) == 0):
			return -1

		if(i == "S"):
			temp = s.pop()
			q.append(temp)
		
		elif(i == "Q"):
			temp = q.pop(0)
			s.append(temp)

	if((len(q) == l) and (q == sorted_queue)):
		return 1

	else:
		return 0
	

def solve(queue):
	moves = ["S", "Q"]
	
	while(1):
		to_remove = []
		for i in range(len(moves)):
			x = is_found(moves[i], queue)
			if(x == 1):
				return moves[i]
			elif(x == -1):
				to_remove.append(moves[i])
		
		for el in to_remove:
			moves.remove(el)

		for i in range(len(moves)):
			moves.append(moves[i]+"Q")
			moves[i] = moves[i]+"S"


f = open(sys.argv[1], "r")

n = int(f.readline() )

line = f.readline().split()

queue = []
for elem in line:
	queue.append(int(elem) )

f.close()

if(is_found([], queue)):
	print('empty')
	exit()

res = solve(queue)

print(res)
