import sys
from datetime import datetime

def is_found(q):
    global sorted_queue
    global found
    
    if(q == sorted_queue):
        found = True
        return True

    else:
        return False


def BFS(queue):
    global res
    global found
    permutations = [(queue, "", "")]
    
    while(1):
        for i in range(len(permutations)):
            if(len(permutations[i][2]) == 0 and is_found(permutations[i][0]) ):
                found = True
                if(permutations[i][1] < res or len(res) == 0):
                    res = permutations[i][1]
        
        if(found == True):
            return

        for i in range(len(permutations) ):
            if(permutations[i][2] != ""):
                permutations.append((permutations[i][0] + permutations[i][2][-1], permutations[i][1] + "S",\
                    permutations[i][2][:-1]) )
            
            if(permutations[i][0] != ""):
                permutations[i] = (permutations[i][0][1:], permutations[i][1] + "Q", \
                    permutations[i][2] + permutations[i][0][0])


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

    found = False
    res = ""
    BFS(queue)
    
    if(res == ""):
        print("empty")

    else:
        print(res)

    #print("Elapsed time: %s seconds" % ( (datetime.now().time().minute - now.minute) * \
    #  60 + datetime.now().time().second - now.second))
