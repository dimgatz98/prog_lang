import sys

def reverse_bfs(v, start, n, m):
	queue = []
	queue.append(start)
	count = 0

	while len(queue) != 0:
		s = queue.pop(0)
		count += 1
 
		if(s[0] != 0 and v[s[0] - 1][s[1]] == 'D'):
		    queue.append((s[0] - 1, s[1]))

		if(s[0] != m - 1 and v[s[0] + 1][s[1]] == 'U'):
		    queue.append((s[0] + 1, s[1]))

		if(s[1] != 0 and v[s[0]][s[1] - 1] == 'R'):
		    queue.append((s[0], s[1] - 1))

		if(s[1] != n - 1 and v[s[0]][s[1] + 1] == 'L'):
		    queue.append((s[0], s[1] + 1))

	return count


f = open(sys.argv[1], "r")
line = f.readline()
temp = line.split(" ")
m, n = int(temp[0]), int(temp[1])

maze = []
for line in f.readlines():
	maze.append([])
	temp = line.strip("\n")
	for elem in temp:
		maze[-1].append(elem)

f.close()
#print(m, n, '\n', maze)

winning = []
for i in range(0, m):
	if(maze[i][0] == 'L'):
		winning.append((i,0))
	if(maze[i][n - 1] == 'R'):
		winning.append((i,n - 1) )

for j in range(0, n):
	if(maze[0][j] == 'U'):
		winning.append((0, j))
	if(maze[m - 1][j] == 'D'):
		winning.append((m - 1, j))


winning_count = 0
for i in winning:
	winning_count += reverse_bfs(maze, i, n , m);

print(n * m - winning_count)