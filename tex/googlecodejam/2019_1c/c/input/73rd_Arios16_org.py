t = int(input())
memo = {}
grid = []


def nimber(i1, j1, i2, j2):
    if i2 <= i1 or j2 <= j1:
        return 0, 0
    if(i1, j1, i2, j2) in memo:
        return memo[(i1, j1, i2, j2)]
    prohibited_i = set()
    prohibited_j = set()
    for i in range(i1, i2):
        for j in range(j1, j2):
            if grid[i][j]:
                prohibited_i.add(i)
                prohibited_j.add(j)
    successor_nimbers = set()
    nim0s = 0
    # H moves
    for i in range(i1, i2):
        if i in prohibited_i:
            continue
        nim = nimber(i1, j1, i, j2)[0] ^ nimber(i+1, j1, i2, j2)[0]
        successor_nimbers.add(nim)
        if nim == 0:
            nim0s += j2-j1
    # V moves
    for j in range(j1, j2):
        if j in prohibited_j:
            continue
        nim = nimber(i1, j1, i2, j)[0] ^ nimber(i1, j+1, i2, j2)[0]
        successor_nimbers.add(nim)
        if nim == 0:
            nim0s += i2-i1
    nim = 0
    while True:
        if nim not in successor_nimbers:
            memo[(i1, j1, i2, j2)] = nim, nim0s
            return nim, nim0s
        else:
            nim += 1


for casen in range(1, t+1):
    r, c = list(map(int, input().split()))
    memo.clear()
    grid.clear()
    for i in range(r):
        row = input().strip()
        row = [c != '.' for c in row]
        grid.append(row)
    _, nim0s = nimber(0, 0, r, c)
    print("Case #{}: {}".format(casen, nim0s))
