# p. 45
import sys
sys.path.append('..')  # 親ディレクトリのファイルをインポートするための設定
import numpy as np
from common.optimizer import SGD
from dataset import spiral
import matplotlib.pyplot as plt
from two_layer_net import TwoLayerNet


# ハイパーパラメータの設定
max_epoch = 300
batch_size = 30
hidden_size = 10
learning_rate = 1.0

# もしload_data()の引数ランダムシードを与えるならのちのload_data()も同じにすべき。
x, t = spiral.load_data()  # 300個の座標らと、300個のone-hotな正解ら。
# 入力層のニューロンは2個、唯一の隠れ層のニューロンは10個、出力層のニューロンは3個。
model = TwoLayerNet(input_size=2, hidden_size=hidden_size, output_size=3)
optimizer = SGD(lr=learning_rate)  # 学習率は1である。stochastic gradient descent.

# 学習で使用する変数
data_size = len(x)  # 300
max_iters = data_size // batch_size  # 300/30==10
total_loss = 0
loss_count = 0
loss_list = []

for epoch in range(max_epoch):
    # データのシャッフル
    idx = np.random.permutation(data_size)
    x = x[idx]
    t = t[idx]

    for iters in range(max_iters):
        batch_x = x[iters*batch_size:(iters+1)*batch_size]
        batch_t = t[iters*batch_size:(iters+1)*batch_size]

        # 勾配を求め、パラメータを更新
        loss = model.forward(batch_x, batch_t)
        model.backward()
        optimizer.update(model.params, model.grads)

        total_loss += loss
        loss_count += 1

        # 定期的に学習経過を出力
        if (iters+1) % 10 == 0:
            avg_loss = total_loss / loss_count
            print('| epoch %d |  iter %d / %d | loss %.2f'
                  % (epoch + 1, iters + 1, max_iters, avg_loss))
            loss_list.append(avg_loss)
            total_loss, loss_count = 0, 0


# 学習結果のプロット
plt.plot(np.arange(len(loss_list)), loss_list, label='train')
plt.xlabel('iterations (x10)')
plt.ylabel('loss')
plt.show()

# 境界領域のプロット
h = 0.001
# h = 0.01  # とすると表示がギザギザになるが瞬時に処理できる。
# -1.0223506996640548 1.0889954428950932
x_min, x_max = x[:, 0].min() - .1, x[:, 0].max() + .1
# -0.9886726617070215 1.0580883414647684
y_min, y_max = x[:, 1].min() - .1, x[:, 1].max() + .1
# len(np.arange(x_min, x_max, h)) == 2112
# len(np.arange(y_min, y_max, h)) == 2047
xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
# (len(xx), len(yy)) == (2047 2047)
# x方向に2112、y方向に2047の点を取るから、2112×2047=4323264の点ができる。
# (len(xx.flatten()), len(yy.flatten())) == 4323264 4323264
# ndarray.ravel()は破壊的なndarray.flatten()だ。
# numpy.c_[]はリストを結合する。この場合いわゆるzipする動作となる。
X = np.c_[xx.ravel(), yy.ravel()]
# len(X) == 4,323,264。この個数のデータらをpredictする。
score = model.predict(X)
predict_cls = np.argmax(score, axis=1)  # one-hot表現からスカラ化する
Z = predict_cls.reshape(xx.shape)       # 行列の形を合わせてz座標とする
plt.contourf(xx, yy, Z)  # 塗りつぶした2次元等高線図
# plt.axis('off')  # 各座標軸の目盛りを書かない

# データ点のプロット
x, t = spiral.load_data()  # 再びのspiral.load_data()。
N = 100
CLS_NUM = 3
markers = ['o', 'x', '^']
for i in range(CLS_NUM):
    plt.scatter(x[i*N:(i+1)*N, 0], x[i*N:(i+1)*N, 1], s=40, marker=markers[i])
plt.show()
