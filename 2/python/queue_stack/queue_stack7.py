import sys
from datetime import datetime
import zlib

def BFS(queue):
    global res
    global sorted_queue
    found = False
    #max_len = 0
    if(queue == sorted_queue):
        return

    permutations = {(queue, zlib.compress("".encode() ) ): zlib.compress("".encode())}
    save = permutations.copy()

    while(1):
        #print("Elapsed time: %s seconds" % ( (datetime.now().time().minute - now.minute) * \
        #    60 + datetime.now().time().second - now.second))
        #print(max_len)

        for i,j in permutations.items():
            if(zlib.decompress(i[1]) != "".encode()):
                temp1 = zlib.compress(zlib.decompress(j) + "S".encode() )
                temp2 = zlib.compress(zlib.decompress(i[0]) + zlib.decompress(i[1]).decode()[-1].encode() )
                temp3 = zlib.compress(zlib.decompress(i[1])[:-1])
                
                '''
                if(zlib.decompress(temp1) == "QQSQSSQQSS".encode()):
                    if(len(temp3) == 0 and temp2 == sorted_queue):
                        print("hey")
                    print(zlib.decompress(temp3), temp2, sorted_queue, sep=" \ ")
                    exit()
                '''

                if(len(zlib.decompress(temp3) ) == 0 and temp2 == sorted_queue):
                    found = True
                    if(zlib.decompress(temp1) < res or len(res) == 0):
                        res = zlib.decompress(temp1)

                if( (not (temp2, temp3) in save.keys())\
                 or len(temp1) < len(save[(temp2, temp3)])\
                 or zlib.decompress(temp1) < zlib.decompress(save[(temp2, temp3)]) ):
                    save[(temp2, temp3)] = temp1
                    #if(len(zlib.decompress(temp1).decode()) > max_len):
                    #    max_len = len(zlib.decompress(temp1).decode() )

            if(zlib.decompress(i[0]) != "".encode()):
                temp1 = zlib.compress(zlib.decompress(j) + "Q".encode() )
                temp2 = zlib.compress(zlib.decompress(i[0])[1:])
                temp3 = zlib.compress(zlib.decompress(i[1]) + zlib.decompress(i[0]).decode()[0].encode() ) 
                
                if(len(zlib.decompress(temp3) ) == 0 and temp2 == sorted_queue):
                    found = True
                    if(zlib.decompress(temp1) < res or len(res) == 0):
                        res = zlib.decompress(temp1)

                if( (not (temp2, temp3) in save.keys())\
                 or len(temp1) < len(save[(temp2, temp3)])\
                 or zlib.decompress(temp1) < zlib.decompress(save[(temp2, temp3)]) ):
                    save[(temp2, temp3)] = temp1
                    #if(len(zlib.decompress(temp1).decode() ) > max_len):
                    #    max_len = len(zlib.decompress(temp1).decode() )

        #print(temp1, temp2, temp3, res, queue, sorted_queue)

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

    queue = zlib.compress(string.encode())

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

    sorted_queue = zlib.compress(string.encode())

    res = "".encode()
    BFS(queue)
    
    if(len(res) == 0):
        print("empty")

    else:
        print(res.decode())

    #print("Elapsed time: %s seconds" % ( (datetime.now().time().minute - now.minute) * \
    #   60 + datetime.now().time().second - now.second))
