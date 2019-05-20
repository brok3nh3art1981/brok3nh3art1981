import sys
import numpy as np
import matplotlib.pyplot as plt
sys.path.append("../../deep-learning-from-scratch")
from dataset.mnist import load_mnist  # noqa


def sigmoid(x):
    """シグモイド関数。0から1の連続的な値を返す。"""
    return 1 / (1 + np.exp(-x))


def sigmoid_grad(x):
    return (1.0 - sigmoid(x)) * sigmoid(x)


def cross_entropy_error(y, t):
    if y.ndim == 1:
        t = t.reshape(1, t.size)
        y = y.reshape(1, y.size)

    # 教師データがone-hot-vectorの場合、正解ラベルのインデックスに変換
    if t.size == y.size:
        t = t.argmax(axis=1)

    batch_size = y.shape[0]
    return -np.sum(np.log(y[np.arange(batch_size), t] + 1e-7)) / batch_size


def softmax(x):
    """ソフトマックス関数。全体に比した確率的表現に変換する。"""
    if x.ndim == 2:
        x = x.T
        x = x - np.max(x, axis=0)
        y = np.exp(x) / np.sum(np.exp(x), axis=0)
        return y.T
    x = x - np.max(x)  # オーバーフロー対策
    return np.exp(x) / np.sum(np.exp(x))


def numerical_gradient(f, x):
    """関数fの位置xにおける勾配を数値微分で得て返す。"""
    h = 1e-4  # 0.0001
    grad = np.zeros_like(x)
    it = np.nditer(x, flags=['multi_index'], op_flags=['readwrite'])
    while not it.finished:
        idx = it.multi_index
        tmp_val = x[idx]
        x[idx] = float(tmp_val) + h
        fxh1 = f(x)  # f(x+h)

        x[idx] = tmp_val - h
        fxh2 = f(x)  # f(x-h)
        grad[idx] = (fxh1 - fxh2) / (2*h)

        x[idx] = tmp_val  # 値を元に戻す
        it.iternext()
    return grad


class TwoLayerNet:
    """2層のニューラルネットワーク。"""

    def __init__(self, input_size, hidden_size, output_size,
                 weight_init_std=0.01):
        # 実際の引数は: input_size=784, hidden_size=50, output_size=10
        # 重みの初期化
        self.params = {}
        # 重みはガウス分布に従う乱数で初期化する
        self.params['W1'] = (
            weight_init_std * np.random.randn(input_size, hidden_size))
        self.params['b1'] = np.zeros(hidden_size)
        self.params['W2'] = (
            weight_init_std * np.random.randn(hidden_size, output_size))
        self.params['b2'] = np.zeros(output_size)
        self.n_predict = 0

    def predict(self, x):
        W1, W2 = self.params['W1'], self.params['W2']
        b1, b2 = self.params['b1'], self.params['b2']

        a1 = np.dot(x, W1) + b1
        z1 = sigmoid(a1)
        a2 = np.dot(z1, W2) + b2
        y = softmax(a2)
        
        self.n_predict += 1
        return y

    # x:入力データ, t:教師データ
    def loss(self, x, t):
        y = self.predict(x)

        return cross_entropy_error(y, t)

    def accuracy(self, x, t):
        y = self.predict(x)
        y = np.argmax(y, axis=1)
        t = np.argmax(t, axis=1)

        accuracy = np.sum(y == t) / float(x.shape[0])
        return accuracy

    # x:入力データ, t:教師データ
    def numerical_gradient(self, x, t):
        def loss_W(W): return self.loss(x, t)

        grads = {}
        grads['W1'] = numerical_gradient(loss_W, self.params['W1'])
        grads['b1'] = numerical_gradient(loss_W, self.params['b1'])
        grads['W2'] = numerical_gradient(loss_W, self.params['W2'])
        grads['b2'] = numerical_gradient(loss_W, self.params['b2'])

        return grads

    def gradient(self, x, t):
        W1, W2 = self.params['W1'], self.params['W2']
        b1, b2 = self.params['b1'], self.params['b2']
        grads = {}

        batch_num = x.shape[0]

        # forward
        a1 = np.dot(x, W1) + b1
        z1 = sigmoid(a1)
        a2 = np.dot(z1, W2) + b2
        y = softmax(a2)

        # backward
        dy = (y - t) / batch_num
        grads['W2'] = np.dot(z1.T, dy)
        grads['b2'] = np.sum(dy, axis=0)

        dz1 = np.dot(dy, W2.T)
        da1 = sigmoid_grad(a1) * dz1
        grads['W1'] = np.dot(x.T, da1)
        grads['b1'] = np.sum(da1, axis=0)

        return grads


# データの読み込み
(x_train, t_train), (x_test, t_test) = (
    load_mnist(normalize=True, one_hot_label=True))
# 入力層、隠れ層、出力層のニューロンの個数を指定してネットワークを作る。
network = TwoLayerNet(input_size=784, hidden_size=50, output_size=10)

# iters_num = 10000  # 繰り返しの回数を適宜設定する
iters_num = 10000
train_size = x_train.shape[0]  # 訓練データの個数
batch_size = 100               # ミニバッチの大きさ
learning_rate = 0.1   # 学習率

train_loss_list = []  # 損失の履歴
train_acc_list = []   # 訓練データでの精度の履歴
test_acc_list = []    # テストデータでの精度の履歴

iter_per_epoch = max(train_size / batch_size, 1)

for i in range(iters_num):
    batch_mask = np.random.choice(train_size, batch_size)  # ミニバッチを無作為に作る。
    x_batch = x_train[batch_mask]  # 訓練データの入力データ
    t_batch = t_train[batch_mask]  # 訓練データの正解データ

    # 勾配の計算
    # grad = network.numerical_gradient(x_batch, t_batch)
    grad = network.gradient(x_batch, t_batch)  # 誤差逆伝搬法を用いる

    # パラメータの更新
    for key in ('W1', 'b1', 'W2', 'b2'):  # それぞれの重みについて
        network.params[key] -= learning_rate * grad[key]  # 重みを動かす

    loss = network.loss(x_batch, t_batch)
    train_loss_list.append(loss)

    if i % iter_per_epoch == 0:
        train_acc = network.accuracy(x_train, t_train)
        test_acc = network.accuracy(x_test, t_test)
        train_acc_list.append(train_acc)
        test_acc_list.append(test_acc)
        print("i:", i)
        print("train acc, test acc | " + str(train_acc) + ", " + str(test_acc))

print("n_predict:", network.n_predict)
# グラフの描画
x = np.arange(len(train_acc_list))
plt.plot(x, train_acc_list, label='train acc')                # 訓練データによる精度
plt.plot(x, test_acc_list, label='test acc', linestyle='--')  # テストデータによる精度
plt.xlabel("epochs")           # エポック。全ての訓練データを使い切ったことに相当する。
plt.ylabel("accuracy")         # 精度
plt.ylim(0, 1.0)               # 精度は0から1（全て正解）である
plt.legend(loc='lower right')  # 凡例の位置を指定する
plt.show()
