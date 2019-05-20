# （期待通り、）test set 1でAC、test set 2でWA。
def permutation(l, cs):  # length, characters.
    """文字列csの要素からなるl文字の順列らのリストを返す。"""
    if l == 1:
        return list(cs)
    sol = []             # solution
    for xs in permutation(l-1, cs):
        for c in cs:
            sol.append(xs + c)
    return sol

def simulate(program, C):
    """プログラムprogramがプログラムらCのすべてに勝つならprogramを返し、
    そうでなければFalseを返す。"""
    for i in range(9):  # i文字目を考える
        # 最適なプログラムは1文字ごとに1個以上のプログラムを撃破できる。
        # よってtest set 1の敵の最大数7で勝てていないなら絶望とする。
        if i == 8:      
            return False
        i1 = i % len(program)  # 周回した添字を剰余で得る
        move1 = program[i1]    # プレイヤーのi個目の動き
        C2 = []                # 撃破したもの以外を集める
        for c in C:
            i2 = i % len(c)
            move2 = c[i2]      # 相手のi番目の動き
            if move1 == "R":
                if move2 == "R":
                    C2.append(c)  # あいこ
                elif move2 == "P":
                    return False  # 負け
                else:  # move2 == "S":
                    pass          # 勝ち。このプログラムを排除する。
            elif move1 == "P":
                if move2 == "R":
                    pass
                elif move2 == "P":
                    C2.append(c)
                else:  # move2 == "S":
                    return False
            else:  # move1 == "S":
                if move2 == "R":
                    return False
                elif move2 == "P":
                    pass
                else:  # move2 == "S":
                    C2.append(c)
        if len(C2) == 0:  # すべての敵に勝利した
            return program
        C = C2

T = int(input())
for t in range(1, T+1):
    A = int(input())
    C = [input() for _ in range(A)]
    programs = []  # 3^7 + 3^6 + 3^5 + 3^4 + 3^3 + 3^2 + 3^1 = 3279個のプログラム
    for l in range(1, 8):  # length.
        programs += permutation(l, "RPS")
    result = [simulate(p, C) for p in programs]  # それぞれのプログラムのシミュレート結果
    wins = [x for x in result if x != False]     # すべての敵に勝つプログラムら
    if len(wins) >= 1:
        y = wins[0]
    else:
        y = "IMPOSSIBLE"
    print("Case #{}: {}".format(t, y))
