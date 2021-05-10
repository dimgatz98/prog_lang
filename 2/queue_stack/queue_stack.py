import sys
import itertools

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
		
f = open(sys.argv[1], "r")

n = int(f.readline() )

line = f.readline().split()

queue = []
stack = []
for elem in line:
	queue.append(int(elem) )

f.close()

print(n, queue)

found = False
length = 1
while(not found):
	moves = list(itertools.product(['S', 'Q'], repeat=length))
	for move in moves:
		if(is_found(move, queue)):
			res = move
			found = True
			break

	length += 1

print(res)