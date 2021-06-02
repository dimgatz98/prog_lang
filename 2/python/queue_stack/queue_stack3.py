import sys
from datetime import datetime
import time

parents = [-1]
depth = 10

for i in range(10):
	parents.append(i)
	parents.append(i)

def is_found(queue):
	global sorted_queue
	if(sorted_queue == queue):
		return True
	else:
		return False

def preorder(length, moves, queue, stack):
	global found
	global res

	#if(moves == "QQQSQSQQSSQSQSQSSSQS"):
	#	print("Found!")

	#print(moves)

	#time.sleep(0.1)

	if(len(moves) >= length // 2):
		if(len(stack) == 0 and is_found(queue)):
			found = True
			if(len(moves) < len(res) or len(res) == 0):
				res = moves
			
		
	if(len(moves) == length):
		return

	if(len(queue) != 0):
		preorder(length, moves + "Q", queue[1:], stack + queue[0])

	
	#if(len(moves) == length):
	#	return

	if(len(stack) != 0):
		preorder(length, moves + "S", queue + stack[-1], stack[:-1])

if __name__ == '__main__':
	now = datetime.now().time()
	
	f = open(sys.argv[1], "r")

	n = int(f.readline() )

	line = f.readline().split()

	queue = []
	for elem in line:
		queue.append(int(elem) )

	f.close()

	sorted_queue = queue.copy()
	sorted_queue.sort()

	j = -1
	for l,i in enumerate(queue):
		for x,y in enumerate(sorted_queue):
			if(y == i):
				save = x
				break
		
		count = 0
		for j in range(save):
			if(not (sorted_queue[j] < i)):
				break

			count += 1

		queue[l] = count

	res = ""
	string = ""
	for x in queue:
		string += str(x)

	queue = string

	temp = []
	for i in range(len(sorted_queue)):
		count = 0
		for j in range(i):
			if(not (sorted_queue[j] < sorted_queue[i]) ):
				break
			count += 1
		temp.append(count)
	sorted_queue = temp

	string = ""
	for x in sorted_queue:
		string += str(x)

	sorted_queue = string

	#print(queue, sorted_queue)

	found = False
	length = 1
	while(not found):
		preorder(length, "", queue, "")
		length *= 2
		#print('length++')
		if(found):
			break

	if(res == ""):
		print('empty')

	else:
		print(res)

	#print("Elapsed time: %s seconds" % ( (datetime.now().time().minute - now.minute) * \
	#	60 + datetime.now().time().second - now.second))