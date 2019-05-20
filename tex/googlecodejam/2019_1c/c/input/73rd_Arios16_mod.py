# AC.
def nimber(top, lft, btm, rgt):
    if btm <= top or rgt <= lft:         # 範囲が異常
        return 0, 0                      # 敗北状態だ
    if (top, lft, btm, rgt) in memoize:  # メモ化されている
        return memoize[(top, lft, btm, rgt)]
    radio_rows = set()                   # 置けない行ら
    radio_clms = set()                   # 置けない列ら
    for r in range(top, btm):            # 細菌で閉じられてる範囲内で改めて集める
        for c in range(lft, rgt):
            if radioss[r][c]:            # 放射性物質がある
                radio_rows.add(r)
                radio_clms.add(c)
    next_nims = set()                    # 動いたあとのnimberら。
    n_winnings = 0                       # 勝てる動きの個数
    for r in range(top, btm):            # 各行にHコロニーを置く動きら
        if r in radio_rows:              # 置けない
            continue
        # Hコロニーを第r行に置いて上下2つのサブ問題に分ける。
        next_nim = nimber(top, lft, r, rgt)[0] ^ nimber(r+1, lft, btm, rgt)[0]
        next_nims.add(next_nim)
        if next_nim == 0:                # 敵に敗北状態を渡す。つまり勝利状態。
            n_winnings += rgt-lft        # Hが置けるセルの数を加算する
    for c in range(lft, rgt):            # 各列にVコロニーを置く動きら
        if c in radio_clms:
            continue
        # Vコロニーを第c列に置いて左右2つのサブ問題に分ける。
        next_nim = nimber(top, lft, btm, c)[0] ^ nimber(top, c+1, btm, rgt)[0]
        next_nims.add(next_nim)
        if next_nim == 0:
            n_winnings += btm-top
    nim = 0      # minimum excludant (MEX)を得る
    while True:  # 動く前のnimberは動いた後のnimberらのMEXとして得られる
        if nim not in next_nims:
            memoize[(top, lft, btm, rgt)] = nim, n_winnings
            return nim, n_winnings
        else:
            nim += 1

T = int(input())
for t in range(1, T+1):
    R, C = [int(x) for x in input().split()]
    memoize = {}
    radioss = []
    for i in range(R):
        s = input().strip()
        radios = [c != '.' for c in s]  # 放射性物質があるセルをTrueで表す
        radioss.append(radios)
    _, n_winnings = nimber(0, 0, R, C)
    print("Case #{}: {}".format(t, n_winnings))
