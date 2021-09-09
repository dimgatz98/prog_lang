import sys
from datetime import datetime

def BFS(queue):
    global res
    global sorted_queue
    found = False
    #max_len = 0
    if(queue == sorted_queue):
        return

    permutations = {(queue,""): ""}
    save = permutations.copy()

    while(1):
        #print("Elapsed time: %s seconds" % ( (datetime.now().time().minute - now.minute) * \
        #    60 + datetime.now().time().second - now.second))
        #print(max_len)

        for i,j in permutations.items():
            if(i[1] != ""):
                temp1 = j + "S"
                temp2 = i[0] + i[1][-1]
                temp3 = i[1][:-1]
                
                if(len(temp3) == 0 and temp2 == sorted_queue):
                    found = True
                    if(temp1 < res or len(res) == 0):
                        res = temp1

                if((not (temp2, temp3) in save.keys())\
                 or len(temp1) < len(save[(temp2, temp3)])\
                 or temp1 < save[(temp2, temp3)]):
                    save[(temp2, temp3)] = temp1
                    #if(len(temp1) > max_len):
                    #    max_len = len(temp1)

            if(i[0] != ""):
                temp1 = j + "Q"
                temp2 = i[0][1:]
                temp3 = i[1] + i[0][0]
                
                if(len(temp3) == 0 and temp2 == sorted_queue):
                    found = True
                    if(temp1 < res or len(res) == 0):
                        res = temp1

                if((not (temp2, temp3) in save.keys())\
                 or len(temp1) < len(save[(temp2, temp3)])\
                 or temp1 < save[(temp2, temp3)]):
                    save[(temp2, temp3)] = temp1
                    #if(len(temp1) > max_len):
                    #    max_len = len(temp1)

        if(found):
            return

        permutations = save.copy()


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

    res = ""
    BFS(queue)
    
    if(res == ""):
        print("empty")

    else:
        print(res)

    #print("Elapsed time: %s seconds" % ( (datetime.now().time().minute - now.minute) * \
    #   60 + datetime.now().time().second - now.second))