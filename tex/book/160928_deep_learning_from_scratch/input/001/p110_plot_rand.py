# numpy.random.randn()の挙動を確認する。
# 標準正規分布（平均0、標準偏差1）の値を1000個作成して散布図とする。
import matplotlib.pylab as plt
import numpy as np

x = np.random.randn(1000)
y = np.random.randn(1000)
plt.scatter(x, y)
plt.show()
