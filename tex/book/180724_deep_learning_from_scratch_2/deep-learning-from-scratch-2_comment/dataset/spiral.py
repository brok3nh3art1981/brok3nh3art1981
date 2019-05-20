# spiralつまり螺旋状のデータを生成するプログラム。p. 42で使う。
# load_data()という関数名を用いているが、ファイルを読み込みはしない。
import numpy as np


def load_data(seed=1984):  # 任意な乱数の種として著者の生年としたか。
    np.random.seed(seed)
    N = 100  # クラスごとのサンプル数
    DIM = 2  # データの要素数
    CLS_NUM = 3  # クラス数

    x = np.zeros((N*CLS_NUM, DIM))  # (300, 2); データの座標ら。
    t = np.zeros((N*CLS_NUM, CLS_NUM), dtype=np.int)  # (300, 3); 正解のone-hot表現。

    for j in range(CLS_NUM):  # 各クラスについて
        for i in range(N):#N*j, N*(j+1)):  # 各データについて
            rate = i / N       # i==[0, 99]が[0, 1)になる。
            radius = 1.0*rate  # 1を乗算しても変化しない。
            # 4 radは約229.2度だから240度と似た動きをする。
            # j*4.0はクラスごとの基本となる角度だ。
            # 4.0*rateにより、クラスの最後のデータでは約240度回転する。
            # randn()*0.2により、標準偏差0.2でランダムに角度が乱れる。
            theta = j*4.0 + 4.0*rate + np.random.randn()*0.2
            # 240度は約4.189 radだ。それを使ったほうが整うかもしれない。
            degree240 = 4.1887902047863905
            # theta = j*degree240 + degree240*rate + np.random.randn()*0.2

            ix = N*j + i  # 同じクラスのデータらがリスト上で連続する。
            # 斜辺の長さradiusから、直角三角形でsin()とcos()を得る。
            # x方向にsin()を用いている。そのせいで右に回る。
            # もともとフラットなのでflatten()しなくても同じである。
            x[ix] = np.array([radius*np.sin(theta),
                              radius*np.cos(theta)]).flatten()
            t[ix, j] = 1  # 正解のone-hot表現。
            # x[ix] = np.array([radius*np.cos(theta),
            #                   radius*np.sin(theta)]).flatten()
            t[ix, j] = 1  # 正解のone-hot表現。

    return x, t  # 座標らと正解らを返す。
