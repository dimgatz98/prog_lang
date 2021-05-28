import sys

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
			return False
		if(i == "Q" and len(q) == 0):
			return False

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
		return True

	else:
		return False
		

# Function to generate all binary strings 
def generateAllBinaryStrings(n, arr, i, queue): 
	global res
	global found
			
	if(found):
		return

	if i == n:
		#if(arr == ["Q","Q","S","Q","S","S","Q","Q","S","S"]):
			#print(arr)
		if(is_found(arr, queue, 0)):
			res = arr
			found = True
		return
      
    # First assign "S" at ith position 
    # and try for all other permutations 
    # for remaining positions 
	arr[i] = "S"
	generateAllBinaryStrings(n, arr, i + 1, queue) 
  
	if(found):
		return

    # And then assign "Q" at ith position 
    # and try for all other permutations 
    # for remaining positions 
	arr[i] = "Q"
	generateAllBinaryStrings(n, arr, i + 1, queue) 

f = open(sys.argv[1], "r")

n = int(f.readline() )

line = f.readline().split()

queue = []
for elem in line:
	queue.append(int(elem) )

f.close()

#print(n, queue)

found = False
length = 1
while(not found):
	arr = [None] * length
	generateAllBinaryStrings(length, arr, 0, queue)
	if(found):
		break
	length += 1

is_found(res, queue, 1)
for elem in res:
	print(elem, end="")
print(bcolors.ENDC)
