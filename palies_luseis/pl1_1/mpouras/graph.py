#Theoroume oti oi akmes ksekinane apo to 0, kai ara pairnoume ta u,v autousia
#O(1) complexity
def has_edge_mat(M,u,v):
    if(M[u][v] == 1):
        return True
    else:
        return False

#O(V^2) complexity with somewhat optimized constants
def adj_mat_list(M):
    number_of_lists = len(M)
    G = [set() for x in range(number_of_lists)]
    for i in range(number_of_lists):
        for j in range (i, number_of_lists):
            if(M[i][j] == 1):
                G[i].add(j)
                G[j].add(i)
    return G

#Worst case: O(V) (maximum set length)
#Average case: O(1)
def has_edge_list(G,u,v):
    if(v in G[u]):
        return True
    else:
        return False
