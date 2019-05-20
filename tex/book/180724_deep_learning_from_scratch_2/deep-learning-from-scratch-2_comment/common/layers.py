# coding: utf-8
from common.config import GPU  # 順序が逆な気がしたので変えた
from common.np import *  # import numpy as np  # npだけはできないのだろうか
from common.functions import softmax, cross_entropy_error


class MatMul:
    """行列積のレイヤを表すクラス。y=xWを扱う。"""
    def __init__(self, W):  # 生成時に重みを定義する
        self.params = [W]
        self.grads = [np.zeros_like(W)]  # 未定の勾配
        self.x = None                    # 未定の入力

    def forward(self, x):
        """順伝搬"""
        W, = self.params    # 変数名を直観的にする
        out = np.dot(x, W)  # 行列積を得る
        self.x = x          # 入力を記憶しておく
        return out          # 出力yを返す

    def backward(self, dout):
        W, = self.params
        # xが+1動くとLはどれだけ動くか。
        dx = np.dot(dout, W.T)       # ∂L/∂x = ∂L/∂y dot W^T
        # Wが+1動くとLはどれだけ動くか。
        dW = np.dot(self.x.T, dout)  # ∂L/∂W = X^T dot ∂L/∂y
        self.grads[0][...] = dW  # Wの勾配を上書きで記録する
        return dx                # xの勾配を返す


class Affine:
    """アフィン変換のレイヤを表すクラス。"""
    def __init__(self, W, b):  # 重みとバイアス
        self.params = [W, b]
        # 重みの勾配とバイアスの勾配をリストに並べて持つ。
        self.grads = [np.zeros_like(W), np.zeros_like(b)]
        self.x = None  # 未定な入力値

    def forward(self, x):       # 順伝搬
        W, b = self.params      # 変数名を直観的にする
        out = np.dot(x, W) + b  # 行列積、および加算
        self.x = x              # 入力を覚えておく
        return out              # 出力を返す

    def backward(self, dout):  # 逆伝搬
        W, b = self.params     # 変数名を直観的にする
        dx = np.dot(dout, W.T)       # ∂L/∂x = ∂L/∂y dot W^T
        dW = np.dot(self.x.T, dout)  # ∂L/∂W = X^T dot ∂L/∂y
        db = np.sum(dout, axis=0)

        self.grads[0][...] = dW
        self.grads[1][...] = db
        return dx


class Softmax:
    def __init__(self):
        self.params, self.grads = [], []
        self.out = None

    def forward(self, x):
        self.out = softmax(x)
        return self.out

    def backward(self, dout):
        dx = self.out * dout
        sumdx = np.sum(dx, axis=1, keepdims=True)
        dx -= self.out * sumdx
        return dx


class SoftmaxWithLoss:
    def __init__(self):
        self.params, self.grads = [], []
        self.y = None  # softmaxの出力
        self.t = None  # 教師ラベル

    def forward(self, x, t):
        self.t = t
        self.y = softmax(x)

        # 教師ラベルがone-hotベクトルの場合、正解のインデックスに変換
        if self.t.size == self.y.size:
            self.t = self.t.argmax(axis=1)

        loss = cross_entropy_error(self.y, self.t)
        return loss

    def backward(self, dout=1):
        batch_size = self.t.shape[0]

        dx = self.y.copy()
        dx[np.arange(batch_size), self.t] -= 1
        dx *= dout
        dx = dx / batch_size

        return dx


class Sigmoid:
    def __init__(self):
        self.params, self.grads = [], []
        self.out = None

    def forward(self, x):
        out = 1 / (1 + np.exp(-x))
        self.out = out
        return out

    def backward(self, dout):
        dx = dout * (1.0 - self.out) * self.out
        return dx


class SigmoidWithLoss:
    def __init__(self):
        self.params, self.grads = [], []
        self.loss = None
        self.y = None  # sigmoidの出力
        self.t = None  # 教師データ

    def forward(self, x, t):
        self.t = t
        self.y = 1 / (1 + np.exp(-x))

        self.loss = cross_entropy_error(np.c_[1 - self.y, self.y], self.t)

        return self.loss

    def backward(self, dout=1):
        batch_size = self.t.shape[0]

        dx = (self.y - self.t) * dout / batch_size
        return dx


class Dropout:
    '''
    http://arxiv.org/abs/1207.0580
    '''
    def __init__(self, dropout_ratio=0.5):
        self.params, self.grads = [], []
        self.dropout_ratio = dropout_ratio
        self.mask = None

    def forward(self, x, train_flg=True):
        if train_flg:
            self.mask = np.random.rand(*x.shape) > self.dropout_ratio
            return x * self.mask
        else:
            return x * (1.0 - self.dropout_ratio)

    def backward(self, dout):
        return dout * self.mask


class Embedding:
    def __init__(self, W):
        self.params = [W]
        self.grads = [np.zeros_like(W)]
        self.idx = None

    def forward(self, idx):
        W, = self.params
        self.idx = idx
        out = W[idx]
        return out

    def backward(self, dout):
        dW, = self.grads
        dW[...] = 0
        np.add.at(dW, self.idx, dout)
        return None
