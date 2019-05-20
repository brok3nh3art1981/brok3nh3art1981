# p. 17
import numpy as np


class Sigmoid:  # シグモイドとはシグマ文字のような曲線だということ
    """シグモイド関数のレイヤを表すクラス。"""
    def __init__(self):
        self.params = []  # 活性化関数なのでパラメータは持っていない。

    def forward(self, x):            # 順伝搬
        return 1 / (1 + np.exp(-x))  # シグモイド関数の式


class Affine:  # アフィン変換。全結合層を表す。
    """アフィン変換のレイヤを表すクラス。"""
    def __init__(self, W, b):
        self.params = [W, b]  # パラメータは重さとバイアスだ。

    def forward(self, x):       # 順伝搬
        W, b = self.params      # 分かりやすい変数名を与える
        print("重み: ")
        print(W)
        print("行列積: ")
        dot = np.dot(x, W)
        print(dot)
        print("バイアス: ")
        print(b)
        out = dot + b  # バイアスは発火のしやすさである。
        return out


class TwoLayerNet:
    """隠れ層が1層であるつまり2層のニューラルネットワークを表すクラス。"""
    # 入力層のニューロンの個数、隠れ層のニューロンの個数、出力層のニューロンの個数。
    def __init__(self, input_size, hidden_size, output_size):  # 2, 4, 3
        I, H, O = input_size, hidden_size, output_size         # 2, 4, 3

        # 重みとバイアスの初期化
        W1 = np.random.randn(I, H)
        print("第1層の重みW1を定義します: ")
        print(W1)
        b1 = np.random.randn(H)
        print("第1層のバイアスb1を定義します: ")
        print(b1)
        W2 = np.random.randn(H, O)
        print("第2層の重みW2を定義します: ")
        print(W2)
        b2 = np.random.randn(O)
        print("第2層のバイアスb2を定義します: ")
        print(b2)

        # レイヤの生成
        self.layers = [
            Affine(W1, b1),
            Sigmoid(),
            Affine(W2, b2)
        ]

        # すべての重みをリストにまとめる
        self.params = []
        for layer in self.layers:  # ただしsigmoidはパラメータを持たない。
            self.params += layer.params

    def predict(self, x):
        for i, layer in enumerate(self.layers):
            print("▼ 入力{}; {}レイヤ: ".format(i, type(layer).__name__))
            print(x)
            y = layer.forward(x)
            print("▲ 出力{}; {}レイヤ: ".format(i, type(layer).__name__))
            print(y)
            x = y  # 変数xを更新してしまう。
        return x   # 変数xの最後の状態、つまり最後の層の出力。

np.random.seed(0)          # 疑似乱数の種を固定する。
x = np.random.randn(2, 2)  # 入力値。2ケースのデータがあるとする。
print("入力xを定義します: ")
print(x)
model = TwoLayerNet(2, 4, 3)  # インスタンス化。なお乱数により複雑な個性を持つ。
s = model.predict(x)          # 演算を実行する。
print("s（スコア）: ")
print(s)
