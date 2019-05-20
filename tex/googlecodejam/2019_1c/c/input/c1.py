# test set 1用の公式解説による解法。test set 1のみAC。
R, C = [-1, -1]

def get_empties(ss):
    """空のセルの座標らを返す。"""
    empties = []
    for r in range(R):
        for c in range(C):
            if ss[r][c] == ".":         # 空のセルを見つけた
                empties.append((r, c))  # 追加
    return empties

def place(ss, coord, is_H):
    """行列ssの座標coordにコロニーを置いたときの次の状態を返す。
    置けないならFalseを返す。"""
    ss = ss.copy()
    if is_H:
        directions = [(0, -1), (0, +1)]  # 横に広がるつまり列が動く
    else:
        directions = [(-1, 0), (+1, 0)]  # 縦に広がるつまり行が動く
    if is_H:                             # デバッグ用
        B = "H"
    else:
        B = "V"
    B = "B"                              # メモ化のためには細菌は区別しない
    for dir in directions:               # 2つの方向を扱う
        r, c = [coord[0], coord[1]]
        ss[r] = ss[r][:c] + B + ss[r][c+1:]  # コード簡略化のため2回やってる
        while True:
            r, c = r+dir[0], c+dir[1]        # 前進する
            if r<0 or r>=R or c<0 or c>=C:   # 範囲外に出たらこの方向は終わり
                break
            if ss[r][c] == "#":  # 放射性物質に遭遇した
                return False     # coordに置くことはできない
            if ss[r][c] != ".":  # すでに細菌がある
                break            # この方向は終わり
            ss[r] = ss[r][:c] + B + ss[r][c+1:]  # コロニーを広げる
    return ss  # 次の状態を返す

memoize = {}  # この辞書でメモ化する
def is_winning(ss, is_initial):
    """状態ssがwinningならTrueを返す。
    ただしis_initialならwinningなmoveのリストを返す。"""
    args = (tuple(ss), is_initial)  # リストはhashにできないのでtupleとする
    if args in memoize:
        return memoize[args]        # メモ化されている値を返す
    empties = get_empties(ss)       # 空のセルら
    winning_moves = []
    if len(empties) == 0:  # 置ける場所がない
        if is_initial:
            memoize[args] = winning_moves  # つまり空のリスト
        else:
            memoize[args] = False
        return is_winning(*args)
    for empty in empties:         # 空のセルそれぞれに置いてみる
        for hv in [True, False]:  # コロニーHとVをそれぞれ置いてみる
            next = place(ss, empty, hv)  # 置いた次の状態を得る
            if next == False:  # 座標emptyに細菌hvは置けない
                continue
            result = is_winning(next, False)  # 次の状態はwinningか？
            if result == True:  # 勝っている状態を渡してしまう
                continue
            if not is_initial:  # 置ける場所があった
                memoize[args] = True
                return is_winning(*args)
            # 座標emptyにコロニーhvを置くのはwinningなmoveの1つだ。
            winning_moves.append([empty, hv])
    memoize[args] = winning_moves
    return is_winning(*args)

T = int(input())
for t in range(1, T+1):
    R, C = [int(x) for x in input().split()]
    ss = []
    for r in range(R):
        ss.append(input())
    ans = is_winning(ss, True)  # 状態ssのwinningなmoveらを得る
    print("Case #{}: {}".format(t, len(ans)))

