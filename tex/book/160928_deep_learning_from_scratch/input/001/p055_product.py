# 行列の積ABとBAは「異なる値になりえる」などと言われる。
# 同じ値になる確率はどの程度だろうか？
# 結論：[0, 9]の整数を一様に要素とする2x2行列A、Bについて
# AB=BAである確率は大雑把に言って0.3%である。よって、たいてい異なる。
import numpy as np


def try_():
    A = np.random.randint(0, 10, (2, 2))
    B = np.random.randint(0, 10, (2, 2))
    AB = np.dot(A, B)
    BA = np.dot(B, A)
    b = np.array_equal(AB, BA)
    # if b:
    #     print(A, B)
    return b


def try_many():
    count = 0
    N = 10_000
    for _ in range(N):
        response = try_()
        if response is True:
            count += 1
    print(count, count/N)


try_many()
