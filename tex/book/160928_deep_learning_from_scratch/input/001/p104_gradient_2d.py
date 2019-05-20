import numpy as np
import matplotlib.pylab as plt


def _numerical_gradient_no_batch(f, x):
    """点xにおけるfの勾配を数値微分によって返す。"""
    h = 1e-4  # 0.0001
    grad = np.zeros_like(x)    # [0, 0]

    for idx in range(x.size):  # 各座標について
        tmp_val = x[idx]
        # x[idx] = float(tmp_val) + h  # float()は不要だと思われる
        x[idx] = tmp_val + h           # 点xをidx座標方向に+hする
        fxh1 = f(x)                    # f(x+h)

        x[idx] = tmp_val - h           # 点xをidx座標方向に-hする
        fxh2 = f(x)                    # f(x-h)
        grad[idx] = (fxh1 - fxh2) / (2*h)  # 中心差分

        x[idx] = tmp_val               # 値を元に戻す

    return grad


def numerical_gradient(f, X):
    """Xが点ならばXにおけるfの勾配を返す。
    Xが点のリストなら各点におけるfの勾配のリストを返す。"""
    if X.ndim == 1:  # この文脈では常に2
        return _numerical_gradient_no_batch(f, X)
    else:
        grad = np.zeros_like(X)      # 324要素のndarray; [[0,0],[0,0],...]
        for idx, x in enumerate(X):  # [[0,(x0,y0)], [1,(x1,y1)], ...]
            # 各点の勾配を計算する
            grad[idx] = _numerical_gradient_no_batch(f, x)
        return grad


def function_2(x):
    """xが点ならば各座標を2乗した和を返す。
    xが点のリストなら各点についてそうしたリストを返す。"""
    if x.ndim == 1:  # この文脈では常に1
        return np.sum(x**2)
    else:
        return np.sum(x**2, axis=1)


if __name__ == '__main__':
    x0 = np.arange(-2, 2.5, 0.25)  # -2から2.25までの0.25刻みで18要素のリスト
    x1 = np.arange(-2, 2.5, 0.25)
    X, Y = np.meshgrid(x0, x1)     # 18個の数を18個持つリスト2個
    X = X.flatten()  # 18*18 -> 324要素
    Y = Y.flatten()  # 18*18 -> 324要素

    # x座標らXとy座標らYのリストをnp.array()することで
    # np.ndarrayオブジェクトが得られる。
    # それを.Tすることで、[(x0, y0), (x1, y1), ...]という形にできる。
    grad = numerical_gradient(function_2, np.array([X, Y]).T).T

    plt.figure()
    # matplotlib.pyplot.quiver(X, Y, U, V)
    # クウィヴァーは矢筒、えびらのこと。
    plt.quiver(X, Y, -grad[0], -grad[1],  angles="xy", color="#666666")
    plt.xlim([-2, 2])
    plt.ylim([-2, 2])
    plt.xlabel('x0')
    plt.ylabel('x1')
    plt.grid()
    plt.draw()
    plt.show()
