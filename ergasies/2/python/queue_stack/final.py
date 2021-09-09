import sys
from datetime import datetime
from collections import deque

def string_from_list(l):
    string = ""
    for char in l:
        string += str(char)
    return string

def BFS(queue):
    global res
    global sorted_queue
    if(queue == sorted_queue):
        return

    permutations = deque([ [queue, [], [] ] ] )
    visited = set()
    length = -1
    
    while(1):
        i = permutations.popleft()
        #if(len(i[2].decode()) > length):
        #    length += 1
        #    print(length)

        if(i[0] != []):
            temp1 = i[2].copy()
            temp1.append("Q")
            temp2 = i[0][1:].copy()
            temp3 = i[1].copy()
            temp3.append(i[0][0])
            
            if(len(temp3) == 0 and temp2 == sorted_queue):
                res = temp1
                return

            if(not (string_from_list(temp2), string_from_list(temp3) ) in visited ):
               visited.add( (string_from_list(temp2), string_from_list(temp3) ) )
               permutations.append( [temp2, temp3, temp1] )


        if(i[1] != []):
            temp1 = i[2].copy()
            temp1.append("S")
            temp2 = i[0].copy()
            temp2.append(i[1][-1])
            temp3 = i[1][:-1].copy()
            
            if(len(temp3) == 0 and temp2 == sorted_queue):
                res = temp1
                return

            if(not (string_from_list(temp2), string_from_list(temp3) ) in visited):
                visited.add( (string_from_list(temp2), string_from_list(temp3) ) )
                permutations.append( [temp2, temp3, temp1] )
           
        


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

    temp = []
    for i in range(len(sorted_queue)):
        count = 0
        for j in range(i):
            if(not (sorted_queue[j] < sorted_queue[i]) ):
                break
            count += 1
        temp.append(count)
    sorted_queue = temp

    res = "".encode()
    BFS(queue)
    
    if(len(res) == 0):
        print("empty")

    else:
        for x in res:
            print(x, end = "")
        print()

    #print("Elapsed time: %s seconds" % ( (datetime.now().time().minute - now.minute) * \
    #   60 + datetime.now().time().second - now.second))
