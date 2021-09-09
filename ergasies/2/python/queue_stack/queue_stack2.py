import sys
from datetime import datetime

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def is_found(move, queue, op):
	counter = 1
	l = len(queue)
	sorted_queue = queue.copy()
	sorted_queue.sort()
	q = queue.copy()
	s = []

	if(op == 1):
		print(bcolors.OKBLUE + str(counter), ". ", sep = "", end =  "")
		print("Queue:", q, " / Stack:", s)
		print()
		counter += 1

	for i in move:
		if(i == "S" and len(s) == 0):
			return 0
		if(i == "Q" and len(q) == 0):
			return 0

		if(i == "S"):
			temp = s.pop()
			q.append(temp)
		
		elif(i == "Q"):
			temp = q.pop(0)
			s.append(temp)
		if(op == 1):
			print(str(counter), ". ", sep = "", end =  "")
			print("Queue:", q, " / Stack:", s)
			print()
			counter += 1

	if((len(q) == l) and (q == sorted_queue)):
		return 1

	else:
		return 0
	

def solve(queue):
	moves = ["Q", "S"]
	
	while(1):
		to_remove = []
		for i in range(len(moves)):
			x = is_found(moves[i], queue, 0)
			if(x == 1):
				return moves[i]
			#elif(x == -1):
			#	to_remove.append(moves[i])
		
		#for elem in to_remove:
		#	moves.remove(elem)

		for i in range(len(moves)):
			moves.append(moves[i] + "S")
			moves[i] += "Q"


f = open(sys.argv[1], "r")

n = int(f.readline() )

line = f.readline().split()

queue = []
for elem in line:
	queue.append(int(elem) )

f.close()

if(is_found([], queue, 0)):
	print('empty')
	exit()

#if(is_found("QQSQSSQQSQQSQQQSSSSSQS", queue, 1) ):
#	print("Cool")
#	exit()

now = datetime.now().time()

res = solve(queue)

is_found(res, queue, 1)
print(res)
print("Elapsed time: %s seconds" % ( (datetime.now().time().minute - now.minute) * \
	60 + datetime.now().time().second - now.second))