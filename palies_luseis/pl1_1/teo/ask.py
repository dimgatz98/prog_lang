def count_substr(S, K):
    s = set()
    c = 0
    for i in range(len(S)-K+1):
        if S[i:i+K] not in s:
            c+=1
            s.add(S[i:i+K])
    return c

print(count_substr("helloworld", 3))
print(count_substr("banana", 2))
