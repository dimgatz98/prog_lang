import sys

def is_found(move, queue):
	l = len(queue)
	sorted_queue = queue.copy()
	sorted_queue.sort()
	q = queue.copy()
	s = []
	for i in move:
		if(i == "S" and len(s) == 0):
			return False
		if(i == "Q" and len(q) == 0):
			return False

		if(i == "S"):
			temp = s.pop()
			q.append(temp)
		
		elif(i == "Q"):
			temp = q.pop(0)
			s.append(temp)

	if((len(q) == l) and (q == sorted_queue)):
		return True

	else:
		return False
	

def solve(queue):
	moves = ["S", "Q"]
	
	while(1):
		for i in range(len(moves)):
			if(is_found(moves[i], queue)):
				return moves[i]
		
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

#print(n, queue)

res = solve(queue)

print(res)
