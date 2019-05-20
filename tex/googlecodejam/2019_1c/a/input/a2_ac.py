# AC.
T = int(input())                     # テストケースの個数
for t in range(1, T+1):              # 各テストケースについて
    A = int(input())                 # 対戦相手の個数
    C = [input() for _ in range(A)]  # プログラムら
    y = ""                           # 解答
    for i in range(255+1):           # 自分のプログラムのi文字目を決める
        if i == 255:                 # 倒せるなら255文字で倒せる
            y = "IMPOSSIBLE"         # 256文字目を考える時点で負け
            break
        moves = set(c[i % len(c)] for c in C)  # プログラムらのi文字目
        if len(moves) == 3:                    # 何を出しても誰かに負ける
            y = "IMPOSSIBLE"
            break
        if len(moves) == 1:                    # 適切に動けばすべて倒せる
            if moves == set(["R"]):
                y += "P"
            if moves == set(["P"]):
                y += "S"
            if moves == set(["S"]):
                y += "R"
            break
        if len(moves) == 2:                    # 一方とあいこ、一方に勝つ
            if moves == set(["R", "P"]):
                y += "P"
                C = [c for c in C if c[i % len(c)] != "R"]  # 倒したのは排除する
            if moves == set(["R", "S"]):
                y += "R"
                C = [c for c in C if c[i % len(c)] != "S"]
            if moves == set(["P", "S"]):
                y += "S"
                C = [c for c in C if c[i % len(c)] != "P"]
    print("Case #{}: {}".format(t, y))
