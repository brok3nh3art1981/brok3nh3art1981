# coding: utf-8
from common.np import *


def sigmoid(x):
    """シグモイド関数"""
    return 1 / (1 + np.exp(-x))


def relu(x):
    """ReLU (rectified linear unit) 関数"""
    return np.maximum(0, x)


def softmax(x):
    """ソフトマックス関数"""
    if x.ndim == 2:
        x = x - x.max(axis=1, keepdims=True)
        x = np.exp(x)
        x /= x.sum(axis=1, keepdims=True)
    elif x.ndim == 1:
        x = x - np.max(x)  # 桁溢れを抑制する
        x = np.exp(x) / np.sum(np.exp(x))

    return x


def cross_entropy_error(y, t):
    """交差エントロピー誤差関数"""
    if y.ndim == 1:
        t = t.reshape(1, t.size)
        y = y.reshape(1, y.size)
        
    # 教師データがone-hot-vectorの場合、正解ラベルのインデックスに変換
    if t.size == y.size:
        t = t.argmax(axis=1)  # 最大の要素の添字を得る
             
    batch_size = y.shape[0]

    return -np.sum(np.log(y[np.arange(batch_size), t] + 1e-7)) / batch_size
