from collections import deque
import sys

infile = open(sys.argv[1])
input = infile.read().split('\n')[:-1]
N = int(input[0])

def isBad(left, right, seen):
    if((left[-1:] != right[0]) and (seen[left[-1:]] == True)):
        return True
    else:
        return False

def complement(first):
    l = list(first)
    for i in range(len(first)):
        if(l[i] == 'C'):
            l[i] = 'G'
        elif(l[i] == 'G'):
            l[i] = 'C'
        elif(l[i] == 'A'):
            l[i] = 'U'
        else:
            l[i] = 'A'
    answer = "".join(l)
    return answer



for i in range(N):
    left = input[i+1][:-1]
    right = input[i+1][-1:]
    seen = {
        "A" : False,
        'C' : False,
        'U' : False,
        'G' : False
    }
    seen[right] = True
    first = right[0]
    q = deque()
    q.append((left, right, '', seen))
    visited = set()
    visited.add((left, right))
    while q:
        (first, second, path, curr_seen) = q.popleft()
        rev = second[::-1]           #For r
        comp = complement(first)        #For c
        newfirst = first[:-1]           #For p
        newsecond = first[-1:] + second #For p
        #Push in c
        if((comp, second) not in visited):
            visited.add((comp, second))
            q.append((comp, second, path+'c', curr_seen))

        #Push in p
        if(not(isBad(first, second, curr_seen)) and ((newfirst, newsecond) not in visited)):
            helper_seen = curr_seen.copy()
            helper_seen[newsecond[0]] = True
            visited.add((newfirst, newsecond))
            if(newfirst == ''):
                print('p'+path+'p')
                break
            q.append((newfirst, newsecond, path+'p', helper_seen))

        #Push in r
        if((first, rev) not in visited):
            visited.add((first, rev))
            q.append((first, rev, path+'r', curr_seen))
