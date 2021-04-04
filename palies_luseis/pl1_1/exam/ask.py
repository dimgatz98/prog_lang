#We assume that node numbering starts from 0
#O(E) complexity
def out_degree(M, u):
    counter = 0
    for i in range(len(M)):
        counter+= M[u][i]
    return counter

#O(V) complexity
def in_degree(M, u):
    counter = 0
    for i in range(len(M)):
        counter+= M[i][u]
    return counter

#O(V) complexity
def adj_list_mat(G):
    lists = len(G)
    M = [[0 for i in range (lists)] for j in range (lists)]
    for i in range(lists):
        for j in range(len(G[i])):
            M[i][G[i][j]] = 1
    return M

G = [[1, 2], [2], [3, 0], []]
M = adj_list_mat(G)
print(M)
print(out_degree(M, 1))
print(in_degree(M, 1))
