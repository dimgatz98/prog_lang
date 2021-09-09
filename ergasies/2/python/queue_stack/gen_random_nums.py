import random 
import sys

def gen_nums(lim):
	seq = ""
	for i in range(1, lim + 1):
		if(i == lim):
			seq += str(random.randint(1,1000))
			return seq
			
		seq += str(random.randint(1,1000)) + " "
	

if(__name__ == "__main__"):
	#gen_nums(sys.argv[1])
	with open(sys.argv[2], "w") as f:
		f.write(str(sys.argv[1])+"\n"+gen_nums(int(sys.argv[1])))