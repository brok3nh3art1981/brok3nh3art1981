# p. 51

import matplotlib.pyplot as plt  # グラフ描画
import numpy as np               # 数値計算
import tensorflow as tf          # 機械学習

print("tf.__version ==", tf.__version__)  # 1.13.1
# tf.logging.set_verbosity(tf.logging.ERROR)  # warningを非表示にする。

# Tensor型。
x = tf.placeholder(tf.float32,  # float32型を行列要素の型とする
                   [None, 5])   # 行列のサイズを?x5とする

# パラメータ。RefVariable型。
w = tf.Variable(tf.zeros([5, 1]))  # -> warning

# 予測値のモデル。Tensor型。?x1行列。
y = tf.matmul(x, w)

# 観測値。Tensor型。
t = tf.placeholder(tf.float32,
                   [None, 1])

# 損失関数。Tensor型。
loss = tf.reduce_sum(tf.square(y-t))  # 二乗誤差

# Operation型。
# パラメータ更新アルゴリズムにAdamを選ぶ。損失関数lossの出力を最小化するように指定する。
train_step = tf.train.AdamOptimizer().minimize(loss)

# セッションを用意する。
sess = tf.Session()
# 変数を初期化する。
# sess.run(tf.initialize_all_variables())  # -> warning
sess.run(tf.global_variables_initializer())

# 観測値。教師データ。
train_t = np.array([5.2, 5.7, 8.6, 14.9, 18.2, 20.4,
                    25.5, 26.4, 22.8, 17.5, 11.1, 6.6])
# -> [ 5.2  5.7  8.6 14.9 18.2 20.4 25.5 26.4 22.8 17.5 11.1  6.6]
train_t = train_t.reshape([12, 1])
# -> [[ 5.2][ 5.7][ 8.6][14.9][18.2][20.4][25.5][26.4][22.8][17.5][11.1][ 6.6]]

train_x = np.zeros([12, 5])
for row, month in enumerate(range(1, 13)):  # row == month - 1
    for col, n in enumerate(range(0, 5)):   # col == n == 0, 1, 2, 3, 4
        train_x[row][col] = month**n

i = 0
for _ in range(100_000):
    i += 1
    sess.run(train_step, feed_dict={x:train_x, t:train_t})
    if i % 10_000 == 0:
        # 現在のパラメータでの損失を得る。
        loss_val = sess.run(loss, feed_dict={x:train_x, t:train_t})
        print("Step: {}, Loss: {}".format(i, loss_val))

w_val = sess.run(w)  # np.ndarray

# 予測気温 y(x) = w_0 + w_1*x + w_2*x^2 + w_3*x^3 + w_4*x^4
#              = Sigma(from m=0 to 4) w_m*x^m
def predict(x):
    result = 0.0
    for n in range(0, 5):
        result += w_val[n][0] * x**n
    return result
def plot():
    fig = plt.figure()
    subplot = fig.add_subplot(1, 1, 1)
    subplot.set_xlim(1, 12)
    subplot.scatter(range(1, 13), train_t)
    linex = np.linspace(1, 12, 100)  # 区間[1, 12]で100要素。
    liney = predict(linex)
    subplot.plot(linex, liney)
    plt.show()
plot()
