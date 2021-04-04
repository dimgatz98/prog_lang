from collections import deque
import sys

#DEBUG
def print2DArray(a):
    for i in range(len(a)):
        for j in range(len(a[0])):
            print(a[i][j],end=" ")
        print("")

################## Initializations start here #######################

maxTime = 2000010

inputFile = open(sys.argv[1])
grid = inputFile.read().split('\n')[:-1]
N = len(grid)
M = len(grid[0])

activated = False
entered = False
cando = False
visited = [[False for j in range(M)] for i in range(N)]
time = [[maxTime for j in range(M)] for i in range(N)]
airports = []
moves = ''
time_airports = 0

for i in range(N):
    for j in range(M):
        if grid[i][j] == 'W':
            covid = (i,j)
            time[i][j] = 0
        elif grid[i][j] == 'A':
            airports.append((i,j))
        elif grid[i][j] == 'S':
            tsiodras = (i,j)
        elif grid[i][j] == 'T':
            grafeio = (i,j)

################## Initializations end here #########################
################## Flood fill starts here ###########################
q = deque()
q.append(covid)
while q:
    (x,y) = q.popleft()
    current_time = time[x][y]
    if(((current_time == time_airports-1) or (not(q) and current_time != 0)) and not(entered)):
        for (a,b) in airports:
            if(not(visited[a][b])):
                time[a][b] = time_airports
                visited[a][b] = True
                q.append((a,b))
        entered = True
    for (a,b) in ((x-1, y), (x, y-1), (x, y+1), (x+1,y)):
        if(0 <= a < N and 0 <= b < M):
            if(not(visited[a][b]) and not(grid[a][b] == 'X') and not(grid[a][b] == 'A')):
                time[a][b] = current_time + 2
                visited[a][b] = True
                q.append((a,b))
            elif(not(visited[a][b]) and not(grid[a][b] == 'X') and not(activated)):
                q.append((a,b))
                visited[a][b] = True
                time[a][b] = current_time + 2
                activated = True
                time_airports = current_time + 7
            elif(not(visited[a][b]) and not(grid[a][b] == 'X')):
                q.append((a,b))
                visited[a][b] = True
                time[a][b] = current_time + 2
################## Flood fill ends here #############################

visited = [[False for j in range(M)] for i in range(N)]

################## Pathfinder starts here ###########################
q = deque()
q.append((tsiodras, ('', 0)))
while q and not(cando):
    ((x,y), (path, reach_time)) = q.popleft()
    if (x,y) == grafeio:
        moves = path
        cando = True
    visited[x][y] = True
    for (a,b,c) in ((x+1, y, 'D'), (x, y-1, 'L'), (x, y+1, 'R'), (x-1, y, 'U')):
        if(0 <= a < N and 0 <= b < M):
            if(not(visited[a][b]) and grid[a][b] != 'X' and time[a][b] > reach_time+1):
                q.append(((a,b), (path+c, reach_time+1)))
                visited[a][b] = True

################## Pathfinder ends here #############################


if(not(cando)):
    print('IMPOSSIBLE')
else:
    print(len(moves))
    print(moves)
#print2DArray(time)
#print2DArray(grid)
#print(airports)
#print(covid)
#print(time[18][54], "HAHAH")
