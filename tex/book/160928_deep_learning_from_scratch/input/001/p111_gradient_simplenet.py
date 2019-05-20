import numpy as np


def softmax(x):
    if x.ndim == 2:  # この文脈では常に1
        x = x.T
        x = x - np.max(x, axis=0)
        y = np.exp(x) / np.sum(np.exp(x), axis=0)
        return y.T

    x = x - np.max(x)  # オーバーフロー対策
    return np.exp(x) / np.sum(np.exp(x))


def cross_entropy_error(y, t):
    if y.ndim == 1:
        t = t.reshape(1, t.size)
        y = y.reshape(1, y.size)

    # 教師データがone-hot-vectorの場合、正解ラベルのインデックスに変換
    if t.size == y.size:
        t = t.argmax(axis=1)

    batch_size = y.shape[0]
    return -np.sum(np.log(y[np.arange(batch_size), t] + 1e-7)) / batch_size


def numerical_gradient(f, x):
    h = 1e-4  # 0.0001
    grad = np.zeros_like(x)

    it = np.nditer(x, flags=['multi_index'], op_flags=['readwrite'])
    while not it.finished:
        idx = it.multi_index
        tmp_val = x[idx]
        # x[idx] = float(tmp_val) + h
        x[idx] = tmp_val + h
        fxh1 = f(x)  # f(x+h)

        x[idx] = tmp_val - h
        fxh2 = f(x)  # f(x-h)
        grad[idx] = (fxh1 - fxh2) / (2*h)

        x[idx] = tmp_val  # 値を元に戻す
        it.iternext()

    return grad


class simpleNet:
    def __init__(self):
        self.W = np.random.randn(2, 3)
        self.W[0][0] = 0.47355232
        self.W[0][1] = 0.9977393
        self.W[0][2] = 0.84668094
        self.W[1][0] = 0.85557411
        self.W[1][1] = 0.03563661
        self.W[1][2] = 0.69422093

    def predict(self, x):
        return np.dot(x, self.W)

    def loss(self, x, t):
        z = self.predict(x)
        y = softmax(z)
        loss = cross_entropy_error(y, t)
        return loss


x = np.array([0.6, 0.9])
t = np.array([0, 0, 1])
net = simpleNet()
print("net.W", net.W)
print("net.predict(x)", net.predict(x))
print("softmax", softmax(net.predict(x)))
print("net.loss()", net.loss(x, t))


def f(w): return net.loss(x, t)


dW = numerical_gradient(f, net.W)
print(dW)
